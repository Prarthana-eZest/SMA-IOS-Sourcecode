//
//  ResourceUtilisationRouter.swift
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

@objc protocol ResourceUtilisationRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ResourceUtilisationDataPassing
{
  var dataStore: ResourceUtilisationDataStore? { get }
}

class ResourceUtilisationRouter: NSObject, ResourceUtilisationRoutingLogic, ResourceUtilisationDataPassing
{
  weak var viewController: ResourceUtilisationViewController?
  var dataStore: ResourceUtilisationDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ResourceUtilisationViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ResourceUtilisationDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
