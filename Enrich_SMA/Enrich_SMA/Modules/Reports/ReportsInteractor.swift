//
//  ReportsInteractor.swift
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

protocol ReportsBusinessLogic {
  func doSomething(request: Reports.Something.Request)
}

protocol ReportsDataStore {
  //var name: String { get set }
}

class ReportsInteractor: ReportsBusinessLogic, ReportsDataStore {
  var presenter: ReportsPresentationLogic?
  var worker: ReportsWorker?
  //var name: String = ""

  // MARK: Do something

  func doSomething(request: Reports.Something.Request) {
    worker = ReportsWorker()
    worker?.doSomeWork()

    let response = Reports.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
