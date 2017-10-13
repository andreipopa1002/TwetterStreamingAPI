//
//  ViewController.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController {
    var interactor: FeatureInteractorProtocol?
    var tweets = [TweetViewModel]()
    @IBOutlet var tableView: UITableView!
    
    fileprivate struct Constants {
        static let cellIdentifier = "experiment2"
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        interactor?.ready()
    }
}

extension FeatureViewController: FeatureViewControllerProtocol {

    func update(viewModel: ViewModel) {
        switch viewModel {
        case .add(let tweets, let index):
            self.tweets = tweets
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .none)
        case .delete(let tweets, let index):
            self.tweets = tweets
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .none)
        case .alert(let title, let message, let action):
            showAlert(title: title, message: message, action: action)
        }
    }
}

extension FeatureViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if let cell = cell as? TweetTableViewCell {
            cell.nameLabel?.text = tweets[indexPath.row].name
            cell.messageLabel?.text = tweets[indexPath.row].message
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

extension FeatureViewController {
    fileprivate func showAlert(title: String, message: String, action: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: action, style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
