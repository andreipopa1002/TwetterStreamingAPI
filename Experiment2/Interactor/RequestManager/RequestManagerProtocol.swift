//
//  RequestManagerProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 15/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

typealias RequestCompletion = (Result<Tweet, ErrorMessage>)->()

protocol RequestManagerProtocol {
    func fetch(request: URLRequest, completion:@escaping RequestCompletion)
}
