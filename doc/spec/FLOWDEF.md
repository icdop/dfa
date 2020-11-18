<pre>
# Flow definition file (<i>flow_ref_id</i>.dfk)
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
