//
//  ParserBase.h
//  ChatTokenHost
//
//  Created by anthonyl on 4/11/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserBase : NSObject

- (NSArray *) runWithString : (NSString *) string;

@property (nonatomic, readonly) NSString * key;

@end
