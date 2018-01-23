//
//  UIView+ProportionalResizing.m
//  ProportionalResizing
//
//  Created by Tsiolas Nikos on 17/01/18.
//  Copyright © 2018 Advantage FSE. All rights reserved.
//

#import "UIView+ProportionalResizing.h"
#import "AFSEResizeExcludedView.h"

#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

@implementation UIView (ProportionalResizing)

#pragma mark - Definition methods

// specifying the device height of the prototype
+ (CGFloat)prototypeHeight
{
	return 667.0;
}

// specifying the device width of the prototype
+ (CGFloat)prototypeWidth
{
	return 375.0;
}

// specifying any class types that should be excluded from the adaptation
+ (NSArray<Class> *)typesExcludedFromAdaptation
{
	return @[[AFSEResizeExcludedView class]];
}

#pragma mark - Adaptation factors

+ (CGFloat)horizontalAdaptationFactor
{
	CGFloat ratio = [[UIScreen mainScreen] bounds].size.width / [UIView prototypeWidth];
	return ratio;
}

+ (CGFloat)verticalAdaptationFactor
{
	// adding exceptions to the rule
    if (IS_IPHONE_4) {
        return [UIView horizontalAdaptationFactor] * 1.1;
    }
		
	CGFloat ratio = [[UIScreen mainScreen] bounds].size.height / [UIView prototypeHeight];
	return ratio;
}

+ (CGFloat)imageAdaptationFactor
{
	// adding exceptions to the rule
    if (IS_IPHONE_4) {
		return [UIView horizontalAdaptationFactor];
    }
	
    return [UIView verticalAdaptationFactor];
}

+ (CGFloat)fontAdaptationFactor
{
	// adding exceptions to the rule
    if (IS_IPHONE_4) {
        return [UIView horizontalAdaptationFactor] * 1.05;
        
    } else if (IS_IPAD) {
        return [UIView verticalAdaptationFactor];
    }
	
    return [UIView horizontalAdaptationFactor] * 0.9;
}

#pragma mark - Collecting views and constraints

+ (NSArray<UIView *> *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *allViews = [NSMutableArray array];
    NSArray *subviews = [view subviews];
    
    for (UIView *subview in subviews) {
        [allViews addObject:subview];
        [allViews addObjectsFromArray:[self allSubviewsOfView:subview]];
    }
    return [NSArray arrayWithArray:allViews];
}

- (NSArray*)allSubviews
{
    return [UIView allSubviewsOfView:self];
}

+ (NSArray*)constraintsOfViews:(NSArray*)viewsArray
{
	NSArray *constraintsArray = [NSArray array];
	for (UIView *view in viewsArray) {
		constraintsArray = [constraintsArray arrayByAddingObjectsFromArray:view.constraints];
	}
	return constraintsArray;
}

#pragma mark - Adaptation methods

+ (void)adaptViews:(NSArray<UIView *> *)viewsArray
{
	CGFloat yFactor = [UIView verticalAdaptationFactor];
	CGFloat xFactor = [UIView horizontalAdaptationFactor];
	
	NSArray *constraintsArray = [UIView constraintsOfViews:viewsArray];
	
	for (NSLayoutConstraint *constraint in constraintsArray) {
		
		if ((constraint.firstAttribute == NSLayoutAttributeLeading)||
			(constraint.firstAttribute == NSLayoutAttributeTrailing)) {
			constraint.constant *= xFactor;
		}
		
		if ((constraint.firstAttribute == NSLayoutAttributeTop)||
			(constraint.firstAttribute == NSLayoutAttributeHeight)||
			(constraint.firstAttribute == NSLayoutAttributeBottom)) {
			constraint.constant *= yFactor;
		}
	}
}

+ (void)adaptImageViews:(NSArray<UIView *> *)viewsArray
{
	CGFloat multiplier = [UIView imageAdaptationFactor];
	
	NSArray *constraintsArray = [UIView constraintsOfViews:viewsArray];
	
	for (NSLayoutConstraint *constraint in constraintsArray) {
		
		if ((constraint.firstAttribute == NSLayoutAttributeWidth)||
			(constraint.firstAttribute == NSLayoutAttributeHeight)) {
			constraint.constant *= multiplier;
		}
	}
}

- (void)adaptFont
{
	if ([self isKindOfClass:[UILabel class]]) {
		
		UILabel *labelSelf = (UILabel *)self;
		labelSelf.font = [labelSelf.font fontWithSize:labelSelf.font.pointSize * [UIView fontAdaptationFactor]];
		
	} else if ([self isKindOfClass:[UIButton class]]) {
		
		UIButton *buttonSelf = (UIButton *)self;
		
		NSMutableAttributedString *attributedString = [[buttonSelf attributedTitleForState:UIControlStateNormal] mutableCopy];
		
		if (attributedString) {
			
			[attributedString enumerateAttributesInRange:NSMakeRange(0, [attributedString length])
												 options:NSAttributedStringEnumerationReverse
											  usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
												  
												  UIFont *font = attributes[NSFontAttributeName];
												  CGFloat fontSize = font.pointSize;
												  font = [font fontWithSize:fontSize * [UIView fontAdaptationFactor]];
												  
												  [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];
												  [buttonSelf setAttributedTitle:attributedString forState:UIControlStateNormal];
											  }];
			
		} else {
			
			UIFont *font = ((UIButton *)self).titleLabel.font;
			CGFloat fontSize = font.pointSize;
			[buttonSelf.titleLabel setFont:[font fontWithSize:fontSize * [UIView fontAdaptationFactor]]];
		}
	}
}

