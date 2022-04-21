//
//  DecimalUtil.swift
//  Bankey
//
//  Created by Raeein Bagheri on 2022-04-16.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
