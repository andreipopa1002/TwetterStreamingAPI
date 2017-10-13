//
//  FeatureInteractorTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
import Accounts
@testable import Experiment2

class FeatureInteractorTests: XCTestCase {
    var interactor: FeatureInteractor!
    fileprivate var mockedPresenter: MockPresenter!
    fileprivate var mockedRequestFetcher: MockAccountRequestFetcher!
    fileprivate var mockedRequestManager: MockRequestManager!
    
    fileprivate let stubbedURLRequest = URLRequest(url: URL(string:"www.google.com")!)
    fileprivate let stubbedTweet = Tweet(name: "name", screenName: "screenName", tweetMessage: "tweettMessage")
    
    override func setUp() {
        super.setUp()
        mockedRequestFetcher = MockAccountRequestFetcher()
        mockedPresenter = MockPresenter()
        mockedRequestManager = MockRequestManager()
        interactor = FeatureInteractor(presenter: mockedPresenter, requestFetcher: mockedRequestFetcher, requestManager: mockedRequestManager)
    }
    
    override func tearDown() {
        mockedRequestManager = nil
        mockedRequestFetcher = nil
        mockedPresenter = nil
        interactor = nil
        
        super.tearDown()
    }
    
    // MARK: - ready
    func test_Ready_WhenCalled_ShouldAskForTwitterRequestWithCorrectArguments() {
        interactor.ready()
        
        XCTAssertEqual(mockedRequestFetcher.spyAccountType, .twitter)
        XCTAssertEqual(mockedRequestFetcher.spyRequestParameters?.url, URL(string: "https://stream.twitter.com/1.1/statuses/filter.json"))
        XCTAssertEqual(mockedRequestFetcher.spyRequestParameters?.httpMethod, .get)
        XCTAssertEqual(mockedRequestFetcher.spyRequestParameters?.parameters["track"], "transferwise")
    }
    
    func test_Ready_WhenRequestFetcherReturnsError_ShouldSendErrorToPresenter() {
        let errorString = "Some error"
        interactor.ready()
        mockedRequestFetcher.spyCompletion?(.failure(ErrorMessage(operationMessage: errorString)))
        
        XCTAssertEqual(mockedPresenter.spyError?.operationMessage, errorString)
    }
    
    func test_Ready_WhenRequestManagerFails_ShouldSendErrorToPresenter() {
        let errorString = "some error"
        interactor.ready()
        mockedRequestFetcher.spyCompletion?(.success(stubbedURLRequest))
        mockedRequestManager.spyCompletion?(.failure(ErrorMessage(operationMessage: errorString)))
        
        XCTAssertEqual(mockedPresenter.spyError?.operationMessage, errorString)
    }
    
    func test_Ready_WhenRequestFetcherSuccedes_ShouldFetchRequestWithCorrectRequest() {
        interactor.ready()
        mockedRequestFetcher.spyCompletion?(.success(stubbedURLRequest))
        
        XCTAssertEqual(mockedRequestManager.spyURLRequest, stubbedURLRequest)
    }
    
    func test_Ready_WhenReceivedTweet_shouldSendTweetsToPresenterToInsert() {
        setUpFlowThatReceives(tweet: stubbedTweet)
        
        XCTAssertEqual(mockedPresenter.spyInsertTweets!, interactor.tweets)
        XCTAssertEqual(mockedPresenter.spyInsertIndex!, 0)
    }
    
    func test_Ready_WhenReceivedTweetAndTotalTweetsNumberIsSmallerThanMaxNo_ShouldNotSentTweetToPresenterToDelete() {
        setUpFlowThatReceives(tweet: stubbedTweet)
        
        XCTAssertNil(mockedPresenter.spyDeleteTweets)
        XCTAssertNil(mockedPresenter.spyDeleteIndex)
    }
    
    func test_Ready_WhenReceivedTweetAndTotalTweetsNumberIsGreaterThanMaxNo_ShouldRemoveOldestTweetAndAddTheNewOne() {
        interactor.maxNumberOfTweets = 2
        setUpFlowThatReceives(tweet: stubbedTweet)
        let secondTweet = Tweet(name: "secondName", screenName: "secondScreenName", tweetMessage: "second")
        setUpFlowThatReceives(tweet: secondTweet)
        let thirdTweet = Tweet(name: "thirdTweet", screenName: "thirdScreenName", tweetMessage: "third")
        setUpFlowThatReceives(tweet: thirdTweet)
        
        XCTAssertEqual(mockedPresenter.spyDeleteTweets!, [secondTweet])
        XCTAssertEqual(mockedPresenter.spyDeleteIndex, 0)
        XCTAssertEqual(mockedPresenter.spyInsertTweets!, [secondTweet, thirdTweet])
        XCTAssertEqual(mockedPresenter.spyInsertIndex, 1)
    }
    
}

extension FeatureInteractorTests {
    func setUpFlowThatReceives(tweet: Tweet) {
        interactor.ready()
        mockedRequestFetcher.spyCompletion?(.success(stubbedURLRequest))
        mockedRequestManager.spyCompletion?(.success(tweet))
    }
}

private final class MockPresenter: FeaturePresenterProtocol {
    var spyError: ErrorMessage?
    var spyInsertTweets: [Tweet]?
    var spyInsertIndex: Int?
    var spyDeleteTweets: [Tweet]?
    var spyDeleteIndex: Int?
    
    func error(_ error: ErrorMessage) {
        spyError = error
    }
    
    func update(tweets: [Tweet], insertAt index: Int) {
        spyInsertTweets = tweets
        spyInsertIndex = index
    }
    
    func update(tweets: [Tweet], deleteAt index: Int) {
        spyDeleteTweets = tweets
        spyDeleteIndex = index
    }
}

private final class MockAccountRequestFetcher: AccountRequestFetcherProtocol {
    var spyAccountType: AccountTypes?
    var spyRequestParameters: RequestParameters?
    var spyCompletion: AccountRequestFetcherCompletion?
    
    func fetchRequest(for accountType: AccountTypes, requestParameters: RequestParameters, completion:@escaping AccountRequestFetcherCompletion) {
        spyAccountType = accountType
        spyRequestParameters = requestParameters
        spyCompletion = completion
    }
}

private final class MockRequestManager: RequestManagerProtocol {
    var spyURLRequest: URLRequest?
    var spyCompletion: RequestCompletion?
    var stubbedTweet: Tweet?
    var stubbedError: ErrorMessage?
    
    func fetch(request: URLRequest, completion:@escaping RequestCompletion) {
        spyURLRequest = request
        spyCompletion = completion
    }
}
