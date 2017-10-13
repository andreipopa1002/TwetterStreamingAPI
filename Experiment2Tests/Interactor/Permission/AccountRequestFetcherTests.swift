//
//  PermissionTests.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import XCTest
import Accounts
import Social
@testable import Experiment2

class AccountRequestFetcherTests: XCTestCase {
    var requestFetcher: AccountRequestFetcher!
    fileprivate var mockedAccount: MockAccount!
    fileprivate var mockedSocialWrapper: MockSocialWrapper!
    var paramenter = RequestParameters(url: URL(string: "www.google.com")!,
                                       parameters: ["key": "value"],
                                       httpMethod: .get)
    
    override func setUp() {
        super.setUp()
        
        mockedAccount = MockAccount()
        mockedSocialWrapper = MockSocialWrapper()
        requestFetcher = AccountRequestFetcher(store: mockedAccount, socialWrapper: mockedSocialWrapper)
    }
    
    override func tearDown() {
        mockedAccount = nil
        mockedSocialWrapper = nil
        requestFetcher = nil
        
        super.tearDown()
    }
    
    func test_FetchRequest_WhenCalled_ShouldRequestAccess() {
        let stubbedAccountType = ACAccountType()
        mockedAccount.stubAccountType = stubbedAccountType
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { _ in }
        
        XCTAssertEqual(mockedAccount.spyAccountTypeIdentifier, ACAccountTypeIdentifierTwitter)
        XCTAssertNil(mockedAccount.spyOptions)
        XCTAssertEqual(mockedAccount.spyAccountType, stubbedAccountType)
    }
    
    func test_FetchRequest_WhenRequestPermissionFails_ShouldCallCompletionWithFailedToGetErrorMessage() {
        var capturedError: ErrorMessage?
        let mainThreadExpectation = expectation(description: "main thread expectation")
        
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { result in
            mainThreadExpectation.fulfill()
            switch result {
            case .failure(let receivedError):
                capturedError = receivedError
            default:
                XCTFail("should get .failure")
            }
        }
        
        mockedAccount.spyCompletion!(false, MockError())
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil( error,"should not get errors")
            XCTAssertEqual(capturedError?.operationMessage, "Failed to get permission")
        }
    }
    
    func test_FetchRequest_WhenDeniedAccess_ShouldCallCompletionWithAccessDeniedError() {
        var capturedError: ErrorMessage?
        let mainThreadExpectation = expectation(description: "main thread expectation")
        
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { result in
            mainThreadExpectation.fulfill()
            switch result {
            case .failure(let receivedError):
                capturedError = receivedError
            default:
                XCTFail("should get .failure")
            }
        }
        
        mockedAccount.spyCompletion!(false, nil)
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil( error,"should not get errors")
            XCTAssertEqual(capturedError?.operationMessage, "Twitter account access denied. Please allow access!")
        }
    }
    
    func test_GetPersmission_WhenCalledWithAccessGranted_ShouldCallCompletionWithRequest() {
        var capturedRequest: URLRequest?
        let mainThreadExpectation = expectation(description: "main thread expectation")
        
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { result in
            mainThreadExpectation.fulfill()
            switch result {
            case .success(let request):
                capturedRequest = request
            default:
                XCTFail("should get .success")
            }
        }
        
        mockedAccount.spyCompletion!(true, nil)
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "should not get any errors")
            XCTAssertEqual(self.mockedSocialWrapper.spyServiceType,SLServiceTypeTwitter)
            XCTAssertEqual(self.mockedSocialWrapper.spyRequestMethod, .GET)
            XCTAssertEqual(self.mockedSocialWrapper.spyURL, URL(string: "www.google.com"))
            XCTAssertEqual(self.mockedSocialWrapper.spyParameters?["key"], "value")
            XCTAssertEqual(capturedRequest, self.mockedSocialWrapper.stubbedURLRequest)
        }
    }
    
    func test_FetchRequest_WhenCalledWithAccessGrantedSocialRequestIsNil_ShouldCallCompletionWithFailToGetRequestError() {
        var capturedError: ErrorMessage?
        mockedSocialWrapper.stubbedURLRequest = nil
        let mainThreadExpectation = expectation(description: "main thread expectation")
        
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { result in
            mainThreadExpectation.fulfill()
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                XCTFail("should not get on this brach")
            }
        }
        
        mockedAccount.spyCompletion!(true, nil)
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertNil(error, "should not get any errors")
            XCTAssertEqual(capturedError?.operationMessage, "Failed to get request")
        }
    }
    
    func test_FetchRequest_WhenCalledWithAccessGrantedAndNoAccount_ShouldCallCompletionWithNoAccountErrorMessage() {
        var capturedError: ErrorMessage?
        mockedAccount.stubbedAccounts = []
        let mainThreadExpectation = expectation(description: "main thread expectation")
        
        requestFetcher.fetchRequest(for: .twitter, requestParameters: paramenter) { result in
            mainThreadExpectation.fulfill()
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                XCTFail("should get .failure")
            }
        }
        
        mockedAccount.spyCompletion!(true, nil)
        
        waitForExpectations(timeout: 0.1) { error in
            XCTAssertEqual(capturedError?.operationMessage, "No Twitter account found on this device. Please login to have data access")
        }
    }
}

private struct MockError: Error { }

private final class MockAccount: AccountWrapperProtocol {
    var spyAccountType: ACAccountType?
    var spyOptions: [AnyHashable: Any]?
    var spyCompletion: Accounts.ACAccountStoreRequestAccessCompletionHandler?
    var spyAccountTypeIdentifier: String?
    
    var stubAccountType = ACAccountType()
    var stubbedError: MockError?
    var stubbedAccess: Bool?
    var stubbedAccounts = [ACAccount(), ACAccount()]
    
    func requestAccessToAccounts(with accountType: ACAccountType!, options: [AnyHashable : Any]!, completion: Accounts.ACAccountStoreRequestAccessCompletionHandler!) {
        spyAccountType = accountType
        spyOptions = options
        spyCompletion = completion
    }
    
    func accountType(withAccountTypeIdentifier typeIdentifier: String!) -> ACAccountType! {
        spyAccountTypeIdentifier = typeIdentifier
        return stubAccountType
    }
    
    func accounts(with accountType: ACAccountType!) -> [Any]! {
        return stubbedAccounts
    }
}

private final class MockSocialWrapper: SocialWrapperProtocol {
    var stubbedURLRequest: URLRequest? = URLRequest(url: URL(string: "www.test.com")!)
    var spyAccount:ACAccount?
    var spyServiceType: String?
    var spyRequestMethod: SLRequestMethod?
    var spyURL: URL?
    var spyParameters: [String : String]?
    
    func socialRequest(account: ACAccount, serviceType: String!, requestMethod: SLRequestMethod, url: URL!, parameters: [String : String]!) -> URLRequest? {
        spyAccount = account
        spyServiceType = serviceType
        spyRequestMethod = requestMethod
        spyURL = url
        spyParameters = parameters
        
        return stubbedURLRequest
    }
}
