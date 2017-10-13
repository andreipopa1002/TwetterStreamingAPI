//
//  FeaturePresenterProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

protocol FeaturePresenterProtocol {
    func error(_ error: ErrorMessage)
    func update(tweets: [Tweet], insertAt index: Int)
    func update(tweets: [Tweet], deleteAt index: Int)
    
}
