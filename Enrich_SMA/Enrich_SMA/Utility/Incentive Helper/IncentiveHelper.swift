//
//  IncentiveHelper.swift
//  Enrich_SMA
//
//  Created by Prarthana on 25/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import Foundation

import UIKit

enum EarningDetails : String {
    
    case Revenue = "Revenue"
    case Sales = "Sales"
    case FreeServices = "Free Services"
    case Footfall = "Footfall"
    case CustomerFeedback = "Customer Feedback"
    case Productivity = "Productivity"
    case PenetrationRatios = "Penetration Ratios"
    case CustomerEngagement = "Customer Engagement"
    case ResourceUtilisation = "Resource Utilisation"
    case Fixed_Earning = "Fixed Earning"
    case Incentive = "Incentive"
    case Bonus = "Bonus"
    case Other_Earnings = "Other Earnings"
    case Awards = "Awards"
    case Deductions = "Deductions"
    
    var menuTitle: String {
        switch self {
        case .Revenue: return "Revenue"
        case .Sales: return "Sales"
        case .FreeServices: return "Free Services"
        case .Footfall: return "Footfall"
        case .CustomerFeedback: return "Customer Feedback"
        case .Productivity: return "Productivity"
        case .PenetrationRatios: return "Penetration Ratios"
        case .CustomerEngagement: return "Customer Engagement"
        case .ResourceUtilisation: return "Resource Utilisation"
        case .Fixed_Earning: return "Fixed Earning"
        case .Incentive: return "Incentive"
        case .Bonus: return "Bonus"
        case .Other_Earnings: return "Other Earnings"
        case .Awards: return "Awards"
        case .Deductions: return "Deductions"
        }
    }
    
    var menuIcon: UIImage? {
        switch self {
        case .Revenue: return UIImage(named: "Revenue")
        case .Sales: return UIImage(named: "Sales")
        case .FreeServices: return UIImage(named: "FreeService")
        case .Footfall: return UIImage(named: "Footfall")
        case .CustomerFeedback: return UIImage(named: "CustomerFeedback")
        case .Productivity: return UIImage(named: "Productivity")
        case .PenetrationRatios: return UIImage(named: "Ratio")
        case .CustomerEngagement: return UIImage(named: "Engagement")
        case .ResourceUtilisation: return UIImage(named: "Utilisation")
        case .Fixed_Earning: return UIImage(named: "FixedEarnings")
        case.Incentive: return UIImage(named: "Incentive")
        case .Bonus: return UIImage(named: "Bonus")
        case .Other_Earnings: return UIImage(named: "OtherEarnings")
        case .Awards: return UIImage(named: "Awards")
        case .Deductions: return UIImage(named: "Deduction")
        }
    }
    
    var valueColor: UIColor {
        switch self {
        case .Revenue: return UIColor(red: 0.08, green: 0.70, blue: 0.55, alpha: 1.00)
        case .Sales: return UIColor(red: 0.47, green: 0.79, blue: 0.91, alpha: 0.3)//rgba(119, 202, 231, 1) 30%
        case .FreeServices: return UIColor(red: 1.00, green: 0.38, blue: 0.53, alpha: 1.00)
        case .Footfall: return UIColor(red: 1.00, green: 0.69, blue: 0.48, alpha: 1.00)
        case .CustomerFeedback: return UIColor(red: 0.25, green: 0.61, blue: 0.92, alpha: 1.00)
        case .Productivity: return UIColor(red: 0.34, green: 0.69, blue: 0.08, alpha: 1.00)
        case .PenetrationRatios: return UIColor(red: 0.73, green: 0.34, blue: 0.84, alpha: 1.00)
        case .CustomerEngagement: return UIColor(red: 0.12, green: 0.39, blue: 0.80, alpha: 1.00)
        case .ResourceUtilisation: return UIColor(red: 0.29, green: 0.40, blue: 0.42, alpha: 1.00)
        case .Fixed_Earning: return UIColor(red: 0.08, green: 0.70, blue: 0.55, alpha: 1.00)
        case .Incentive: return UIColor(red: 0.36, green: 0.53, blue: 0.90, alpha: 1.00)
        case .Bonus: return UIColor(red: 0.34, green: 0.69, blue: 0.08, alpha: 1.00)
        case .Other_Earnings: return UIColor(red: 0.29, green: 0.40, blue: 0.42, alpha: 1.00)
        case .Awards: return UIColor(red: 0.73, green: 0.34, blue: 0.84, alpha: 1.00)
        case .Deductions: return UIColor(red: 1.0, green: 0.38, blue: 0.53, alpha: 1.00)//rgba(255, 97, 136, 1)
        }
    }
    
