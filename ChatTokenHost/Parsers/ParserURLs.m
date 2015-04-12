//
//  ParserURLs.m
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import "ParserURLs.h"

@implementation ParserURLs

- (NSString *) key
{
    return @"links";
}

// Having this method block made reasoning about concurrency a lot easier
// an alternative would have been juggling AFNetworking dispatch queues
// but I'd like to avoid that and leave concurrency up to the caller (runWithString)

- (NSString *) loadTitleForURL : (NSString *) url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *res = nil;
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if (error) {
        DDLogVerbose(@"Request error (%@)", error.localizedDescription);
        return nil;
    }
    
    if (data == nil) {
        return nil;
    }
    
    NSString *content =[ NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
    
    if (content == nil) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<title[^>]*>(.*?)</title>" options:NSRegularExpressionCaseInsensitive error:NULL];    NSArray* matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    
    for ( NSTextCheckingResult* match in matches ) {
        NSString *matchText = [content substringWithRange:[match range]];
        matchText = [matchText stringByReplacingOccurrencesOfString:@"<title>" withString:@""];
        matchText = [matchText stringByReplacingOccurrencesOfString:@"</title>" withString:@""];
        return matchText;
    }
    
    return nil;
}

- (NSArray *) runWithString : (NSString *) string
{
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for ( NSTextCheckingResult* match in matches ) {
            dispatch_group_enter(dispatchGroup);
            dispatch_async(dispatchQueue, ^{
                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                NSString *matchText = [string substringWithRange:[match range]];
                d[@"url"] = matchText;
                
                NSString *title = [self loadTitleForURL:matchText]; // Blocking
                
                if (title) {
                    d[@"title"] = title;
                }
                
                [result addObject:d];
                dispatch_group_leave(dispatchGroup);
            });
    }
    
    // TODO think of what timeout value would be appropriate
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    
    return (result.count > 0) ? result : nil;
}

@end
