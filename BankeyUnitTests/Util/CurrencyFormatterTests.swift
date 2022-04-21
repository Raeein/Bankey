//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Raeein Bagheri on 2022-04-17.
//

import Foundation

import XCTest

@testable import Bankey

class CurrenyFormatterTests: XCTestCase {
    
    var formatter: CurrencyFormatter!
    
    override func setUp()  {
        super.setUp()
        formatter = CurrencyFormatter()
        
    }
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
    func testDollarsFormatted() throws {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!

        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "\(currencySymbol)929,466.23")
    }
    func testZeroDollarsFormatted() throws {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        let result = formatter.dollarsFormatted(0)
        XCTAssertEqual(result, "\(currencySymbol)0.00")
    }
}
