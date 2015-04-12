//
//  ChatTokenHostTests.m
//  ChatTokenHostTests
//
//  Created by anthonyl on 4/9/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ParserURLs.h"
#import "ParserEmotes.h"
#import "ParserMentions.h"

@interface ChatTokenHostTests : XCTestCase

@end

@implementation ChatTokenHostTests

- (void)setUp {
    [super setUp];
    
    sleep(1); // TODO remove, added for debugging

}

- (void)tearDown {
    [super tearDown];
}

- (void) testEmotes
{
    [self assertEmoteDetected:@"(wink)" : @"wink"];
    [self assertEmoteCount:@"(wink)" :1];
    [self assertEmoteCount:@"(wink)(smile)" :2];
    [self assertEmoteCount:@"(wink)(smile)(boom)" :3];
    [self assertEmoteDetected:@"(()(())))))(howdy)(wink)(smile(((" : @"wink"];
    [self assertEmoteDetected:@"(()(())))))(()(howdy)))(wink)(smile(((" : @"howdy"];
    [self assertEmoteDetected:@"Hey @anthony how are you?? (howdy)" : @"howdy"];
    [self assertEmoteNotDetected:@"Hey @anthonyhttp://www.wfajfsajfsafsajfas.net how are you?? howdy)" : @"howdy"];
    [self assertEmoteNotDetected:@"Hey @anthony how are you?? (howdy" : @"howdy"];
    [self assertEmoteNotDetected:@"Hey @anthony how are you?? )howdy(" : @"howdy"];
}

- (void) testMentions
{
    [self assertMentionDetected:@"@anthony" :@"anthony"];
    [self assertMentionDetected:@"@ashley @anthony" :@"ashley"];
    [self assertMentionDetected:@"@anthony @anthony2 @ashley" :@"ashley"];
    [self assertMentionDetected:@"Howdy @1293193912312391213Anthony," :@"1293193912312391213Anthony"];
    [self assertMentionDetected:@"Hello @Anthony+@Ashley," :@"Anthony"];
    [self assertMentionDetected:@"@anthony,@ashley are either of you need github access?," :@"ashley"];
    [self assertMentionDetected:@"@anthony,@ashley are either of you need github access?," :@"anthony"];
    [self assertMentionDetected:@"@anthony,@ashley are either -- @james?," :@"anthony"];
    [self assertMentionCount:@"@anthony,@ashley are either -- @james?" :3];
    [self assertMentionCount:@"@anthony are you in today?" :1];
}

- (void) testSingleURL
{
    [self assertURLDetected:@"Hello http://www.google.com" : @"http://www.google.com"];
}

- (void) testMultiURL
{
    [self assertURLDetected:@"http://www.google.co.uk is good so is http://www.apple.com" : @"http://www.google.co.uk"];
}

- (void) testFunnyURL
{
    [self assertURLDetected:@"http://www.google.co.uk is good http://as.asdj.asfs.asfasf.com so is http://www.apple.com" : @"http://as.asdj.asfs.asfasf.com"];
}

// Network access required / external resource requirement

- (void) testURLTitle
{
    [self assertURLTitle:@"....!!!!~~~~ http://www.apple.com !!!!~~~~~..." :@"Apple"];
}


- (void) assertEmoteNotDetected : (NSString *) s : (NSString *) emote
{
    ParserBase *p = [[ParserEmotes alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSString *d in result) {
        if ([d isEqualToString:emote]) {
            [NSException raise:@"EmountFound" format:@""];
        }
    }
}

- (void) assertEmoteDetected : (NSString *) s : (NSString *) emote
{
    ParserBase *p = [[ParserEmotes alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSString *d in result) {
        if ([d isEqualToString:emote]) {
            return;
        }
    }
    [NSException raise:@"NoEmoteException" format:@""];
}

- (void) assertEmoteCount : (NSString *) s : (int) count
{
    ParserBase *p = [[ParserEmotes alloc] init];
    NSArray *result = [p runWithString:s];
    if (result.count != count) {
        [NSException raise:@"InvalidEmoteCount" format:@""];
    }
}

- (void) assertMentionCount : (NSString *) s : (int) count
{
    ParserBase *p = [[ParserMentions alloc] init];
    NSArray *result = [p runWithString:s];
    if (result.count != count) {
        [NSException raise:@"InvalidMentionCount" format:@""];
    }
}

- (void) assertMentionDetected : (NSString *) s : (NSString *) mention
{
    ParserBase *p = [[ParserMentions alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSString *d in result) {
        if ([d isEqualToString:mention]) {
            return;
        }
    }
    [NSException raise:@"NoMention" format:@""];
}

- (void) assertMentionNotDetected : (NSString *) s : (NSString *) mention
{
    ParserBase *p = [[ParserMentions alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSString *d in result) {
        if ([d isEqualToString:mention]) {
            [NSException raise:@"MentionFound" format:@""];
        }
    }
}

- (void) assertURLDetected : (NSString *) s : (NSString *) targetUrl
{
    ParserBase *p = [[ParserURLs alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSDictionary *d in result) {
        NSString *url = [d objectForKey:@"url"];
        if ([url isEqualToString:targetUrl]) {
            return;
        }
    }
    [NSException raise:@"URLNotFound" format:@""];
}

- (void) assertURLTitle : (NSString *) s : (NSString *) targetTitle
{
    ParserBase *p = [[ParserURLs alloc] init];
    NSArray *result = [p runWithString:s];
    for (NSDictionary *d in result) {
        NSString *title = [d objectForKey:@"title"];
        if ([title isEqualToString:targetTitle]) {
            return;
        }
    }
    [NSException raise:@"URLTitleNotFound" format:@""];
}



@end
