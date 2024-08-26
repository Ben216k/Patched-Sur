set libName to "Hax2Lib.dylib"
set targetBundle to "com.apple.InstallAssistant.Seed.macOS1016Seed1"

to crash(message)
	display dialog message with icon stop with title "Error" buttons {"Stop"} default button 1 cancel button 1
end crash
to warn(message)
	display dialog message with icon caution with title "Warning" buttons {"Stop", "Continue"} default button 1 cancel button 1
end warn

do shell script "csrutil status"
if result does not contain "disabled" then
	warn("SIP seems to be enabled.")
end if

set bootArgs to (do shell script "nvram boot-args")
if bootArgs does not contain "-no_compat_check" then
	warn("-no_compat_check doesn't seem to be set.")
end if

set lvOn to true
try
	do shell script "defaults read /Library/Preferences/com.apple.security.libraryvalidation.plist  DisableLibraryValidation"
	if result is "1" then
		set lvOn to false
	end if
end try
if bootArgs contains "amfi_get_out_of_my_way" then
	set lvOn to false
end if
if lvOn then
	warn("Library Validation might be on.")
end if

try
	do shell script "open -b " & targetBundle
on error
	crash("Can't open the installer app.")
end try

set libPath to quoted form of POSIX path of (path to resource "Hax2Lib.dylib")
do shell script "launchctl setenv DYLD_INSERT_LIBRARIES " & libPath & "
sleep 10
launchctl unsetenv DYLD_INSERT_LIBRARIES"