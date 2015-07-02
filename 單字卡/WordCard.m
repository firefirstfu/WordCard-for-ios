
#import "WordCard.h"

@interface WordCard()

@end

@implementation WordCard

//getter
-(NSMutableArray*)random4ChineseWord{
    if (!_random4ChineseWord) {
        _random4ChineseWord = [[NSMutableArray alloc] init];
    }
    return _random4ChineseWord;
}


@end




