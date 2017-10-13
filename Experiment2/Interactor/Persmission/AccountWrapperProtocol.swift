//
//  AccountWrapperProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 14/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation
import Accounts

protocol AccountWrapperProtocol {
    func requestAccessToAccounts(with accountType: ACAccountType!, options: [AnyHashable : Any]!, completion: Accounts.ACAccountStoreRequestAccessCompletionHandler!)
    func accountType(withAccountTypeIdentifier typeIdentifier: String!) -> ACAccountType!
    func accounts(with accountType: ACAccountType!) -> [Any]!
}

extension ACAccountStore: AccountWrapperProtocol { }
