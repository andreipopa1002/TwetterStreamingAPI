//
//  FeatureLauncherTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
@testable import Experiment2

class FeatureLauncherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_LaunchFeature_WhenCalled_ShouldReturnFeatureViewController() {
        let viewController = FeatureLauncher.launchFeature()
        
        XCTAssertTrue(viewController is FeatureViewController)
    }
    
    func test_LaunchFeature_whenCalled_ShouldSetInteractorOnViewController() {
        guard let viewController = FeatureLauncher.launchFeature() as? FeatureViewController else {
            XCTFail("ViewController not expected type")
            return
        }
        
        XCTAssertTrue(viewController.interactor is FeatureInteractor)
    }
    
    func test_LaunchFeature_WhenCalled_ShouldSetPresenterOnInteractor() {
        guard let viewController = FeatureLauncher.launchFeature() as? FeatureViewController,
            let interactor = viewController.interactor as? FeatureInteractor else {
                XCTFail("Interactor not exepected type")
                return
        }
        
        XCTAssertTrue(interactor.presenter is FeaturePresenter)
    }
    
    func test_LaunchFeature_WhenCalled_ShouldSetViewOnPresenter() {
        guard let viewController = FeatureLauncher.launchFeature() as? FeatureViewController,
            let interactor = viewController.interactor as? FeatureInteractor,
            let presenter = interactor.presenter as? FeaturePresenter else {
                XCTFail("Presenter not expected type")
                return
        }
        
        XCTAssertTrue(presenter.view === viewController)
    }
    
}
