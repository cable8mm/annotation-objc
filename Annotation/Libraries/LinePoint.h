//
//  LinePoint.h
//  Annotation
//
//  Created by 이삼구 on 05/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum PointType {
    standard    = 0,
    coalesced,
    predicted,
    needsUpdate,
    updated,
    cancelled,
    finger
} PointType;

@interface LinePoint : NSObject
@property (nonatomic) int sequenceNumber;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) CGFloat force;
@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint preciseLocation;
@property (nonatomic) UITouchProperties estimatedPropertiesExpectingUpdates;
@property (nonatomic) UITouchProperties estimatedProperties;
@property (nonatomic) UITouchType type;
@property (nonatomic) CGFloat altitudeAngle;
@property (nonatomic) CGFloat azimuthAngle;
@property (nonatomic) PointType pointType;
@property (nonatomic) NSNumber *estimationUpdateIndex;

-(CGFloat) magnitude;
-(id)initWithTouch:(UITouch*)touch sequenceNumber:(int)sequenceNumber pointType:(PointType)pointType view: (UIView*)view;
-(BOOL)updateWithTouch:(UITouch*)touch;

@end

NS_ASSUME_NONNULL_END
