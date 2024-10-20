import Testing
@testable import Calculate
@testable import Dictionary

@Test func testCalculationEval() async throws {
  let answer = CalculateExpression("1+2")
  print(answer ?? "") // 3
}

@Test func testDictionaryLookups() async throws {
  let dict = DictionaryProvider
    .Dictionaries
    .filter(\.isAvailable)
    .first(where: { $0.shortName == "Apple" })!
  print(dict)
  let results = dict.search(q: "mac") ?? []
  print(results.compactMap(\.headword))
  let result = results.randomElement()!
  print(result.headword ?? "", result.data(.text) ?? "")
}
