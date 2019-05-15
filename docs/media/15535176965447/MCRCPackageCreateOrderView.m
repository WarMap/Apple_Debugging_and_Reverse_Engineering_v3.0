//
//  MCRCPackageCreateOrderView.m
//  MCRentCar
//
//  Created by warmap on 2019/4/16.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import "MCRCPackageCreateOrderView.h"
#import "MCRCCreateOrderButton.h"

@interface MCRCPackageCreateOrderView ()

@property (nonatomic, strong) MCRCCreateOrderButton *button;

@end

@implementation MCRCPackageCreateOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeSubviews];
	}
	return self;
}

- (void)initializeSubviews {
	self.button = [MCRCCreateOrderButton buttonWithTitle1:@"使用此方案叫车" title2:@"请选择车型" enble:NO];
	//	CGFloat margin = ScreenAdapt375(8);
	self.button.layer.cornerRadius = ScreenAdapt375(22.0);
	self.button.layer.masksToBounds = YES;
	[self.button normalTitleColor:[UIColor whiteColor]];
	[self.button disableTitleColor:[UIColor whiteColor]];
	[self.button normalBackgroundImageColor:HexColor(0x3385ff)];
	[self.button disableBackgroundImageColor:HexColor(0xB2CCFB)];
	[self.button addTarget:self action:@selector(clickedRightButton) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.button];
	
}

- (void)clickedRightButton {
		if (self.clickedRightBlock) {
			self.clickedRightBlock();
		}
}

- (void)updateTitle1:(NSString *)title {
	[self.button updateTitle1:title];
}
- (void)updateTitle2:(NSString *)title {
	[self.button updateTitle2:title];
}
- (void)updateTitle1:(NSString *)title title2:(NSString *)title2 enble:(BOOL)enble {
	[self.button updateTitle1:title title2:title2 enble:enble];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat margin = ScreenAdapt375(8);
	self.button.frame = CGRectMake(margin, ScreenAdapt375(10), self.width-2*margin, ScreenAdapt375(44));
}


@end
