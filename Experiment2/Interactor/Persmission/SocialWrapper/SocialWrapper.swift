//
//  SocialWrapperProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 15/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation
import Accounts
import Social

protocol SocialWrapperProtocol {
    func socialRequest(account: ACAccount, serviceType: String!, requestMethod: SLRequestMethod, url: URL!, parameters: [String : String]!) -> URLRequest?
}

class SocialWrapper: SocialWrapperProtocol {
    
    func socialRequest(account: ACAccount, serviceType: String!, requestMethod: SLRequestMethod,
                       url: URL!, parameters: [String : String]!) -> URLRequest? {
        let social = SLRequest(forServiceType: serviceType,
                  requestMethod: requestMethod,
                  url: url,
                  parameters: parameters)
        social?.account = account
        
        return social?.preparedURLRequest()
    }
}
