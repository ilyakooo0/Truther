//
//  Operator.swift
//  Truther
//
//  Created by Ilya Kos on 10/6/17.
//  Copyright © 2017 Ilya Kos. All rights reserved.
//

import Foundation

enum Operator {
    case f0
    case f1
    case f2
    case f3
    case f4
    case f5
    case f6
    case f7
    case f8
    case f9
    case f10
    case f11
    case f12
    case f13
    case f14
    case f15
    var value: ((Bool, Bool) -> (Bool)) {
        switch self {
        case .f0:
            return {_, _ in false}
        case .f1:
            return {$0 && $1}
        case .f2:
            return { $0 && !$1 }
        case .f3:
            return {a, _ in a}
        case .f4:
            return {!$0 && $1}
        case .f5:
            return {_, b in b }
        case .f6:
            return {!($0 == $1)}
        case .f7:
            return {$0 || $1}
        case .f8:
            return {!($0 || $1)}
        case .f9:
            return {$0 == $1}
        case .f10:
            return {_, b in !b}
        case .f11:
            return {!(!$0 && $1)}
        case .f12:
            return {a, _ in !a}
        case .f13:
            return {!($0 && !$1)}
        case .f14:
            return {!($0 && $1)}
        case .f15:
            return {_, _ in true}
        }
    }
    static func process(_ op: Substring) -> Operator? {
        switch op.trimmingCharacters(in: .whitespaces).lowercased() {
        case "+", "or", "||":
            return .f7
        case "(+)", "⊕", "xor", "!=", "=!=", "=/=", "/=":
            return .f6
        case "*", "and", "&", "&&", "⚫︎":
            return .f1
        case "1":
            return .f15
        case "0":
            return .f0
        case "=/>", "=/=>", "-/>", "-/->", "!=>", "!->", "=!>", "-!>", "=!=>", "-!->":
            return .f2
        case "</=", "<=/=", "</-", "<-/-", "!<=", "!<-", "<!=", "<!-", "<=!=", "<-!-":
            return .f4
        case "o", "O", "о", "О", "◯", "⚬", "𐩒", "⚪︎", "nor", "web":
            return .f8
        case "=", "<=>", "==":
            return .f9
        case "<=", "<-", "<==", "<--":
            return .f11
        case "=>", "->", "==>", "-->":
            return .f13
        case "|", "nand", "shif":
            return .f14
        default:
            return nil
        }
    }
}
