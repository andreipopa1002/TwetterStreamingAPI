//
//  FeatureInteractor.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import Foundation

final class FeatureInteractor {
    fileprivate struct Constants {
        static let streamURL = "https://stream.twitter.com/1.1/statuses/filter.json"
        static let parameterKey = "track"
        static let parameterValue = "transferwise"
    }
    var maxNumberOfTweets = 5
    let presenter: FeaturePresenterProtocol
    fileprivate let requestFetcher: AccountRequestFetcherProtocol
    fileprivate let requestManager: RequestManagerProtocol
    fileprivate(set) var tweets = [Tweet]()
    
    init(presenter: FeaturePresenterProtocol, requestFetcher: AccountRequestFetcherProtocol = AccountRequestFetcher(), requestManager: RequestManagerProtocol = RequestManager()) {
        self.presenter = presenter
        self.requestFetcher = requestFetcher
        self.requestManager = requestManager
    }
}

extension FeatureInteractor: FeatureInteractorProtocol {
    func ready() {
        requestFetcher.fetchRequest(for: .twitter, requestParameters: RequestParameters(url: URL(string: Constants.streamURL)!, parameters: [Constants.parameterKey : Constants.parameterValue], httpMethod: .get)) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.error(error)
            case .success(let request):
                self?.startFetchingTweets(with: request)
            }
        }
    }
}

extension FeatureInteractor {
    fileprivate func startFetchingTweets(with request: URLRequest) {
        self.requestManager.fetch(request: request, completion: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.error(error)
            case .success(let tweet):
                self?.handleNew(tweet: tweet)
            }
        })
    }
    
    fileprivate func handleNew(tweet: Tweet) {
        if tweets.count > maxNumberOfTweets - 1 {
            tweets.removeFirst()
            presenter.update(tweets: tweets, deleteAt: 0)
        }
        tweets.append(tweet)
        presenter.update(tweets: tweets, insertAt: tweets.count-1)
        
    }
}
