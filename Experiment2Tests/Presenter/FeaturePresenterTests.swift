//
//  FeaturePresenterTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 16/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class FeaturePresenterTests: XCTestCase {
    var presenter: FeaturePresenter!
    fileprivate var mockedView: MockView!
    
    override func setUp() {
        super.setUp()
        
        mockedView = MockView()
        presenter = FeaturePresenter()
        presenter.view = mockedView
    }
    
    override func tearDown() {
        mockedView = nil
        presenter = nil
        
        super.tearDown()
    }
    
    func test_View_shouldBeWeakProperty() {
        presenter.view = MockView()
        
        XCTAssertNil(presenter.view)
    }
    
    // MARK: - update insertAtIndex
    func test_UpdateInsertAtIndex_WhenCalled_ShouldCreateAddViewModelAndCallView() {
        let tweet = Tweet(name: "name", screenName: "screenName", tweetMessage: "tweet message")
        
        presenter.update(tweets: [tweet], insertAt: 2)
        
        guard let viewModel = mockedView.spyViewModel,
            case .add(let tweetViewModels, let index) = viewModel else {
            XCTFail("unexpected view model")
            return
        }
        
        XCTAssertEqual(index, 2)
        XCTAssertEqual(tweetViewModels.count, 1)
        XCTAssertEqual(tweetViewModels[0].name, "name")
        XCTAssertEqual(tweetViewModels[0].message, "screenName@: tweet message")
    }
    
    // MARK: - update deleteAtIndex
    func test_UpdateDeleteAtIndex_WhenCalled_ShouldCreateDeleteViewModelAndCallView() {
        let tweet = Tweet(name: "name", screenName: "screenName", tweetMessage: "tweet message")
        
        presenter.update(tweets: [tweet], deleteAt: 2)
        
        guard let viewModel = mockedView.spyViewModel,
            case .delete(let tweetViewModels, let index) = viewModel else {
            XCTFail("unexpected view model")
            return
        }
        
        XCTAssertEqual(index, 2)
        XCTAssertEqual(tweetViewModels.count, 1)
        XCTAssertEqual(tweetViewModels[0].name, "name")
        XCTAssertEqual(tweetViewModels[0].message, "screenName@: tweet message")
    }
    
    // MARK: - error with message
    func test_ErrorWithMessage_WhenCalled_ShouldCreateAlertViewModelAndCallView() {
        let errorMessage = ErrorMessage(operationMessage: "some message")
        
        presenter.error(errorMessage)
        
        guard let viewModel = mockedView.spyViewModel,
            case .alert(let title, let message, let action) = viewModel else {
                XCTFail("unexpected view model")
                return
        }
        
        XCTAssertEqual(title, "Error")
        XCTAssertEqual(message, "some message")
        XCTAssertEqual(action, "Ok")
    }
    
}

fileprivate final class MockView: FeatureViewControllerProtocol {
    var spyViewModel: ViewModel?
    
    func update(viewModel: ViewModel) {
        spyViewModel = viewModel
    }
}
