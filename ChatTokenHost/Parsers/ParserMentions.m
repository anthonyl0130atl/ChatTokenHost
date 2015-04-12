//
//  ParserMentions.m
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import "ParserMentions.h"

@implementation ParserMentions

- (NSString *) key
{
    return @"mentions";
}

- (NSArray *) runWithString : (NSString *) string
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /*
     [@] Match starting token '('
     [A-Za-z0-9] {1,} Match the remaning content of the username require the mention have some text
    */
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[@][A-Za-z0-9]{1,}" options:0 error:nil];
    NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for ( NSTextCheckingResult* match in matches ) {
        NSString* matchText = [string substringWithRange:[match range]];
        [result addObject:[matchText substringFromIndex:1]];
    }
    
    return (result.count > 0) ? result : nil;
}

@end
