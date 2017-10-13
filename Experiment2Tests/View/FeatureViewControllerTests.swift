//
//  FeatureViewControllerTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class FeatureViewControllerTests: XCTestCase {
    var viewController: FeatureViewController!
    fileprivate var mockedInteractor: MockInteractor!
    
    override func setUp() {
        super.setUp()
        
        mockedInteractor = MockInteractor()
        viewController = FeatureViewController()
        viewController.interactor = mockedInteractor
    }
    
    override func tearDown() {
        mockedInteractor = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_ViewDidAppear_WhenCalled_ShouldCallReadyOnInteractor() {
        let tableView = UITableView()
        viewController.tableView = tableView
        viewController.viewDidAppear(true)

        XCTAssertEqual(mockedInteractor.spyReadyCallCount, 1)
    }    
}

fileprivate final class MockInteractor: FeatureInteractorProtocol {
    var spyReadyCallCount = 0
    
    func ready() {
        spyReadyCallCount += 1
    }
}
