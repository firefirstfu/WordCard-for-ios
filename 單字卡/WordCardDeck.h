
#import <Foundation/Foundation.h>
#import "WordCard.h"

@interface WordCardDeck : NSObject

//wordCardDesk Array
@property (nonatomic, strong) NSMutableArray *wordCardDeck;

//增加單字卡
-(void) addCard:(WordCard*)wordCard;

//移除單字卡
-(void) removeCard:(NSInteger)index;

//隨機抽取單字卡&移除已經抽取的單字卡
-(WordCard*) getRandomWordCard;

@end
