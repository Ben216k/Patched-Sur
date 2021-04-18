//
//  PSApp.h
//  Patched Sur
//
//  Created by Ben Sova on 4/16/21.
//

#import <Foundation/Foundation.h>

@interface PSApp : NSObject

+(NSString*_Nonnull)version;
+(NSString*_Nonnull)build;
+(NSString*_Nonnull)macOS;
+(NSArray*_Nonnull)runTask:(NSString*_Nonnull)binary arguments:(NSArray<NSString *> * _Nullable)arguments;

@end