    var headerGradientColors: [UIColor] {
        
        switch self {
        case .Revenue, .Fixed_Earning: return [UIColor(red: 144/255.0, green: 214/255.0, blue: 181/255.0, alpha: 1.00), UIColor(red: 52/255.0, green: 151/255.0, blue: 144/255.0, alpha: 1.00)]
        case .Sales, .Incentive: return [UIColor(red: 143/255.0, green: 228/255.0, blue: 242/255.0, alpha: 1.00), UIColor(red: 41/255.0, green: 118/255.0, blue: 196/255.0, alpha: 1.00)]
        case .FreeServices: return [UIColor(red: 255/255.0, green: 224/255.0, blue: 177/255.0, alpha: 1.00), UIColor(red: 232/255.0, green: 59/255.0, blue: 112/255.0, alpha: 1.00)]
        case .Footfall: return [UIColor(red: 1.00, green: 220/255.0, blue: 197/255.0, alpha: 1.00), UIColor(red: 255/255.0, green: 140/255.0, blue: 39/255.0, alpha: 1.00)]
        case .CustomerFeedback: return [UIColor(red: 0.57, green: 0.93, blue: 0.96, alpha: 1.00), UIColor(red: 0.25, green: 0.61, blue: 0.92, alpha: 1.00)]
        case .Productivity, .Bonus: return [UIColor(red: 163/255.0, green: 211/255.0, blue: 70/255.0, alpha: 1.00), UIColor(red: 68/255.0, green: 139/255.0, blue: 9/255.0, alpha: 1.00)]
        case .PenetrationRatios: return [UIColor(red: 1.0, green: 119/255.0, blue: 166/255.0, alpha: 1.00), UIColor(red: 176/255.0, green: 84/255.0, blue: 187/255.0, alpha: 1.00)]
        case .CustomerEngagement: return [UIColor(red: 175/255.0, green: 165/255.0, blue: 1.0, alpha: 1.00), UIColor(red: 138/255.0, green: 42/255.0, blue: 222/255.0, alpha: 1.00)]
        case .ResourceUtilisation: return [UIColor(red: 203/255.0, green: 240/255.0, blue: 1.0, alpha: 1.00), UIColor(red: 56/255.0, green: 91/255.0, blue: 100/255.0, alpha: 1.00)]
        case .Other_Earnings: return [UIColor(red: 212/255.0, green: 240/255.0, blue: 252/255.0, alpha: 1.00), UIColor(red: 73/255.0, green: 101/255.0, blue: 107/255.0, alpha: 1.00)]
        case .Awards: return [UIColor(red: 247/255.0, green: 156/255.0, blue: 177/255.0, alpha: 1.00), UIColor(red: 190/255.0, green: 91/255.0, blue: 205/255.0, alpha: 1.00)]
        case .Deductions: return [UIColor(red: 242/255.0, green: 112/255.0, blue: 156/255.0, alpha: 1.00), UIColor(red: 1.0, green: 148/255.0, blue: 114/255.0, alpha: 1.00)]
        }
    }
    
    var headerIcon: UIImage? {
        switch self {
        case .Revenue: return UIImage(named: "RevenueWhiteNew")
        case .Sales: return UIImage(named: "SalesWhiteNew")
        case .FreeServices: return UIImage(named: "FreeServicesWhiteNew")
        case .Footfall: return UIImage(named: "FootfallWhiteNew")
        case .CustomerFeedback: return UIImage(named: "CustomerFeedbackWhite")
        case .Productivity: return UIImage(named: "ProductivityWhite_New")
        case .PenetrationRatios: return UIImage(named: "PenetrationWhiteNew")
        case .CustomerEngagement: return UIImage(named: "EngagementWhiteNew")
        case .ResourceUtilisation: return UIImage(named: "UtilisationWhiteNew")
        case .Fixed_Earning: return UIImage(named: "FixedEarningsHeader")
        case .Incentive: return UIImage(named: "IncentiveHeader")
        case.Bonus: return UIImage(named: "BonusHeader")
        case .Other_Earnings: return UIImage(named: "OtherEarningsHeader")
        case .Awards: return UIImage(named: "AwardsHeader")
        case .Deductions: return UIImage(named: "DeductionsHeader")
        }
    }
    
