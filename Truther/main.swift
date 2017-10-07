//
//  main.swift
//  Truther
//
//  Created by Ilya Kos on 10/6/17.
//  Copyright © 2017 Ilya Kos. All rights reserved.
//

import Foundation

if CommandLine.arguments.count > 1 {
    let form = Formula.init(CommandLine.arguments[1])
    let table = Truther.init(formula: form).run().map { $0.0 + [$0.1] }
        .map {$0.map {$0 ? "1" : "0"}}
    
    print(Formatter.format(table: [form.variables + ["F"]] + table))
} else {
    print("You did't supply a formula")
}
