//
//  PermissionProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation
import Accounts

enum Result<T,ErrorType> {
    case success(T)
    case failure(ErrorType)
}

typealias AccountRequestResponse = Result<URLRequest, ErrorMessage>
typealias AccountRequestFetcherCompletion = (AccountRequestResponse) -> ()

enum AccountTypes {
    case twitter
}

enum HTTPMethod {
    case get
}

struct RequestParameters {
    let url: URL
    let parameters: [String : String]
    let httpMethod: HTTPMethod
}

protocol AccountRequestFetcherProtocol {
    func fetchRequest(for accountType: AccountTypes, requestParameters: RequestParameters, completion:@escaping AccountRequestFetcherCompletion)
}
