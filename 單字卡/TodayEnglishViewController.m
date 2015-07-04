
#import "TodayEnglishViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "WordCard.h"
#import "WordCardDeck.h"

@interface TodayEnglishViewController ()<UIGestureRecognizerDelegate>

//單字卡ImageView
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
//單字Label
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
//Tap手勢物件
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
//Swipe手勢物件
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeGesture;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeGesture;
//Title Label
@property (weak, nonatomic) IBOutlet UILabel *theTitleLabel;

//翻轉switch
@property (assign, nonatomic) BOOL wordCardSwitch;
//SwipeWordCard 計數
@property (assign, nonatomic) NSInteger cardCountNumber;
//隨機單字卡Deck
@property (strong, nonatomic) NSMutableArray *randomWordCardDeck;




@end



@implementation TodayEnglishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _randomWordCardDeck  = [[NSMutableArray alloc] init];
    
    //創造隨機6張單字卡
    WordCardDeck *newDesk = [[WordCardDeck alloc] init];
    for (NSInteger index = 1; index <= 6; index++) {
        WordCard *temp = [newDesk getRandomWordCard];
        [_randomWordCardDeck addObject:temp];
    }
    _theLabel.text = [_randomWordCardDeck[_cardCountNumber] englishWord];
    _theTitleLabel.text = [NSString stringWithFormat:@"Today Words %ld of 6", _cardCountNumber + 1];
    
    UIImage *image = [UIImage imageNamed:@"Card.png"];
    _theImageView.contentMode = UIViewContentModeScaleToFill;
    _theImageView.image = image;
    //創造Tap手勢物件&加上單擊行為
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMotion:)];
    
    //創造Swipe手勢物件&滑動行為
    _leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeMotion:)];
    _leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    _rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeMotion:)];
    _rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    //imageView附著手勢物件
    [_theImageView addGestureRecognizer:_tapGesture];
    [_theImageView addGestureRecognizer:_leftSwipeGesture];
    [_theImageView addGestureRecognizer:_rightSwipeGesture];
}

//Tap手勢的行為
-(void)tapMotion:(UITapGestureRecognizer*)sender{
    _theLabel.text = [_randomWordCardDeck[_cardCountNumber] chineseWord];
    [self imageTapAnimation:sender];
}

//swipe左手勢的行為
-(void) leftSwipeMotion:(UISwipeGestureRecognizer*)sender{
    if (_cardCountNumber < ([_randomWordCardDeck count] -1)) {
        _cardCountNumber++;
         _theTitleLabel.text = [NSString stringWithFormat:@"Today Words %ld of 6", _cardCountNumber + 1];
         [self imageSwipeAnimation:sender];
    }
}

//swipe右手勢的行為
-(void) rightSwipeMotion:(UISwipeGestureRecognizer*)sender{
    if (_cardCountNumber > 0) {
        _cardCountNumber--;
         _theTitleLabel.text = [NSString stringWithFormat:@"Today Words %ld of 6", _cardCountNumber + 1];
         [self imageSwipeAnimation:sender];
    }
}




//附著動畫
-(void) imageTapAnimation:(UITapGestureRecognizer*)sender{
    //宣告一個CATransition
    CATransition *transition = [CATransition animation];
    //細部設定
    transition.duration = 0.3f;
    transition.delegate = self;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //動畫效果
    transition.type = @"oglFlip";
    
    if (!_wordCardSwitch) {
        _theLabel.text = [_randomWordCardDeck[_cardCountNumber] chineseWord];
        _wordCardSwitch = YES;
        //image透明度
        _theImageView.alpha = 0.6;

        //動畫方向
        transition.subtype = kCATransitionFromLeft;
    }else{
        _theLabel.text = [_randomWordCardDeck[_cardCountNumber] englishWord];
        _wordCardSwitch = NO;
        //image透明度
        _theImageView.alpha = 1;
        //動畫方向
        transition.subtype = kCATransitionFromRight;
    }
        //執行動畫
    [_theImageView.layer addAnimation:transition forKey:@"myTransition"];
}


//附著動畫
-(void) imageSwipeAnimation:(UISwipeGestureRecognizer*)sender{
    //宣告一個CATransition
    _theLabel.text = [_randomWordCardDeck[_cardCountNumber] englishWord];
    CATransition *transition = [CATransition animation];
    //細部設定
    transition.duration = 0.3f;
    transition.delegate = self;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //動畫效果
    transition.type = @"push";
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        //動畫方向
        transition.subtype = kCATransitionFromLeft;
    } else {
        //動畫方向
        transition.subtype = kCATransitionFromRight;
    }
    //執行動畫
    [_theImageView.layer addAnimation:transition forKey:@"myTransition"];
}

//動畫開始的delegate
-(void) animationDidStart:(CAAnimation *)anim{
    _theLabel.hidden = YES;
    
}

//動畫結束的delegate
-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _theLabel.hidden = NO;
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
