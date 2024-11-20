// forked version of 7,1 patcher's InstallerInject.m for MinhTon

@import Foundation;
#import "Utils/Trace.m"
#import "Utils/Swizzling.m"

@interface Fake:NSObject
@end

@implementation Fake

// prevent sealing
-(BOOL)fake_doNotSealSystem
{
	trace(@"doNotSealSystem");
	return true;
}

// force old compatibility checks even on a Big Sur system
-(BOOL)fake_isLegacyMSUSpringboard
{
	trace(@"isLegacyMSUSpringboard");
	return true;
}

// slightly cleaner way to force compatibility checks to succeed
-(BOOL)fake_runningInVirtualMachine
{
	trace(@"runningInVirtualMachine");
	return true;
}

// ignore lack of APFS boot ROM support
+(BOOL)fake_apfsSupportedByROM
{
	trace(@"apfsSupportedByROM");
	return true;
}

@end

void swizzlePrintingResult(NSString* className,NSString* selName,BOOL isInstance)
{
	trace(@"swizzle %@.%@: %@",className,selName,swizzleSimple(className,selName,isInstance)?@"success":@"failure");
}

@interface Inject:NSObject
@end

@implementation Inject

+(void)load
{
	traceSetPrefix(@"Hax4: ");
	traceSetLog(true);
	
	NSString* processName=NSProcessInfo.processInfo.processName;
	
	if([processName containsString:@"osinstallersetupd"])
	{
		trace(@"loading hacks for osinstallersetupd");
		
		swizzlePrintingResult(@"OSISCustomizationController",@"doNotSealSystem",true);
		swizzlePrintingResult(@"OSISCustomizationController",@"isLegacyMSUSpringboard",true);
		swizzlePrintingResult(@"BIBuildInformation",@"runningInVirtualMachine",true);
		swizzlePrintingResult(@"OSISUtilities",@"apfsSupportedByROM",false);
	}
}

@end