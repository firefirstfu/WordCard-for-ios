#import "BuildWordTableViewController.h"
#import "WordCard.h"
#import "WordCardDeck.h"
#import "WordDataDataBase.h"

@interface BuildWordTableViewController ()

//目前資料庫的全部單字卡
@property (nonatomic, strong) WordCardDeck *nowDataBaseWordCards;
//被選擇cell
@property (strong, nonatomic) UITableViewCell *choiceCell;
//被選擇cell IndexPath
@property (strong, nonatomic) NSIndexPath *choiceRow;

@end

@implementation BuildWordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    _nowDataBaseWordCards = [WordCardDeck new];
    //增加左邊Add按鈕
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                       target:self action:@selector(enterNewWordCard)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

//新增單字卡
-(void) enterNewWordCard{
    //產生一個AlertView(打底)
    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"新增單字卡"
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField){textField.placeholder = @"請輸入英文單字";
        
    }];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField){textField.placeholder = @"請輸入中文解釋";}];
    
    //作第1個Alert按鈕物件
    UIAlertAction *alertEnter = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *aciton){
                                                           //get Textfield value
                                                           NSString *firstTextField = alertView.textFields.firstObject;
                                                           NSString *secondTextField = alertView.textFields.lastObject;
                                                           
                                                            //新增單字卡=>wordCardDeck
                                                           WordCard *newCard = [WordCard new];
                                                           newCard.englishWord = [firstTextField valueForKey:@"text"];
                                                           newCard.chineseWord = [secondTextField valueForKey:@"text"];
//                                                            for (WordCard *card in _nowDataBaseWordCards.wordCardDeck) {
//                                                                if ([newCard.englishWord isEqualToString:card.englishWord]){
//                                                                    break;
//                                                                }
//                                                            }
                                                           [_nowDataBaseWordCards.wordCardDeck insertObject:newCard atIndex:0];
                                                           //指定要把資料放入哪裡
                                                           NSIndexPath *insertIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                                                           //開始把資料插入TableView(以陣列型態)
                                                           [self.tableView insertRowsAtIndexPaths:@[insertIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                       }];
    //作第2個按鈕物件
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {}];
    //把按鈕加到AlertView上面
    [alertView addAction:alertEnter];
    [alertView addAction:alertCancel];
    //把AlertView加到View上面
    [self presentViewController:alertView animated:YES completion:nil];
}



//有幾個section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//有幾列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nowDataBaseWordCards.wordCardDeck count] ;
}


//每列的Data delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //每一列
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    //單字呈現
    WordCard *card = _nowDataBaseWordCards.wordCardDeck[indexPath.row];
    card.isChoiced = YES;
    cell.textLabel.text = card.englishWord;
    return cell;
}

//每列被選擇時
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //被選擇的Cell indexPath
    _choiceRow = indexPath;
    //被選擇的Cell
     _choiceCell= [tableView cellForRowAtIndexPath:indexPath];
    [self imageTapAnimation:nil];
}

//附著動畫
-(void) imageTapAnimation:(UITapGestureRecognizer*)sender{
    //宣告一個CATransition
    CATransition *transition = [CATransition animation];
    //細部設定
    transition.duration = 0.2f;
    transition.delegate = self;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //動畫效果
    transition.type = @"oglFlip";
    //正反面翻轉方向
    if ([_nowDataBaseWordCards.wordCardDeck[_choiceRow.row] isChoiced]) {
        WordCard *choiceCard =  _nowDataBaseWordCards.wordCardDeck[_choiceRow.row];
        choiceCard.isChoiced = NO;
        transition.subtype = kCATransitionFromBottom;
        _choiceCell.textLabel.text = [_nowDataBaseWordCards.wordCardDeck[_choiceRow.row] chineseWord];
    }else{
        WordCard *choiceCard =  _nowDataBaseWordCards.wordCardDeck[_choiceRow.row];
        choiceCard.isChoiced = YES;
         transition.subtype = kCATransitionFromTop;
        _choiceCell.textLabel.text = [_nowDataBaseWordCards.wordCardDeck[_choiceRow.row] englishWord];
    }
    //執行動畫
    [ _choiceCell.layer addAnimation:transition forKey:@"myTransition"];
}


//動畫開始的delegate
-(void) animationDidStart:(CAAnimation *)anim{
    _choiceCell.hidden = YES;
}

//動畫結束的delegate
-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _choiceCell.hidden = NO;
}

//是否可編輯
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//確定刪除資料
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_nowDataBaseWordCards removeCard:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//寫入PList
-(void) viewDidDisappear:(BOOL)animated{
    //將更新後的wordCard轉成dictionary
    NSMutableArray *tempArray = [NSMutableArray new];
    tempArray = _nowDataBaseWordCards.wordCardDeck;
    NSMutableDictionary *tempDict = [NSMutableDictionary new];
    for (WordCard *card in tempArray) {
        [tempDict setObject:card.chineseWord forKey:card.englishWord];
    }
    
    //創造資料庫物件 && upDate資料庫
    WordDataDataBase *dataBaseObject = [WordDataDataBase new];
    dataBaseObject.plistPath =  [NSString stringWithFormat:@"%@/Documents/Property List.plist", NSHomeDirectory()];
    [dataBaseObject updateDataInPlist:tempDict];
}









































/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
