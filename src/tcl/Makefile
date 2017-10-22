include ../../etc/make/header.make

#
# publish script to $(LIBS_DIR)
publish: 
	cp lib/package.tcl $(LIBS_DIR)/libdfa.tcl

# concat tcl script to lib/package.tcl
merge:
	$(BIN_DIR)/concat_tcl.tcl -cfg genlib.cfg -o lib/package.tcl 

# split package.tcl to individual tcl file
split:
	$(BIN_DIR)/split_tcl.tcl $(LIBS_DIR)/dfa.tcl


