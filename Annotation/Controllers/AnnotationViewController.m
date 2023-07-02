//
//  AnnotationViewController.m
//  Annotation
//
//  Created by 이삼구 on 10/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "AnnotationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Toast.h"
#import "CanvasView.h"

@interface AnnotationViewController () <UIPencilInteractionDelegate>

// MARK: Properties
@property (weak, nonatomic) IBOutlet CanvasView *canvasView;
@property (nonatomic, assign) int content_id;
@property (weak, nonatomic) IBOutlet UIImageView *fullsizeImage;
@property (weak, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) UIBezierPath *path;
@property (nonatomic, assign) CGPoint prevPoint;
@property (strong, nonatomic) IBOutlet UIView *mainView;

/* 필요한 저장 데이터 */
@property (strong, nonatomic) NSMutableArray *shapeLayers;  // Annotation Storage
@property (strong, nonatomic) NSMutableArray *redoShapeLayers;  // Annotation Redo Storage
@property (strong, nonatomic) NSMutableArray *saveTouchPoints;  // coordinate array

/* 버튼 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic) int saveCount;

@end

@implementation AnnotationViewController

// MARK: Actions

- (IBAction)redo:(id)sender {
    if([self.redoShapeLayers count] > 0) {
        CAShapeLayer *shapeLayer = [self.redoShapeLayers lastObject];
        [self.view.layer addSublayer:shapeLayer];
        [self.shapeLayers addObject:shapeLayer];
        [self.redoShapeLayers removeLastObject];
    } else {
        [self.view makeToast:@"no more REDO"];
    }

    [self controlUnRedoButtonEnabledAndSetPrevPoint];
}

- (IBAction)undo:(id)sender {
    if([self.shapeLayers count] > 0) {
        CAShapeLayer *shapeLayer = [self.shapeLayers lastObject];
        [shapeLayer removeFromSuperlayer];
        
        [self.redoShapeLayers addObject:[self.shapeLayers lastObject]];
        [self.shapeLayers removeLastObject];
    } else {
        [self.view makeToast:@"no more UNDO"];
    }
    
    [self controlUnRedoButtonEnabledAndSetPrevPoint];
}

- (void) controlUnRedoButtonEnabledAndSetPrevPoint {
    if([self.redoShapeLayers count] > 0) {
        [self.redoButton setEnabled:YES];
    } else {
        [self.redoButton setEnabled:NO];
    }
    
    if([self.shapeLayers count] > 0) {
        [self.undoButton setEnabled:YES];
    } else {
        [self.undoButton setEnabled:NO];
    }
}

- (IBAction)save:(id)sender {
    for (CAShapeLayer *shapeLayer in self.shapeLayers) {
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
    }
    
    self.prevPoint = CGPointMake(0., 0.);
    self.saveCount++;
}

- (void) setSaveCount:(int)saveCount {
    _saveCount = saveCount;
    self.saveButton.title = [NSString stringWithFormat:@"Save(%d)", saveCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view makeToast:@"화면을 1초간 누르고 있으면(롱탭) 상단/하단 바가 나타납니다."];
    
    // 저장된 draw 값을 다시 표여준다.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveTouchPointData = [defaults objectForKey:[NSString stringWithFormat:@"saveTouchPointData%d", self.content_id]];
    NSArray *savedTouchPoints = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:saveTouchPointData]];

    if(savedTouchPoints != nil) {
        [self.saveTouchPoints addObjectsFromArray:savedTouchPoints];
        
        if(self.saveTouchPoints != nil && [self.saveTouchPoints count] > 0) {
            for(int i=0; i < [self.saveTouchPoints count]/2; i++) {
                [self drawLine:[self.saveTouchPoints objectAtIndex:(i*2)] y:[self.saveTouchPoints objectAtIndex:(i*2+1)]];
                NSLog(@"drawLine x : %@ y : %@", [self.saveTouchPoints objectAtIndex:(i*2)], [self.saveTouchPoints objectAtIndex:(i*2+1)]);
            }
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveTouchPointData = [NSKeyedArchiver archivedDataWithRootObject:self.saveTouchPoints];
    [defaults setObject:saveTouchPointData forKey: [NSString stringWithFormat:@"saveTouchPointData%d", self.content_id]];
    [defaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 12.1, *)) {
        UIPencilInteraction *pencilInteraction = [[UIPencilInteraction alloc] init];
        pencilInteraction.delegate = self;
        [self.view addInteraction:pencilInteraction];
    }
    
    UITapGestureRecognizer *drawGestureRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawPath:)];
    drawGestureRecognition.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:drawGestureRecognition];

//    UITapGestureRecognizer *dismissGestureRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
//    dismissGestureRecognition.numberOfTapsRequired = 2;
//    [self.view.imageView addGestureRecognizer:dismissGestureRecognition];

    
    NSString *original_name =self.responseOsRawPicture[@"OsRawPicture"][@"original_name"];
    [self.fullsizeImage sd_setImageWithURL:[NSURL URLWithString:[API_SERVER_PREFIX stringByAppendingString:original_name]]
                 placeholderImage:[UIImage imageNamed:@"doai_logo.jpg"]];

    // init
    self.shapeLayers = [[NSMutableArray alloc] init];
    self.redoShapeLayers = [[NSMutableArray alloc] init];
    self.saveCount  = 0;
    self.saveTouchPoints = [[NSMutableArray alloc] initWithCapacity:15];
    self.content_id = (int)self.responseOsRawPicture[@"OsRawPicture"][@"id"];
}

// MARK: Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    [self.canvasView drawTouches:touches withEvent: event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches move");
    [self.canvasView drawTouches:touches withEvent: event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.canvasView drawTouches:touches withEvent: event];
    [self.canvasView endTouches:touches cancel:false];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.canvasView endTouches:touches cancel:false];
}

- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches {
    [self.canvasView updateEstimatedPropertiesForTouches:touches];
}

-(BOOL) isClosedPoint:(CGPoint)point {
    if(self.saveTouchPoints != nil && [self.saveTouchPoints count] >= 2) {
        CGPoint initialPoint = CGPointMake([[self.saveTouchPoints objectAtIndex:0] floatValue], [[self.saveTouchPoints objectAtIndex:1] floatValue]);
        NSLog(@"Distance : %f, %F, %f, %f, %f", initialPoint.x, initialPoint.y, point.x, point.y, sqrt((point.x - initialPoint.x)*(point.x - initialPoint.x) + (point.y = initialPoint.y)*(point.y = initialPoint.y)));
        
        if(sqrt((point.x - initialPoint.x)*(point.x - initialPoint.x) + (point.y - initialPoint.y)*(point.y - initialPoint.y)) < 25) {
            return YES;
        }
    }
    return NO;
}

-(void) drawLine:(NSNumber *)x y:(NSNumber *)y {
    CGPoint touchPoint = CGPointMake((CGFloat)[x floatValue], (CGFloat)[y floatValue]);

    // 첫번째 좌표와 거리가 얼마 되지 않으면 첫번째 좌표로 교정
    if([self isClosedPoint:touchPoint]) {
        touchPoint = CGPointMake([[self.saveTouchPoints objectAtIndex:0] floatValue], [[self.saveTouchPoints objectAtIndex:1] floatValue]);
   }

    if(self.prevPoint.x != 0. && self.prevPoint.y != 0.) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.prevPoint.x, self.prevPoint.y)];
        [path addLineToPoint:CGPointMake(touchPoint.x, touchPoint.y)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.view.layer addSublayer:shapeLayer];
        [self.shapeLayers addObject:shapeLayer];
    }
    
    [self controlUnRedoButtonEnabledAndSetPrevPoint];
    
    // 탭 저장 히스토리
    self.prevPoint = touchPoint;

    // 첫번째 좌표와 거리가 얼마 되지 않으면 save 함
    if([self isClosedPoint:touchPoint]) {
        [self save:self];
    }
}

-(void) drawPath:(UITapGestureRecognizer *) sender
{
    CGPoint touchPoint = [sender locationInView: self.mainView];
    [self drawLine:[NSNumber numberWithFloat:touchPoint.x] y:[NSNumber numberWithFloat:touchPoint.y]];
    
    [self.saveTouchPoints addObject:[NSNumber numberWithFloat:touchPoint.x]];
    [self.saveTouchPoints addObject:[NSNumber numberWithFloat:touchPoint.y]];
    
    NSLog(@"self.saveTouchPoints = %@", self.saveTouchPoints);
}

-(void) showHideNavbarToolbar:(UILongPressGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.navigationController.navigationBar.hidden == NO)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setToolbarHidden:YES animated:YES];
        }
        else if (self.navigationController.navigationBar.hidden == YES)
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
//    guard UIPencilInteraction.preferredTapAction == .switchPrevious else { return }
//
//    /* The tap interaction is a quick way for the user to switch tools within an app.
//     Toggling the debug drawing mode from Apple Pencil is a discoverable action, as the button
//     for debug mode is on screen and visually changes to indicate what the tap interaction did.
//     */
//    toggleDebugDrawing(sender: debugButton)
//}

@end
