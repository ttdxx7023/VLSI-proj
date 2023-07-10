export arch=/home/majx/vtr-verilog-to-routing/parmys/parmys-plugin/tests/VexRiscv_Lite/k6_frac_N10_frac_chain_mem32K_40nm.xml

$VTR_ROOT/vpr/vpr \
    $arch \
    VexRicsv_Lite --circuit_file VexRiscv_Lite.yosys.blif \
    --route_chan_width 300 > vpr.out