//
//  OrderSummaryReusableView.m
//  Gizmeondeals
//
//  Created by Maneesh M on 28/04/15.
//  Copyright (c) 2015 Maneesh M. All rights reserved.
//

#import "OrderSummaryReusableView.h"

@implementation OrderSummaryReusableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    
    UINib* nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    [nib instantiateWithOwner:self options:nil];
    
    self.view.frame = self.bounds;
    
    [self addSubview:self.view];
    
    
    return self;
}

-(CGRect) frameForNextView
{
    
    CGRect thisFrame = self.frame;
    
    CGRect nextFrame = CGRectMake(thisFrame.origin.x, thisFrame.origin.y+thisFrame.size.height, thisFrame.size.width, thisFrame.size.height)
    ;
    
    
    return nextFrame;
}











@end
