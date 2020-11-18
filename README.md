# Design Flow Automation
## 1. Prepare Flow Ticket file
<pre>
# Flow Ticket file (T400-XXXX.ticket)
[HEADER]
TITLE   =  description of the flow ticket
FLOW_ID =  <i>flow_reference_id</i>:<i>ticket_run_dir</i>
TECHLIB =  <i>techlib_config_file</i>
DVC_SRC =  <i>design_source_version_path</i>
DVC_DST =  <i>design_dest_version_path</i>
DESIGN  =  <i>top_module_name</i>

[INPUT]
<i>input_ref_id1</i>  = <i>input_file_name</i>
<i>input_ref_id2</i>  = <i>input_dir_name</i>

[OUTPUT]
<i>output_ref_id1</i> = <i>output_file_name</i>
<i>output_ref_id2</i> = <i>output_dir_name</i>

[PARAM]
<i>parameter_id1</i>  = <i>parameter_value1</i>
<i>parameter_id2</i>  = <i>parameter_value2</i>
...

</pre>
<hr>
<pre>
# Design Flow Definition File (<i>flow_ref_id</i>.dfd)
FLOW	<i>flow_ref_id</i>
	
INPUT   <i>input_ref_id1</i>  = <i>input_file_name</i>
INPUT   <i>input_ref_id2</i>  = <i>input_dir_name</i>
OUTPUT  <i>output_ref_id1</i> = <i>output_file_name</i>
OUTPUT	<i>output_ref_id2</i> = <i>output_dir_name</i>
	
PARAM	<i>parameter_id1</i>  = <i>parameter_value1</i>
PARAM	<i>parameter_id2</i>  = <i>parameter_value2</i>
	
STEP	<i>step_ref_id1</i>	<i>step_dir_name1</i>
\+	<i>sf1_input_ref_id</i>  \< <i>input_ref_id1</i>
\+	<i>sf1_output_ref_id</i> > <i>output_ref_id1</i>
\@	<i>sf1_parameter_id</i>  = <i>parameter_id1</i>
;

STEP	<i>step_ref_id2</i>	<i>step_dir_name2</i>
\+	<i>sf2_input_ref_id</i>  \< <i>output_ref_id1</i>
\+	<i>sf2_output_ref_id</i> > <i>output_ref_id2</i>
\@	<i>sf2_parameter_id</i>  = <i>parameter_id2</i>
;		
			
PRECHECK  <i>run_precheck</i>
EXECUTE	  <i>run_flow_script</i>
EXECDQI   <i>run_dqi_extraction</i>
POSTCHECK <i>run_postcheck</i>
		
ENDF		
</pre>
      
## 2. Building design flow run directory
<pre>
  % dfa_build_flow_rundir<i>flow_ref_id</i>
</pre>
<pre>
.dfa/	"DEFINITION SUBFLOW PARAMETER script/"
.techlib -> /project/<i>project_id</i>/techlib/<i>techlib_id</i>
.design -> /project/<i>project_id<id>/design/<i>phase</i>/<i>block</i>/<i>stage</i>/<i>version</i>/
.script -> /project/<i>project_id</i>/script
.inp$<i>input_ref_id1</i>  -> .design/<i>input_file_name</i>
.out$<i>output_ref_id1</i> -> ::main/<i>output_file_name</i>
::main/
	script -> ../.script/<i>flow_ref_id</i>
	<i>input_file_name</i> -> ../.inp$<i>input_ref_id1</i>
	Makefile -> script/Makefile.flow

		FLOW      := 510-RCXT
		INPUT     := <i>input_file_name</i>
		OUTPUT    := <i>output_file_name</i>
		PRECHECK  := script/<i>run_precheck</i>
		EXECUTE   := script/<i>run_flow_script</i>
		POSTCHECK := script/<i>run_postcheck</i>
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
			$(EXECDQI) | tee dqi.log

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

### Example: DEFINITION
<pre>
[510-RCXT.dfd]
  FLOW    510-RCXT
  INPUT   DEF_FILE  = design.def
  OUTPUT  SPEF_FILE = design.spef.gz
  PARAM   rc_corner = Cmax
  EXECUTE run_rcxt.tcl
  END
  
[511-SPEF2SDF.dfd]
  FLOW    511-SPEF2SDF
  INPUT   VLOG_FILE = design.v
  INPUT   SPEF_FILE = design.spef.gz
  OUTPUT  SDF_FILE  = design.sdf.gz
  PARAM   op_corner = WCL
  EXECUTE run_spef2sdf.tcl
  END

