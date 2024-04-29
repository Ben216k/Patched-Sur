set libName to "HaxLib.dylib"
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

if bootArgs does not contains "amfi_get_out_of_my_way" then
	warn("amfi_get_out_of_my_way doesn't seem to be set.")
end if

try
	do shell script "open -b " & targetBundle
on error
	crash("Can't open the installer app.")
end try

set libPath to quoted form of POSIX path of (path to resource libName)
do shell script "launchctl setenv DYLD_INSERT_LIBRARIES " & libPath & "
sleep 10
launchctl unsetenv DYLD_INSERT_LIBRARIES"