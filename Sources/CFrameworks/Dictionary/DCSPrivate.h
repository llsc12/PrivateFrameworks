//
//  DCSPrivate.h
//  Dictionary
//
//  Created by Nicholas Jitkoff on 3/19/08.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

CFArrayRef DCSCopyAvailableDictionaries();
CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
CFStringRef DCSDictionaryGetShortName(DCSDictionaryRef dictionary);
DCSDictionaryRef DCSDictionaryCreate(CFURLRef url);
CFArrayRef DCSCopyRecordsForSearchString(DCSDictionaryRef dictionary, CFStringRef string, void *, void *);
CFDictionaryRef DCSCopyDefinitionMarkup(DCSDictionaryRef dictionary, CFStringRef record);
CFStringRef DCSRecordCopyData(CFTypeRef record, long version);
CFStringRef DCSRecordCopyDataURL(CFTypeRef record);
CFStringRef DCSRecordGetAnchor(CFTypeRef record);
CFStringRef DCSRecordGetAssociatedObj(CFTypeRef record);
CFStringRef DCSRecordGetHeadword(CFTypeRef record);
CFStringRef DCSRecordGetRawHeadword(CFTypeRef record);
CFStringRef DCSRecordGetString(CFTypeRef record);
CFStringRef DCSRecordGetTitle(CFTypeRef record);
DCSDictionaryRef DCSRecordGetSubDictionary(CFTypeRef record);
