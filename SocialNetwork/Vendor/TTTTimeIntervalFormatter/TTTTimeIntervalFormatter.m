// TTTTimeIntervalFormatter.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TTTTimeIntervalFormatter.h"
#include <tgmath.h>

static inline NSCalendarUnit NSCalendarUnitFromString(NSString *string) {
    if ([string isEqualToString:@"year"]) {
        return NSYearCalendarUnit;
    } else if ([string isEqualToString:@"month"]) {
        return NSMonthCalendarUnit;
    } else if ([string isEqualToString:@"week"]) {
        return NSWeekCalendarUnit;
    } else if ([string isEqualToString:@"day"]) {
        return NSDayCalendarUnit;
    } else if ([string isEqualToString:@"hour"]) {
        return NSHourCalendarUnit;
    } else if ([string isEqualToString:@"minute"]) {
        return NSMinuteCalendarUnit;
    } else if ([string isEqualToString:@"second"]) {
        return NSSecondCalendarUnit;
    }
    
    return NSUndefinedDateComponent;
}

@interface TTTTimeIntervalFormatter ()
- (NSString *)localizedStringForNumber:(NSUInteger)number ofCalendarUnit:(NSCalendarUnit)unit;
- (NSString *)localizedIdiomaticDeicticExpressionForComponents:(NSDateComponents *)componenets;
- (NSString *)enRelativeDateStringForComponents:(NSDateComponents *)components;
@end

@implementation TTTTimeIntervalFormatter
@synthesize locale = _locale;
@synthesize calendar = _calendar;
@synthesize pastDeicticExpression = _pastDeicticExpression;
@synthesize presentDeicticExpression = _presentDeicticExpression;
@synthesize futureDeicticExpression = _futureDeicticExpression;
@synthesize deicticExpressionFormat = _deicticExpressionFormat;
@synthesize approximateQualifierFormat = _approximateQualifierFormat;
@synthesize presentTimeIntervalMargin = _presentTimeIntervalMargin;
@synthesize usesAbbreviatedCalendarUnits = _usesAbbreviatedCalendarUnits;
@synthesize usesApproximateQualifier = _usesApproximateQualifier;
@synthesize usesIdiomaticDeicticExpressions = _usesIdiomaticDeicticExpressions;
@synthesize numberOfSignificantUnits = _numberOfSignificantUnits;
@synthesize leastSignificantUnit = _leastSignificantUnit;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.locale = [NSLocale currentLocale];
    self.calendar = [NSCalendar currentCalendar];
    
   // self.pastDeicticExpression = NSLocalizedString(@"ago", nil);//(@"ago", @"FormatterKit", @"Past Deictic Expression");
    self.presentDeicticExpression = NSLocalizedString(@"just now", nil);//NSLocalizedStringFromTable(@"just now", @"FormatterKit", @"Present Deictic Expression");
    self.futureDeicticExpression = NSLocalizedString(@"from now", nil);//NSLocalizedStringFromTable(@"from now", @"FormatterKit", @"Future Deictic Expression");
    
    self.deicticExpressionFormat = NSLocalizedStringWithDefaultValue(@"Deictic Expression Format String", @"FormatterKit", [NSBundle mainBundle], @"%@ %@", @"Deictic Expression Format (#{Time} #{Ago/From Now}");
    self.approximateQualifierFormat = NSLocalizedStringFromTable(@"about %@", @"FormatterKit", @"Approximate Qualifier Format");
    self.presentTimeIntervalMargin = 1;
    
    self.leastSignificantUnit = NSSecondCalendarUnit;
    self.numberOfSignificantUnits = 1;
    
    return self;
}


