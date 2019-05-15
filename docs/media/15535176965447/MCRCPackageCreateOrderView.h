//
//  MCRCPackageCreateOrderView.h
//  MCRentCar
//
//  Created by warmap on 2019/4/16.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCRCPackageCreateOrderView : UIView

@property (nonatomic, strong) void (^ clickedRightBlock)(void);

- (void)updateTitle1:(NSString *)title title2:(NSString *)title2 enble:(BOOL)enble;

@end

NS_ASSUME_NONNULL_END
