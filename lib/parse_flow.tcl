#!/bin/tclsh

#package require cmdline
array set FLOW_MAP {}
array set FLOW_DEF {}
set FLOW_ID 0

proc flow {name version} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  upvar FLOW_MAP map
  incr id
  set map($name) $id
  set dfl($id,version) $version
}

proc .header {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,header,$name) $value
}

proc .model {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,model,$name) $value
}


proc .input {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,option,$name) $value
  lappend dfl($id,input) $value
}

proc .output {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,output,$name) $value
}

proc .report {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,report,$name) $value
}

proc .file {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,file,$name) $value
}

proc .option {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,option,$name) $value
}

proc .target {name value {command ""}} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,target,$name) $value
  set dfl($id,command,$name) $command
}

proc .command {name value} {
  upvar FLOW_DEF dfl
  upvar FLOW_ID  id
  set dfl($id,depend,$name) $depend
}

