BRAGGHLS_DIR="$( cd "$(dirname "$0")" ; pwd -P)/.."

function flopoco () {
    docker run --rm=true -v $BRAGGHLS_DIR/ip_cores:/flopoco_workspace flopoco "$@"
}

function make() {
  freq=$1
  wE=$2
  wF=$3
  echo $freq
  echo "fmul"
  flopoco FPMult wE=$wE wF=$wF name=fmul outputFile=flopoco_fmul_${wE}_${wF}.vhdl target=Virtex6 frequency=$freq clockEnable=0 2>&1 | grep "   Pipeline depth ="
  $BRAGGHLS_DIR/scripts/ghdl_convert_vhdl_verilog.sh $BRAGGHLS_DIR/ip_cores/flopoco_fmul_${wE}_${wF}.vhdl fmul 2> /dev/null
  echo "fadd"
  flopoco FPAdd wE=$wE wF=$wF name=fadd dualPath=0 outputFile=flopoco_fadd_${wE}_${wF}.vhdl target=Virtex6 frequency=$freq clockEnable=0 2>&1  | grep "   Pipeline depth ="
  $BRAGGHLS_DIR/scripts/ghdl_convert_vhdl_verilog.sh $BRAGGHLS_DIR/ip_cores/flopoco_fadd_${wE}_${wF}.vhdl fadd 2> /dev/null
  echo "\n"
}
#
#for freq in 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800; do
#  make $freq 6 6
#done

make 300 8 23
