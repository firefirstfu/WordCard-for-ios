
#import <Foundation/Foundation.h>

@interface WordDataDataBase : NSObject

//Plist Path
@property (nonatomic, strong) NSString *plistPath;

//撈Plist Data
-(NSMutableDictionary*) getDataInPlist;

//寫入Plist Data
-(void) updateDataInPlist:(NSMutableDictionary*)plistData;


@end
