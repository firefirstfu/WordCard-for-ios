
#import <Foundation/Foundation.h>

@interface WordCard : NSObject

//寫在.h檔裡面的為私有變量及方法，本地類及外部類皆可訪問

//英文單字
@property (nonatomic, strong) NSString *englishWord;
//中譯
@property (nonatomic, strong) NSString *chineseWord;
//隨機中文單字組
@property (nonatomic, strong) NSMutableArray *random4ChineseWord;
//是否被選中
@property (nonatomic, assign) BOOL isChoiced;

@end
