//
//  CanvasView.h
//  Annotation
//
//  Created by 이삼구 on 04/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView
@property (strong, nonatomic) NSMutableArray *lines;         // Annotation Storage
@property (strong, nonatomic) NSMutableArray *finishedLines; // Annotation Redo Storage
@property (strong, nonatomic) NSMapTable *activeLines;       // coordinate array
@property (strong, nonatomic) NSMapTable *pendingLines;      // coordinate array

- (void)clear;
- (void)drawTouches:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)endTouches:(NSSet *)touches cancel:(BOOL)cancel;
- (void)updateEstimatedPropertiesForTouches:(NSSet<UITouch *> *)touches;

@end

NS_ASSUME_NONNULL_END
