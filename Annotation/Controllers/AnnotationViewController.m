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

@interface AnnotationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fullsizeImage;
@property (weak, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) UIBezierPath *path;
@property (nonatomic, assign) CGPoint prevPoint;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSMutableArray *shapeLayers;
@property (strong, nonatomic) NSMutableArray *redoShapeLayers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;

@end

@implementation AnnotationViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILongPressGestureRecognizer *dismissGestureRecognition = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbarToolbar:)];
    [dismissGestureRecognition setNumberOfTapsRequired:0]; // Set your own number here
    [dismissGestureRecognition setMinimumPressDuration:1.0];
    [self.view addGestureRecognizer:dismissGestureRecognition];

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
}

- (void) dragging: (UIPanGestureRecognizer*) p {
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [p setTranslation: CGPointZero inView: vv.superview];
    }
}

-(void) drawPath:(UITapGestureRecognizer *) sender
{
    CGPoint touchPoint = [sender locationInView: self.mainView];

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
    
    self.prevPoint = touchPoint;
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

@end
