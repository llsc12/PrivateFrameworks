//
//  TTTDictionary.h
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 20/10/2024.
//

#import <Foundation/Foundation.h>

/// https://github.com/NSHipster/DictionaryKit/blob/main/DictionaryKit/TTTDictionary.m
/**
 
 */
@interface TTTDictionaryEntry : NSObject
@property (readonly, nonatomic, copy) NSString *headword;
@property (readonly, nonatomic, copy) NSString *text;
@property (readonly, nonatomic, copy) NSString *HTML;
@property (readonly, nonatomic, copy) NSString *popoverHTML;
@property (readonly, nonatomic, copy) NSString *appHTML;
@end

#pragma mark -

/**
 
 */
@interface TTTDictionary : NSObject

/**
 
 */
@property (readonly, nonatomic, copy) NSString *name;

/**
 
 */
@property (readonly, nonatomic, copy) NSString *shortName;

/**
 
 */
+ (NSSet *)availableDictionaries;

/**
 
 */
+ (instancetype)dictionaryNamed:(NSString *)name;

/**
 
 */
- (NSArray *)entriesForSearchTerm:(NSString *)term;

@end


NSString * const DCSAppleDictionaryName;
NSString * const DCSDutchDictionaryName;
NSString * const DCSFrenchDictionaryName;
NSString * const DCSGermanDictionaryName;
NSString * const DCSItalianDictionaryName;
NSString * const DCSJapaneseDictionaryName;
NSString * const DCSJapaneseSupaDaijirinDictionaryName;
NSString * const DCSJapanese_EnglishDictionaryName;
NSString * const DCSKoreanDictionaryName;
NSString * const DCSKorean_EnglishDictionaryName;
NSString * const DCSNewOxfordAmericanDictionaryName;
NSString * const DCSOxfordAmericanWritersThesaurus;
NSString * const DCSOxfordDictionaryOfEnglish;
NSString * const DCSOxfordThesaurusOfEnglish;
NSString * const DCSSimplifiedChineseDictionaryName;
NSString * const DCSSimplifiedChinese_EnglishDictionaryName;
NSString * const DCSSpanishDictionaryName;
NSString * const DCSWikipediaDictionaryName;
