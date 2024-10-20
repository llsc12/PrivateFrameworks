//
//  TTTDictionary.m
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 20/10/2024.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "include/TTTDictionary.h"
@import DictionaryPrivate;
@import CoreServices.DictionaryServices;

#import <CoreServices/CoreServices.h>
/// https://github.com/NSHipster/DictionaryKit/blob/main/DictionaryKit/TTTDictionary.m
NSString * const DCSAppleDictionaryName = @"Apple Dictionary";
NSString * const DCSDutchDictionaryName = @"Prisma woordenboek Nederlands";
NSString * const DCSFrenchDictionaryName = @"Multidictionnaire de la langue française";
NSString * const DCSGermanDictionaryName = @"Duden-Wissensnetz deutsche Sprache";
NSString * const DCSItalianDictionaryName = @"Dizionario italiano da un affiliato di Oxford University Press";
NSString * const DCSJapaneseSupaDaijirinDictionaryName = @"スーパー大辞林";
NSString * const DCSJapanese_EnglishDictionaryName = @"ウィズダム英和辞典 / ウィズダム和英辞典";
NSString * const DCSKoreanDictionaryName = @"New Ace Korean Language Dictionary";
NSString * const DCSKorean_EnglishDictionaryName = @"New Ace English-Korean Dictionary and New Ace Korean-English Dictionary";
NSString * const DCSNewOxfordAmericanDictionaryName = @"New Oxford American Dictionary";
NSString * const DCSOxfordAmericanWritersThesaurus = @"Oxford American Writer's Thesaurus";
NSString * const DCSOxfordDictionaryOfEnglish = @"Oxford Dictionary of English";
NSString * const DCSOxfordThesaurusOfEnglish = @"Oxford Thesaurus of English";
NSString * const DCSSimplifiedChineseDictionaryName = @"现代汉语规范词典";
NSString * const DCSSimplifiedChinese_EnglishDictionaryName = @"Oxford Chinese Dictionary";
NSString * const DCSSpanishDictionaryName = @"Diccionario General de la Lengua Española Vox";
NSString * const DCSWikipediaDictionaryName = @"Wikipedia";

typedef NS_ENUM(NSInteger, TTTDictionaryRecordVersion) {
  TTTDictionaryVersionHTML = 0,
  TTTDictionaryVersionHTMLWithAppCSS = 1,
  TTTDictionaryVersionHTMLWithPopoverCSS = 2,
  TTTDictionaryVersionText = 3,
};

#pragma mark -

extern CFArrayRef DCSCopyAvailableDictionaries();
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFStringRef DCSDictionaryGetShortName(DCSDictionaryRef dictionary);
extern DCSDictionaryRef DCSDictionaryCreate(CFURLRef url);
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFArrayRef DCSCopyRecordsForSearchString(DCSDictionaryRef dictionary, CFStringRef string, void *, void *);

extern CFDictionaryRef DCSCopyDefinitionMarkup(DCSDictionaryRef dictionary, CFStringRef record);
extern CFStringRef DCSRecordCopyData(CFTypeRef record, long version);
extern CFStringRef DCSRecordCopyDataURL(CFTypeRef record);
extern CFStringRef DCSRecordGetAnchor(CFTypeRef record);
extern CFStringRef DCSRecordGetAssociatedObj(CFTypeRef record);
extern CFStringRef DCSRecordGetHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetRawHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetString(CFTypeRef record);
extern DCSDictionaryRef DCSRecordGetSubDictionary(CFTypeRef record);
extern CFStringRef DCSRecordGetTitle(CFTypeRef record);

#pragma mark -

@interface TTTDictionaryEntry ()
@property (readwrite, nonatomic, copy) NSString *headword;
@property (readwrite, nonatomic, copy) NSString *text;
@property (readwrite, nonatomic, copy) NSString *HTML;
@property (readwrite, nonatomic, copy) NSString *popoverHTML;
@property (readwrite, nonatomic, copy) NSString *appHTML;
@end

@implementation TTTDictionaryEntry

