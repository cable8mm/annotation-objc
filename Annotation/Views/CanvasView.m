//
//  CanvasView.m
//  Annotation
//
//  Created by 이삼구 on 04/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "CanvasView.h"
#import "Line.h"

@implementation CanvasView
- (id)init
{
    self = [super init];
    if (self) {
        // NSMapTable<UITouch, Line>
        self.activeLines = [NSMapTable<UITouch *, Line *> strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)clear
{
    [self.lines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
    }
}

- (void)endTouches:(NSSet *)touches cancel:(BOOL)cancel
{
}

- (void)updateEstimatedPropertiesForTouches:(NSSet<UITouch *> *)touches
{
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
