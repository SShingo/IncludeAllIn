Type : Package
Package : IncludeAllIn
Title : InstallAllIn SAS package
Version : 1.0.0
Author : Shingo Suzuki(shingo.suzuki@sas.com)
Maintainer : Shingo Suzuki(shingo.suzuki@sas.com)
License : SAS
Encoding : UTF8
Required : "Base SAS Software"
ReqPackages :  

DESCRIPTION START:
# The IncludeAllIn package [ver. 1.0] <a name="includeallin-package"></a> ###############################################
This package provides "InstallAllIn" macro.
InstallAllIn macro includes all .sas files in the specified directory and its sub-directories.

Typical usage of "IncludeAllIn" macro is shown in below.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  %IncludeAllIn(/tmp/program)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The all .sas programs contaied in /tmp/program and its sub-directories will be included.
See the help for the `IncludeAllIn` macro to find more examples. 

### Content ###################################################################

SQLinDS package contains the following components:

1. `InstallAllIn` macro - the main package macro available for the User
2. `Prv_DoIncludingProcess.sas` internal used macro
3. `Prv_IncludeSASFile` internal used macro
4. `Prv_IncludeSASFileHalper` internal used macro
5. `Prv_MakeIncludingFileList.sas` internal used macro
6. `Prv_RSUFile_GetContentsHelper.sas` internal used macro

DESCRIPTION END:
