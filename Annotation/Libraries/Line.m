//
//  Line.m
//  Annotation
//
//  Created by 이삼구 on 05/03/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "Line.h"
#import "LinePoint.h"

@implementation Line
// MARK: Drawing

/// Draw line points to the canvas, altering the drawing based on the data originally collected from `UITouch`.
/// - Tag: DrawLine
-(void)drawInContext:(CGContextRef)context {
    for(LinePoint *linePoint in self.linePoints) {
        
    }
//    for point in points {
//        guard let priorPoint = maybePriorPoint else {
//            maybePriorPoint = point
//            continue
//        }
//
//        let color = strokeColor(for: point, useDebugColors: isDebuggingEnabled)
//
//        let location = usePreciseLocation ? point.preciseLocation : point.location
//        let priorLocation = usePreciseLocation ? priorPoint.preciseLocation : priorPoint.location
//
//        context.setStrokeColor(color.cgColor)
//
//        context.beginPath()
//
//        context.move(to: CGPoint(x: priorLocation.x, y: priorLocation.y))
//        context.addLine(to: CGPoint(x: location.x, y: location.y))
//
//        context.setLineWidth(point.magnitude)
//
//        context.strokePath()

}
@end
