//
//  Truther.swift
//  Truther
//
//  Created by Ilya Kos on 10/6/17.
//  Copyright © 2017 Ilya Kos. All rights reserved.
//

import Foundation

struct Truther {
    var formula: Formula
    func run() -> [(inp: [Bool], result: Bool)] {
        var out: [(inp: [Bool], result: Bool)] = []
        for i in 0..<Int(pow(2, Double(formula.variables.count))) {
            var t = 0
            var inp: [Bool] = []
            for _ in formula.variables {
                inp.append((UInt(i)>>t) & 1 == 1)
                t += 1
            }
            inp = inp.reversed()
            out.append((inp, formula.run(with: inp)))
        }
        return out
    }
}

struct Formula {
    fileprivate func run(with inputs: [Bool]) -> Bool {
        var ins: [Variable: Bool] = [:]
        for (v, va) in zip(variables, inputs) {
            ins[v] = va
        }
        return value.evaluate(with: ins)
    }
    init(_ f: String) {
        var vars: Set<String> = Set()
        func process(_ s: Substring, startingLeft: FormulaElement? = nil) -> FormulaElement {
            if s.isEmpty {
                guard let startingLeft = startingLeft else {
                    print("Internal error: Empty input")
                    exit(1)
                }
                return startingLeft
            }
            var ns = s.trimmingCharacters(in: .whitespaces)
            if ns == "0" {
                return .constant(false)
            }
            if ns == "1" {
                return .constant(true)
            }
            if ns.trimmingCharacters(in: .whitespaces).reduce(true, {$0 && CharacterSet.letters.contains($1.unicodeScalars.first!)}) {
                vars.insert(String(s))
                return .variable(String(s))
            }
            func extractVar() -> Substring {
                if ns.first == "(" {
                    let parts = extractBrackets(from: ns)
                    ns = parts.after.trimmingCharacters(in: .whitespaces)
                    return Substring(parts.wasInside.trimmingCharacters(in: .whitespaces))
                } else {
                    if CharacterSet.whitespaces.contains((ns.first?.unicodeScalars.first)!) {
                        print("Internal error: weird variable name first charecter \(ns.first!)")
                        exit(1)
                    }
                    switch ns.first! {
                    case "0":
                        ns = ns.dropFirst().trimmingCharacters(in: .whitespaces)
                        return "0"
                    case "1":
                        ns = ns.dropFirst().trimmingCharacters(in: .whitespaces)
                        return "1"
                    default:
                        break
                    }
                    var i = ns.startIndex
                    while i < ns.endIndex {
                        if !CharacterSet.letters.contains(ns[i].unicodeScalars.first!) {
                            break
                        }
                        i = ns.index(after: i)
                    }
                    let out = ns[..<i]
                    ns = ns[i...].trimmingCharacters(in: .whitespaces)
                    return out
                }
            }
            let left = startingLeft ?? process(extractVar())
            ns = ns.trimmingCharacters(in: .whitespaces)
            let isLetterOrNot = CharacterSet.letters.contains((ns.first?.unicodeScalars.first)!)
            var i = ns.startIndex
            while i < ns.endIndex {
                if CharacterSet.letters.contains(ns[i].unicodeScalars.first!) != isLetterOrNot || ns[i] == " " {
                    break
                }
                i = ns.index(after: i)
            }
            guard let op = Operator.process(ns[..<i]) else {
                print("No such operator \(ns[..<i])")
                exit(1)
            }
            ns = ns[i...].trimmingCharacters(in: .whitespaces)
            let right = process(extractVar())
            return process(Substring(ns), startingLeft: .operation(left, op, right))
        }
        self.value = process(Substring(f))
        self.variables = vars.sorted()
    }
    let variables: [String]
    private let value: FormulaElement
}

private func extractBrackets(from s: String) -> (wasInside: Substring, after: Substring) {
    var i = s.startIndex
    var brackets = 0
    while i < s.endIndex {
        switch s[i] {
        case "(":
            brackets += 1
        case ")":
            brackets -= 1
        default:
            break
        }
        if brackets == 0 {
            break
        }
        i = s.index(after: i)
    }
    if brackets != 0 {
        print("Mismatched brackets")
        exit(1)
    }
    return (s[s.index(after: s.startIndex)..<i], s[s.index(after: i)...])
}

private typealias Variable = String
private indirect enum FormulaElement {
    case variable(Variable)
    case constant(Bool)
    case operation(FormulaElement, Operator, FormulaElement)
    func evaluate(with variables: [Variable: Bool]) -> Bool {
        switch self {
        case .variable(let v):
            if let va = variables[v] {
                return va
            } else {
                print("Internal error: didn't initialize all variables")
                exit(1)
            }
        case .operation(let l, let op, let r):
            return op.value(l.evaluate(with: variables), r.evaluate(with: variables))
        case .constant(let b):
            return b
        }
    }
}
