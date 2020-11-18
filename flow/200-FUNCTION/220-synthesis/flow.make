FLOW::TITLE	= Synthesis

INPUT::RTL	= design_rtl.v
INPUT::SDC	= design_rtl.sdc

OUTPUT::GATE	= design_gate.v
OUTPUT::SDC	= design_gate.sdc

REPORT::LOG	= dc.log
REPORT::STA	= sta.rpt

TOOL::VERSION	=
TOOL::SCRIPT	= dc_syn.tcl
TOOL::COMMAND	= dc_shell -f $(SCRIPT)

