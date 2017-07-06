//
//  NonPasteUITextField.m
//  Netzwierk
//
//  Created by Eric Schanet on 26.02.15.
//
//

#import "NonPasteUITextField.h"

@implementation NonPasteUITextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) || action == @selector(cut:) || action == @selector(select:) || action == @selector(selectAll:))
    {
        return true;
    }
    return false;
}
@end