- (NSString *)stringForTimeInterval:(NSTimeInterval)seconds {
    return [self stringForTimeIntervalFromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
}

- (NSString *)stringForTimeIntervalFromDate:(NSDate *)startingDate
                                     toDate:(NSDate *)endingDate
{
    NSTimeInterval seconds = [startingDate timeIntervalSinceDate:endingDate];
    if (fabs(seconds) < self.presentTimeIntervalMargin) {
        return self.presentDeicticExpression;
    }
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    if (self.usesIdiomaticDeicticExpressions) {
        NSString *idiomaticDeicticExpression = [self localizedIdiomaticDeicticExpressionForComponents:components];
        if (idiomaticDeicticExpression) {
            return idiomaticDeicticExpression;
        }
    }
    
    NSString *string = nil;
    BOOL isApproximate = NO;
    NSUInteger numberOfUnits = 0;
    for (NSString *unitName in [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"minute", @"second", nil]) {
        NSCalendarUnit unit = NSCalendarUnitFromString(unitName);
        if (!string || self.leastSignificantUnit >= unit) {
            NSNumber *number = [components valueForKey:unitName];
            number = @(ABS([number integerValue]));
            if ([number integerValue] != 0) {
                NSString *suffix = [NSString stringWithFormat:@"%@%@", number, [self localizedStringForNumber:[number integerValue] ofCalendarUnit:unit]];
                if (!string) {
                    string = suffix;
                } else if (self.numberOfSignificantUnits == 0 || numberOfUnits < self.numberOfSignificantUnits) {
                    string = [string stringByAppendingFormat:@"%@", suffix];
                } else {
                    isApproximate = YES;
                }
                
                numberOfUnits++;
            }
        }
    }
    
    if (string) {
        if (seconds > 0) {
            if ([self.pastDeicticExpression length]) {
                NSString *languageCode = [self.locale objectForKey:NSLocaleLanguageCode];
                if ([languageCode isEqualToString:@"es"]) {
                    string = [NSString stringWithFormat:self.deicticExpressionFormat, self.pastDeicticExpression, string];
                } else {
                    string = [NSString stringWithFormat:self.deicticExpressionFormat, string, self.pastDeicticExpression];
                }
            }
        } else {
            if ([self.futureDeicticExpression length]) {
                string = [NSString stringWithFormat:self.deicticExpressionFormat, string, self.futureDeicticExpression];
            }
        }
        
        if (isApproximate && self.usesApproximateQualifier) {
            string = [NSString stringWithFormat:self.approximateQualifierFormat, string];
        }
    }
    
    return string;
}

- (NSString *)localizedStringForNumber:(NSUInteger)number ofCalendarUnit:(NSCalendarUnit)unit {
    BOOL singular = (number == 1);
    
    if (self.usesAbbreviatedCalendarUnits) {
        switch (unit) {
            case NSYearCalendarUnit:
                return singular ? NSLocalizedString(@"yr", nil) : NSLocalizedString(@"yrs", nil);
            case NSMonthCalendarUnit:
                return singular ? NSLocalizedString(@"mo",nil) : NSLocalizedString(@"mos", nil);
            case NSWeekCalendarUnit:
                return singular ? NSLocalizedString(@"wk", nil) : NSLocalizedString(@"wks", nil);
            case NSDayCalendarUnit:
                return singular ? NSLocalizedString(@"d", nil) : NSLocalizedString(@"d", nil);
            case NSHourCalendarUnit:
                return singular ? NSLocalizedString(@"h", nil) : NSLocalizedString(@"h", nil);
            case NSMinuteCalendarUnit:
                return singular ? NSLocalizedString(@"m", nil) : NSLocalizedString(@"m", nil);
            case NSSecondCalendarUnit:
                return singular ? @"s" : @"s";
            default:
                return nil;
        }
    } else {
        switch (unit) {
            case NSYearCalendarUnit:
                return singular ? NSLocalizedString(@"year", nil) : NSLocalizedString(@"years", nil);
            case NSMonthCalendarUnit:
                return singular ? NSLocalizedString(@"month", nil) : NSLocalizedString(@"months", nil);
            case NSWeekCalendarUnit:
                return singular ? NSLocalizedString(@"week", nil) : NSLocalizedString(@"weeks", nil);
            case NSDayCalendarUnit:
                return singular ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil);
            case NSHourCalendarUnit:
                return singular ? NSLocalizedString(@"hour", nil) : NSLocalizedString(@"hours", nil);
            case NSMinuteCalendarUnit:
                return singular ? NSLocalizedString(@"minute", nil) : NSLocalizedString(@"minutes", nil);
            case NSSecondCalendarUnit:
                return singular ? NSLocalizedString(@"second", nil) : NSLocalizedString(@"seconds", nil);
            default:
                return nil;
        }
    }
}

#pragma mark -

- (NSString *)localizedIdiomaticDeicticExpressionForComponents:(NSDateComponents *)components {
    NSString *languageCode = [self.locale objectForKey:NSLocaleLanguageCode];
    if ([languageCode isEqualToString:@"en"]) {
        return [self enRelativeDateStringForComponents:components];
    } else if ([languageCode isEqualToString:@"es"]){
        return [self esRelativeDateStringForComponents:components];
    } else if ([languageCode isEqualToString:@"nl"]){
        return [self nlRelativeDateStringForComponents:components];
    }
    
    return nil;
}

