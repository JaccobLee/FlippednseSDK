//
//  ConfigNetwork.h
//  iEnglish
//
//  Created by JacobLi on 2/26/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#ifndef ConfigNetwork_h
#define ConfigNetwork_h



#define APP_ID          @"ios"
#define APP_Secret      @"856cd8c6ec30e4c375d4a143213b1ef2"

#define AuthAPI         @"e10adc3949ba59abbe56e057f20f883e"

//  定义网站和api接口的baseurl
#ifndef Environment_Distribution
#define BaseUrlWebSite  @"http://testnsebookstore.jiaoxuebang.cn/"
#define BaseUrlApi      @"http://121.43.100.42:8080/api/v3/"
#else
#define BaseUrlWebSite  @"http://nsebooks.jiaoxuebang.cn/"
#define BaseUrlApi      @"http://backadm.jiaoxuebang.cn/api/v3/"
#endif

//  定义网站服务地址
#define Url_WebSite_LastVersion     [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/last_version"]
#define Url_WebSite_Download        [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"download?current_version"]
#define Url_WebSite_DeviceNeed      [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/devices/books"]
#define Url_WebSite_DeviceSwitch    [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/devices/switch_to"]
#define Url_WebSite_Bought          [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/books/bought"]
#define Url_WebSite_ServerTime      [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/app/server_time"]
#define Url_WebSite_ModuleVersion   [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/books/module_version"]
#define Url_WebSite_BooksAll        [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/books"] 


//  定义api接口地址
// 登陆
#define Url_API_Login               [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/login.do"]
// 获取书本信息
#define Url_API_BookInfo            [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"book/getBookDetails.do"]
// 免费购书
#define Url_API_BookBuyFree         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/buyFreeBook.do"]
// 新增订单
#define Url_API_AddBookOrder        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/addBookOrder.do"]
// 新增套餐订单
#define Url_API_AddBookPackageOrder [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/addPackageOrder.do"]
// 获取订单列表接口
#define Url_API_OrderList           [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/getBookOrderList.do"]
// 获取初始订单列表接口
#define Url_API_OrderListInit       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/getInitBookOrderList.do"]
// 取消订单接口
#define Url_API_OrderCancel         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/cancelBookOrder.do"]
// 支付订单接口
#define Url_API_OrderPay            [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/payBookOrder.do"]
// Iap支付完成验证接口
#define Url_API_OrderIapPay         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/payAppStoreOrderSuccess.do"]
// 订单详情接口
#define Url_API_OrderDetail         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/getBookOrderDetails.do"]
// 微信获得prepayId接口
#define Url_API_WXPayPrepayId       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookOrder/prePayOrder.do"]
// 修改密码接口
#define Url_API_ChangePassword      [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/updatePassword.do"]
// 在线书库列表接口
#define Url_API_BookStack           [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"book/getPurchaseBooKByUser.do"]
/** 验证码发送接口 */
#define Url_API_VerifiedSend        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/sendRandCode.do"]
/** 验证码验证接口 */
#define Url_API_VerifiedCheck       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/checkRandCode.do"]
/** 密码重置接口 */
#define Url_API_ResetPassword       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/resetPassword.do"]
/** 用户注册接口 */
#define Url_API_Register            [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/register.do"]
/** 代理商用户注册接口 */
#define Url_API_AgentUserRegister   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/agentUserRegister.do"]
/** 获取省接口 */
#define Url_API_Provice             [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"sys/getProvince.do"]
/*** 获取市接口 */
#define Url_API_City                [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"sys/getCity.do?provinceCode="]
/** 获取县接口 */
#define Url_API_Town                [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"sys/getCountry.do?cityCode="]
/** 获取用户注册协议 */
#define Url_API_Provision           [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"sys/getAgreement.do"]
/** 获取个人信息 **/
#define Url_API_UserInfo            [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/getUser.do"]

