//
//  YALSunyRefreshControl.m
//  YALSunyPullToRefresh
//
//  Created by Konstantin Safronov on 12/24/14.
//  Copyright (c) 2014 Konstantin Safronov. All rights reserved.
//

#import "YALSunnyRefreshControl.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

static const CGFloat DefaultHeight = 100.f;
static const CGFloat AnimationDuration = 1.f;
static const CGFloat AnimationDamping = 0.4f;
static const CGFloat AnimationVelosity= 0.8f;

static const CGFloat SunTopPoint = 5.f;
static const CGFloat SunBottomPoint = 55.f;
static const CGFloat SkyTopShift = 15.f;
static const CGFloat SkyDefaultShift = -70.f;

static const CGFloat BuildingDefaultHeight = 72;

static const CGFloat CircleAngle = 360.f;
static const CGFloat BuildingsMaximumScale = 1.7f;
static const CGFloat SunAndSkyMinimumScale = 0.85f;
static const CGFloat SpringTreshold = 120.f;
static const CGFloat SkyTransformAnimationDuration = 0.5f;
static const CGFloat SunRotationAnimationDuration = 0.9f;
static const CGFloat DefaultScreenWidth = 320.f;

@interface YALSunnyRefreshControl () 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraint;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *sunTopConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *skyTopConstraint;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *skyLeadingConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *skyTrailingConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buildingsHeightConstraint;

@property (nonatomic,weak) IBOutlet UIImageView *sunImageView;
@property (nonatomic,weak) IBOutlet UIImageView *skyImageView;
@property (nonatomic,weak) IBOutlet UIImageView *buildingsImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;
@property (nonatomic,assign) BOOL forbidSunSet;
@property (nonatomic,assign) BOOL isSunRotating;
@property (nonatomic,assign) BOOL forbidOffsetChanges;

@end

@implementation YALSunnyRefreshControl

-(void)dealloc{
    
    [self removeObserver:self.scrollView forKeyPath:@"contentOffset"];
}

+ (YALSunnyRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                      target:(id)target
                               refreshAction:(SEL)refreshAction{
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YALSunnyRefreshControl" owner:self options:nil];
    YALSunnyRefreshControl *refreshControl = (YALSunnyRefreshControl *)[topLevelObjects firstObject];

    refreshControl.scrollView = scrollView;
    [refreshControl.scrollView addObserver:refreshControl forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    refreshControl.target = target;
    refreshControl.action = refreshAction;
//    [scrollView setDelegate:refreshControl]; no need to set because it breaks other connections
    [refreshControl setFrame:CGRectMake(0.f,
                                        0.f,
                                        scrollView.frame.size.width,
                                        0.f)];
    [scrollView addSubview:refreshControl];
    return refreshControl;
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    CGFloat leadingRatio = [UIScreen mainScreen].bounds.size.width / DefaultScreenWidth;
    [self.skyLeadingConstraint setConstant:self.skyLeadingConstraint.constant * leadingRatio];
    [self.skyTrailingConstraint setConstant:self.skyTrailingConstraint.constant * leadingRatio];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    [self calculateShift];
}

-(void)calculateShift{

    [self setFrame:CGRectMake(0.f,
                              0.f,
                              self.scrollView.frame.size.width,
                              self.scrollView.contentOffset.y)];
    
    if(self.scrollView.contentOffset.y <= -DefaultHeight){
        
        if(self.scrollView.contentOffset.y < -SpringTreshold){
            
            [self.scrollView setContentOffset:CGPointMake(0.f, -SpringTreshold)];
        }
        [self scaleItems];
        [self rotateSunInfinitly];
        self.forbidSunSet = YES;
    }
   
    if(!self.scrollView.dragging && self.forbidSunSet && self.scrollView.decelerating && !self.forbidOffsetChanges){
        [self startRefreshing];
    }
    
    if(!self.forbidSunSet){
        [self setupSunHeightAboveHorisont];
        [self setupSkyPosition];
    }
}

- (void)startRefreshing {
    [self.scrollView setContentOffset:CGPointMake(0.f, -DefaultHeight) animated:YES];
    self.forbidOffsetChanges = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.action withObject:nil];
#pragma clang diagnostic pop

}

-(void)endRefreshing{
    
    self.forbidOffsetChanges = NO;
    
    [UIView animateWithDuration:AnimationDuration
                          delay:0.f
         usingSpringWithDamping:AnimationDamping
          initialSpringVelocity:AnimationVelosity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0.f, 0.f, 0.f)];
                         [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)];

                     } completion:^(BOOL finished) {
                         
                         self.forbidSunSet = NO;
                         [self stopSunRotating];
                     }];
}

-(void)setupSunHeightAboveHorisont{
    
    CGFloat shiftInPercents = [self shiftInPercents];
    CGFloat sunWay = SunBottomPoint - SunTopPoint;
    CGFloat sunYCoordinate = SunBottomPoint - (sunWay / 100) * shiftInPercents;
    [self.sunTopConstraint setConstant:sunYCoordinate];
    [self.iconTopConstraint setConstant:sunYCoordinate-6];
    
    CGFloat rotationAngle = (CircleAngle / 100) * shiftInPercents;
    self.sunImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotationAngle));
}

-(CGFloat)shiftInPercents{
    
    return (DefaultHeight / 100) * -self.scrollView.contentOffset.y;
}

-(void)setupSkyPosition{
    
    CGFloat shiftInPercents = [self shiftInPercents];
    CGFloat skyTopConstant = SkyDefaultShift + ((SkyTopShift / 100) * shiftInPercents);
    [self.skyTopConstraint setConstant:skyTopConstant];
}

-(void)scaleItems{
    
    CGFloat shiftInPercents = [self shiftInPercents];
    CGFloat buildigsScaleRatio = shiftInPercents / 100;
    
    if(buildigsScaleRatio <= BuildingsMaximumScale){
        
        CGFloat extraOffset = ABS(self.scrollView.contentOffset.y) - DefaultHeight;
        self.buildingsHeightConstraint.constant = BuildingDefaultHeight + extraOffset;
        [self.buildingsImageView setTransform:CGAffineTransformMakeScale(buildigsScaleRatio,1.f)];
        
        CGFloat skyScale = (SunAndSkyMinimumScale + (1 - buildigsScaleRatio));
        [UIView animateWithDuration:SkyTransformAnimationDuration animations:^{
            
            [self.skyImageView setTransform:CGAffineTransformMakeScale(skyScale,skyScale)];
            [self.sunImageView setTransform:CGAffineTransformMakeScale(skyScale,skyScale)];
        }];
    }
}

- (void)rotateSunInfinitly{
    
    if(!self.isSunRotating){
        self.isSunRotating = YES;
        self.forbidSunSet = YES;
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.speed = 2;
        rotationAnimation.fromValue = @(M_PI * -0.1);
        rotationAnimation.toValue = @(M_PI * 0.1);
        rotationAnimation.duration = SunRotationAnimationDuration;
        rotationAnimation.autoreverses = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.sunImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

-(void)stopSunRotating{
    
    self.isSunRotating = NO;
    self.forbidSunSet = NO;
    [self.sunImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end