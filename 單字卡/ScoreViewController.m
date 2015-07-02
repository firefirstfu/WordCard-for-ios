
#import "ScoreViewController.h"

@interface ScoreViewController ()
//正確答題數
@property (weak, nonatomic) IBOutlet UILabel *theCorrectLabel;
//錯誤答題數
@property (weak, nonatomic) IBOutlet UILabel *theWrongLabel;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _theCorrectLabel.text = _correctScore;
    _theWrongLabel.text = _wrongScore;
    
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
