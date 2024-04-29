const int ANSI_RED=31;
const int ANSI_GREEN=32;
const int ANSI_YELLOW=33;
const int ANSI_BLUE=34;
const int ANSI_MAGENTA=35;
const int ANSI_CYAN=36;

NSString* tracePrefix=@"";
int traceStyle=0;
BOOL traceLog=false;

void traceSetPrefix(NSString* prefix)
{
	tracePrefix=prefix;
}
void traceSetStyle(int style)
{
	traceStyle=style;
}
void traceSetLog(BOOL flag)
{
	traceLog=flag;
}

void trace(NSString* format,...)
{
	va_list argList;
	va_start(argList,format);
	NSString* message=[NSString.alloc initWithFormat:format arguments:argList];
	va_end(argList);
	
	NSString* prefixedMessage=[tracePrefix stringByAppendingString:message];
	
	if(traceLog)
	{
		NSLog(@"%@",prefixedMessage);
	}
	else
	{
		printf("\e[%dm%s\e[0m\n",traceStyle,prefixedMessage.UTF8String);
		fflush(stdout);
	}
}