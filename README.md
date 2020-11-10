# Design Flow Automation
## 1. Prepare Flow Ticket file
<pre>
# Flow Ticket file (T400-XXXX.dfa)
[HEADER]
TITLE   =  description of the flow ticket
TECHLIB =  <i>techlib_config_file</i>
FLOW_ID =  <i>flow_reference_id</i>
DVC_SRC =  <i>design_source_version_path</i>
DVC_DST =  <i>design_dest_version_path</i>
DESIGN  =  <i>top_module_name</i>
RUNDIR  =  <i>ticket_run_dir_name</i>

[INPUT]
<i>input_ref_id1</i>  = <i>input_file_name</i>
<i>input_ref_id2</i>  = <i>input_dir_name</i>

[OUTPUT]
<i>output_ref_id1</i> = <i>output_file_name</i>
<i>output_ref_id2</i> = <i>output_dir_name</i>

[PARAM]
<i>param_ref_id1</i>  = <i>parameter_value1</i>
<i>param_ref_id2</i>  = <i>parameter_value2</i>
...

</pre>
<hr>
<pre>
# Flow definition file (<i>flow_ref_id</i>.flow)
FLOW	<i>flow_ref_id</i>	
#		
INPUT   <i>input_ref_id1</i>  : <i>input_file_name</i>
INPUT   <i>input_ref_id2</i>  : <i>input_dir_name</i>
OUTPUT  <i>output_ref_id1</i> : <i>output_file_name</i>
OUTPUT	<i>output_ref_id2</i> : <i>output_dir_name</i>
#
PARAM	<i>param_ref_id1</i>  = <i>parameter_value1</i>
PARAM	<i>param_ref_id2</i>  = <i>parameter_value2</i>
#		
SUBFLOW	<i>subflow_ref_id1</i>	<i>subflow_dir_name1</i>
+	<i>sf1_input_ref_id</i>  < <i>input_ref_id1</i>
+	<i>sf1_output_ref_id</i> > <i>temp_ref_id</i>
+	<i>sf1_param_ref_id</i>  = <i>param_ref_id1</i>
ENDSUB		
SUBFLOW	<i>subflow_ref_id2</i>	<i>subflow_dir_name2</i>
+	<i>sf2_input_ref_id</i>  < <i>temp_ref_id</i>
+	<i>sf2_output_ref_id</i> > <i>output_ref_id</i>
+	<i>sf2_param_ref_id</i>  = <i>param_ref_id2</i>
ENDSUB		
#			
PRECHECK  <i>run_precheck</i>
EXECUTE	  <i>run_flow_script</i>
EXECDQI   <i>run_dqi_extraction</i>
PSTCHECK  <i>run_postcheck</i>	
#		
END		
</pre>
      
## 2. Building Flow run directory
<pre>
  % dfa_build_rundir <i>FlowDefinitionFile</i>
</pre>
<pre>
.dfa/	"DEFINITION SUBFLOW PARAMETER script/"	
.inp$<i>input_ref_id1</i>  -> ::main/<i>input_file_name</i>	
.out$<i>output_ref_id1</i> -> ::main/<i>output_file_name</i>
Makefile
techlib -> /techlib/<i>techlib_id</i>/
design/
::main/
	Makefile
	<i>input_file_name</i> -> ../.inp$<i>input_ref_id1</i>
</pre>

## 3. Executing Flow run directory
+ Link technology library .....<t>
<code> % make techlib </code>
+ Checkout input data .........<t>
<code> % make checkout </code>
+ Execute flow script ............<t>
<code> % make execute </code>
+ Extract quality indicator ..<t>
<code> % make dqi </code>
+ Checkin output data .........<t>
<code> % make checkin </code>
+ Mark status done

### Example: DEFINITION.dfa
<pre>
[401-RCXT.dfa]
  FLOW    401-RCXCT
  INPUT   DEF_FILE  : design.def
  OUTPUT  SPEF_FILE : design.spef.gz
  PARAM   rc_corner = Cmax
  EXECUTE run_rcxt.tcl
  END
  
[402-SPEF2SDF.dfa]
  FLOW    402-SPEF2SDF
  INPUT   SPEF_FILE : design.spef.gz
  OUTPUT  SDF_FILE  : design.sdf.gz
  PARAM   op_corner = WCL
  EXECUTE run_spef2sdf.tcl
  END

[410-DEF2SDF.dfa]
  FLOW    410-DEF2SDF
  INPUT   DEF_FILE  : design.def
  OUTPUT  SPEF_FILE : design.spef.gz
  OUTPUT  SDF_FILE  : design.sdf.gz
  PARAM   rc_corner = Cmax_WCL
  PARAM   op_corner = WC
  SUBFLOW 401-RCXT  rcxt_spef
  + DEF_FILE  < DEF_FILE
  + SPEF_FILE > SPEF_FILE
  + rc_corner = rc_corner
  ENDSUB
  SUBFLOW 402-SPEF2SDF spef2sdf
  + SPEF_FILE < SPEF_FILE
  + SDF_FILE  > SDF_FILE
  + op_corner = op_corner
  ENDSUB
  END
</pre>

### Example: Flow Run Directory
<pre>
.dfa/	"DEFINITION PARAMETER script"	
.inp$DEF_FILE  -> ::main/design.def	
.out$SPEF_FILE -> :401-RXCT:rcxt_spef/.out$SPEF_FILE		
.out$SDF_FILE  -> :402-SPEF2SDF:spef2sdf/.out$SDF_FILE		
Makefile
techlib -> /techlib/xxxx/….		
design/		
::main/
	design.def -> ../inp$EF_FILE
		
:401-RCXT:rcxt_spef/
	.dfa/	"DEFINITION PARAMETER script"
	.inp$DEF_FILE  -> ../.inp$DEF_FILE	
	.out$SPEF_FILE -> ::main/design.spef.gz
	Makefile
	techlib -> ../techlib	
	design -> ../design	
	::main/
		design.def -> ../.inp$DEF_FILE
		
:402-SPEF2SDF:spef2sdf/	DEFINITION.dfa	
	.dfa/	"DEFINITION PARAMETER script"
	.inp$SPEF_FILE -> ../.out$SPEF_FILE
	.out$SDF_FILE -> ::main/$design.sdf.gz	
	Makefile
	techlib -> ../techlib	
	design -> ../design	
	::main/
		design.spef.gz -> .../.inp$SPEF_FILE
</pre>
