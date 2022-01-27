//
//  FootfallInteractor.swift
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

protocol FootfallBusinessLogic
{
  func doSomething(request: Footfall.Something.Request)
}

protocol FootfallDataStore
{
  //var name: String { get set }
}

class FootfallInteractor: FootfallBusinessLogic, FootfallDataStore
{
  var presenter: FootfallPresentationLogic?
  var worker: FootfallWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Footfall.Something.Request)
  {
    worker = FootfallWorker()
    worker?.doSomeWork()
    
    let response = Footfall.Something.Response()
    presenter?.presentSomething(response: response)
  }
}