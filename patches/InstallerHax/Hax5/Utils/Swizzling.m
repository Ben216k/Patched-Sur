@import ObjectiveC.runtime;
@import MachO.loader;

Method getMethod(NSString* className,NSString* selName,BOOL isInstance)
{
	Class class=NSClassFromString(className);
	SEL sel=NSSelectorFromString(selName);
	
	if(isInstance)
	{
		return class_getInstanceMethod(class,sel);
	}
	return class_getClassMethod(class,sel);
}

BOOL swizzle(NSString* realClass,NSString* fakeClass,NSString* realSel,NSString* fakeSel,BOOL isInstance)
{
	Method realMethod=getMethod(realClass,realSel,isInstance);
	Method fakeMethod=getMethod(fakeClass,fakeSel,isInstance);
	
	if(!realMethod||!fakeMethod)
	{
		return false;
	}
	
	method_exchangeImplementations(realMethod,fakeMethod);
	
	return true;
}

BOOL swizzleSimple(NSString* className,NSString* selName,BOOL isInstance)
{
	NSString* fakeSelName=[@"fake_" stringByAppendingString:selName];
	return swizzle(className,@"Fake",selName,fakeSelName,isInstance);
}