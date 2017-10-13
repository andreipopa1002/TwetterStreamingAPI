//
//  FeaturePresenter.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

final class FeaturePresenter: FeaturePresenterProtocol {
    weak var view: FeatureViewControllerProtocol?
    
    func error(_ error: ErrorMessage) {
        view?.update(viewModel: .alert(title: "Error", message: error.operationMessage, action: "Ok"))
    }
    
    func update(tweets: [Tweet], insertAt index: Int) {
        view?.update(viewModel: .add(tweets: convert(tweets: tweets), atIndex: index))
    }
    
    func update(tweets: [Tweet], deleteAt index: Int) {
        view?.update(viewModel: .delete(tweets: convert(tweets: tweets), atIndex: index))
    }
}

extension FeaturePresenter {
    fileprivate func convert(tweets: [Tweet]) -> [TweetViewModel] {
        return tweets.map({ TweetViewModel(name: $0.name, message: "\($0.screenName)@: \($0.tweetMessage)") })
    }
}
