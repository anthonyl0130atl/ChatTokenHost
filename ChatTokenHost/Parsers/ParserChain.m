//
//  ParserChain.m
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import "ParserChain.h"
#import "ParserBase.h"

@interface ParserChain()
@property (nonatomic, strong) NSArray *parsers;
@end

@implementation ParserChain

- (instancetype) initWithParsers : (NSArray *) theParsers
{
    self = [super init];
    _parsers = theParsers;
    return self;
}

- (void) executeWithString : (NSString *) string andCompletion:(void (^)(NSDictionary * result)) completion
{
    __block NSMutableDictionary *mappedResults = [[NSMutableDictionary alloc] init];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (ParserBase *parser in self.parsers) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^{
            NSArray *payload = [parser runWithString:string];
            if (payload) {
                [mappedResults setObject:payload forKey:parser.key];
            }
        });
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(mappedResults);
        }
    });
}

@end
