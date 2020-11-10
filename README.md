# Design Flow Automation
## 0. Prepare Flow definition file
<pre>
# Flow definition file (DEFINITION.dfa)
FLOW	<i>flow_ref_id</i>	
#		
INPUT   <i>input_ref_id1</i>  = <i>input_file_name</i>
INPUT   <i>input_ref_id2</i>  = <i>input_dir_name</i>
OUTPUT  <i>output_ref_id1</i> = <i>output_file_name</i>
OUTPUT	<i>output_ref_id2</i> = <i>output_dir_name</i>
TEMP    <i>temp_ref_id</i>    = <i>temp_file_name</i>
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
+	<i>sf2_outpu_ref_id</i>  > <i>output_ref_id</i>
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
      
## 1. Building Flow run directory
<pre>
DEFINITION.dfa		
.dfa/	"SUBFLOW PARAMETER"	
.techlib -> /techlib/xxxx/….		
.design/		
.script/		
.inp$<i>input_ref_id1</i> -> .design/:/:/:/:/<i>input_file_name</i>	
.out$<i>output_ref_id1</i> -> .run/<i>output_file_name</i>
.tmp$<i>temp_ref_id</i> -> .run/<i>temp_file_name</i>
.run/
Makefile
</pre>

## 2. Executing Flow run directory
+ Link technology library .....<t>
<code> % make techlib </code>
+ Checkout input data .........<t>
<code> % make checkout </code>
+ Execute flow script ............<t>
<code> % make execute </code>
+ Extract quality indicator ...<t>
<code> % make dqi </code>
+ Checkin output data .........<t>
<code> % make checkin </code>
+ Mark status done

### Example: DEFINITION.dfa
<pre>
[401-RCXT.dfa]
  FLOW    401-RCXCT
  INPUT   DEF_FILE  design.def
  OUTPUT  SPEF_FILE design.spef.gz
  PARAM   rc_corner   Cmax
  EXECUTE run_rcxt.tcl
  END
  
[402-SPEF2SDF.dfa]
  FLOW    402-SPEF2SDF
  INPUT   SPEF_FILE design.spef.gz
  OUTPUT  SDF_FILE  design.sdf.gz
  PARAM   lib_corner WCL
  EXECUTE run_spef2sdf.tcl
  END

[410-DEF2SDF.dfa]
  FLOW    410-DEF2SDF
  INPUT   DEF_FILE  design.def
  OUTPUT  SPEF_FILE design.spef.gz
  OUTPUT  SDF_FILE  design.sdf.gz
  PARAM   rc_corner Cmax_WCL
  PARAM   lib_corner WC
  SUBFLOW 401-RCXT  rcxt
  + DEF_FILE  = DEF_FILE
  + SPEF_FILE = SPEF_FILE
  ENDSUB
  SUBFLOW 402-SPEF2SDF spef2sdf
  + SPEF_FILE = SPEF_FILE
  + SDF_FILE  = SDF_FILE
  ENDSUB
  END
</pre>

### Example: Flow Run Directory
<pre>
DEFINITION.dfa		
.dfa/	"SUBFLOW PARAMETER"	
.techlib -> /techlib/xxxx/….		
.design/		
.script/		
.inp$DEF_FILE -> .design/X/Y/Z/design.def		
.out$SDF_FILE -> spef2sdf/.out$SDF_FILE		
.tmp$SPEF_FILE -> rcxt/.out$SPEF_FILE		
.run/
Makefile
		
rcxt_spef/	DEFINITION.dfa	
	.dfa/	"PARAMETER"
	.techlib -> ../techlib	
	.design -> ../design	
	.script/	
	.inp$DEF_FILE -> ../.inp$DEF_FILE	
	.out$SPEF_FILE -> .run/$SPEF_FILE	
	.run/
	Makefile
		
spef2sdf/	DEFINITION.dfa	
	.dfa/	"PARAMETER"
	.techlib -> ../techlib	
	.design -> ../design	
	.inp$SPEF_FILE -> ../.tmp$SPEF_FILE	
	.out$SDF_FILE -> .run/$SDF_FILE	
	.run/
	Makefile
</pre>
