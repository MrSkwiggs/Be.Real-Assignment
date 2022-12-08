//
//  LoginProviderTests.swift
//  CoreTests
//
//  Created by Dorian on 08/12/2022.
//

import XCTest
import Combine
@testable import Core
@testable import Networking

final class LoginProviderTests: XCTestCase {
    
    var dataSource: Networking.Mock.LoginDataSource!
    var loginProvider: LoginProvider!
    
    var subscriptions: [AnyCancellable] = []
    
    override func setUp() {
        dataSource = .init(result: .success(Networking.Mock.user))
        loginProvider = .init(dataSource: dataSource)
    }
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions = []
    }
    
    func testLoginSuccessful() {
        let valueExpectation = expectation(description: "LoginProvider should emit login result value")
        let completionExpectation = expectation(description: "LoginProvider should emit completion")
        
        Task { [self] in
            loginProvider
                .login(username: "whatever", password: "wh4t3v3r")
                .sink { completion in
                    completionExpectation.fulfill()
                    if case .failure = completion {
                        XCTFail("Unexpected login failure")
                    }
                } receiveValue: { value in
                    XCTAssertEqual(value, true)
                    valueExpectation.fulfill()
                }

//                .sink { completion in
//                    completionExpectation.fulfill()
//                    if case .failure = completion {
//                        XCTFail("Unexpected login failure")
//                    }
//                } receiveValue: { didSucceed in
//                    valueExpectation.fulfill()
//                    XCTAssertEqual(didSucceed, true, "Login should have succeeded")
//                }
//                .store(in: &subscriptions)
        }
        waitForExpectations(timeout: 2)
    }
    
    func testLoginFailure() {
        let valueExpectation = expectation(description: "LoginProvider should not emit login result value")
        valueExpectation.isInverted = true
        let completionExpectation = expectation(description: "LoginProvider should emit failure")
        
        dataSource = .init(result: .failure(.init(.unknown(httpStatusCode: 401))))
        loginProvider = .init(dataSource: dataSource)
        
        loginProvider
            .login(username: "whatever", password: "wh4t3v3r")
            .sink { completion in
                completionExpectation.fulfill()
                switch completion {
                case let .failure(error):
                    XCTAssertEqual(error, .authFailed)
                    
                case .finished:
                    XCTFail("Login should have completed with a failure")
                }
            } receiveValue: { didSucceed in
                valueExpectation.fulfill()
                XCTAssertEqual(didSucceed, false, "Login should not have succeeded")
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2)
    }
    
    func testLoginInvalidCredentials() {
        let valueExpectation = expectation(description: "LoginProvider should not emit login result value")
        valueExpectation.isInverted = true
        let completionExpectation = expectation(description: "LoginProvider should emit failure")
        
        loginProvider
            .login(username: "whate:ver", password: "wh4t3v:3r")
            .sink { completion in
                completionExpectation.fulfill()
                switch completion {
                case let .failure(error):
                    XCTAssertEqual(error, .invalidCharacter)
                    
                case .finished:
                    XCTFail("Login should have completed with a failure")
                }
            } receiveValue: { didSucceed in
                valueExpectation.fulfill()
                XCTAssertEqual(didSucceed, false, "Login should not have succeeded")
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2)
    }
}