[521-DEF2SDF.dfd]
  FLOW    521-DEF2SDF
  INPUT   VLG_FILE  = design.v
  INPUT   DEF_FILE  = design.def
  OUTPUT  SPEF_FILE = design.spef.gz
  OUTPUT  SDF_FILE  = design.sdf.gz
  PARAM   rc_corner = Cmax_WCL
  PARAM   op_corner = WC
  
  STEP 510-RCXT  rcxt_spef
  \+ DEF_FILE  \< $DEF_FILE
  \+ SPEF_FILE > $SPEF_FILE
  \@ rc_corner = $rc_corner
  ;
  STEP 511-SPEF2SDF spef2sdf
  \+ VLOG_FILE \< $VLG_FILE
  \+ SPEF_FILE \< $SPEF_FILE
  \+ SDF_FILE  > $SDF_FILE
  \@ op_corner = $op_corner
  ;
  
  END
</pre>

### Example: Flow Run Directory
<pre>
.dfa/	"DEFINITION PARAMETER"	
.techlib -> /project/<i>project_id</i>/techlib/<i>techlib_id</i>
.design -> /project/<i>project_id<id>/design/<i>phase</i>/<i>block</i>/<i>stage</i>/<i>version</i>/
.script -> /project/<i>project_id</i>/script
.inp$DEF_FILE  -> .design/design.def
.out$SPEF_FILE -> 401-RXCT::rcxt_spef/.out$SPEF_FILE		
.out$SDF_FILE  -> 511-SPEF2SDF::spef2sdf/.out$SDF_FILE
::main/
	script -> ../.script/521-DEF2SDF
	design.def -> ../.inp$DEF_FILE
	design.spef.gz -> ../.out$SPEF_FILE
	design.sdf.gz  -> ../.out$SDF_FILE
	Makefile -> script/Makefile

		# FLOW := 521-DEF2SDF
		INPUT  := design.def
		OUTPUT := design.spef.gz design.sdf.gz
		PRECHECK  :=
		POSTCHECK :=
		run: $(PRECHECK)
			make $(OUTPUT) | tee run.log
		$(INPUT):
			@echo "ERROR: Missing input file '$@'..." | tee -a error.log
		precheck: $(INPUT)
			$(PRECHECK) | tee precheck.log
		postcheck: $(OUTPUT)
			$(POSTCHECK) | tee postcheck.log

		design.spef.gz: design.def
			cd ../510-RCXT::rcxt_spef/::main; make design.spef.gz
		design.sdf.gz:	design.spef.gz
			cd ../511-SPEF2SDF::spef2sdf/::main; make design.sdf.gz
		
510-RCXT::rcxt_spef/
	.dfa/	"DEFINITION PARAMETER"
	.techlib -> ../.techlib	
	.design -> ../.design	
	.script -> ../.script
	.inp$DEF_FILE  -> ../.inp$DEF_FILE	
	.out$SPEF_FILE -> ::main/design.spef.gz
	::main/
		script -> ../.script/510-RCXT
		design.def -> ../.inp$DEF_FILE
		design.spef.gz
		Makefile -> script/Makefile

			# FLOW := 510-RCXT
			INPUT  := design.def
			OUTPUT := design.spef.gz
			PRECHECK  :=
			POSTCHECK := 
			run: precheck
				make $(OUTPUT) | tee run.log
			$(INPUT):
				@echo "ERROR: Missing input file '$@'..." | tee -a error.log
			precheck: $(INPUT)
				$(PRECHECK) | tee precheck.log
			postcheck: $(OUTPUT)
				$(POSTCHECK) | tee postcheck.log
			$(OUTPUT) : $(INPUT)
				script/run.tcl

511-SPEF2SDF::spef2sdf/
	.dfa/	"DEFINITION PARAMETER"
	.design -> ../.design	
	.techlib -> ../.techlib
	.script -> ../.script
	.inp$SPEF_FILE -> ../.out$SPEF_FILE
	.out$SDF_FILE -> ::main/$design.sdf.gz	
	::main/
		script -> ../.script/511-SPEF2SDF
		design.spef.gz -> .../.inp$SPEF_FILE
		design.sdf.gz
		Makefile -> script/Makefile
</pre>
