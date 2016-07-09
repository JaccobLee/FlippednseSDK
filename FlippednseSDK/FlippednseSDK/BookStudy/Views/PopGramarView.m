//
//  PopGramarView.m
//  iEnglish
//
//  Created by JacobLi on 5/13/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PopGramarView.h"

@interface PopGramarView ()

@property (nonatomic, strong) UIScrollView      *scrollContent;

@end

@implementation PopGramarView

- (NSString *)flantHtml:(NSString *)html
{
    NSString *str = html;
    
    NSString *number = @"-?[0-9]+";
    
    NSError *error = NULL;
    NSRegularExpression *regexBLOCKINDENT = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"<TEXTFORMAT BLOCKINDENT=\"%@\"><P ALIGN=\"JUSTIFY\">",number] options:NSRegularExpressionCaseInsensitive error:&error];
    while ([regexBLOCKINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])])
    {
        NSTextCheckingResult *result = [regexBLOCKINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        NSString *searchText = [str substringWithRange:result.range];
        str = [str stringByReplacingOccurrencesOfString:searchText withString:@"<br>"];
    }
    
    NSRegularExpression *regexINDENT = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"<TEXTFORMAT INDENT=\"%@\"><P ALIGN=\"JUSTIFY\">",number] options:NSRegularExpressionCaseInsensitive error:&error];
    while ([regexINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])])
    {
        NSTextCheckingResult *result = [regexINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        NSString *searchText = [str substringWithRange:result.range];
        str = [str stringByReplacingOccurrencesOfString:searchText withString:@"<br>"];
    }
    
    NSRegularExpression *regexINDENTandBLOCKINDENT = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"<TEXTFORMAT INDENT=\"%@\" BLOCKINDENT=\"%@\"><P ALIGN=\"JUSTIFY\">",number,number] options:NSRegularExpressionCaseInsensitive error:&error];
    while ([regexINDENTandBLOCKINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])])
    {
        NSTextCheckingResult *result = [regexINDENTandBLOCKINDENT firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        NSString *searchText = [str substringWithRange:result.range];
        str = [str stringByReplacingOccurrencesOfString:searchText withString:@"<br>"];
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"Arial,宋体,_sans\" COLOR=\"#333333\"></FONT>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"宋体\" KERNING=\"1\"></FONT>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"宋体\"></FONT>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"Arial\"></FONT>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<TEXTFORMAT><P ALIGN=\"JUSTIFY\">" withString:@"<br>"];
    str = [str stringByReplacingOccurrencesOfString:@"</P></TEXTFORMAT>" withString:@"<br/>"];
    str = [str stringByReplacingOccurrencesOfString:@"<br/><br><br/><br>" withString:@"<br/><br>"];
    str = [str stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"<br>"];
    str = [str stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"<br/>"];
    
    
    while ([str hasSuffix:@"<br>"] || [str hasSuffix:@"<br/>"])
    {
        str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:1 range:NSMakeRange(str.length - 4, 4)];
        str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@"" options:1 range:NSMakeRange(str.length - 5, 5)];
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"</P><br>" withString:@"</P>"];
    
    return str;
}

- (CGSize)layoutViewWithContentStr:(NSString *)str withContentViewFrame:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.cornerRadius = 3.0f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 1.0;
    self.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - WidthScale(200), HeightScale(500))];
    _scrollContent.backgroundColor = [UIColor clearColor];
    _scrollContent.layer.cornerRadius = 5.0f;
    _scrollContent.showsHorizontalScrollIndicator = NO;
    _scrollContent.showsVerticalScrollIndicator = NO;
    _scrollContent.scrollEnabled = YES;
    [self addSubview:_scrollContent];
    
    UILabel *lbContent = [UILabel createLabelWithFrame:CGRectMake(10, 10, _scrollContent.frame.size.width - 20, _scrollContent.frame.size.height - 20) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:KSystemfont(15) textalignment:NSTextAlignmentLeft text:@""];
    lbContent.numberOfLines = 0;
    
    
    NSString *content = [str stringByReplacingOccurrencesOfString:@"<NULL>" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"</<TEXTFORMAT>" withString:@"</TEXTFORMAT>"];
    content = [content stringByReplacingOccurrencesOfString:@"</<TEX TFORMAT>" withString:@"</TEXTFORMAT>"];
    content = [content stringByReplacingOccurrencesOfString:@"[br/]" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"……" withString:@"······"];
    content = [self flantHtml:content];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lbContent.attributedText = attrStr;
    [lbContent sizeToFit];
    [_scrollContent addSubview:lbContent];
    
    CGFloat heightMax = lbContent.frame.size.height + 20 < HeightScale(600) ? lbContent.frame.size.height + 20 : HeightScale(600);
    
    _scrollContent.frame = CGRectMake(_scrollContent.frame.origin.x, _scrollContent.frame.origin.y, _scrollContent.frame.size.width, heightMax);
    _scrollContent.contentSize = CGSizeMake(0, lbContent.frame.size.height + 20);

    self.frame = CGRectMake(self.frame.size.width / 2 - _scrollContent.frame.size.width / 2, self.frame.size.height / 2 - _scrollContent.frame.size.height / 2, _scrollContent.frame.size.width, _scrollContent.frame.size.height);
    
    return self.frame.size;
}

@end
