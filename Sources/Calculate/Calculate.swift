//
//  Calculate.swift
//  PrivateFrameworks
//
//  Created by Lakhan Lothiyi on 19/10/2024.
//

import Foundation

// this was easier than working with the tbd idk why

func CalculatePerformExpression(_ expr: UnsafeMutablePointer<CChar>!, _ significantDigits: Int32, _ flags: Int32, _ answer: UnsafeMutablePointer<CChar>!) -> Int32 {
  let handle = dlopen("/System/Library/PrivateFrameworks/Calculate.framework/Versions/A/Calculate", RTLD_NOW)
  let sym = dlsym(handle, "CalculatePerformExpression")

  typealias CalculateExprCall = @convention(c) (UnsafeMutablePointer<CChar>?, Int32, Int32, UnsafeMutablePointer<CChar>?) -> Int32
  let f = unsafeBitCast(sym, to: CalculateExprCall.self)
  let result = f(expr, significantDigits, flags, answer)
  dlclose(handle)
  print(result)
  
  return result
}

public struct CalculateFlags: OptionSet {
  public let rawValue: Int32
  public static let unknown1: Self = .init(rawValue: 1 << 0)
  public static let treatInputAsIntegers: Self = .init(rawValue: 1 << 1)
  public static let moreAccurate: Self = .init(rawValue: 1 << 2)
  
  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }
}

func CalculateExpression(_ expression: String, significantDigits: Int32 = 8, flags: CalculateFlags = []) -> String? {
  let exprLength = expression.utf8CString.count
  let expr = UnsafeMutablePointer<CChar>.allocate(capacity: exprLength)
  defer { expr.deallocate() }
  
  expression.utf8CString.withUnsafeBufferPointer { buffer in
    expr.initialize(from: buffer.baseAddress!, count: exprLength)
  }
  
  let answerLength = 2048
  let answer = UnsafeMutablePointer<CChar>.allocate(capacity: answerLength)
  defer { answer.deallocate() }
  
  _ = CalculatePerformExpression(expr, significantDigits, flags.rawValue, answer)

  let result = String(cString: answer)
  
  return result
}