+ (void)adaptFontsForViews:(NSArray<UIView *> *)viewsArray
{
	for (UIView *view in viewsArray) {
		[view adaptFont];
	}
}

- (void)performTableViewAdaptation
{
	if ([self isKindOfClass:[UITableView class]]) {
		
		UITableView *tableView = (UITableView *)self;
		tableView.rowHeight *= [UIView verticalAdaptationFactor];
		[self sizeHeaderToFitForTableView:tableView];
		[self sizeFooterToFitForTableView:tableView];
	}
}

- (void)performBasicAdaptation:(NSArray<UIView *> *)viewsArray
{
	// apply constraint resizing on all views excluding the special cases
	NSArray *defaultExcludedTypes = @[[UIImageView class], [UIButton class]];
	NSArray *excludedViews = [defaultExcludedTypes arrayByAddingObjectsFromArray:[UIView typesExcludedFromAdaptation]];
	NSArray *otherViewsArray = [NSArray arrayWithArray:viewsArray excludingObjectsOfTypes:excludedViews];
	[UIView adaptViews:otherViewsArray];
}

- (void)performSpecialCasesAdaptation:(NSArray<UIView *> *)viewsArray
{
	// apply constraint resizing on image and button views
	NSArray *imageViewsArray = [NSArray arrayWithArray:viewsArray filteringWithObjectsOfTypes:@[[UIImageView class], [UIButton class]]];
	[UIView adaptImageViews:imageViewsArray];
	
	// resize the table views
	for (UIView *view in viewsArray) {
		if ([view isKindOfClass:[UITableView class]]) {
			UITableView *tableView = (UITableView *)view;
			[tableView performTableViewAdaptation];
		}
	}
}
- (void)performFontAdaptation:(NSArray<UIView *> *)viewsArray
{
	// resize the fonts
	NSArray *fontViewsArray =
	[NSArray arrayWithArray:viewsArray filteringWithObjectsOfTypes:@[[UILabel class], [UIButton class]]];
	[UIView adaptFontsForViews:fontViewsArray];
}

- (void)adaptForAllDevices
{
	NSMutableArray *viewsArray = [[self allSubviews] mutableCopy];
	[viewsArray addObject:self];
	
	[self performBasicAdaptation:viewsArray];
	[self performSpecialCasesAdaptation:viewsArray];
	[self performFontAdaptation:viewsArray];
}

#pragma mark - UITableView methods

- (void)sizeHeaderToFitForTableView:(UITableView*)tableView
{
	UIView *header = tableView.tableHeaderView;
	
	[header setNeedsLayout];
	[header layoutIfNeeded];
	
	CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	CGRect frame = header.frame;
	
	frame.size.height = height;
	header.frame = frame;
	
	tableView.tableHeaderView = header;
}

- (void)sizeFooterToFitForTableView:(UITableView*)tableView
{
	UIView *footer = tableView.tableFooterView;
	
	[footer setNeedsLayout];
	[footer layoutIfNeeded];
	
	CGFloat height = [footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	CGRect frame = footer.frame;
	
	frame.size.height = height;
	footer.frame = frame;
	
	tableView.tableFooterView = footer;
}

@end

#pragma mark -

@implementation NSArray (Extras)

+ (NSArray*)arrayWithArray:(NSArray*)array excludingObjectsOfTypes:(NSArray<Class>*)typesArray
{
	NSMutableArray *mutableArray = [array mutableCopy];
	
	for (NSObject *object in array) {
		
		for (Class classtype in typesArray) {
			if ([object isKindOfClass:classtype]) {
				[mutableArray removeObject:object];
				break;
			}
		}
	}
	
	return [NSArray arrayWithArray:mutableArray];
}

+ (NSArray*)arrayWithArray:(NSArray*)array filteringWithObjectsOfTypes:(NSArray<Class>*)typesArray
{
	NSMutableArray *mutableArray = [array mutableCopy];
	
	for (NSObject *object in array) {
		
		BOOL shouldRemove = YES;
		
		for (Class classtype in typesArray) {
			if ([object isKindOfClass:classtype]) {
				shouldRemove = NO;
				break;
			}
		}
		
		if (shouldRemove) {
			[mutableArray removeObject:object];
		}
	}
	
	return [NSArray arrayWithArray:mutableArray];
}

@end

#pragma mark -

@implementation UIViewController (ProportionalResizing)

- (void)adaptForAllDevices
{
	[self.view adaptForAllDevices];
}

@end
