//
//  RequestManagerTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 15/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class RequestManagerTests: XCTestCase {
    var requestManager: RequestManager!
    fileprivate var mockedSessionWrapper: MockSessionWrapper!
    private let urlRequest = URLRequest(url: URL(string: "www.test.com")!)
    
    override func setUp() {
        super.setUp()
        mockedSessionWrapper = MockSessionWrapper()
        requestManager = RequestManager(sessionFactory: mockedSessionWrapper)
    }
    
    override func tearDown() {
        mockedSessionWrapper = nil
        requestManager = nil
        
        super.tearDown()
    }
    
    func test_FetchRequest_ShouldCreateSessionWithCorrectArgs() {
        requestManager.fetch(request: urlRequest) { _ in }
        
        XCTAssertEqual(mockedSessionWrapper.spyConfiguration, URLSessionConfiguration.default)
        XCTAssertNotNil(mockedSessionWrapper.spyDelegate)
        XCTAssertNil(mockedSessionWrapper.spyDelegateQueue)
    }
    
    func test_FetchRequest_ShouldFetchCorrectURLRequest() {
        requestManager.fetch(request: urlRequest, completion: { _ in })
        
        let mockedSession = mockedSessionWrapper.stubbedSession
        
        XCTAssertEqual(mockedSession.spyURLRequest, urlRequest)
    }
    
    func test_FetchRquest_ShouldCallResumeOnDataTask() {
        requestManager.fetch(request: urlRequest, completion: { _ in })
        
        let mockedDataTask = mockedSessionWrapper.stubbedSession.stubbedDataTask
        
        XCTAssertEqual(mockedDataTask.spyResumeCallCount, 1)
    }
    
    func test_FetchRequest_ShouldSetCompletionOnDelegate() {
        let closureExpectation = expectation(description: "this should end in the delegate")
        let completion: RequestCompletion = { _ in closureExpectation.fulfill() }
        requestManager.fetch(request: urlRequest, completion: completion)
        
        guard let delegate = mockedSessionWrapper.spyDelegate as? SessionDelegate else {
            XCTFail("delegate not the correct type")
            return
        }
        
        delegate.completion(.success(Tweet(name: "", screenName: "", tweetMessage: "")))
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "we should not receiv an error")
        }
    }
    
}

fileprivate final class MockSessionWrapper: URLSessionWrapperProtocol {
    var spyConfiguration: URLSessionConfiguration?
    var spyDelegate: URLSessionDelegate?
    var spyDelegateQueue: OperationQueue?
    var stubbedSession = MockURLSession()
    
    func session(configuration: URLSessionConfiguration, delegate: URLSessionDelegate, delegateQueue: OperationQueue?) -> URLSession {
        spyConfiguration = configuration
        spyDelegate = delegate
        spyDelegateQueue = delegateQueue
        
        return stubbedSession
    }
}

fileprivate final class MockURLSessionDataTask: URLSessionDataTask {
    var spyResumeCallCount = 0
    
    override func resume() {
        spyResumeCallCount += 1
    }
}

fileprivate final class MockURLSession: URLSession {
    var spyURLRequest: URLRequest?
    let stubbedDataTask = MockURLSessionDataTask()
    
    override func dataTask(with request: URLRequest) -> URLSessionDataTask {
        spyURLRequest = request
        return stubbedDataTask
    }
}
