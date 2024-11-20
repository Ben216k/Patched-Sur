/*

clang -dynamiclib -fmodules InstallHax.m -o Hax.dylib
codesign -f -s - Hax.dylib

csrutil disable
nvram boot-args='-no_compat_check amfi_get_out_of_my_way=1'

launchctl setenv DYLD_INSERT_LIBRARIES $PWD/Hax.dylib

*/

@import Foundation;
@import ObjectiveC.runtime;

void swizzle(Class realClass,Class fakeClass,SEL realSelector,SEL fakeSelector,BOOL instance)
{
	Method realMethod;
	Method fakeMethod;
	if(instance)
	{
		realMethod=class_getInstanceMethod(realClass,realSelector);
		fakeMethod=class_getInstanceMethod(fakeClass,fakeSelector);
	}
	else
	{
		realMethod=class_getClassMethod(realClass,realSelector);
		fakeMethod=class_getClassMethod(fakeClass,fakeSelector);
	}
	
	if(!realMethod||!fakeMethod)
	{
		NSLog(@"swizzle fail");
		return;
	}
	
	method_exchangeImplementations(realMethod,fakeMethod);
	
	NSLog(@"swizzle complete");
}

@interface FakeBIBuildInformation:NSObject
@end
@implementation FakeBIBuildInformation
-(BOOL)fakeIsUpdateInstallable:(id)something
{
	NSLog(@"hax");
	
	return true;
}
@end

@interface FakeOSISCustomizationController:NSObject
@end
@implementation FakeOSISCustomizationController
-(BOOL)fakeHasSufficientSpaceForMSUInstall:(id)thing1 error:(id)thing2
{
	NSLog(@"hax2");
	
	return true;
}
@end

@interface Inject:NSObject
@end
@implementation Inject
+(void)load
{
	NSLog(@"loaded");
	
	swizzle(NSClassFromString(@"BIBuildInformation"),FakeBIBuildInformation.class,@selector(isUpdateInstallable:),@selector(fakeIsUpdateInstallable:),true);
	swizzle(NSClassFromString(@"OSISCustomizationController"),FakeOSISCustomizationController.class,@selector(hasSufficientSpaceForMSUInstall:error:),@selector(fakeHasSufficientSpaceForMSUInstall:error:),true);
}
@end