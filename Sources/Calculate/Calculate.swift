//
//  Calculate.swift
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 19/10/2024.
//

import CalculatePrivate

// These are really just guesses, just pass 1
//enum {
//  CalculateUnknown1 = 1 << 0,
//  CalculateTreatInputAsIntegers = 1 << 1,
//  CalculateMoreAccurate = 1 << 2
//} CalculateFlags;
//
//// Returns 1 on success
//int CalculatePerformExpression(char *expr, int significantDigits, int flags, char *answer);


public struct CalculateFlags: OptionSet {
  public let rawValue: Int32
  public static let unknown1: Self = .init(rawValue: 1 << 0)
  public static let treatInputAsIntegers: Self = .init(rawValue: 1 << 1)
  public static let moreAccurate: Self = .init(rawValue: 1 << 2)
  
  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }
}

public func CalculateExpression(_ expression: String, significantDigits: Int32 = 8, flags: CalculateFlags = []) -> String? {
  
  let exprLength = expression.utf8CString.count
  let expr = UnsafeMutablePointer<CChar>.allocate(capacity: exprLength)
  defer {
    expr.deallocate() // Ensure memory is freed after use
  }

  expression.utf8CString.withUnsafeBufferPointer { buffer in
    expr.initialize(from: buffer.baseAddress!, count: exprLength)
  }
  
  let answerLength = 2048 // Assume a large enough buffer for the result
  let answer = UnsafeMutablePointer<CChar>.allocate(capacity: answerLength)
  defer { answer.deallocate() }
  
  _ = CalculatePerformExpression(expr, significantDigits, flags.rawValue, answer)
  
  let result = String(cString: answer)
  
  return result
}
