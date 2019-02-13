//
//  AnnotationViewController.m
//  Annotation
//
//  Created by 이삼구 on 10/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "AnnotationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AnnotationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fullsizeImage;
@property (weak, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation AnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *dismissGestureRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
    dismissGestureRecognition.numberOfTapsRequired = 2;
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
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
//    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 100, 100)] CGPath]];
    self.path = [[UIBezierPath alloc] init];

//    [self.path moveToPoint:CGPointMake(0, 0)];
//    [self.path addLineToPoint:CGPointMake(100, 0)];
//    [self.path addLineToPoint:CGPointMake(100, 100)];
    pathLayer.path = self.path.CGPath;

    [[self.view layer] addSublayer:pathLayer];
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

-(void) drawPath:(id) sender
{
//    [self.path moveToPoint:CGPointMake(0, 0)];
//    [self.path addLineToPoint:CGPointMake(100, 0)];
//    [self.path addLineToPoint:CGPointMake(100, 100)];
}

-(void) showHideNavbar:(id) sender
{
    if (self.navigationController.navigationBar.hidden == NO)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
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
