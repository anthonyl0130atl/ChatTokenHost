//
//  ParserEmotes.m
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import "ParserEmotes.h"

@implementation ParserEmotes

- (NSString *) key
{
    return @"emoticons";
}

- (NSArray *) runWithString : (NSString *) string
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    /*
     
     [(]   Match starting token '('
     [^)]{1,}  Require emote content to be more then one token requre there be some emote payload
     [)]   Termination token
     
     */
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[(][^)]{1,}[)]" options:0 error:nil];
    NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for ( NSTextCheckingResult* match in matches ) {
        NSString* matchText = [string substringWithRange:[match range]];
        NSCharacterSet *parens = [NSCharacterSet characterSetWithCharactersInString:@"()"];
        NSString * cleanText = [[matchText componentsSeparatedByCharactersInSet:
                                  parens]
                                 componentsJoinedByString:@""];
        [results addObject:cleanText];
    }
    
    return (results.count > 0) ? results : nil;
}

@end
