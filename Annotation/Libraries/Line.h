//
//  Line.h
//  Annotation
//
//  Created by 이삼구 on 05/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Line : NSObject
@property (strong, nonatomic) NSMutableArray *linePoints;

//func drawInContext(_ context: CGContext, isDebuggingEnabled: Bool, usePreciseLocation: Bool) {
-(void)drawInContext:(CGContextRef)context;
@end


NS_ASSUME_NONNULL_END
