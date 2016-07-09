//
//  ModelBookInfo.h
//  iEnglish
//
//  Created by JacobLi on 3/2/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Model.h"
#import "FlippednseHeader.h"

@interface ModelBookInfo : Model

@property (nonatomic, strong) NSString    *category;
@property (nonatomic, strong) NSString<Optional>    *deadline;
@property (nonatomic, strong) NSString    *eid;
@property (nonatomic, assign) int         id;
@property (nonatomic, strong) NSString    *image_url;
@property (nonatomic, strong) NSString    *name;
@property (nonatomic, assign) int         position;
@property (nonatomic, strong) NSString    *volumn_names;

@property (nonatomic, strong) NSString    *version ;//= "0.1"  cmy

@end



@interface ModelBookInfoOfOnline : Model
@property (nonatomic, strong) NSString  *code;
@property (nonatomic, strong) NSString  *bookName;
@property (nonatomic, strong) NSString  *cover;//"http://121.43.100.42:8080/upload/http://img5.imgtn.bdimg.com/it/u=2149796787,842171726&fm=21&gp=0.jpg"
@property (nonatomic, assign) BOOL  hasBuy;
@property (nonatomic, assign) BOOL  canFree;
@property (nonatomic, assign) BOOL  canDiscount;

@end

@interface BookStoreInfo : Model
@property (nonatomic, strong) NSString  *category;
@property (nonatomic, strong) NSMutableArray  *books;//<ModelBookInfoOfOnline *>

-(instancetype)initBookStoreInfoWithDictionary:(NSDictionary *)dictionary;
@end


@interface ModelBookInfoDetail : Model

@property (nonatomic, strong) NSString  *bookId;
@property (nonatomic, strong) NSString  *code;
@property (nonatomic, strong) NSString  *bookName;
@property (nonatomic, strong) NSString  *publishingHouseName;
@property (nonatomic, strong) NSString  *description;     // 接口为description， 与保留字冲突
@property (nonatomic, strong) NSString  *cover;
@property (nonatomic, strong) NSString  *size;
@property (nonatomic, strong) NSString  *usableUnits;
@property (nonatomic, assign) BOOL  canFreeBuy;


@property (nonatomic, assign) CGFloat   freePrice;
@property (nonatomic, strong) NSDate    *freeEndDate;
@property (nonatomic, strong) NSString  *activityContent;
@property (nonatomic, strong) NSArray<Optional>   *bookEditions;


@property (nonatomic, strong) NSString  *discountPic;
@property (nonatomic, assign) BOOL  canDiscountBuy;
@property (nonatomic, strong) NSArray<Optional>   *bookPackageList;//ModelBookPackage
@end


@interface ModelBookEdition : Model

@property (nonatomic, assign) int   bookEditionId;
@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) int   type;
@property (nonatomic, strong) NSString *editionName;
@property (nonatomic, assign) int   validity;
@property (nonatomic, assign) BOOL  hasBuy;

@property (nonatomic, assign) CGFloat   discountPrice;

@end

@interface ModelBookPackage :Model

@property (nonatomic, assign) int   bookPackageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CGFloat originalPrice;
@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) int  validity;
@property (nonatomic, assign) int   type;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSArray<Optional>   *coverList;//年级套餐封面集合
@end


@interface ModelBookDataXml : Model

@property (nonatomic, strong) NSString      *bookname;
@property (nonatomic, strong) NSString      *bookid;
@property (nonatomic, strong) NSString      *gradename;
@property (nonatomic, strong) NSString      *gradeid;
@property (nonatomic, assign) CGFloat       volume;
@property (nonatomic, assign) CGFloat       width;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, assign) CGFloat       flashwidth;
@property (nonatomic, assign) CGFloat       flashheight;
@property (nonatomic, assign) int           totalpages;
@property (nonatomic, assign) int           coverpages;
@property (nonatomic, assign) int           contentpages;
@property (nonatomic, strong) NSString      *moduleobj;
@property (nonatomic, strong) NSString      *testid;
@property (nonatomic, assign) BOOL          clickread;
@property (nonatomic, strong) NSString      *pagename;
@property (nonatomic, assign) int           clickReadLevel;

// 根据xml特殊格式做相关处理
- (instancetype)initWithDictionaryTrimText:(NSDictionary *)dicXml;

@end

@interface ModelBookDownloadEnableModuleUnit : Model

@property (nonatomic, assign) int           startPage;
@property (nonatomic, assign) int           endPage;
@property (nonatomic, strong) NSString      *name;

@end

@interface ModelBookModuleInfo : Model

@property (nonatomic, strong) NSString<Optional>      *text;
@property (nonatomic, assign) int           startPage;
@property (nonatomic, assign) int           endPage;
@property (nonatomic, assign) int           hasUnit;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSArray<Optional>       *units;

@end

@interface ModelBookUnitInfo : Model

@property (nonatomic, strong) NSString      *title;
@property (nonatomic, assign) int           startPage;
@property (nonatomic, assign) int           endPage;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString<Optional>      *text;


@end


//购买的课本信息及绑定的设备信息
@interface ModelBookSchema : JSONModel
@property (nonatomic, assign) int               book_id;
@property (nonatomic, strong) NSString          *book_eid;
@property (nonatomic, strong) NSString          *book_name;
@property (nonatomic, strong) NSString          *deadline;
@property (nonatomic, assign) BOOL               expired;
@property (nonatomic, strong) NSString          *device;


@end


