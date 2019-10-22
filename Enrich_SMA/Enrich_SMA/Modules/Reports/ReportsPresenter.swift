//
//  ReportsPresenter.swift
//  Enrich_SMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReportsPresentationLogic
{
  func presentSomething(response: Reports.Something.Response)
}

class ReportsPresenter: ReportsPresentationLogic
{
  weak var viewController: ReportsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Reports.Something.Response)
  {
    let viewModel = Reports.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
