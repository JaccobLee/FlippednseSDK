//
//  PopTranslateAndGramarView.m
//  iEnglish
//
//  Created by JacobLi on 5/3/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PopTranslateAndGramarView.h"
#import "GDataXMLNode.h"

@interface PopTranslateAndGramarView ()

@property (nonatomic, strong) UIView    *contentView;
@property (nonatomic, strong) UILabel   *lbContent;

@end

@implementation PopTranslateAndGramarView

- (NSString *)flantHtml:(NSString *)html
{
    NSString *str = @"";
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:[NSString stringWithFormat:@"<root>%@</root>",html] options:0 error:nil];
    GDataXMLElement *root = [xml rootElement];
    
    if (root)
    {
        NSArray *arrChild = [root children];
        
        for (GDataXMLElement *child in arrChild)
        {
            if ([child stringValue])
            {
                str = [str stringByAppendingString:[child stringValue]];
            }
        }
    }

    
//    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"宋体\"></FONT>" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"Arial\"></FONT>" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"宋体\" KERNING=\"1\">" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<FONT FACE=\"Arial\" KERNING=\"1\"></FONT>" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<TEXTFORMAT><P ALIGN=\"JUSTIFY\">" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"</P></TEXTFORMAT>" withString:@"<br>"];
//    str = [str stringByReplacingOccurrencesOfString:@"<TEXTFORMAT BLOCKINDENT=\"30\"><P ALIGN=\"JUSTIFY\">" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"<br>"];
//    
//    if ([str hasSuffix:@"<br>"])
//    {
//        str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:1 range:NSMakeRange(str.length - 4, 4)];
//    }
    
    return str;
}


- (CGSize)layoutViewWithContentStr:(NSString *)str withContentViewFrame:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    
    if (_lbContent)
    {
        [_lbContent removeFromSuperview];
    }
    
    self.frame = rect;
    self.layer.cornerRadius = 3.0f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 1.0;
    self.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    _lbContent = [UILabel createLabelWithFrame:CGRectMake(10, 2, self.frame.size.width - 20, self.frame.size.height) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:KSystemfont(18) textalignment:NSTextAlignmentLeft text:@""];
    _lbContent.numberOfLines = 0;
    
    NSString *content = [str stringByReplacingOccurrencesOfString:@"<NULL>" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"[br/]" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"……" withString:@"······"];
    content = [self flantHtml:content];
    
    if ([[UIScreen mainScreen] bounds].size.height >= 1024)
    {
        content = [NSString stringWithFormat:@"<font size=\"5\">%@</font>",content];
    }
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _lbContent.attributedText = attrStr;
    [self addSubview:_lbContent];
    
    [_lbContent sizeToFit];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,_lbContent.frame.size.width + 20, _lbContent.frame.size.height + 5);
    
    return self.frame.size;
}

- (void)relayoutContentViewWithFrame:(CGRect)frame
{
    self.frame = frame;
}


@end