- (NSString *)enRelativeDateStringForComponents:(NSDateComponents *)components {
    if ([components year] == -1) {
        return NSLocalizedString(@"last year", nil);
    } else if ([components month] == -1 && [components year] == 0) {
        return NSLocalizedString(@"last month", nil);
    } else if ([components week] == -1 && [components year] == 0 && [components month] == 0) {
        return NSLocalizedString(@"last week", nil);
    } else if ([components day] == -1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return NSLocalizedString(@"yesterday", nil);
    }
    
    if ([components year] == 1) {
        return NSLocalizedString(@"next year", nil);
    } else if ([components month] == 1 && [components year] == 0) {
        return NSLocalizedString(@"next month", nil);
    } else if ([components week] == 1 && [components year] == 0 && [components month] == 0) {
        return NSLocalizedString(@"next week", nil);
    } else if ([components day] == 1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return NSLocalizedString(@"tomorrow", nil);
    }
    
    return nil;
}

- (NSString *)esRelativeDateStringForComponents:(NSDateComponents *)components {
    if ([components year] == -1) {
        return @"año pasado";
    } else if ([components month] == -1 && [components year] == 0) {
        return @"mes pasado";
    } else if ([components week] == -1 && [components year] == 0 && [components month] == 0) {
        return @"semana pasada";
    } else if ([components day] == -1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"ayer";
    }
    
    if ([components year] == 1) {
        return @"próximo año";
    } else if ([components month] == 1 && [components year] == 0) {
        return @"próximo mes";
    } else if ([components week] == 1 && [components year] == 0 && [components month] == 0) {
        return @"próxima semana";
    } else if ([components day] == 1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"mañana";
    }
    
    return nil;
}

- (NSString *)nlRelativeDateStringForComponents:(NSDateComponents *)components {
    if ([components year] == -1) {
        return @"vorig jaar";
    } else if ([components month] == -1 && [components year] == 0) {
        return @"vorige maand";
    } else if ([components week] == -1 && [components year] == 0 && [components month] == 0) {
        return @"vorige week";
    } else if ([components day] == -1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"gisteren";
    } else if ([components day] == -2 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"eergisteren";
    }
    
    if ([components year] == 1) {
        return @"volgend jaar";
    } else if ([components month] == 1 && [components year] == 0) {
        return @"volgende maand";
    } else if ([components week] == 1 && [components year] == 0 && [components month] == 0) {
        return @"volgende week";
    } else if ([components day] == 1 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"morgern";
    } else if ([components day] == 2 && [components year] == 0 && [components month] == 0 && [components week] == 0) {
        return @"overmorgern";
    }
    
    return nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.locale = [aDecoder decodeObjectForKey:@"locale"];
    self.pastDeicticExpression = [aDecoder decodeObjectForKey:@"pastDeicticExpression"];
    self.presentDeicticExpression = [aDecoder decodeObjectForKey:@"presentDeicticExpression"];
    self.futureDeicticExpression = [aDecoder decodeObjectForKey:@"futureDeicticExpression"];
    self.deicticExpressionFormat = [aDecoder decodeObjectForKey:@"deicticExpressionFormat"];
    self.approximateQualifierFormat = [aDecoder decodeObjectForKey:@"approximateQualifierFormat"];
    self.presentTimeIntervalMargin = [aDecoder decodeDoubleForKey:@"presentTimeIntervalMargin"];
    self.usesAbbreviatedCalendarUnits = [aDecoder decodeBoolForKey:@"usesAbbreviatedCalendarUnits"];
    self.usesApproximateQualifier = [aDecoder decodeBoolForKey:@"usesApproximateQualifier"];
    self.usesIdiomaticDeicticExpressions = [aDecoder decodeBoolForKey:@"usesIdiomaticDeicticExpressions"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.locale forKey:@"locale"];
    [aCoder encodeObject:self.pastDeicticExpression forKey:@"pastDeicticExpression"];
    [aCoder encodeObject:self.presentDeicticExpression forKey:@"presentDeicticExpression"];
    [aCoder encodeObject:self.futureDeicticExpression forKey:@"futureDeicticExpression"];
    [aCoder encodeObject:self.deicticExpressionFormat forKey:@"deicticExpressionFormat"];
    [aCoder encodeObject:self.approximateQualifierFormat forKey:@"approximateQualifierFormat"];
    [aCoder encodeDouble:self.presentTimeIntervalMargin forKey:@"presentTimeIntervalMargin"];
    [aCoder encodeBool:self.usesAbbreviatedCalendarUnits forKey:@"usesAbbreviatedCalendarUnits"];
    [aCoder encodeBool:self.usesApproximateQualifier forKey:@"usesApproximateQualifier"];
    [aCoder encodeBool:self.usesIdiomaticDeicticExpressions forKey:@"usesIdiomaticDeicticExpressions"];
}

@end