    var headerTitle: String {
        switch self {
        case .Revenue: return "Total Revenue"
        case .Sales: return "Total Sales"
        case .FreeServices: return "Free Services"
        case .Footfall: return "Total Footfall"
        case .CustomerFeedback: return "Feedback Score"
        case .Productivity: return "Productivity"
        case .PenetrationRatios: return "Penetration Ratio"
        case .CustomerEngagement: return "Customer Engagement"
        case .ResourceUtilisation: return "Resource Utilisation"
        case .Fixed_Earning: return "Fixed Earning"
        case .Incentive: return "Incentive"
        case .Bonus: return "Bonus"
        case .Other_Earnings: return "Other Earnings"
        case .Awards: return "Awards"
        case .Deductions: return "Deductions"
        }
    }
    
    var isGraphAvailable: Bool {
        switch self {
        case .Revenue,.Sales, .FreeServices, .Footfall, .Fixed_Earning, .Incentive, .Bonus, .Other_Earnings, .Awards, .Deductions: return true
        case .CustomerEngagement,.ResourceUtilisation, .CustomerFeedback, .Productivity, .PenetrationRatios: return false
        }
    }
    
    var headerTileHeight: CGFloat {
        switch self {
        case .Revenue,.Sales, .FreeServices, .Footfall, .Fixed_Earning, .Incentive, .Bonus, .Other_Earnings, .Awards, .Deductions: return 126
        case .CustomerEngagement,.ResourceUtilisation, .CustomerFeedback, .Productivity, .PenetrationRatios: return 126
        }
    }
    
    var graphBarColor: [UIColor] {
        switch self {
        case .Revenue: return [UIColor(red: 0.08, green: 0.70, blue: 0.55, alpha: 1.00), UIColor(red: 0.90, green: 0.25, blue: 0.45, alpha: 1.00)]
        case .Sales: return [UIColor(red: 0.67, green: 0.91, blue: 0.78, alpha: 1.00), UIColor(red: 0.68, green: 0.87, blue: 0.99, alpha: 1.00)]//rgba(103, 185, 224, 1)
        case .FreeServices: return [UIColor(red: 1.00, green: 0.38, blue: 0.53, alpha: 1.00)]
        case .Footfall: return [UIColor(red: 1.00, green: 0.69, blue: 0.48, alpha: 1.00)]
        case .CustomerFeedback: return [UIColor(red: 0.50, green: 0.79, blue: 1.00, alpha: 1.00)]
        case .Productivity: return [UIColor(red: 0.78, green: 0.88, blue: 0.44, alpha: 1.00)]
        case .PenetrationRatios: return [UIColor(red: 0.88, green: 0.45, blue: 1.00, alpha: 1.00)]
        case .CustomerEngagement: return [UIColor(red: 0.71, green: 0.31, blue: 0.82, alpha: 1.00), UIColor(red: 0.36, green: 0.66, blue: 1.00, alpha: 1.00)]
        case .ResourceUtilisation: return [UIColor(red: 0.49, green: 0.65, blue: 0.71, alpha: 1.00), UIColor(red: 0.90, green: 0.25, blue: 0.45, alpha: 1.00)]
        case .Fixed_Earning: return [UIColor(red: 0.08, green: 0.70, blue: 0.55, alpha: 1.00), UIColor(red: 0.90, green: 0.25, blue: 0.45, alpha: 1.00)]
        case .Incentive: return [UIColor(red: 0.36, green: 0.53, blue: 0.90, alpha: 1.00)]//rgba(91, 134, 229, 1)
        case .Bonus: return [UIColor(red: 0.78, green: 0.88, blue: 0.44, alpha: 1.00)]
        case .Other_Earnings: return [UIColor(red: 0.33, green: 0.44, blue: 0.47, alpha: 1.00)]//rgba(84, 112, 119, 1)
        case .Awards: return [UIColor(red: 0.88, green: 0.45, blue: 1.00, alpha: 1.00)]
        case .Deductions: return [UIColor(red: 1.0, green: 0.38, blue: 0.53, alpha: 1.00)]//rgba(255, 97, 136, 1)
        }
    }
    
