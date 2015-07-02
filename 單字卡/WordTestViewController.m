
#import "WordTestViewController.h"
#import "WordCardDeck.h"
#import "WordCard.h"
#import "ScoreViewController.h"

@interface WordTestViewController ()

//UI
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *theEnglishWordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageCorrectOrwrong;
@property (weak, nonatomic) IBOutlet UILabel *theTitleLabel;

//答案按鈕
@property (weak, nonatomic) IBOutlet UIButton *theChineseButtonTag1;
@property (weak, nonatomic) IBOutlet UIButton *theChineseButtonTag2;
@property (weak, nonatomic) IBOutlet UIButton *theChineseButtonTag3;
@property (weak, nonatomic) IBOutlet UIButton *theChineseButtonTag4;

//WordCard 計數
@property (assign, nonatomic) NSInteger cardCountNumber;
//隨機單字卡Deck
@property (strong, nonatomic) NSMutableArray *randomWordCardDeck;
//正確答案分數
@property (assign, nonatomic) NSInteger correctScore;
//錯誤答案分數
@property (assign, nonatomic) NSInteger wrongScore;

@end

@implementation WordTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated{
    [self startView];
    _cardCountNumber = 0;
    _correctScore = 0;
    _wrongScore = 0;
    _theTitleLabel.text = [NSString stringWithFormat:@"Qeuestion %ld of 10", _cardCountNumber + 1];
}

-(void) startView{
    UIImage *image = [UIImage imageNamed:@"Card.png"];
    _theImageView.image = image;
    _randomWordCardDeck  = [[NSMutableArray alloc] init];
    
    //創造隨機10張單字卡
    WordCardDeck *newDesk = [[WordCardDeck alloc] init];
    for (NSInteger index = 1; index <= 10; index++) {
        WordCard *temp = [newDesk getRandomWordCard];
        [_randomWordCardDeck addObject:temp];
    }
    _theTitleLabel.text = [NSString stringWithFormat:@"Qeuestion %ld of 10", _cardCountNumber + 1];
    [self appearTheRandomChineseWord];
}

//答按選擇Button appear
-(void) appearTheRandomChineseWord{
    _theTitleLabel.text = [NSString stringWithFormat:@"Question %ld of 10", _cardCountNumber + 1];
    _theEnglishWordLabel.text = [_randomWordCardDeck[_cardCountNumber] englishWord];
    
    [_theChineseButtonTag1 setTitle:[_randomWordCardDeck[_cardCountNumber] random4ChineseWord][0] forState:UIControlStateNormal];
    [_theChineseButtonTag2 setTitle:[_randomWordCardDeck[_cardCountNumber] random4ChineseWord][1] forState:UIControlStateNormal];
    [_theChineseButtonTag3 setTitle:[_randomWordCardDeck[_cardCountNumber] random4ChineseWord][2] forState:UIControlStateNormal];
    [_theChineseButtonTag4 setTitle:[_randomWordCardDeck[_cardCountNumber] random4ChineseWord][3] forState:UIControlStateNormal];
}

//The Choice Answer Button
- (IBAction)theChineseWordAnserButton:(UIButton *)sender {
    
    UIImage *imageCorrect = [UIImage imageNamed:@"corrent.png"];
    UIImage *imageWrong = [UIImage imageNamed:@"wrong.png"];
    
    if (_cardCountNumber < ([_randomWordCardDeck count] -1)) {
        if ([sender.titleLabel.text isEqualToString:[_randomWordCardDeck[_cardCountNumber] chineseWord]]) {
            _theImageCorrectOrwrong.image = imageCorrect;
            [self imageTapAnimation:nil];
            _correctScore++;
        }else{
            _theImageCorrectOrwrong.image = imageWrong;
            [self imageTapAnimation:nil];
            _wrongScore++;
        }
        _cardCountNumber++;
        _theImageCorrectOrwrong.hidden = NO;
        [self getNextWordTest];
    }else{
        [self performSegueWithIdentifier:@"scoreCard" sender:nil];
    }
}

//換下一張單字卡(共10張)
-(void) getNextWordTest{
    [self goNextQuestionAnimation:nil];
    [self appearTheRandomChineseWord];
}


//附著動畫
-(void) imageTapAnimation:(id)sender{
    //宣告一個CATransition
    CATransition *transition = [CATransition animation];
    //細部設定
    transition.duration = 0.6f;
    transition.delegate = self;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //動畫效果(2種語法表示法-常數or字符串)
    transition.type =  @"rippleEffect";
    //動畫方向
    transition.subtype = kCATransitionFromRight;
    //執行動畫
    [_theImageCorrectOrwrong.layer addAnimation:transition forKey:@"myTransition"];
}

//附著動畫
-(void) goNextQuestionAnimation:(id)sender{
    //宣告一個CATransition
    CATransition *transition = [CATransition animation];
    //細部設定
    transition.duration = 0.8f;
    transition.delegate = self;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //動畫效果(2種語法表示法-常數or字符串)
    transition.type =  @" ";
    //動畫方向
    transition.subtype = kCATransitionFromBottom;
    //執行動畫
    [_theChineseButtonTag1.layer addAnimation:transition forKey:@"myTransition"];
    [_theChineseButtonTag2.layer addAnimation:transition forKey:@"myTransition"];
    [_theChineseButtonTag3.layer addAnimation:transition forKey:@"myTransition"];
    [_theChineseButtonTag4.layer addAnimation:transition forKey:@"myTransition"];

}

//動畫開始的delegate
-(void) animationDidStart:(CAAnimation *)anim{
    
}

//動畫結束的delegate
-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _theImageCorrectOrwrong.hidden = YES;
}

//返回
-(IBAction) backToWordTest:(UIStoryboardSegue*)segue{
}

//傳值到下一個ViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"scoreCard"]) {
        ScoreViewController *targeView = segue.destinationViewController;
        targeView.correctScore = [NSString stringWithFormat:@"%ld", _correctScore];
        targeView.wrongScore = [NSString stringWithFormat:@"%ld", _wrongScore];
    }
}




@end
