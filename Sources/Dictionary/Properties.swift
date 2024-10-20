//
//  Properties.swift
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 20/10/2024.
//

import CoreFoundation
import Foundation
import DictionaryPrivate

public extension DictionaryProvider.Dictionary {
  internal typealias Utils = DictionaryProvider.Utils
  
  var isAvailable: Bool {
    Utils.DictionaryGetShortName(dict) != nil
  }
  
  func search(q: String) -> [Record]? {
    (Utils.RecordsForSearchString(dict, query: q) ?? []).map { Record(record: $0) }
  }
  
  var shortName: String? {
    Utils.DictionaryGetShortName(dict)
  }
  
  var name: String {
    Utils.DictionaryGetName(dict)
  }
}

public extension DictionaryProvider.Dictionary.Record {
  internal typealias Utils = DictionaryProvider.Utils

  var headword: String? {
    Utils.RecordGetHeadword(record)
  }
  
  func data(_ type: DictionaryProvider.RecordVersion = .text) -> String? {
    Utils.RecordCopyData(record, type: type)
  }
}
