//
//  BPPassbookViewController.m
//  Passbook
//
//  Created by Bojan Percevic on 9/17/12.
//  Copyright (c) 2012 Bojan Percevic. All rights reserved.
//

#import "BPPassbookViewController.h"
#import "BPPassbookView.h"
#import "BPCard.h"

@interface BPPassbookViewController () <BPPassbookDataSource>

@end

@implementation BPPassbookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    BPPassbookView *passbookView = [[BPPassbookView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    passbookView.passbookDataSource = self;
    [self.view addSubview:passbookView];
}

- (UIColor *)colorForNumber:(NSUInteger)number
{
	CGFloat hue = (0.618033988749895 * number);
	hue = hue - floorf(hue);
	return [UIColor colorWithHue:hue saturation:0.75 brightness:0.95 alpha:1.0f];
}

#pragma mark -
#pragma mark BPPassbookDataSource Required
- (NSInteger)numberOfColumnSectionsInPassbookView:(BPPassbookView *)passbookView
{
    return 6;
}

- (NSInteger)passbookView:(BPPassbookView *)passbookView numberOfColumnsInColumnSection:(NSInteger)section
{
    if(section%2 == 0)
    {
        return 4;
    } else {
        return 2;
    }
}


#pragma mark -
#pragma mark BPPassbookDataSource Optional
- (UIView *)passbookView:(BPPassbookView *)passbookView viewForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    BPCard *card = [[BPCard alloc] initWithFrame:[passbookView safeFrame]];
    card.label.text = [NSString stringWithFormat:@"ColumnSection %i, Column %i", indexPath.section, indexPath.row];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        card.backgroundColor = [UIColor redColor];        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(10, card.frame.size.height-54, card.frame.size.width-20, 44);
        [btn setTitle:@"button" forState:UIControlStateNormal];
        [card addSubview:btn];
    }
    else
    {
        card.backgroundColor = [self colorForNumber:arc4random_uniform(74)];
    }
    return card;
}


@end
