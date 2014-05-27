"""
GRAB COMMON REGISTRY LOCATIONS
2013-12-07	M.Ulm

This script will grab the most common registry keys from
the configured memory image. Additions should be added as 
we go.
"""


"""
These are the location I would like to grab.
"Microsoft\Windows NT\CurrentVersion\Winlogon"
"Software\Microsoft\Windows\CurrentVersion\Run"
"Software\Microsoft\Windows\CurrentVersion\RunOnce"
"Software\Microsoft\Windows\CurrentVersion\RunOnceEx"

Dump all scheduled Tasks

SANS CHKECS

Detection 7:
To check to see if any malware has registered for login events check the following registry key:
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify == check this.

If the subkey doesn't exist you are in good shape.   If a subkey with any name exists and it has a "shutdown" value then the dll in the "DLLName" key will be launched during the shutdown process.   Check that DLL to see what it does.   You should expect that it does very little beyond loading another payload from somewhere else on the hard drive.   Here is an example of a registry key registering scard32.dll or shutdown events.
"""