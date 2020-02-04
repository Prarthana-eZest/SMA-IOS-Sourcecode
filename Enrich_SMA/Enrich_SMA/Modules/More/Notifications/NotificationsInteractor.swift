//
//  NotificationsInteractor.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NotificationsBusinessLogic {
  func doSomething(request: Notifications.Something.Request)
}

protocol NotificationsDataStore {
  //var name: String { get set }
}

class NotificationsInteractor: NotificationsBusinessLogic, NotificationsDataStore {
  var presenter: NotificationsPresentationLogic?
  var worker: NotificationsWorker?
  //var name: String = ""

  // MARK: Do something

  func doSomething(request: Notifications.Something.Request) {
    worker = NotificationsWorker()
    worker?.doSomeWork()

    let response = Notifications.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
