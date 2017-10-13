//
//  SessionDelegateTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 20/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class SessionDelegateTests: XCTestCase {
    fileprivate var mockedParser: MockParser!
    fileprivate var mockedJsonSerialization: MockJsonSerialization!
    private var spyCompletionResult: Result<Tweet, ErrorMessage>?
    private var mainThreadExpectation: XCTestExpectation!
    private let dummyTweet = Tweet(name: "true", screenName: "equals", tweetMessage: "false")
    
    var delegate: SessionDelegate!
    
    override func setUp() {
        super.setUp()
        mainThreadExpectation = expectation(description: "main thread expectation")
        mockedJsonSerialization = MockJsonSerialization()
        mockedParser = MockParser()
        delegate = SessionDelegate(jsonSerialization: mockedJsonSerialization, parser: mockedParser, completion: { [weak self] result in
            self?.spyCompletionResult = result
            self?.mainThreadExpectation.fulfill()
        })
    }
    
    override func tearDown() {
        mockedJsonSerialization = nil
        mockedParser = nil
        delegate = nil
        
        super.tearDown()
    }
    
    // MARK: - did receive data
    func test_DidReceiveData_WhenValidJsonAndValidTweet_ShouldReturnTweet() {
        mockedParser.stubbedTweet = dummyTweet
        mockedJsonSerialization.stubbedJsonResponse = ["json": "correct"]
        
        delegate.urlSession(URLSession(), dataTask: URLSessionDataTask(), didReceive: Data())
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "should not receive error")
            switch self.spyCompletionResult! {
            case .success(let captureTweet):
                XCTAssertEqual(captureTweet, self.dummyTweet)
            default:
                XCTFail("completion result is not success")
            }
        }
    }
    
    func test_DidReceiveData_WhenValidJsonAndInvalidTweet_ShouldNotReturnTweet() {
        mockedParser.stubbedTweet = nil
        mockedJsonSerialization.stubbedJsonResponse = ["json": "correct"]
        
        delegate.urlSession(URLSession(), dataTask: URLSessionDataTask(), didReceive: Data())
        mainThreadExpectation.fulfill()
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(self.spyCompletionResult)
        }
    }
    
    func test_DidReceiveData_WhenInvalidJson_ShouldNotReturnTweet() {
        mockedParser.stubbedTweet = dummyTweet
        mockedJsonSerialization.stubbedJsonResponse = nil
        
        delegate.urlSession(URLSession(), dataTask: URLSessionDataTask(), didReceive: Data())
        
        mainThreadExpectation.fulfill()
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "should not receive error")
            XCTAssertNil(self.spyCompletionResult)
        }
    }
    
    // MARK: DidCompleteWithError
    func test_DidCompleteWithError_ShouldCallCompletionWithError() {
        let terminationError = ErrorMessage(operationMessage: "termination error")
        let mockedTask = MockURLSessionTask()
        delegate.urlSession(URLSession(), task: mockedTask, didCompleteWithError: terminationError)
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "should not receive error")
            switch self.spyCompletionResult! {
            case .failure(let captureError):
                XCTAssertEqual(captureError.operationMessage, "call failed with error: Optional(\"The operation couldn’t be completed. (Experiment2.ErrorMessage error 1.)\")")
            default:
                XCTFail("result should be failure")
            }
            XCTAssertEqual(mockedTask.spyCancelCount, 1)
        }
    }
}

fileprivate final class MockParser: ParserProtocol {
    var stubbedTweet: Tweet?
    
    func parse(response: Any) -> Tweet? {
        return stubbedTweet
    }

}

fileprivate final class MockJsonSerialization: JSONSerializationWrapperProtocol {
    var stubbedJsonResponse: Dictionary? = ["" : ""]
    
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        if let stubbedJsonResponse = stubbedJsonResponse {
            return stubbedJsonResponse
        } else {
            throw ErrorMessage(operationMessage: "error serializing json")
        }
    }
}

fileprivate final class MockURLSessionTask: URLSessionTask {
    var spyCancelCount = 0
    
    override func cancel() {
        spyCancelCount += 1
    }
}
