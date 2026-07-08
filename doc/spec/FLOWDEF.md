# Simple Flow Step defintion file (<i>flow_ref_id</i>.dfd)
<pre>
FLOW	  <i>flow_ref_id</i>
INPUT   <i>input_ref_id1</i>  : <i>input_file_name</i>
OUTPUT  <i>output_ref_id1</i> : <i>output_file_name</i>
PARAM  	<i>param_ref_id1</i>  = <i>parameter_value1</i>
TOOL    <i>eda_tool_name</i>  = <i>eda_tool_cmd_path</i>
END FLOW  
</pre>

### Example: 510-RCXT.dfd
<pre>
  FLOW    510-RCXT
  INPUT   DEF_FILE  = design.def
  OUTPUT  SPEF_FILE = design.spef.gz
  PARAM   rc_corner = Cmax
  TOOL    STAR_RC   = /tools/eda/star_rcxt
  EXECUTE run_rcxt.tcl
  END
</pre>
### Build Flow Run directory
<pre>
.script -> /projects/xxxx/dfd
.inp$DEF_FILE  -> design.def
.out$SPEF_FILE -> design.spef.gz
Makefile
		FLOW      := 510-RCXT
		INPUT     := .inp$DEF_FILE
		OUTPUT    := .out$SPEF_FILE
		PRECHECK  := .script/$FLOW/<i>run_precheck</i>
		EXECUTE   := .script/$FLOW/<i>run_flow_script</i>
		POSTCHECK := .script/$FLOW/<i>run_postcheck</i>
    EXTRDQI   := .script/$FLOW/<i>run_extract_dqi</i>
		run: precheck
			make $(OUTPUT) | tee run.log

		$(INPUT):
			@echo "ERROR: Missing input file '$@'..." | tee -a error.log
		precheck: $(INPUT)
			$(PRECHECK) | tee precheck.log
		$(OUTPUT) : precheck
			$(EXECUTE)  | tee execute.log
		postcheck: $(OUTPUT)
			$(POSTCHECK) | tee postcheck.log
		dqi:
			$(EXTRDQI) | tee extrdqi.log
</pre>

# Complex Flow definition file (<i>flow_ref_id</i>.dfd)
<pre>
FLOW	<i>flow_ref_id</i>:
#		
INPUT   <i>input_ref_id1</i>  : <i>input_file_name</i>
INPUT   <i>input_ref_id2</i>  : <i>input_dir_name</i>
OUTPUT  <i>output_ref_id1</i> : <i>output_file_name</i>
OUTPUT	<i>output_ref_id2</i> : <i>output_dir_name</i>
#
PARAM	<i>param_ref_id1</i>  = <i>parameter_value1</i>
PARAM	<i>param_ref_id2</i>  = <i>parameter_value2</i>
#		
STEP	<i>subflow_ref_id1</i>	<i>subflow_dir_name1</i>
+	<i>sf1_input_ref_id</i>  < <i>input_ref_id1</i>
+	<i>sf1_output_ref_id</i> > <i>temp_ref_id</i>
+	<i>sf1_param_ref_id</i>  = <i>param_ref_id1</i>
ENDS		
STEP	<i>subflow_ref_id2</i>	<i>subflow_dir_name2</i>
+	<i>sf2_input_ref_id</i>  < <i>temp_ref_id</i>
+	<i>sf2_output_ref_id</i> > <i>output_ref_id</i>
+	<i>sf2_param_ref_id</i>  = <i>param_ref_id2</i>
ENDS		
#			
PRECHECK  <i>run_precheck</i>
EXECUTE	  <i>run_flow_script</i>
EXECDQI   <i>run_dqi_extraction</i>
PSTCHECK  <i>run_postcheck</i>	
#		
ENDF		
</pre>
