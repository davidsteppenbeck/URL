import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(URLMacros)
import URLMacros

let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self,
]
#endif

final class URLTests: XCTestCase {
    
    func testURL() throws {
        #if canImport(URLMacros)
        assertMacroExpansion(
            """
            #URL("https://www.apple.com/iphone")
            """,
            expandedSource:
            """
            URL(string: "https://www.apple.com/iphone")!
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testURLWithNoArguments() throws {
        #if canImport(URLMacros)
        assertMacroExpansion(
            """
            #URL()
            """,
            expandedSource:
            """
            #URL()
            """,
            diagnostics: [
                DiagnosticSpec(message: "The macro does not have any arguments", line: 1, column: 1),
                DiagnosticSpec(message: "The macro does not have any arguments", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testURLWithNonStringLiteral() throws {
        #if canImport(URLMacros)
        assertMacroExpansion(
            #"""
            let str = "/iphone"
            #URL("https://www.apple.com\(str)")
            """#,
            expandedSource:
            #"""
            let str = "/iphone"
            #URL("https://www.apple.com\(str)")
            """#,
            diagnostics: [
                DiagnosticSpec(message: "Argument must be a string literal", line: 2, column: 1),
                DiagnosticSpec(message: "Argument must be a string literal", line: 2, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testURLWithInvalidStringLiteral() throws {
        #if canImport(URLMacros)
        assertMacroExpansion(
            """
            #URL(" https:// www.apple.com/ iphone")
            """,
            expandedSource:
            """
            #URL(" https:// www.apple.com/ iphone")
            """,
            diagnostics: [
                DiagnosticSpec(message: "The string does not represent a valid URL", line: 1, column: 1),
                DiagnosticSpec(message: "The string does not represent a valid URL", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
}