// /** 外研社用户接口 */
/** 更改个人信息 **/
#define Url_API_UserInfoChange      [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/updateUser.do"]
/** 发送修改验证码接口 **/
#define Url_API_UpdateRandCode      [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/sendUpdateRandCode.do"]
/** 修改手机或者邮箱接口 **/
#define Url_API_ChangeMobileEmail   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/updatePhoneOrEmailByCode.do"]
/** 获取用户购买历史记录 **/
#define Url_API_PayHistory          [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"book/getHasPurchasedMore.do"]
/** 修改头像 **/
#define Url_API_ChangeHead          [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/uploadHeadPic.do"]
// 检查学习助手的版本号
#define Url_API_LearnHelperVersion  [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookMarkRecord/getBookMarkRecordVersion.do"]
// 上传学习助手信息
#define Url_API_UploadHelperInfo    [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookMarkRecord/uploadBookMarkRecord.do"]
// 获取班级学习记录
#define Url_API_StudentRecord       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"leaningRecord/getLeaningRecords.do"]
// 下载学习助手信息
#define Url_API_DownloadHelperInfo  [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"bookMarkRecord/getBookMarkRecord.do"]
// 检查第三方登录数据是否合法
#define Url_API_CheckAppid          [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/agentUserLogin.do"]
/** 学习记录查询接口 */
#define Url_API_SearchStudyRecord   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"leaningRecord/getLeaningRecordList.do"]
/** 学习记录上传接口 */
#define Url_API_UploadStudyRecord   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"leaningRecord/uploadLeaningRecord.do"]
// 查找学习记录
#define Url_API_SearchStudy         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"leaningRecord/getLeaningRecordList.do"]
// 获取学校接口
#define Url_API_ChooseSchool        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"school/getSchoolList.do"]
// 新建班级接口
#define Url_API_CreateClass         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"class/addClass.do"]
// 获取班级详情
#define Url_API_ClassDetail         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"class/getClassDetails.do"]
// 加入班级接口
#define Url_API_AddClassMember      [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classMember/addClassMember.do"]
// 修改班级接口
#define Url_API_UpdateClass         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"class/updateClass.do"]
// 获取推荐书本
#define Url_API_GetRecommendBook    [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"book/getRecommendBooKByUser.do"]
// 分页获取班级通知接口
#define Url_API_GetClassNotifications   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classNotifications/getClassNotifications.do"]
// 解散班级接口
#define Url_API_RemoveClass         [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"class/removeClass.do"]
// 获取班级列表
#define Url_API_ClassList           [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"class/getClassList.do"]
// 退出班级
#define Url_API_RemoveClassMember   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classMember/removeClassMember.do"]
// 分页获取查询班级成员接口
#define Url_API_GetClassMember      [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classMember/getClassMembers.do"]
// 发送通知
#define Url_API_SendClassNotification   [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classNotifications/sendClassNotification.do"]
//删除通知
#define Url_API_RemoveClassNotification [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classNotifications/removeClassNotification.do"]
//获取成员列表
#define Url_API_GetUserMember       [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/getUsers.do"]
//批量添加成员
#define Url_API_ClassAddMembers     [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"classMember/addClassMemberBatch.do"]
//修改用户学校
#define Url_API_ChangeSchool        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"user/updateUserSchool.do"]
//用户未购书库
#define Url_API_UserNoBuy_book        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"book/getNobuyBooKByUser.do"]
//获取幻灯片列表
#define Url_API_Slidelist        [NSString stringWithFormat:@"%@%@",BaseUrlApi,@"slideInfo/getSlideInfoList.do"]
//下载语法库
#define Url_DownloadGrammar [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/downloads/grammers?category=jh"]
//下载词典
#define Url_DownloadDict [NSString stringWithFormat:@"%@%@",BaseUrlWebSite,@"api/v1/downloads/dict"]
#endif /* ConfigNetwork_h */
