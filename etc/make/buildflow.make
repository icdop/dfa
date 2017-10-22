#
# Flow target:
#
# build:
#	- build required file link and iterate through flow steps
#
#	- create input file link
#		:input:INP_FILE  --> $(INP_FILE)
#	- create output file link
#		:output:LOG_FILE --> $(LOG_FILE)
#	- create local file link
#		:local:TMP_FILE --> $(TMP_FILE)
#
# run:
#	- iterate through each flow step and run each step sequentially
#
# reset:
#	- reset the output result for re-run
#
# clean:
#	- remove all file links and delete sub steps directorires
#
#
_FLOW_DSTAMP	= `date +%D%T`

.FLOW_BUILD_CMD	=
_CMD_run	= make run
_CMD_dqi	= make dqi
_CMD_init	= make .FLOW_CLEAN_FILES .FLOW_CLEAN_LINKS
_CMD_clean	=

help:
	@echo "=============================================================="
	@echo "PWD      = $(PWD)"
	@echo "SVN_ROOT = $(SVN_ROOT)"
	@echo "SVN_URL  = $(SVN_URL)"
	@echo "=============================================================="
	@echo "Usage:"
	@echo "        make build     ; build the flow run directory"
	@echo "        make init      ; remove all output files"
	@echo "        make run       ; run the flow step squentially"
	@echo ""
	@echo "Usage:  make clean     (clean_data)"
	@echo ""
	

build: .FLOW_BUILD
.FLOW_BUILD: $(_FLOW_INPUTS) $(_FLOW_OUTPUTS) $(_FLOW_REPORTS) $(_FLOW_TEMPS) $(_FLOW_STEPS)
	@rm -f .FLOW.BUILD .FLOW_RUN .FLOW_DRY_RUN
	@for step in $(_FLOW_STEPS); do ( \
		cd :STEP:$$step; \
		echo "*** Building [:STEP::$$dir]..."; \
		make $@; \
	); done;
	@eval $($@_CMD)
	@echo $(_FLOW_DSTAMP) > .FLOW_BUILD

run: .FLOW_RUN
.FLOW_RUN: .FLOW_BUILD
	@rm -f .FLOW_RUN
	@for step in $(_FLOW_STEPS); do \
	(cd :STEP:$$step; echo "*** Entering [:STEP:$$step]..."; make $@); \
	done;
	eval $(_CMD_run)
	@echo $(_FLOW_DSTAMP) > .FLOW_RUN

dqi: .FLOW_DQI
.FLOW_DQI: .FLOW_RUN
	@rm -f .FLOW_DQI
	@for step in $(_FLOW_STEPS); do \
	(cd :STEP:$$step; echo "*** Entering [:STEP:$$step]..."; make $@); \
	done;
	eval $(_CMD_dqi)
	@echo $(_FLOW_DSTAMP) > .FLOW_DQI

dry_run:
.FLOW_DRY_RUN: .FLOW_BUILD
	@rm -f .FLOW_DRY_RUN
	@for step in $(_FLOW_STEPS); do \
	(cd :STEP:$$step; echo "*** Entering [:STEP:$$step]..."; make $@); \
	done;
	@for file in $(_FLOW_OUTPUTS); do \
		touch `realpath :output:$$file`; \
	done;
	@echo $(_FLOW_DSTAMP) > .FLOW_DRY_RUN

init: .FLOW_INIT
.FLOW_INIT:
	@for step in $(_FLOW_STEPS); do \
	(cd :STEP:$$step; echo "*** Initalizing [:STEP:$$step]..."; make $@); \
	done;
	@eval $(_CMD_init)
	@rm -f .FLOW_RUN .FLOW_DRY_RUN

clean: .FLOW_CLEAN
.FLOW_CLEAN:
	@for step in $(_FLOW_STEPS); do \
	(echo "*** Cleaning [:STEP:$$step]..."; rm -fr :STEP:$$step;); \
	done
	@eval $(_CMD_clean)
	@rm -f .FLOW_*

.FLOW_CLEAN_OUTPUTS: $(_FLOW_OUTPUTS)
	rm -f .FLOW_DONE
	@for file in $(_FLOW_OUTPUTS); do \
		rm -fr `realpath :output:$$file`; \
	done

.FLOW_CLEAN_FILES: $(_FLOW_OUTPUTS) $(_FLOW_REPORTS) $(_FLOW_TEMPS)
	rm -f .FLOW_DONE
	@for file in $(_FLOW_OUTPUTS); do \
		rm -fr `realpath :output:$$file`; \
	done
	@for file in $(_FLOW_REPORTS); do \
		rm -fr `realpath :report:$$file`; \
	done
	@for file in $(_FLOW_TEMPS); do \
		rm -fr `realpath :temp:$$file`; \
	done
	
.FLOW_CLEAN_LINKS:
	@for file in $(_FLOW_INPUTS); do \
		rm -fr :input:$$file; \
	done
	@for file in $(_FLOW_OUTPUTS); do \
		rm -fr :output:$$file; \
	done
	@for file in $(_FLOW_REPORTS); do \
		rm -fr :report:$$file; \
	done
	@for file in $(_FLOW_TEMPS); do \
		rm -fr :temp:$$file; \
	done


# design.def -> :input:DEF_FILE
$(_FLOW_INPUTS):
	ln -fs :input:$@	$($@)
	
# :output:SPEF_FILE -> design.spef
$(_FLOW_OUTPUTS):
	ln -fs $($@)		:output:$@

# :report:LOG_FILE -> star_rc.log
$(_FLOW_REPORTS):
	ln -fs $($@)		:report:$@

# :temp:LOG_FILE -> temp_file
$(_FLOW_TEMPS):
	ln -fs $($@)		:temp:$@

$(_FLOW_STEPS):
	mkdir -p :STEP:$@
	@ln -fs ../makefile.flow 	:STEP:$@/makefile.flow
	@ln -fs ../.flow		:STEP:$@/.flow
	@ln -fs ../.techlib		:STEP:$@/.techlib
	@ln -fs ../.project		:STEP:$@/.project
	@echo "FLOW_NAME = $($@)"			>  :STEP:$@/Makefile
	@echo "FLOW_PATH = \`glob .flow/$$(FLOW_NAME)\`">> :STEP:$@/Makefile
	@echo "include $$(FLOW_PATH)/flow.options"	>> :STEP:$@/Makefile
	@echo "include $$(FLOW_PATH)/flow.files" 	>> :STEP:$@/Makefile
	@echo "include $$(FLOW_PATH)/flow.steps" 	>> :STEP:$@/Makefile
	@echo "include $$(FLOW_PATH)/flow.targets"	>> :STEP:$@/Makefile
	@echo "include makefile.flow"			>> :STEP:$@/Makefile
		

.flow:
	ln -s $(DOP_HOME)/dfa/flow .flow

makefile.flow:
	ln -s $(DOP_HOME)/dfa/etc/make/flow.make makefile.flow