- (instancetype)initWithRecordRef:(CFTypeRef)record
                    dictionaryRef:(DCSDictionaryRef)dictionary
{
  self = [self init];
  if (!self && record) {
    return nil;
  }
  
  self.headword = (__bridge NSString *)DCSRecordGetHeadword(record);
  if (self.headword) {
    self.text = (__bridge_transfer NSString*)DCSRecordCopyData(record, TTTDictionaryVersionText);
  }
  
  self.HTML = (__bridge_transfer NSString *)DCSRecordCopyData(record, (long)TTTDictionaryVersionHTML);
  self.popoverHTML = (__bridge_transfer NSString *)DCSRecordCopyData(record, (long)TTTDictionaryVersionHTMLWithPopoverCSS);
  self.appHTML = (__bridge_transfer NSString *)DCSRecordCopyData(record, (long)TTTDictionaryVersionHTMLWithAppCSS);
  
  return self;
}

@end

@interface TTTDictionary ()
@property (readwrite, nonatomic, assign) DCSDictionaryRef dictionary;
@property (readwrite, nonatomic, copy) NSString *name;
@property (readwrite, nonatomic, copy) NSString *shortName;
@end

@implementation TTTDictionary

+ (NSSet *)availableDictionaries {
  static NSSet *_availableDictionaries = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableSet *mutableDictionaries = [NSMutableSet set];
    for (id dictionary in (__bridge_transfer NSArray *)DCSCopyAvailableDictionaries()) {
      [mutableDictionaries addObject:[[TTTDictionary alloc] initWithDictionaryRef:(__bridge DCSDictionaryRef)dictionary]];
    }
    
    _availableDictionaries = [NSSet setWithSet:mutableDictionaries];
  });
  
  return _availableDictionaries;
}

+ (instancetype)dictionaryNamed:(NSString *)name {
  static NSDictionary *_availableDictionariesKeyedByName = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableDictionary *mutableAvailableDictionariesKeyedByName = [NSMutableDictionary dictionaryWithCapacity:[[self availableDictionaries] count]];
    for (TTTDictionary *dictionary in [self availableDictionaries]) {
      mutableAvailableDictionariesKeyedByName[dictionary.name] = dictionary;
    }
    
    _availableDictionariesKeyedByName = [NSDictionary dictionaryWithDictionary:mutableAvailableDictionariesKeyedByName];
  });
  
  return _availableDictionariesKeyedByName[name];
}

- (instancetype)initWithDictionaryRef:(DCSDictionaryRef)dictionary {
  self = [self init];
  if (!self || !dictionary) {
    return nil;
  }
  
  self.dictionary = dictionary;
  self.name = (__bridge NSString *)DCSDictionaryGetName(self.dictionary);
  self.shortName = (__bridge NSString *)DCSDictionaryGetShortName(self.dictionary);
  
  return self;
}

- (NSArray *)entriesForSearchTerm:(NSString *)term {
  CFRange termRange = DCSGetTermRangeInString(self.dictionary, (__bridge CFStringRef)term, 0);
  if (termRange.location == kCFNotFound) {
    return nil;
  }
  
  term = [term substringWithRange:NSMakeRange(termRange.location, termRange.length)];
  
  NSArray *records = (__bridge_transfer NSArray *)DCSCopyRecordsForSearchString(self.dictionary, (__bridge CFStringRef)term, NULL, NULL);
  NSMutableArray *mutableEntries = [NSMutableArray arrayWithCapacity:[records count]];
  if (records) {
    for (id record in records) {
      TTTDictionaryEntry *entry = [[TTTDictionaryEntry alloc] initWithRecordRef:(__bridge CFTypeRef)record dictionaryRef:self.dictionary];
      if (entry) {
        [mutableEntries addObject:entry];
      }
    }
  }
  
  return [NSArray arrayWithArray:mutableEntries];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[TTTDictionary class]]) {
    return NO;
  }
  
  return [self.name isEqualToString:[(TTTDictionary *)object name]];
}

- (NSUInteger)hash {
  return [self.name hash];
}

@end
