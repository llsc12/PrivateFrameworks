//
//  Dictionary.swift
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 19/10/2024.
//

import DictionaryPrivate
import CoreServices.DictionaryServices
import Foundation
import ObjCShims

public struct DictionaryProvider {
  public static let Dictionaries: [Self.Dictionary] = {
    Utils.AvailableDictionaries().map { .init(dictionary: $0) }
  }()
  
  public struct Dictionary {
    var dict: TTTDictionary
    
    init(dictionary: TTTDictionary) {
      self.dict = dictionary
    }
    
    public struct Record {
      var record: TTTDictionaryEntry
      
      init(record: TTTDictionaryEntry) {
        self.record = record
      }
    }
  }
  
  enum Utils {
//    CFDictionaryRef DCSCopyDefinitionMarkup(DCSDictionaryRef dictionary, CFStringRef record);
//    CFStringRef DCSRecordCopyData(CFTypeRef record);
//    CFStringRef DCSRecordCopyDataURL(CFTypeRef record);
//    CFStringRef DCSRecordGetAnchor(CFTypeRef record);
//    CFStringRef DCSRecordGetAssociatedObj(CFTypeRef record);
//    CFStringRef DCSRecordGetHeadword(CFTypeRef record);
//    CFStringRef DCSRecordGetRawHeadword(CFTypeRef record);
//    CFStringRef DCSRecordGetString(CFTypeRef record);
//    CFStringRef DCSRecordGetTitle(CFTypeRef record);
//    DCSDictionaryRef DCSRecordGetSubDictionary(CFTypeRef record);
    
    /// https://stackoverflow.com/questions/29048826/when-to-use-takeunretainedvalue-or-takeretainedvalue-to-retrieve-unmanaged-o
    /// so as far as i can tell, we use retainedvalue on functions that copy/create and unretainedvalue on get or anything else
    /// idk if im right.
    static func AvailableDictionaries() -> [TTTDictionary] {
      let dictionaries = TTTDictionary.availableDictionaries() ?? []
      let array = dictionaries.map { $0.base as! TTTDictionary }
      return array
    }
    
    static func DictionaryGetName(_ dictionary: TTTDictionary) -> String {
      dictionary.name
    }
    
    static func DictionaryGetShortName(_ dictionary: TTTDictionary) -> String? {
      dictionary.shortName
    }
    
    static func RecordsForSearchString(_ dictionary: TTTDictionary, query: String) -> [TTTDictionaryEntry]? {
      let records = dictionary.entries(forSearchTerm: query)
      let array = records?.compactMap { $0 as? TTTDictionaryEntry }
      return array
    }
    
    static func RecordCopyData(_ data: TTTDictionaryEntry, type: RecordVersion = .text) -> String? {
      switch type {
      case .html:
        data.html
      case .htmlWithAppCSS:
        data.appHTML
      case .htmlWithPopoverCSS:
        data.popoverHTML
      case .text:
        data.text
      }
    }
    
    static func RecordGetHeadword(_ data: CFTypeRef) -> String? {
      data.headword
    }
  }
  
  public enum RecordVersion: Int {
    case html = 0
    case htmlWithAppCSS = 1
    case htmlWithPopoverCSS = 2
    case text = 3
  }
}
