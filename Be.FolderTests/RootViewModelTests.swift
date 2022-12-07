//
//  RootViewModelTests.swift
//  Be.FolderTests
//
//  Created by Dorian on 07/12/2022.
//

import XCTest
import Combine
@testable import Be_Folder
@testable import Core

final class RootViewModelTests: XCTestCase {

    typealias VM = RootView.ViewModel
    
    var subscriptions: [AnyCancellable] = []
    var viewModel: VM!
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions = []
        viewModel = nil
    }
    
    func testEmitsSessionAfterLogin() {
        let loginProvider: LoginContract = Mock.LoginProvider(loginResult: .success(Mock.session))
        viewModel = VM(loginProvider: loginProvider)
        
        let completionExpectation = expectation(description: "Session publisher should not emit completion")
        completionExpectation.isInverted = true
        let sessionExpectation = expectation(description: "Session publisher should emit Session value")
        
        viewModel.$session
            .dropFirst() // ignore initial value
            .sink { completion in
                completionExpectation.fulfill()
                switch completion {
                case let .failure(error):
                    XCTFail("Failed emitting session. Error: \(error.localizedDescription)")
                    
                case .finished:
                    break
                }
            } receiveValue: { session in
                guard let session else {
                    return XCTFail("Session should not be nil")
                }
                sessionExpectation.fulfill()
                XCTAssertEqual(session.token, Mock.session.token)
                XCTAssertEqual(session.user, Mock.session.user)
            }
            .store(in: &subscriptions)
        
        _ = loginProvider.login(username: "", password: "") // credentials are irrelevant
        wait(for: [completionExpectation, sessionExpectation], timeout: 2)
    }
}
