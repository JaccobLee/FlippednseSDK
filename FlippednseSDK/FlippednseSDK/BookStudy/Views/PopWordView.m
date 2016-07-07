//
//  PopWordView.m
//  iEnglish
//
//  Created by JacobLi on 4/21/16.
//  Copyright © 2016 jxb. All rights reserved.
//

#import "PopWordView.h"

@interface PopWordView ()

@property (nonatomic, strong) UIScrollView  *scrollContent;

@end

@implementation PopWordView


- (void)setModel:(ModelWordNode *)model
{
    _model = model;
}

- (void)layoutView
{
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetHeight = 0;
    
    UIImageView *imgScrollBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - WidthScale(200), HeightScale(600))];
    imgScrollBg.image = [UIImage imageNamed:@"bookstudy_popview_bg"];
    imgScrollBg.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:imgScrollBg];
    
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - WidthScale(200), HeightScale(600))];
    _scrollContent.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _scrollContent.backgroundColor = [UIColor clearColor];
    _scrollContent.layer.cornerRadius = 5.0f;
    _scrollContent.showsHorizontalScrollIndicator = NO;
    _scrollContent.showsVerticalScrollIndicator = NO;
    _scrollContent.scrollEnabled = YES;
    [self addSubview:_scrollContent];
    
    UILabel *lbTitle = [UILabel createLabelWithFrame:CGRectMake(8, 8, _scrollContent.frame.size.width - 10, 20)  backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:KSystemfontBold(15.0) textalignment:NSTextAlignmentLeft text:_model.word];
    [lbTitle sizeToFit];
    [_scrollContent addSubview:lbTitle];
    
    UIButton *btnVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVoice.frame = CGRectMake(lbTitle.frame.origin.x + lbTitle.frame.size.width + 10, 5, 20, 20);
    btnVoice.backgroundColor = [UIColor clearColor];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_voice"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"bookstudy_btn_voice_press"] forState:UIControlStateHighlighted];
    [btnVoice addTarget:self action:@selector(btnVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContent addSubview:btnVoice];
    
    offsetHeight += 30 + 5;
    
// Feature Box
    UILabel *lbFeatureBox = [UILabel createLabelWithFrame:CGRectMake(10, offsetHeight, _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:Locale(@"Feature Box")];
    [_scrollContent addSubview:lbFeatureBox];
    
    offsetHeight += 5 + 15;
    
    UILabel *lbEntry = [UILabel createLabelWithFrame:CGRectMake(20, offsetHeight , _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"•&nbsp&nbsp&nbsp%@: %@",Locale(@"Entry"),_model.entry]];
    NSAttributedString *attrEntry = [[NSAttributedString alloc] initWithData:[lbEntry.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lbEntry.attributedText = attrEntry;
    [_scrollContent addSubview:lbEntry];
    
    offsetHeight += 5 + 15;
    
    if (_model.frequency.length > 0)
    {
        UILabel *lbFrequency = [UILabel createLabelWithFrame:CGRectMake(20, offsetHeight, _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"•&nbsp&nbsp&nbsp%@: %@",Locale(@"Frequency"),_model.frequency]];
        
        
        NSAttributedString *attrFrequency = [[NSAttributedString alloc] initWithData:[lbFrequency.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        lbFrequency.attributedText = attrFrequency;
        [_scrollContent addSubview:lbFrequency];
        offsetHeight += 10 + 15;
    }
    else
    {
        offsetHeight += 5;
    }
    
// Definition
    UILabel *lbDefinitionTitle = [UILabel createLabelWithFrame:CGRectMake(10, offsetHeight, _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:Locale(@"Definition")];
    [_scrollContent addSubview:lbDefinitionTitle];
    
    offsetHeight += 10 + 15;
    
    for (definitionList *def in _model.definitions)
    {
        int fontSize = [[UIScreen mainScreen] bounds].size.height >= 1024 ? 18 : 15;
        
        if ([def.pos isKindOfClass:[NSString class]])
        {
            UILabel *lbPos = [UILabel createLabelWithFrame:CGRectMake(20, offsetHeight,WidthScale(50), fontSize) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:def.pos];
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:def.pos attributes:@{ NSObliquenessAttributeName : [NSNumber numberWithFloat:0.3f]}];
            
            lbPos.attributedText = attStr;
            [lbPos sizeToFit];
            [_scrollContent addSubview:lbPos];
            
            if ([def.definition isKindOfClass:[NSString class]])
            {
                NSString *defstr = def.definition;
                
                UILabel *lbDefinition = [UILabel createLabelWithFrame:CGRectMake(lbPos.frame.origin.x + lbPos.frame.size.width + 5, offsetHeight, _scrollContent.bounds.size.width - 10 - (lbPos.frame.origin.x + lbPos.frame.size.width + 10), fontSize) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:def.definition];
                lbDefinition.numberOfLines = 0;
                
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[defstr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                
                lbDefinition.attributedText = attrStr;
                [lbDefinition sizeToFit];
                [_scrollContent addSubview:lbDefinition];
                
                offsetHeight += 5 + lbDefinition.frame.size.height;
                
            }
            else
            {
                offsetHeight += fontSize;
            }
        }
        else
        {
            if ([def.definition isKindOfClass:[NSString class]])
            {
                NSString *defstr = def.definition;
                
                UILabel *lbDefinition = [UILabel createLabelWithFrame:CGRectMake(20, offsetHeight, _scrollContent.bounds.size.width - 10 - 20, fontSize) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:def.definition];
                lbDefinition.numberOfLines = 0;
                
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[defstr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                
                lbDefinition.attributedText = attrStr;
                [lbDefinition sizeToFit];
                [_scrollContent addSubview:lbDefinition];
                
                offsetHeight += 5 + lbDefinition.frame.size.height;
            }
            else
            {
                offsetHeight += fontSize;
            }
        }
    }
    
    offsetHeight += 10;
    
// Picture
    if (_model.imagePath.length > 0)
    {
        UILabel *lbPicture = [UILabel createLabelWithFrame:CGRectMake(10, offsetHeight, _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:Locale(@"Picture")];
        [_scrollContent addSubview:lbPicture];
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(20, offsetHeight + 20, 200, 200)];
        [imgview setImage:[UIImage imageWithContentsOfFile:_model.imagePath]];
        [_scrollContent addSubview: imgview];
        
        offsetHeight += 200 + 30;
    }
   
// Examples
    if ([_model.entry_examples count] > 0)
    {
        UILabel *lbExamplesTitle = [UILabel createLabelWithFrame:CGRectMake(10, offsetHeight, _scrollContent.bounds.size.width - 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:Locale(@"Examples")];
        [_scrollContent addSubview:lbExamplesTitle];
        
        offsetHeight += 5 + 15;
        
        for (int i = 0; i < [_model.entry_examples count]; i++)
        {
            UILabel *lbIcon = [UILabel createLabelWithFrame:CGRectMake(20, offsetHeight, 10, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15) textalignment:NSTextAlignmentLeft text:@"•"];
            NSAttributedString *attrIcon = [[NSAttributedString alloc] initWithData:[lbIcon.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            lbIcon.attributedText = attrIcon;
            [_scrollContent addSubview:lbIcon];
            
            UILabel *lbExamples = [UILabel createLabelWithFrame:CGRectMake(34, offsetHeight, _scrollContent.bounds.size.width - 45, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor colorFontDark] font:KSystemfont(15.0f) textalignment:NSTextAlignmentLeft text:[_model.entry_examples objectAtIndex:i]];
            lbExamples.numberOfLines = 0;
            
            
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[_model.entry_examples objectAtIndex:i] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            lbExamples.attributedText = attrStr;
            [lbExamples sizeToFit];
            
            [_scrollContent addSubview:lbExamples];
            
            offsetHeight += 5 + lbExamples.frame.size.height;
        }
    }
    
    offsetHeight += 10;
    
    CGFloat heightMax = offsetHeight < HeightScale(600) ? offsetHeight : HeightScale(600);
    
    _scrollContent.frame = CGRectMake(0, 0, _scrollContent.frame.size.width, heightMax);
    _scrollContent.contentSize = CGSizeMake(0, offsetHeight);
    
    imgScrollBg.frame = CGRectMake(_scrollContent.frame.origin.x, _scrollContent.frame.origin.y, _scrollContent.frame.size.width, _scrollContent.frame.size.height);
    
    self.frame = CGRectMake(self.frame.size.width / 2 - _scrollContent.frame.size.width / 2, self.frame.size.height / 2 - _scrollContent.frame.size.height / 2, _scrollContent.frame.size.width, _scrollContent.frame.size.height);
}

- (void)addView
{
    [self addSubview:_scrollContent];
}

- (void)btnVoiceAction:(id)sender
{
    [Notif postNotificationName:Notif_Play_Word_ListenWord object:_model.pronunciationPath];
}


@end
