# This script handles Sysmon Process Terminate event and writes contents to sysmon_procTerminate.log.
# Version 1.0 (November 2018)
#
# Authors: Jeff Atkinson (jatkinson@salesforce.com)
#
# Copyright (c) 2017, salesforce.com, inc.
# All rights reserved.
module Sysmon;

export {

    redef enum Log::ID += {ProcTerminate};


    type procTerminate:record {
	computerName: string &log &optional;
	processId: string &log &optional;
	image: string &log &optional;
	processGuid: string &log &optional;
	utcTime: string &log &optional;
	};


    global log_procTerminate: event(rec: procTerminate);
}


event bro_init() &priority=5
    {
    Log::create_stream(Sysmon::ProcTerminate, [$columns=procTerminate, $ev=log_procTerminate, $path="sysmon_procTerminate"]);
}

event sysmonProcessTerminated(computerName: string, image: string, processGuid: string, processId: string, utcTime: string)
{
local r: procTerminate;
#print "HERE";
r$computerName = computerName;
r$utcTime = utcTime;
r$image = image;
r$processGuid = processGuid;
r$processId = processId;


#print "Writing log";
Log::write(Sysmon::ProcTerminate, r);
}
