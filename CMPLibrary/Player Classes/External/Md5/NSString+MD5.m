//
//  Copyright iOSDeveloperTips.com All rights reserved.
//
 
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
 
@implementation NSString(MD5)
 
- (NSString*)MD5
{
	// Create pointer to the string as UTF8
  const char *ptr = [self UTF8String];

 	// Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

	// Create 16 bytes MD5 hash value, store in buffer
  CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

	// Convert unsigned char buffer to NSString of hex values
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x",md5Buffer[i]];

  return output;
}


//  NSString+Encode.m

- (NSString *)encodeString:(NSStringEncoding)encoding {
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,                                                                NULL, (CFStringRef)@";/?:@&=$+{}<>,",CFStringConvertNSStringEncodingToEncoding(encoding)));
}  

- (BOOL)containsSubString:(NSString*)subString
{
    NSRange range = [self rangeOfString:subString];
    return range.length != 0;
}



@end
