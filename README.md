# Design Flow Automation
## 0. Prepare Flow definition file
<pre>
# Flow definition file
FLOW	<i>flow_ref_id</i>	
#		
INPUT   <i>input_ref_id1</i>  <i>input_file_name</i>
INPUT   <i>input_ref_id2</i>  <i>input_dir_name</i>
OUTPUT  <i>output_ref_id1</i> <i>output_file_name</i>
OUTPUT	<i>output_ref_id2</i> <i>output_dir_name</i>
TEMP    <i>temp_ref_id</i>  <i>temp_file_name</i>
#
PARAM	<i>parameter_name</i>	<i>default_value</i>
#		
SUBFLOW	<i>subflow_ref_id1</i>	<i>subflow_dir_name1</i>
+	<i>input_ref_id</i>	<i>input_file_name</i>
+	<i>output_ref_id</i>	<i>temp_file_name</i>
ENDSUB		
SUBFLOW	<i>subflow_ref_id2</i>	<i>subflow_dir_name2</i>
+	<i>input_ref_id</i>	<i>temp_file_name</i>
+	<i>outpu_ref_id</i>	<i>output_file_name</i>
ENDSUB		
#			
PRECHECK  <i>run_precheck</i>
EXECUTE	  <i>run_flow_script</i>
EXECDQI   <i>run_dqi_extraction</i>
PSTCHECK	<i>run_postcheck</i>	
#		
END		
</pre>
## 1. Building Flow run directory

## 2. Executing Flow 
### Link technology library 
### Checkout input data
### Execute flow Script
### Extract Quality Indicator
### Checkin output data
### Mark status
