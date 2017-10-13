//
//  FeatureLauncher.swift
//  Experiment2
//
//  Created by Andrei Popa on 13/08/2017.
//  Copyright © 2017 Andrei Popa. All rights reserved.
//

import UIKit

final class FeatureLauncher {
    static func launchFeature() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"FeatureViewController") as! FeatureViewController
        let presenter = FeaturePresenter()
        presenter.view = viewController
        viewController.interactor = FeatureInteractor(presenter: presenter, requestManager: RequestManager())
        return viewController
    }
}
