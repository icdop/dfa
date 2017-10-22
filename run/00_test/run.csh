#!/bin/csh -f
setenv DOP_HOME /home/hungchun/GITHOME
set path = ($DOP_HOME/dop/bin $DOP_HOME/dvc/bin $DOP_HOME/dfa/bin $path)
dvc_create_project testcase
dvc_create_version 2017_0901-xxx
 
