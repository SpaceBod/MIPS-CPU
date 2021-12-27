#!/bin/bash
set -eou pipefail
# Set paths
hex=./test/assembler/hexadecimal
assembly=./test/assembler/assembly
tbRAM=./test/testbench_and_RAM
compiled_results=./test/testbench_and_RAM/compiled_results
check_results=./test/assembler/results

# RTL arg1 and Instruction arg2 (optional)
RTLDR=$1
INSTRCTN=${2:-all}

# Check if RTL directory exists
if [ ! -d $1 ]; then
  echo -e "Invalid RTL Dir: $1"
  exit
fi

# Checks if RTL folders are in multiple places
count=`ls $RTLDR/*.v 2>/dev/null | wc -l` || true             # Counts .v files in RTL
count1=`ls $RTLDR/mips_cpu/*.v 2>/dev/null | wc -l` || true   # Counts .v files in RTL/mips_cpu

if [[ $count != 0 && $count1 != 0 ]]; then    # BOTH folders
  RTLDR=$1/*.v
  RTLDR1=$1/mips_cpu/*.v
elif [[ $count != 0 && $count1 == 0 ]]; then  # Main folder ONLY
  RTLDR=$1/*.v
  RTLDR1=""
elif [[ $count == 0 && $count1 != 0 ]]; then  # Sub folder ONLY
  RTLDR=$1/mips_cpu/*.v
  RTLDR1=""
fi

# Create temp directories
mkdir -p $compiled_results || true
mkdir -p $hex || true

# Check if instruction has been specified
if [ "$INSTRCTN" != "all" ]; then
  input_instruction=$2
fi

# Scans for assembly files
for f in $assembly/*.asm; do
  f=${f##*/}                                                          # Removes previous path
  declare instruction=$(echo ${f::-6} | tr '[:upper:]' '[:lower:]')   # Converts to lowercase and removes extension
  if [ "$INSTRCTN" = "all" ]; then
    instruction=$(echo ${f::-6} | tr '[:upper:]' '[:lower:]')
  else
    if [ "$instruction" = "${input_instruction,,}" ]; then
      instruction=$(echo ${f::-6} | tr '[:upper:]' '[:lower:]')
    else
      continue    # Skips other instructions that are not specified
    fi
  fi
 
  # Assembles the test cases to machine hex code
  mips-linux-gnu-as --no-warn -EL -o $hex/$f.out $assembly/$f
  mips-linux-gnu-readelf --hex-dump=.text $hex/$f.out | sed -n -e '/0x00000000/,$p' | sed 's/^ *0x//g' | xxd -r | xxd -p -c 10000000000 | sed 's/.\{8\}/& /g' > $hex/$f.txt
  rm $hex/$f.out
  
  # Runs MIPS iverilog with hex code into test bench
  iverilog -Wall -g 2012 -o $tbRAM/tb.out $RTLDR $RTLDR1 $tbRAM/mips_cpu_*.v -P mips_cpu_bus_tb.RAM_INIT_FILE=\"$hex/$f.txt\" >/dev/null && ./$tbRAM/tb.out >/dev/null || true
  rm -rf $tbRAM/tb.out

  sed -i "s/ //g" $compiled_results/result.txt                      # Removes whitespace
  mv $compiled_results/result.txt $compiled_results/$f.result.txt   # Renames output to include instruction name
  register_v0=`cat $compiled_results/$f.result.txt` || true         # Extracts the simulated result from file
  correct_v0=`cat $check_results/$f.result.txt` || true             # Extracts the expected result from file

  # Compares if simulated result == expected result
  if cmp --silent -- $compiled_results/$f.result.txt $check_results/$f.result.txt; then
    printf "${f%.*} "
    printf "$instruction "
    printf "Pass\n" 
 
  else
    printf "${f%.*} "
    printf "$instruction "
    printf "Fail "
    printf "\t# v0=$register_v0 -> $correct_v0 \n"    # Error message: obtained reg_v0 value & correct reg_v0 value
  fi
done
# Removes temp directories
rm -rf $hex
rm -rf $compiled_results
rm -rf ./test/testbench_and_RAM/mips_cpu_bus_tb.vcd