//
//  LoginCredentialsTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-22.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import XCTest

@testable import TwitterClient

final class LoginCredentialsTests: XCTestCase {
    
    func testInvalidEmail() {
        let emails = [
            "",
            "test",
            "test@",
            "test@test",
            "test@test.",
            "test.com",
            "@test.com",
            "         "
        ]
        
        try! emails
            .map { LoginCredentials(email: $0, password: "anypassword") }
            .forEach { XCTAssertThrowsError(try $0.validate(), LoginError.invalidEmail) }
    }
    
    func testInvalidPassword() {
        let passwords = [
            "",
            "1",
            "12",
            "123",
            "1234",
            "12345"
        ]
        
        try! passwords
            .map { LoginCredentials(email: "test@test.com", password: $0) }
            .forEach { XCTAssertThrowsError(try $0.validate(), LoginError.invalidPassword) }
    }
    
    func testValid() {
        XCTAssertNoThrow(try LoginCredentials(email: "test@test.com", password: "123456").validate())
    }
    
    private func XCTAssertThrowsError<E: Error & Equatable>(_ expression: @autoclosure () throws -> Void, _ errorToThrow: E) {
        do {
            try expression()
            XCTAssertTrue(true)
        } catch {
            guard let errorThrown = error as? E else {
                XCTFail()
                return
            }
            XCTAssertEqual(errorThrown, errorToThrow)
        }
    }
}
