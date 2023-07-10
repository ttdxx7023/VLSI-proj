export verilog=/home/majx/vtr-verilog-to-routing/vtr_flow/benchmarks/verilog/diffeq2.v
export arch=/home/majx/vtr-verilog-to-routing/vtr_flow/arch/timing/EArch.xml
export tech=/home/majx/vtr-verilog-to-routing/vtr_flow/tech/PTM_45nm/45nm.xml
# odin
$VTR_ROOT/odin_ii/odin_ii \
    -a $arch \
    -V $verilog \
    -o diffeq2.odin.blif > odin.out

# abc
$VTR_ROOT/abc/abc \
    -c 'read_blif diffeq2.odin.blif; 
        balance; strash;
        write_blif diffeq2.abc.blif;
        ' \
    > abc.out

# vpr +power
# ace2
$VTR_ROOT/ace2/ace \
    -b diffeq2.abc.blif \
    -c ./vtr-verilog-to-routing/vtr_flow/benchmarks/blif/multiclock \
    -o diffeq2.ace2.act \
    -n diffeq2.ace2.blif > ace2.out

# reinsert clk
$VTR_ROOT/vtr_flow/scripts/restore_multiclock_latch.pl \
    diffeq2.odin.blif \
    diffeq2.ace2.blif \
    diffeq2.pre-vpr.blif > reinsertclk.out

# vpr
$VTR_ROOT/vpr/vpr \
    $arch \
    diffeq2 --circuit_file diffeq2.pre-vpr.blif \
    --route_chan_width 100 \
    --power \
    --activity_file diffeq2.ace2.act \
    --tech_properties $tech \
    > vpr.out