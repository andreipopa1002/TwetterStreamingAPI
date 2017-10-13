//
//  RequestManager.swift
//  Experiment2
//
//  Created by Andrei Popa on 15/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

class RequestManager: RequestManagerProtocol {
    let sessionFactory: URLSessionWrapperProtocol
    var session: URLSession?
    
    init(sessionFactory: URLSessionWrapperProtocol = URLSessionFactory()) {
        self.sessionFactory = sessionFactory
    }
    
    func fetch(request: URLRequest, completion: @escaping RequestCompletion) {
        session = sessionFactory.session(configuration: URLSessionConfiguration.default, delegate: SessionDelegate(completion: completion), delegateQueue: nil)
        session?.dataTask(with: request).resume()
    }

    
}
