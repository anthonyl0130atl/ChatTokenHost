//
//  ParserChain.h
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserChain : NSObject

- (instancetype) initWithParsers : (NSArray *) theParsers;

- (void) executeWithString : (NSString *) string andCompletion:(void (^)(NSDictionary * result)) completion;

@end
