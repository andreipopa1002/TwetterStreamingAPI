//
//  FeatureViewControllerProtocol.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

struct TweetViewModel {
    let name: String
    let message: String
}

enum ViewModel {
    case add(tweets:[TweetViewModel], atIndex: Int)
    case delete(tweets:[TweetViewModel], atIndex: Int)
    case alert(title: String, message: String, action: String)
}

protocol FeatureViewControllerProtocol: class {
    func update(viewModel: ViewModel)
}
