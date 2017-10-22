#!/bin/tclsh

#package require cmdline
array set FLOW_MAP {}
array set FLOW_DEF {}
set FLOW_ID 0

proc flow {name version} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  upvar FLOW_MAP map
  incr flow_id
  set map($name) $flow_id
  set flow_def($flow_id,version) $version
}

proc .header {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,header,$name) $value
}

proc .model {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,model,$name) $value
}


proc .input {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,option,$name) $value
  lappend flow_def($flow_id,input) $value
}

proc .output {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,output,$name) $value
}

proc .report {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,report,$name) $value
}

proc .file {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,file,$name) $value
}

proc .option {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,option,$name) $value
}

proc .target {name value {command ""}} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,target,$name) $value
  set flow_def($flow_id,command,$name) $command
}

proc .command {name value} {
  upvar FLOW_DEF flow_def
  upvar FLOW_ID  flow_id
  set flow_def($flow_id,depend,$name) $depend
}

