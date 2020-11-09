# Design Flow Automation
## 0. Prepare Flow definition file
<pre>
FLOW	<i>flow_ref_name</i>	
		
INPUT	<input_ref_name1>	<input_file_name>
INPUT	<input_ref_name2>	<input_dir_name>
OUTPUT 	<output_ref_name1>	<output_file_name>
OUTPUT	<output_ref_name2>	<output_dir_name>
TEMP	<temp_ref_name>	<temp_file_name>
		
PARAMETER	<parameter_name>	<default_value>
		
SUBFLOW	<subflow_reference>	<subflow_dir_name1>
+	<input_id>	<input_file_name>
+	<outpu_id>	<temp_file_name>
ENDSUB		
SUBFLOW	<subflow_reference>	<subflow_dir_name2>
+	<input_id>	<temp_file_name>
+	<outpu_id>	<output_file_name>
ENDSUB		
		
		
PRECHECK		
EXECUTE	run_qrc.tcl	run_star.tcl
EXECDQI		
PSTCHECK	pstcheck.py	
		
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
