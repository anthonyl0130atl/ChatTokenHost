//
//  ViewController.m
//  ChatTokenHost
//
//  Created by anthonyl on 4/9/15.
//  Copyright (c) 2015 anthonyl. All rights reserved.
//

#import "ViewController.h"

#import "ParserChain.h"
#import "ParserEmotes.h"
#import "ParserURLs.h"
#import "ParserMentions.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) ParserChain *chain;
@end

@implementation ViewController

- (void) runParserWithString : (NSString *) string
{
    __weak typeof(self) weakSelf = self;

    [self.chain executeWithString:string andCompletion:^(NSDictionary * result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        DDLogDebug(@"Parse Complete | %@", result);
    
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:result  options:NSJSONWritingPrettyPrinted error:nil];
        if (jsonData) {
            strongSelf.textView.text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
        }
        
    }];
}

- (IBAction) tapExecute : (UIButton *) sender
{
    [self runParserWithString:self.textField.text];
}

- (void) setupChain
{
    self.chain = [[ParserChain alloc] initWithParsers:
                  @[
                    [[ParserEmotes alloc] init],
                    [[ParserURLs alloc] init],
                    [[ParserMentions alloc] init],
                    ]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self runParserWithString:@"Hello @anthony and @ashley checkout (wink) http://international.nytimes.com/ (smile) () http://www.google.com http://www.apple.com"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
