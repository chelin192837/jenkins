//
//  ViewController.m
//  xcodeBuild
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ViewController.h"
static int count = 1 ;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.versionLabel.text = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];

}
- (IBAction)countClick:(id)sender {
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",count++];
    
}


@end
