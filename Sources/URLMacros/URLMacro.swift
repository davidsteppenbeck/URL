import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct URLMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first else {
            throw URLError.noArguments
        }
        
        guard let stringLiteralExpr = argument.expression.as(StringLiteralExprSyntax.self) else {
            throw URLError.mustBeValidStringLiteral
        }
        
        guard stringLiteralExpr.segments.count == 1, let segment = stringLiteralExpr.segments.first?.as(StringSegmentSyntax.self) else {
            throw URLError.stringLiteralMustHaveOnlyOneSegment
        }
        
        let text = segment.content.text
        
        if URL(string: text) != nil {
            return #"URL(string: "\#(raw: text)")!"#
        } else {
            throw URLError.invalid
        }
    }
    
}

enum URLError: Error, CustomStringConvertible {
    case noArguments
    case mustBeValidStringLiteral
    case stringLiteralMustHaveOnlyOneSegment
    case invalid
    
    var description: String {
        switch self {
        case .noArguments:
            return "The macro does not have any arguments"
        case .mustBeValidStringLiteral:
            return "Argument must be a string literal"
        case .stringLiteralMustHaveOnlyOneSegment:
            return "String literal must have only one segment"
        case .invalid:
            return "The string does not represent a valid URL"
        }
    }
}

@main
struct URLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
    ]
}
