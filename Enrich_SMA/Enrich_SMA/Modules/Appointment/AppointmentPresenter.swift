//
//  AppointmentPresenter.swift
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

protocol AppointmentPresentationLogic
{
  func presentSomething(response: Appointment.Something.Response)
}

class AppointmentPresenter: AppointmentPresentationLogic
{
  weak var viewController: AppointmentDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Appointment.Something.Response)
  {
    let viewModel = Appointment.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
