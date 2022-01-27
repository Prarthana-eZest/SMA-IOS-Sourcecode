//
//  PenetrationRatiosPresenter.swift
//  Enrich_SMA
//
//  Created by Harshal on 21/01/22.
//  Copyright (c) 2022 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PenetrationRatiosPresentationLogic
{
  func presentSomething(response: PenetrationRatios.Something.Response)
}

class PenetrationRatiosPresenter: PenetrationRatiosPresentationLogic
{
  weak var viewController: PenetrationRatiosDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: PenetrationRatios.Something.Response)
  {
    let viewModel = PenetrationRatios.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}