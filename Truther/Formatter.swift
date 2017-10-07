//
//  Formatter.swift
//  Truther
//
//  Created by Ilya Kos on 10/7/17.
//  Copyright © 2017 Ilya Kos. All rights reserved.
//

import Foundation

private let seperator = " | "

class Formatter {
    static func format(table: [[String]]) -> String {
        var lengths: [Int] = []
        for i in 0..<table[0].count {
            var maxLength = 0
            for row in table {
                maxLength = max(maxLength, row[i].count)
            }
            lengths.append(maxLength)
        }
        var out = ""
        for i in 0..<table.count {
            let row = table[i]
            for u in 0..<row.count {
                out.append(row[u].padding(toLength: lengths[u], withPad: " ", startingAt: 0))
                out.append(seperator)
            }
            out = String(out.dropLast(seperator.count))
            out.append("\n")
            if i == 0 {
                out.append(String.init(repeating: "-", count: lengths.reduce(0, +) + seperator.count * (lengths.count - 1)))
                out.append("\n")
            }
        }
        return out
    }
}
