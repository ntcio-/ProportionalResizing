//
//  UIView+ProportionalResizing.h
//  ProportionalResizing
//
//  Created by Tsiolas Nikos on 17/01/18.
//  Copyright © 2018 Advantage FSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ProportionalResizing)

// adaptation factors
+ (CGFloat)horizontalAdaptationFactor;
+ (CGFloat)verticalAdaptationFactor;
+ (CGFloat)imageAdaptationFactor;
+ (CGFloat)fontAdaptationFactor;

// collecting views and constraints
+ (NSArray*)constraintsOfViews:(NSArray *)viewsArray;
+ (NSArray*)allSubviewsOfView:(UIView *)view;
- (NSArray*)allSubviews;

// adaptation methods
+ (void)adaptViews:(NSArray *)viewsArray;
+ (void)adaptImageViews:(NSArray *)viewsArray;
+ (void)adaptFontsForViews:(NSArray<UIView *> *)viewsArray;
- (void)adaptForAllDevices;
- (void)adaptFont;

// UITableView methods
- (void)sizeHeaderToFitForTableView:(UITableView *)tableView;
- (void)sizeFooterToFitForTableView:(UITableView *)tableView;

@end

@interface NSArray (Extras)

+ (NSArray*)arrayWithArray:(NSArray*)array excludingObjectsOfTypes:(NSArray<Class>*)typesArray;
+ (NSArray*)arrayWithArray:(NSArray*)array filteringWithObjectsOfTypes:(NSArray<Class>*)typesArray;

@end

@interface UIViewController (ProportionalResizing)

- (void)adaptForAllDevices;

@end
