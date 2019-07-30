//
//  OrderViewCell.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/28/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrderViewCell.h"

@interface OrderViewCell() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (strong, nonatomic) IBOutlet UIButton *ordersButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *amountsConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *dishesConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewconstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ordersConstraint;

@end

/*
 NSLayoutConstraint(item: detail, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 20)
 addConstraint(detailTopConstraint)
 
 // Later when you want to change the margin for example :
 detailTopConstraint.constant = 100 */

@implementation OrderViewCell

static CGFloat const kBounceValue = 20.0f;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    self.amountsConstraint.active = NO;
    self.dishesConstraint.active = NO;
    self.viewconstraints.active = NO;
    self.ordersConstraint.active = YES;
  
    [self.myContentView addGestureRecognizer:self.panRecognizer];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.panRecognizer.delegate = self;
    self.amountsConstraint.active = NO;
    self.dishesConstraint.active = NO;
    self.viewconstraints.active = NO;
    self.ordersConstraint.active = YES;
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}
- (void)openCell {
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)setItemText:(NSString *)itemText {
    //Update the instance variable
    _itemText = itemText;
    
    //Set the text to the custom label.
    self.myTextLabel.text = _itemText;
}

//button functions
- (IBAction)buttonClicked:(id)sender {
    if (sender == self.edit) {
        NSLog(@"Clicked edit!");
        [self.delegate editForIndex:self.index];
    } else if (sender == self.complete) {
        NSLog(@"Clicked complete!");
        [self.delegate completeForIndex:self.index];
    } else if (sender == self.ordersButton) {
        NSLog(@"Clicked orders!");
        self.amountsConstraint.active = YES;
        self.dishesConstraint.active = YES;
        self.viewconstraints.active = YES;
        self.ordersConstraint.active = NO;
    } else {
        NSLog(@"Clicked unknown button!");
    }
}

- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.edit.frame);
}


//constraint functions
- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
 
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {

    
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}


//pan functions

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) { //2
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0); //3
                    if (constant == 0) { //4
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //5
                    } else {
                        self.contentViewRightConstraint.constant = constant; //6
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //7
                    if (constant == [self buttonTotalWidth]) { //8
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //9
                    } else {
                        self.contentViewRightConstraint.constant = constant; //10
                    }
                }
            }else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //11
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0); //12
                    if (constant == 0) { //13
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //14
                    } else {
                        self.contentViewRightConstraint.constant = constant; //15
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //16
                    if (constant == [self buttonTotalWidth]) { //17
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //18
                    } else {
                        self.contentViewRightConstraint.constant = constant;//19
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //20
        }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //We were opening
                CGFloat halfOfcomplete = CGRectGetWidth(self.complete.frame) / 2; //2
                if (self.contentViewRightConstraint.constant >= halfOfcomplete) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
                
            } else {
                //We were closing
                CGFloat completePlusHalfOfedit = CGRectGetWidth(self.complete.frame) + (CGRectGetWidth(self.edit.frame) / 2); //4
                if (self.contentViewRightConstraint.constant >= completePlusHalfOfedit) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //We were open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



@end
