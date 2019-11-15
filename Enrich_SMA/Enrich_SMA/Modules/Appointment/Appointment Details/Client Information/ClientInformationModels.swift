//
//  ClientInformationModels.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 08/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ClientInformation
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
    }
  }
}


let consulationData:[TagViewModel] = [TagViewModel(title: "Type of hair", tagView: [TagViewString(text: "DRY", isSelected: true),
                                                                                    TagViewString(text: "FRIZZY", isSelected: false),
                                                                                    TagViewString(text: "SENSITIVE", isSelected: false),
                                                                                    TagViewString(text: "VERGIN", isSelected: false),
                                                                                    TagViewString(text: "CHEMICALLY TREATED", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Hair Elasticity", tagView: [TagViewString(text: "POOR", isSelected: false),
                                                                                       TagViewString(text: "GOOD", isSelected: true)], isSingleSelection: true),
                                      TagViewModel(title: "Hair Sensitivity", tagView: [TagViewString(text: "POROUS", isSelected: false),
                                                                                        TagViewString(text: "SENSITIZED", isSelected: false)], isSingleSelection: true),
                                      TagViewModel(title: "Scalp Sensitivity", tagView: [TagViewString(text: "HEALTHY", isSelected: false),
                                                                                                                                                                                                                TagViewString(text: "ALLERGIC", isSelected: false),
                                                                                                                                                                                                                          TagViewString(text: "ITCHY", isSelected: false),
                                                                                                                                                                                                                          TagViewString(text: "INFECTED", isSelected: false),
                                                                                                                                                                                                                          TagViewString(text: "REDNESS", isSelected: false)], isSingleSelection: false),
                                      
                                      TagViewModel(title: "Hair Texture", tagView: [TagViewString(text: "FINE", isSelected: false),
                                                                                        TagViewString(text: "MEDIUM", isSelected: false),
                                                                                        TagViewString(text: "THICK", isSelected: false)], isSingleSelection: true),
                                      
                                      TagViewModel(title: "Skin Type", tagView: [TagViewString(text: "NORMAL", isSelected: false),
                                                                                                                                                                                                                 TagViewString(text: "OILY", isSelected: false),
                                                                                                                                                                                                                 TagViewString(text: "DRY", isSelected: false),
                                                                                                                                                                                                                 TagViewString(text: "COMBINATION", isSelected: false)], isSingleSelection: true),
                                      
                                      TagViewModel(title: "Skin Sensitivity", tagView: [TagViewString(text: "NORMAL", isSelected: false),
                                                                                    TagViewString(text: "SENSITIVE", isSelected: false),
                                                                                    TagViewString(text: "HYPERSENSITIVE", isSelected: false)], isSingleSelection: true),
                                      
                                      TagViewModel(title: "Muscle Tone", tagView: [TagViewString(text: "POOR", isSelected: false),
                                                                                                                                                                                                                          TagViewString(text: "AVERAGE", isSelected: false),
                                                                                                                                                                                                                          TagViewString(text: "GOOD", isSelected: false)], isSingleSelection: true),
                                      
                                      TagViewModel(title: "Skin Concerns", tagView: [TagViewString(text: "PIGMENTATION", isSelected: false),
                                                                                   TagViewString(text: "DEHYGRATION", isSelected: false),
                                                                                   TagViewString(text: "BLACK HEADS", isSelected: false),
                                                                                   TagViewString(text: "ACNE", isSelected: false),
                                                                                   TagViewString(text: "HYPERSENSITIVE", isSelected: false)], isSingleSelection: false),
                                      
                                      TagViewModel(title: "Contraindications for facial using high frequency or galvanic", tagView: [TagViewString(text: "PIGMENTATION", isSelected: false),
                                                                                     TagViewString(text: "HIGH BLOOD PRESSURE", isSelected: false),
                                                                                     TagViewString(text: "DIABETES", isSelected: false),
                                                                                     TagViewString(text: "CLAUSTROPHOBIA", isSelected: false),
                                                                                     TagViewString(text: "ASTHAMA", isSelected: false),
                                                                                     TagViewString(text: "METAL TOOTH FILLINGS", isSelected: false),
                                                                                     TagViewString(text: "PREGNANCY", isSelected: false)], isSingleSelection: false)]

