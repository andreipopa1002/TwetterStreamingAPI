//
//  Permission.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation
import Accounts
import Social

private struct Constants {
    static let failedToGetErrorMessageMessage = "Failed to get permission"
    static let accessDeniedErrorMessage = "Twitter account access denied. Please allow access!"
    static let noAccountFoundErrorMessage = "No Twitter account found on this device. Please login to have data access"
    static let failedToGetRequest = "Failed to get request"
}

final class AccountRequestFetcher: AccountRequestFetcherProtocol {
    let store: AccountWrapperProtocol
    let socialWrapper: SocialWrapperProtocol
    var socialRequest: SLRequest?
    
    init(store: AccountWrapperProtocol = ACAccountStore(), socialWrapper: SocialWrapperProtocol = SocialWrapper()) {
        self.store = store
        self.socialWrapper = socialWrapper
    }
    
    func fetchRequest(for accountType: AccountTypes, requestParameters: RequestParameters, completion:@escaping AccountRequestFetcherCompletion) {
        let accountType = store.accountType(withAccountTypeIdentifier: accountString(for: accountType))
        store.requestAccessToAccounts(with: accountType, options: nil) { granted, error in
            if error != nil {
                self.callOnMainThread(response: .failure(ErrorMessage(operationMessage: Constants.failedToGetErrorMessageMessage)),
                                 on: completion)
            } else {
                self.handleAccess(granted: granted, accountType: accountType, requestParameters: requestParameters, completion: completion)
            }
        }
    }
}

extension AccountRequestFetcher {
    
    fileprivate func handleAccess(granted: Bool, accountType: ACAccountType?, requestParameters: RequestParameters, completion:@escaping AccountRequestFetcherCompletion) {
        if granted == false {
            callOnMainThread(response: .failure(ErrorMessage(operationMessage: Constants.accessDeniedErrorMessage)), on: completion)
        } else {
            self.handleAccesGranted(accountType: accountType, requestParameters: requestParameters,
                                    completion: completion)
        }
    }
    
    fileprivate func handleAccesGranted(accountType:ACAccountType?, requestParameters: RequestParameters,
                                        completion:@escaping AccountRequestFetcherCompletion) {
        let twitterAccounts = self.store.accounts(with: accountType)
        guard let account = twitterAccounts?.first as? ACAccount else {
            return self.callOnMainThread(response: .failure(ErrorMessage(operationMessage: Constants.noAccountFoundErrorMessage)), on: completion)
        }
        
        extractRequest(from: account, requestParameters: requestParameters, completion: completion)
    }
    
    fileprivate func extractRequest(from account: ACAccount, requestParameters: RequestParameters, completion: @escaping AccountRequestFetcherCompletion) {
        guard let request = socialWrapper.socialRequest(account: account, serviceType: SLServiceTypeTwitter, requestMethod: httpMethod(for: requestParameters.httpMethod), url: requestParameters.url, parameters: requestParameters.parameters) else {
            return self.callOnMainThread(response: .failure(ErrorMessage(operationMessage: Constants.failedToGetRequest)), on: completion)
        }
        
        callOnMainThread(response: .success(request), on: completion)
    }

    fileprivate func accountString(for type: AccountTypes) -> String {
        switch type {
        case .twitter: return ACAccountTypeIdentifierTwitter
        }
    }
    
    fileprivate func httpMethod(for method: HTTPMethod) -> SLRequestMethod {
        switch method {
        case .get:
            return .GET
        }
    }
    
    fileprivate func callOnMainThread(response: AccountRequestResponse, on completion:@escaping AccountRequestFetcherCompletion) {
        DispatchQueue.main.async {
            completion(response)
        }
    }
}
