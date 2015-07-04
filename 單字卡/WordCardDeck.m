
#import "WordCardDeck.h"
#import "WordCard.h"
#import "WordDataDataBase.h"


@interface WordCardDeck()

@end

@implementation WordCardDeck

//初始化從Plist抽取全部單字卡
-(id)init{
    self = [super init];
    if(self){
        //創造資料庫物件
        WordDataDataBase *dataBaseObject = [WordDataDataBase new];
        //取得plist路徑
        dataBaseObject.plistPath =  [NSString stringWithFormat:@"%@/Documents/Property List.plist", NSHomeDirectory()];
        NSMutableDictionary *dataDict = [dataBaseObject getDataInPlist];
        
        NSArray *englishWordArray = [dataDict allKeys];
        NSArray *chineseWordArray = [dataDict allValues];
        
        //這裡要改
//        for (NSString *strs in chineseWordArray) {
//            NSLog(@"%@", strs);
//        }
//        for (NSString *strs in englishWordArray) {
//            NSLog(@"%@", strs);
//        }
        
        //抽取Plist全部的單字卡
        for (NSInteger count = 0; count < [englishWordArray count]; count++) {
            WordCard *wordCard = [[WordCard alloc] init];
            wordCard.englishWord = englishWordArray[count];
            wordCard.chineseWord = chineseWordArray[count];
            wordCard.random4ChineseWord = [WordCardDeck createRandom4ChineseWord:chineseWordArray
                                                                    withWordCard:wordCard];
            [self addCard:wordCard];
        }
        return self;
    }
    return  nil;
}

//getter
-(NSMutableArray*) wordCardDeck{
    if (!_wordCardDeck) {
        _wordCardDeck = [[NSMutableArray alloc] init];
    }
    return _wordCardDeck;
}

//增加單字卡
-(void) addCard:(WordCard*)wordCard{
    WordCard *test = wordCard;
    WordCard *testTwo = test;
    [self.wordCardDeck addObject:testTwo];
}

//移除單字卡
-(void) removeCard:(NSInteger)index{
    [self.wordCardDeck removeObjectAtIndex:index];
}

//隨機抽取單字卡&移除已經抽取的單字卡
-(WordCard*) getRandomWordCard{
    WordCard *tempWordCard = nil;
    if ([self.wordCardDeck count]) {
        NSInteger index = arc4random() % [self.wordCardDeck count];
        tempWordCard = self.wordCardDeck[index];
        [self.wordCardDeck removeObjectAtIndex:index];
        return tempWordCard;
    }
    return tempWordCard;
}

//隨機產生四個不重覆的中文單字組(含Answer)
+(NSMutableArray*) createRandom4ChineseWord:(NSArray*)chineseWordArray withWordCard:(WordCard*)wordCard{
    NSMutableArray *tempWordArray = [[NSMutableArray alloc] init];
    [tempWordArray addObject:wordCard.chineseWord];
    while ([tempWordArray count] !=4) {
        int index = arc4random() % [chineseWordArray count];
        //判斷陣列元素
        if ([tempWordArray containsObject:chineseWordArray[index]] == NO) {
            [tempWordArray addObject:chineseWordArray[index]];
        }
    }
    //random4ChineseWord 屬性賦值
    for (NSInteger index = 0; index <= 3; index++) {
        NSInteger randomNumber = arc4random() % [tempWordArray count];
        [wordCard.random4ChineseWord insertObject:tempWordArray[randomNumber] atIndex:index];
        [tempWordArray removeObjectAtIndex:randomNumber];
    }
    return wordCard.random4ChineseWord;
}


@end









