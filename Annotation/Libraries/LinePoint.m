//
//  LinePoint.m
//  Annotation
//
//  Created by 이삼구 on 05/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "LinePoint.h"

@implementation LinePoint

/// Clamp the force of a touch to a usable range.
/// - Tag: Magnitude
-(CGFloat) magnitude {
    return MAX(_force, 0.025);
}

// MARK: Initialization
-(id)initWithTouch:(UITouch*)touch sequenceNumber:(int)sequenceNumber pointType:(PointType)pointType view: (UIView*)view {
    self = [super init];
    if(self){
        _sequenceNumber = sequenceNumber;
        _type = touch.type;
        _pointType = pointType;
        
        _timestamp = touch.timestamp;
        _location = [touch locationInView:view];
        _preciseLocation = [touch preciseLocationInView:view];
        _azimuthAngle = [touch azimuthAngleInView:view];
        _estimatedProperties = touch.estimatedProperties;
        _estimatedPropertiesExpectingUpdates = touch.estimatedPropertiesExpectingUpdates;
        _altitudeAngle = touch.altitudeAngle;
        _force = (_type == UITouchTypePencil || touch.force > 0) ? touch.force : 1.0;
        
//        if !_estimatedPropertiesExpectingUpdates.isEmpty {
//            self.pointType.formUnion(.needsUpdate)
//        }
        
        _estimationUpdateIndex = touch.estimationUpdateIndex;
    }
    return self;
}

/// Gather the properties on a `UITouch` for force, altitude, azimuth, and location.
/// - Tag: TouchProperties
-(BOOL)updateWithTouch:(UITouch*)touch {
    return YES;
}

@end