    var singleValueTileColor: UIColor? {
        switch self {
        case .Revenue: return UIColor(red: 0.75, green: 0.89, blue: 0.85, alpha: 1.00)
        case .Sales: return UIColor(red: 0.47, green: 0.79, blue: 0.91, alpha: 0.3)
        case .FreeServices: return UIColor(red: 0.96, green: 0.76, blue: 0.81, alpha: 1.00)
        case .Footfall: return UIColor(red: 1.00, green: 0.78, blue: 0.64, alpha: 1.00)
        case .CustomerFeedback: return UIColor(red: 0.50, green: 0.79, blue: 1.00, alpha: 1.00)
        case .Productivity: return UIColor(red: 0.79, green: 0.90, blue: 0.45, alpha: 1.00)
        case .CustomerEngagement: return UIColor(red: 0.77, green: 0.80, blue: 1.00, alpha: 1.00)
        case .ResourceUtilisation: return UIColor(red: 0.49, green: 0.65, blue: 0.71, alpha: 0.3)//rgba(125, 167, 181, 1)
        case .Fixed_Earning: return UIColor(red: 0.75, green: 0.89, blue: 0.85, alpha: 1.00)
        case .Incentive: return UIColor(red: 0.36, green: 0.53, blue: 0.90, alpha: 0.3)//rgba(91, 134, 229, 1)
        case .Bonus: return UIColor(red: 0.79, green: 0.90, blue: 0.45, alpha: 1.00)
        case .Other_Earnings: return UIColor(red: 0.85, green: 0.93, blue: 0.97, alpha: 1.00)
        case .Awards: return UIColor(red: 0.95, green: 0.75, blue: 1.0, alpha: 1.00)
        case .Deductions: return UIColor(red: 1.0, green: 0.38, blue: 0.53, alpha: 0.4) //rgba(255, 97, 136, 1)
        default: return nil
        }
    }
    
    var packageValueTileColor: UIColor? {
        switch self {
        case .Sales: return UIColor(red: 0.47, green: 0.79, blue: 0.91, alpha: 1.0)
        default: return nil
        }
    }
    
    var doubleValueTileColors: [UIColor]? {
        switch self {
        case .Sales: return [UIColor(red: 0.67, green: 0.91, blue: 0.78, alpha: 1.00), UIColor(red: 0.68, green: 0.87, blue: 0.99, alpha: 1.00)]
        case .PenetrationRatios: return [UIColor(red: 1.00, green: 0.91, blue: 0.70, alpha: 1.00), UIColor(red: 0.95, green: 0.75, blue: 1.00, alpha: 1.00)]
        case .CustomerEngagement: return [UIColor(red: 0.77, green: 0.80, blue: 1.00, alpha: 1.00), UIColor(red: 0.79, green: 0.67, blue: 1.00, alpha: 1.00)]
        default: return nil
        }
    }
    
    var tripleValueTileColors: [UIColor]? {
        switch self {
        case .PenetrationRatios: return [UIColor(red: 1.00, green: 0.87, blue: 0.65, alpha: 1.00), UIColor(red: 0.95, green: 0.75, blue: 1.00, alpha: 1.00), UIColor(red: 0.67, green: 0.95, blue: 0.82, alpha: 1.00)]
        case .ResourceUtilisation: return [UIColor(red: 0.67, green: 0.95, blue: 0.82, alpha: 1.00), UIColor(red: 1.00, green: 0.87, blue: 0.65, alpha: 1.00), UIColor(red: 0.85, green: 0.93, blue: 0.97, alpha: 1.00)]
        default: return nil
        }
    }
    
}

class EarningsHeaderDataModel {
    let earningsType: EarningDetails
    var value: Double?
    var isExpanded: Bool
    var dateRangeType:DateRangeType
    var customeDateRange:DateRange
    
    lazy var roundedValue:String? = {
        guard let v = value, v != 0.0 else { return "" }
            return v.roundedStringValue()
        }()
    
    init(earningsType: EarningDetails, value: Double, isExpanded: Bool, dateRangeType:DateRangeType, customeDateRange:DateRange) {
        self.earningsType = earningsType
        self.value = value
        self.isExpanded = isExpanded
        self.dateRangeType = dateRangeType
        self.customeDateRange = customeDateRange
    }
}

class EarningsCellDataModel {
    let earningsType: EarningDetails
    let title: String
    let value : [String]
    let subTitle: [String]
    let showGraph: Bool
    let cellType: EarningDetailsTileType
    var isExpanded: Bool
    var dateRangeType:DateRangeType
    var customeDateRange:DateRange
    
    init(earningsType: EarningDetails, title: String, value: [String] ,subTitle: [String], showGraph: Bool, cellType: EarningDetailsTileType, isExpanded: Bool, dateRangeType:DateRangeType, customeDateRange:DateRange) {
        self.earningsType = earningsType
        self.title = title
        self.value = value
        self.subTitle = subTitle
        self.showGraph = showGraph
        self.cellType = cellType
        self.isExpanded = isExpanded
        self.dateRangeType = dateRangeType
        self.customeDateRange = customeDateRange
    }
}

enum GraphType {
    case linedGraph, barGraph
}

struct GraphDataEntry {
    let graphType: GraphType
    let dataTitle: String
    let units: [String]
    let values: [Double]
    let barColor: UIColor
}


enum EarningDetailsTileType {
    case SingleValue, DoubleValue, PackageType, TripleValue
}
