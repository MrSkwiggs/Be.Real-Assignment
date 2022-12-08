//
//  PublisherExtensionTests.swift
//  CoreTests
//
//  Created by Dorian on 07/12/2022.
//

import XCTest
import Combine
@testable import Core

final class PublisherExtensionTests: XCTestCase {
    
    var subscriptions: [AnyCancellable] = []
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions = []
    }
    
    func testCompleteWithSuccessResult() {
        let subject = PassthroughSubject<String, Core.Error>()
        let expectedValue = "Hello world"
        
        let valueExpectation = expectation(description: "Publisher should emit value")
        let completionExpectation = expectation(description: "Publisher should emit completion")
        
        subject
            .sink { completion in
                completionExpectation.fulfill()
                
                if case .failure = completion {
                    XCTFail("Unexpected failure completion")
                }
            } receiveValue: { value in
                valueExpectation.fulfill()
                XCTAssertEqual(value, expectedValue)
            }
            .store(in: &subscriptions)
        
        subject.complete(with: .success(expectedValue))
        
        waitForExpectations(timeout: 2)
    }
    
    func testCompleteWithFailureResult() {
        let subject = PassthroughSubject<String, Core.Error>()
        
        let valueExpectation = expectation(description: "Publisher should not emit a value")
        valueExpectation.isInverted = true
        let completionExpectation = expectation(description: "Publisher should emit completion")
        
        subject
            .sink { completion in
                completionExpectation.fulfill()
                
                if case .finished = completion {
                    XCTFail("Unexpected non-failure completion")
                }
            } receiveValue: { value in
                valueExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        subject.complete(with: .failure(.networkError))
        
        waitForExpectations(timeout: 2)
    }
    
    func testCompleteWithValue() {
        let subject = PassthroughSubject<String, Core.Error>()
        let expectedValue = "Hello world"
        
        let valueExpectation = expectation(description: "Publisher should emit value")
        let completionExpectation = expectation(description: "Publisher should emit completion")
        
        subject
            .sink { completion in
                completionExpectation.fulfill()
                
                if case .failure = completion {
                    XCTFail("Unexpected failure completion")
                }
            } receiveValue: { value in
                valueExpectation.fulfill()
                XCTAssertEqual(value, expectedValue)
            }
            .store(in: &subscriptions)
        
        subject.complete(expectedValue)
        
        waitForExpectations(timeout: 2)
    }
}
