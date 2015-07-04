
#import "WordDataDataBase.h"

@interface WordDataDataBase()

//Plist Data
@property (nonatomic, strong) NSMutableDictionary *plistData;

@end

@implementation WordDataDataBase


//撈Plist Data
-(NSMutableDictionary*) getDataInPlist{
    //讀取Plist內的Data(dictionary)

    self.plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:_plistPath];
    return self.plistData;
}

//寫入Plist Data
-(void) updateDataInPlist:(NSMutableDictionary*)plistDataDictionary{
    [plistDataDictionary writeToFile:_plistPath atomically:YES];
    
}


@end



