//
//  PopTextView.m
//  iEnglish
//
//  Created by JacobLi on 4/14/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PopTextView.h"
#import "UIViewExt.h"

@interface PopTextView ()

@property (strong, nonatomic) NSMutableArray *leftLabels;
@property (strong, nonatomic) NSMutableArray *rightLabels;

@end

@implementation PopTextView

- (NSString *)changeHtmlStr:(NSString *)html
{
    self.leftLabels = [NSMutableArray array];
    self.rightLabels = [NSMutableArray array];
    
    NSString *str = @"";
    NSString *text = html;
    
    text = [text stringByReplacingOccurrencesOfString:@"[u]" withString:@"<u>"];
    text = [text stringByReplacingOccurrencesOfString:@"[/u]" withString:@"</u>"];
    text = [text stringByReplacingOccurrencesOfString:@"[i]" withString:@"<i>"];
    text = [text stringByReplacingOccurrencesOfString:@"[/i]" withString:@"</i>"];
    text = [text stringByReplacingOccurrencesOfString:@"[b]" withString:@"<b>"];
    text = [text stringByReplacingOccurrencesOfString:@"[/b]" withString:@"</b>"];
    text = [text stringByReplacingOccurrencesOfString:@"[br/]" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TEXTFORMAT>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"－" withString:@"—"];
    
    NSArray *arrText = [text componentsSeparatedByString:@"</TEXTFORMAT>"];
    NSMutableArray *arrText_split = [NSMutableArray arrayWithArray:arrText];
    
    BOOL ischeck = false;
    if ([arrText_split firstObject])
    {
        if ( [[arrText_split firstObject] rangeOfString:@"1|"].location != NSNotFound)
//        if ([[arrText_split firstObject] containsString:@"1|"])
        {
            NSString *tempstr = [arrText_split firstObject];
            tempstr = [[arrText_split firstObject] stringByReplacingOccurrencesOfString:@"1|" withString:@""];
            [arrText_split replaceObjectAtIndex:0 withObject:tempstr];
            ischeck = true;
        }
    }
    
    for (int i = 0; i < [arrText_split count]; i++)
    {
        __weak NSString *string =  [arrText_split objectAtIndex:i];
        string = [string stringByReplacingOccurrencesOfString:@"<P ALIGN=\"JUSTIFY\">" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"</P>" withString:@"<br>"];
        
        
        if (ischeck && [string rangeOfString:(@"[none]")].location == NSNotFound)
//        if (ischeck && ![string containsString:(@"[none]")])
        {
            string = [string stringByReplacingOccurrencesOfString:@"[none]" withString:@""];
            // 对齐有2种表示符,一种是[s],一种是:
            // [s]形式
            
            if ([string rangeOfString:@"[s]"].location != NSNotFound)
//            if ([string containsString:@"[s]"])
            {
                NSArray *arrString = [string componentsSeparatedByString:@"[s]"];

                UILabel *lLabel = [[UILabel alloc] init];
                UILabel *rLabel = [[UILabel alloc] init];
                lLabel.text = [NSString stringWithFormat:@"%@&nbsp", arrString.firstObject];
                rLabel.text = arrString.lastObject;
                [self.leftLabels addObject:lLabel];
                [self.rightLabels addObject:rLabel];
            }
            // :形式
             else if ([string rangeOfString:@"<B>"].location != NSNotFound && ([string rangeOfString:@"</B>"].location - [string rangeOfString:@"<B>"].location != 3))
//            else if ([string containsString:@"<B>"] && ([string rangeOfString:@"</B>"].location - [string rangeOfString:@"<B>"].location != 3))
            {
                // 单独处理七下32页
                if ([string isEqualToString:@"<FONT FACE=\"Arial\"><FONT KERNING=\"1\">1<B>Tony:</B> Where’s the museum?</FONT></FONT><br>"])
                {
                    
                    UILabel *lLabel1 = [[UILabel alloc] init];
                    UILabel *rLabel1 = [[UILabel alloc] init];
                    
                    rLabel1.text = @"<FONT FACE=\"Arial\">1</FONT><br>";
                    [self.leftLabels addObject:lLabel1];
                    [self.rightLabels addObject:rLabel1];
                    
                    UILabel *lLabel = [[UILabel alloc] init];
                    UILabel *rLabel = [[UILabel alloc] init];
                    lLabel.text = [NSString stringWithFormat:@"<B>Tony&nbsp;:&nbsp;</B>"];
                    rLabel.text = @"Where’s the museum?";
                    [self.leftLabels addObject:lLabel];
                    [self.rightLabels addObject:rLabel];
                }
                else if ([string isEqualToString:@"<FONT FACE=\"Arial,宋体,_sans\" COLOR=\"#333333\"><B>Zhao Ming</B>:Well, I love table tennis and Deng Yaping is my favourite table tennis player in China, so I chose her.</FONT><br>"])
                {
                    UILabel *lLabel = [[UILabel alloc] init];
                    UILabel *rLabel = [[UILabel alloc] init];
                    lLabel.text = [NSString stringWithFormat:@"<B>Zhao Ming&nbsp;:&nbsp;</B>"];
                    rLabel.text = @"Well, I love table tennis and Deng Yaping is my favourite table tennis player in China, so I chose her.";
                    [self.leftLabels addObject:lLabel];
                    [self.rightLabels addObject:rLabel];
                }
                else
                {
                    NSString *leftStr = [[string substringWithRange:NSMakeRange([string rangeOfString:@"<B>"].location+3, [string rangeOfString:@"</B>"].location - [string rangeOfString:@"<B>"].location-3)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *rightStr = [[string substringWithRange:NSMakeRange([string rangeOfString:@"</B>"].location+4, [string rangeOfString:@"</FONT>" options:NSBackwardsSearch].location - [string rangeOfString:@"</B>"].location-4)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    UILabel *lLabel = [[UILabel alloc] init];
                    UILabel *rLabel = [[UILabel alloc] init];
                    
                    if ([string rangeOfString:@":"].location != NSNotFound)
                    {
                        
                        if ([leftStr rangeOfString:@":"].location != NSNotFound) {
                            lLabel.text = [NSString stringWithFormat:@"<B>%@</B>", [leftStr stringByReplacingOccurrencesOfString:@":" withString:@"&nbsp;:&nbsp;"]];
                        } else {
                            lLabel.text = [NSString stringWithFormat:@"<B>%@&nbsp;:&nbsp;</B>", leftStr];
                        }
                        rLabel.text = rightStr;
                        
                        string = [string stringByReplacingOccurrencesOfString:@":" withString:@"&nbsp;:&nbsp;"];
                    }
                    else
                    {
                        
                        lLabel.text = [NSString stringWithFormat:@"<B>%@</B>", leftStr];
                        rLabel.text = rightStr;
                    }
                    [self.leftLabels addObject:lLabel];
                    [self.rightLabels addObject:rLabel];
                }
            }
            else {
                
                
                UILabel *lLabel = [[UILabel alloc] init];
                UILabel *rLabel = [[UILabel alloc] init];
//                lLabel.hidden = true;
                rLabel.text = string;
                [self.leftLabels addObject:lLabel];
                [self.rightLabels addObject:rLabel];
            }
        }
        else
        {
            string = [string stringByReplacingOccurrencesOfString:@"[none]" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"&#xA;" withString:@"<br/><br/>"];
            string = [string stringByReplacingOccurrencesOfString:@"<I>|</I>" withString:@"."];
            string = [string stringByReplacingOccurrencesOfString:@"[s]" withString:@""];
            
            // 针对一起一上p48
            if (([string rangeOfString:@"— Five blue birds."].location != NSNotFound) || ([string rangeOfString:@"— Three white dogs."].location != NSNotFound) || ([string rangeOfString:@"— Seven black dogs."].location != NSNotFound) || ([string rangeOfString:@"— Nine red birds."].location != NSNotFound))
            {
//            if ([string containsString:@"— Five blue birds."] || [string containsString:@"— Three white dogs."] || [string containsString:@"— Seven black dogs."] || [string containsString:@"— Nine red birds."])
//            {
                string = [NSString stringWithFormat:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@",string];
            }
            
            UILabel *lLabel = [[UILabel alloc] init];
            UILabel *rLabel = [[UILabel alloc] init];
            lLabel.hidden = true;
            

            
            rLabel.text = string;
            [self.leftLabels addObject:lLabel];
            [self.rightLabels addObject:rLabel];
        }
        
        [arrText_split replaceObjectAtIndex:i withObject:string];
    }
    
    for (NSString *temp in arrText_split)
    {
        str = [str stringByAppendingString:temp];
    }
    
    return str;
}

- (void)layoutView
{
    
    UIScrollView *scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 13, self.bounds.size.width - 13, HeightScale(470))];
    scrollContent.backgroundColor = [UIColor colorMainBg];
    scrollContent.layer.cornerRadius = 5.0f;
    scrollContent.layer.borderColor = [[UIColor grayColor] CGColor];
    scrollContent.layer.borderWidth = 0.5f;
    scrollContent.showsHorizontalScrollIndicator = NO;
    scrollContent.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollContent];
    
    [self changeHtmlStr:_content];

    for (UILabel *lLabel in self.leftLabels) {
        lLabel.font = KSystemfont(15.0);
        lLabel.textAlignment = NSTextAlignmentRight;
        if ([lLabel.text hasSuffix:@"<br>"] || [lLabel.text hasSuffix:@"<br/>"] || [lLabel.text hasSuffix:@"\n"])
        {
            lLabel.text = [lLabel.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:1 range:NSMakeRange(lLabel.text.length - 4, 4)];
            lLabel.text = [lLabel.text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"" options:1 range:NSMakeRange(lLabel.text.length - 5, 5)];
            lLabel.text = [lLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:1 range:NSMakeRange(lLabel.text.length - 2, 2)];
        }
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[lLabel.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        lLabel.text = @"";
        lLabel.attributedText = attrStr;
        [scrollContent addSubview:lLabel];
    }
    
    for (UILabel *rLabel in self.rightLabels) {
        rLabel.font = KSystemfont(15.0);
        rLabel.numberOfLines = 0;
        
        if ([rLabel.text hasSuffix:@"<br>"] || [rLabel.text hasSuffix:@"<br/>"] || [rLabel.text hasSuffix:@"\n"])
        {
            rLabel.text = [rLabel.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"" options:1 range:NSMakeRange(rLabel.text.length - 4, 4)];
            rLabel.text = [rLabel.text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"" options:1 range:NSMakeRange(rLabel.text.length - 5, 5)];
//            rLabel.text = [rLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:1 range:NSMakeRange(rLabel.text.length - 2, 2)];
        }
        
        rLabel.text = [rLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/><br/>"];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[rLabel.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        rLabel.text = @"";
        rLabel.attributedText = attrStr;
        [scrollContent addSubview:rLabel];
    }
    
    for (int i = self.leftLabels.count - 1; i > 0; i --) {
        UILabel *lLabel = self.leftLabels[i];
        UILabel *rLabel = self.rightLabels[i];
        
        if (!lLabel.attributedText.length && !rLabel.attributedText.length) {
            [self.leftLabels removeObject:lLabel];
            [self.rightLabels removeObject:rLabel];
        }
        else {
            break;
        }
    }
    
//    for (int i = 0; i < [self.leftLabels count]; i++)
//    {
//        UILabel *lLabel = self.leftLabels[i];
//        if (i < [self.rightLabels count])
//        {
//            UILabel *rLabel = self.rightLabels[i];
//            if (!lLabel.attributedText.length && !rLabel.attributedText.length) {
//                [self.leftLabels removeObject:lLabel];
//                [self.rightLabels removeObject:rLabel];
//            }
//        }
//    }
    
    
    
    UILabel *maxLengthLabel = self.leftLabels[0];
    for (UILabel *lLabel in self.leftLabels) {
        if ([self getWidthForLabel:lLabel] > [self getWidthForLabel:maxLengthLabel]) {
            maxLengthLabel = lLabel;
        }
    }
    [maxLengthLabel sizeToFit];
    
    CGFloat lWidth = maxLengthLabel.width;
    

    
    for (int i = 0; i < self.leftLabels.count; i++) {
        UILabel *lLabel = self.leftLabels[i];
        UILabel *rLabel = self.rightLabels[i];
        
        lLabel.frame = CGRectMake(10, 10, lWidth, 15);
        if (lLabel.hidden) {
            rLabel.frame = CGRectMake(10, lLabel.top, scrollContent.width-20, 0);
        }
        else {
            rLabel.frame = CGRectMake(lLabel.right, lLabel.top, scrollContent.width-20-lWidth, 0);
        }

        [rLabel sizeToFit];
        
        if (i > 0) {
            UILabel *previousRLabel = self.rightLabels[i-1];
            UILabel *previousLLabel = self.leftLabels[i-1];
            if (previousRLabel.attributedText.length) {
                lLabel.frame = CGRectMake(10, previousRLabel.bottom, lWidth, 15);
            }
            else {
                lLabel.frame = CGRectMake(10, previousLLabel.bottom, lWidth, 15);
            }
            rLabel.top = lLabel.top;
            [rLabel sizeToFit];
        }
        lLabel.textAlignment = NSTextAlignmentRight;
    }
    
    CGFloat height;
    if ([self.rightLabels.lastObject attributedText])
    {
        if ([self.rightLabels.lastObject attributedText].length > 0)
        {
            height = [self.rightLabels.lastObject bottom];
        }
        else {
            height = [self.leftLabels.lastObject bottom];
        }
    }
    else {
        height = [self.leftLabels.lastObject bottom];
    }

    CGFloat viewHeight = height+10 < scrollContent.frame.size.height ? height+10  : scrollContent.frame.size.height;
    
    scrollContent.frame = CGRectMake(0, 13, scrollContent.frame.size.width, viewHeight);
    scrollContent.contentSize = CGSizeMake(0, height + 5);
    
    self.frame = CGRectMake(self.center.x - self.frame.size.width / 2, self.center.y - (scrollContent.frame.size.height) / 2 - 13, self.frame.size.width, scrollContent.frame.size.height + 5 + 13);
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 26, 26);
    [btnClose setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_cancel"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    btnClose.center = CGPointMake(self.frame.size.width - 13, 13);
    btnClose.layer.cornerRadius = 13;
    btnClose.layer.masksToBounds = YES;
    [self addSubview:btnClose];
    
}

- (CGFloat)getWidthForLabel:(UILabel *)label
{
    return [label.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
}

- (void)btnCloseAction:(id)sender
{
    [self removeFromSuperview];
}

@end
