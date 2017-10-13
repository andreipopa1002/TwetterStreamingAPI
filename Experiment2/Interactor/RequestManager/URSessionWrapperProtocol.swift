//
//  URSessionWrapperProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 17/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

protocol URLSessionWrapperProtocol {
    func session(configuration: URLSessionConfiguration, delegate: URLSessionDelegate, delegateQueue: OperationQueue?) -> URLSession
}
