//
//  SalesViewController.swift
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

protocol SalesDisplayLogic: class
{
  func displaySomething(viewModel: Sales.Something.ViewModel)
}

class SalesViewController: UIViewController, SalesDisplayLogic
{
  var interactor: SalesBusinessLogic?
  var router: (NSObjectProtocol & SalesRoutingLogic & SalesDataPassing)?

    @IBOutlet private weak var tableView: UITableView!
    var headerModel: EarningsHeaderDataModel?
    var headerGraphData: GraphDataEntry?
    
    var dataModels = [EarningsCellDataModel]()
    var graphData = [GraphDataEntry]()
    
    var dateSelectedTitle : String = ""
    
    var fromFilters : Bool = false
    
    var fromChartFilter : Bool = false
    
    var dateRangeType : DateRangeType = .mtd
    var salesCutomeDateRange:DateRange = DateRange(Date.today.lastYear(), Date.today)
    
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = SalesInteractor()
    let presenter = SalesPresenter()
    let router = SalesRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    tableView.register(UINib(nibName: CellIdentifier.earningDetailsHeaderCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.earningDetailsHeaderCell)
    tableView.register(UINib(nibName: CellIdentifier.earningDetailsCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.earningDetailsCell)
    dateRangeType = .mtd
    updateSalesScreenData(startDate: Date.today.startOfMonth)
  }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: "Sales")
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = Sales.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Sales.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    func updateSalesScreenData(startDate: Date?, endDate: Date = Date().startOfDay) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        salesData(startDate:  startDate ?? Date.today, endDate: endDate)
    }
    
    func salesData(startDate : Date, endDate : Date = Date().startOfDay) {
        
        //Handled Wrong function calling to avoid data mismatch
        guard fromChartFilter == false else {
            print("******* Wrong Function Called **********")
            return
        }
        
        dataModels.removeAll()
        graphData.removeAll()
        
        let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
        
        
        let filteredSales = technicianDataJSON?.data?.revenue_transactions?.filter({ (sales) -> Bool in
            if let date = sales.date?.date()?.startOfDay {
                
                return date >= startDate && date <= endDate
            }
            return false
        })
        
        let dateRange = DateRange(startDate, endDate)
        var graphRangeType = dateRangeType
        var graphDateRange = dateRange
        var filteredSalesForGraph = filteredSales
        if (dateRangeType == .yesterday || dateRangeType == .today) {
            filteredSalesForGraph = nil
            graphRangeType = .mtd
            graphDateRange = DateRange(graphRangeType.date!, Date().startOfDay)
        }
        
        var membershipRevenueCount : Double = 0.0
        var membershipRenewRevenueCount : Double = 0.0
        var valuePackageRevenueCount : Double = 0.0
        var servicePackageRevenueCount : Double = 0.0
        
        for sales in filteredSales ?? [] {
            // membership revenue
            if let membershipRevenue = sales.membership_new_revenue, membershipRevenue > 0 {
                membershipRevenueCount += membershipRevenue
            }
            if let membershipRevenue = sales.membership_renew_revenue, membershipRevenue > 0 {
                membershipRenewRevenueCount += membershipRevenue
            }
            
            // value package revenue
            if let valuePackageRebenue = sales.value_package_revenue, valuePackageRebenue > 0 {
                valuePackageRevenueCount += valuePackageRebenue
            }
            
            // service_package_revenue
            if let servicePackageRevenue = sales.service_package_revenue, servicePackageRevenue > 0 {
                servicePackageRevenueCount += servicePackageRevenue
            }
        }
        
        print("membershipRevenueCount \(membershipRevenueCount)")
        print("membershipRenewRevenueCount \(membershipRenewRevenueCount)")
        print("valuePackageRevenueCount \(valuePackageRevenueCount)")
        print("servicePackageRevenueCount \(servicePackageRevenueCount)")
        
        //membership revenue
        //Data Model
        let membershipSalesModel = EarningsCellDataModel(earningsType: .Sales, title: "Membership", value: [(membershipRevenueCount + membershipRenewRevenueCount).roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: salesCutomeDateRange)
        dataModels.append(membershipSalesModel)
        //Graph Data
        graphData.append(getGraphEntry(membershipSalesModel.title, forData: filteredSalesForGraph, atIndex: 0, dateRange: graphDateRange, dateRangeType: graphRangeType))
        
        //value package revenue
        //Data Model
        let valuePackageSalesModel = EarningsCellDataModel(earningsType: .Sales, title: "Value Package", value: [valuePackageRevenueCount.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: salesCutomeDateRange)
        dataModels.append(valuePackageSalesModel)
        //Graph Data
        graphData.append(getGraphEntry(valuePackageSalesModel.title, forData: filteredSalesForGraph, atIndex: 1, dateRange: graphDateRange, dateRangeType: graphRangeType))
        
        //service_package_revenue
        //Data Model
        let servicePackageSalesModel = EarningsCellDataModel(earningsType: .Sales, title: "Service Package", value: [servicePackageRevenueCount.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: salesCutomeDateRange)
        dataModels.append(servicePackageSalesModel)
        //Graph Data
        graphData.append(getGraphEntry(servicePackageSalesModel.title, forData: filteredSalesForGraph, atIndex: 2, dateRange: graphDateRange, dateRangeType: graphRangeType))
        
        //Total Revenue for Header data
        headerModel =  EarningsHeaderDataModel(earningsType: .Sales, value: (membershipRevenueCount + valuePackageRevenueCount + servicePackageRevenueCount), isExpanded: false, dateRangeType: graphRangeType, customeDateRange: salesCutomeDateRange)
    
        headerModel?.dateRangeType = graphRangeType
        headerGraphData = getTotalSalesGraphEntry(forData: filteredSalesForGraph, dateRange: graphDateRange, dateRangeType: graphRangeType)
        
        tableView.reloadData()
        EZLoadingActivity.hide()
    }
    
    //Graph functions
    func getGraphEntry(_ title:String, forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, atIndex index : Int, dateRange:DateRange, dateRangeType: DateRangeType) -> GraphDataEntry
    {
        let units = xAxisUnits(forDateRange: dateRange, rangeType: dateRangeType)
        let values = graphData(forData: data, atIndex: index, dateRange: dateRange, dateRangeType: dateRangeType)
        if(index == 0){//for New and Renewal
            let graphColor = EarningDetails.Sales.graphBarColor
            
            return GraphDataEntry(graphType: .barGraph, dataTitle: title, units: units, values: values, barColor: graphColor.first!)
        }
        else {
            //singleValueTileColor
            let graphColor = EarningDetails.Sales.packageValueTileColor!
            
            return GraphDataEntry(graphType: .barGraph, dataTitle: title, units: units, values: values, barColor: graphColor)
        }
    }
    
    func graphData(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, atIndex index : Int, dateRange:DateRange, dateRangeType: DateRangeType) -> [Double] {
        
        var filteredSales = data
        
        if data == nil, (data?.count ?? 0 <= 0) {
            let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
            filteredSales = technicianDataJSON?.data?.revenue_transactions?.filter({ (sales) -> Bool in
                if let date = sales.date?.date()?.startOfDay {
                    
                    return date >= dateRange.start && date <= dateRange.end
                }
                return false
            })
        }
        
        if(index == 0){//Membership revenue
            return calculateMembershipRevenue(filterArray: filteredSales ?? [], dateRange: dateRange, dateRangeType: dateRangeType)
        }
        else if(index == 1){ //value package
            return calculateValuePackageSales(filterArray: filteredSales ?? [], dateRange: dateRange, dateRangeType: dateRangeType)
        }
        else {//service package sales
            return calculateServicePackageSales(filterArray: filteredSales ?? [], dateRange: dateRange, dateRangeType: dateRangeType)
        }
    }
    //fucntions for values as per tile
    func calculateMembershipRevenue(filterArray: [Dashboard.GetRevenueDashboard.Revenue_transaction],  dateRange:DateRange, dateRangeType: DateRangeType) -> [Double]{
        var salesValue = [Double]()
        //membership sales
        
        let membershipRevenue = filterArray.filter({$0.membership_new_revenue ?? 0 > 0})
        
        switch dateRangeType
        {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                let data = membershipRevenue.filter({$0.date == objDt})
                let value = data.compactMap({$0.membership_new_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                let data = membershipRevenue.filter({($0.date?.contains(month)) ?? false})
                let value = data.compactMap({$0.membership_new_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    let data = membershipRevenue.filter({($0.date?.contains(month)) ?? false})
                    let value = data.compactMap({$0.membership_new_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    let data = membershipRevenue.filter({$0.date == objDt})
                    let value = data.compactMap({$0.membership_new_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
        }
        return salesValue
    }
    
    func calculateValuePackageSales(filterArray: [Dashboard.GetRevenueDashboard.Revenue_transaction],  dateRange:DateRange, dateRangeType: DateRangeType) -> [Double]{ //value package sales
        var salesValue = [Double]()
        
        let valuePackageRevenue = filterArray.filter({$0.value_package_revenue ?? 0 > 0})
        
        switch dateRangeType
        {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                let data = valuePackageRevenue.filter({$0.date == objDt})
                let value = data.compactMap({$0.value_package_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                let data = valuePackageRevenue.filter({($0.date?.contains(month)) ?? false})
                let value = data.compactMap({$0.value_package_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    let data = valuePackageRevenue.filter({($0.date?.contains(month)) ?? false})
                    let value = data.compactMap({$0.value_package_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    let data = valuePackageRevenue.filter({$0.date == objDt})
                    let value = data.compactMap({$0.value_package_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
        }
        return salesValue
    }
    func calculateServicePackageSales(filterArray: [Dashboard.GetRevenueDashboard.Revenue_transaction],  dateRange:DateRange, dateRangeType: DateRangeType) -> [Double]{ //
        var salesValue = [Double]()
        
        let servicePackageRevenue = filterArray.filter({$0.service_package_revenue ?? 0 > 0})
        
        switch dateRangeType
        {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                let data = servicePackageRevenue.filter({$0.date == objDt})
                let value = data.compactMap({$0.service_package_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                let data = servicePackageRevenue.filter({($0.date?.contains(month)) ?? false})
                let value = data.compactMap({$0.service_package_revenue}).reduce(0){$0 + $1}
                salesValue.append(value)
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    let data = servicePackageRevenue.filter({($0.date?.contains(month)) ?? false})
                    let value = data.compactMap({$0.service_package_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    let data = servicePackageRevenue.filter({$0.date == objDt})
                    let value = data.compactMap({$0.service_package_revenue}).reduce(0){$0 + $1}
                    salesValue.append(value)
                }
            }
        }
        
        return salesValue
    }
    
    func getTotalSalesGraphEntry(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, dateRange:DateRange, dateRangeType: DateRangeType) -> GraphDataEntry
    {
        let units = xAxisUnits(forDateRange: dateRange, rangeType: dateRangeType)
        let values = totalSalesGraphData(forData: data, dateRange: dateRange, dateRangeType: dateRangeType)
        let graphColor = EarningDetails.Sales.packageValueTileColor!
        
        return GraphDataEntry(graphType: .barGraph, dataTitle: "Total Sales", units: units, values: values, barColor: graphColor)
    }
    
    func totalSalesGraphData(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, dateRange:DateRange, dateRangeType: DateRangeType) -> [Double]
    {
        var totalSales = [Double]()
        var filteredSales = data
        
        //Fetch Data incase not having filtered already
        if data == nil, (data?.count ?? 0 <= 0) {
            let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
            
            //Date filter applied
            filteredSales = technicianDataJSON?.data?.revenue_transactions?.filter({ (freeService) -> Bool in
                if let date = freeService.date?.date()?.startOfDay {
                    return  (date >= dateRange.start && date <= dateRange.end) &&
                        ((freeService.membership_new_revenue ?? 0 > 0) ||
                            (freeService.value_package_revenue ?? 0 > 0) ||
                            (freeService.service_package_revenue ?? 0 > 0 ))
                }
                return false
            })
        }
        else {
            filteredSales = filteredSales?.filter({($0.membership_new_revenue ?? 0 > 0) ||
                                                    ($0.value_package_revenue ?? 0 > 0) ||
                                                    ($0.service_package_revenue ?? 0 > 0 )})
        }
        
        switch dateRangeType
        {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                if let data = filteredSales?.filter({$0.date == objDt}).map({$0.total}), data.count > 0
                {
                    let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                    totalSales.append(Double(value))
                }
                else {
                    totalSales.append(Double(0.0))
                }
            }
            
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                if let data = filteredSales?.filter({($0.date?.contains(month)) ?? false}).map({$0.total}), data.count > 0
                {
                    let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                    totalSales.append(Double(value))
                }
                else {
                    totalSales.append(Double(0.0))
                }
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    if let data = filteredSales?.filter({($0.date?.contains(month)) ?? false}).map({$0.total}), data.count > 0
                    {
                        let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                        totalSales.append(Double(value))
                    }
                    else {
                        totalSales.append(Double(0.0))
                    }
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    if let data = filteredSales?.filter({$0.date == objDt}).map({$0.total}), data.count > 0
                    {
                        let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                        totalSales.append(Double(value))
                    }
                    else {
                        totalSales.append(Double(0.0))
                    }
                }
            }
        }
        
        return totalSales
    }
}

//extension SalesViewController: EarningsFilterDelegate {
//    
//    func actionDateFilter() {
//        let vc = DateFilterVC.instantiate(fromAppStoryboard: .Earnings)
//        self.view.alpha = screenPopUpAlpha
//        vc.fromChartFilter = false
//        vc.selectedRangeTypeString = dateRangeType.rawValue
//        vc.cutomRange = salesCutomeDateRange
//        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//        vc.viewDismissBlock = { [unowned self] (result, startDate, endDate, rangeTypeString) in
//            // Do something
//            self.view.alpha = 1.0
//            if(result){
//                fromChartFilter = false
//                dateRangeType = DateRangeType(rawValue: rangeTypeString ?? "") ?? .cutome
//                
//                if(dateRangeType == .cutome), let start = startDate, let end = endDate
//                {
//                    salesCutomeDateRange = DateRange(start,end)
//                }
//                updateSalesScreenData(startDate: startDate ?? Date.today, endDate: endDate ?? Date.today)
//            }
//        }
//    }
//    
//    func actionNormalFilter() {
//        print("Normal Filter")
//    }
//}

extension SalesViewController: EarningDetailsDelegate {
    
    func reloadData() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func actionDurationFilter(forCell cell: UITableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell), dataModels.count >= indexPath.row else { return }
//
//        let selectedIndex = indexPath.row - 1
//
//        let vc = DateFilterVC.instantiate(fromAppStoryboard: .Incentives)
//        vc.isFromProductivity = false
//        self.view.alpha = screenPopUpAlpha
//        vc.fromChartFilter = true
//        if(selectedIndex >= 0){
//            let model = dataModels[selectedIndex]
//            vc.selectedRangeTypeString = model.dateRangeType.rawValue
//            vc.cutomRange = model.customeDateRange
//        }
//        else if let model = headerModel {
//            vc.selectedRangeTypeString = model.dateRangeType.rawValue
//            vc.cutomRange = model.customeDateRange
//        }
//        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//        vc.viewDismissBlock = { [unowned self] (result, startDate, endDate, rangeTypeString) in
//            // Do something
//            self.view.alpha = 1.0
//            if result == true, startDate != nil, endDate != nil {
//                fromFilters = false
//                fromChartFilter = true
//
//                let rangeType  = DateRangeType(rawValue: rangeTypeString ?? "") ?? .cutome
//                updateSalesScreenData(atIndex: indexPath, withStartDate: startDate, endDate: endDate!, rangeType: rangeType)
//
//                tableView.reloadRows(at: [indexPath], with: .automatic)
//                let text = "You have selected \(rangeTypeString ?? "MTD") filter from Charts."
//                self.showToast(alertTitle: alertTitle, message: text, seconds: toastMessageDuration)
//            }
//        }
    }
    
    func actionPackageFilter(forCell cell: UITableViewCell) {
        let vc = PackageFilterViewController.instantiate(fromAppStoryboard: .Incentives)
        self.view.alpha = screenPopUpAlpha
        guard let earningsCell = cell as? EarningDetailsCell, let index = tableView.indexPath(for: cell)?.row, dataModels.count >= index else {
            return
        }
        let seletcedIndex = index - 1
        
        if(dataModels[seletcedIndex].title == "Value Package Sales")
        {
            vc.filterType = "Value"
        }
        else  if(dataModels[seletcedIndex].title == "Service Package Sales"){
            vc.filterType = "Service"
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        vc.viewDismissBlock = { [unowned self] (result, sku) in
            // Do something
            self.view.alpha = 1.0
            if(result){
                print("SKU \(sku)")
                updateDataUsingPackageFilters(forCell: cell, withSKU: sku, packageType: PackageType.value)
            }
        }
    }
    
    
    func updateDataUsingPackageFilters(forCell cell: UITableViewCell, withSKU sku : String, packageType : String){
        
        guard let earningsCell = cell as? EarningDetailsCell, let index = tableView.indexPath(for: cell)?.row, dataModels.count >= index else {
            return
        }
        let seletcedIndex = index - 1
        
        let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
        
        var servicePackageRevenueCount : Double = 0.0
        var valuePackageRevenueCount : Double = 0.0
        
        if(earningsCell.model.title  == "Value Package Sales"){
            
            //service_package_revenue
            let valuePackageRevenue = technicianDataJSON?.data?.revenue_transactions?.filter({$0.value_package_revenue ?? 0 > 0})
            
            for objvaluePackageRevenue in valuePackageRevenue! {
                if(objvaluePackageRevenue.sku == sku){
                    valuePackageRevenueCount = valuePackageRevenueCount + objvaluePackageRevenue.value_package_revenue!
                }
            }
            print("value PackageRevenueCountafter filter \(valuePackageRevenueCount)")
            
            let valuePackageSalesModel = EarningsCellDataModel(earningsType: .Sales, title: "Value Package Sales", value: [valuePackageRevenueCount.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .PackageType, isExpanded: false, dateRangeType: dateRangeType, customeDateRange: salesCutomeDateRange)
            
            dataModels[seletcedIndex] = valuePackageSalesModel
        }
        else if(earningsCell.model.title  == "Service Package Sales"){
            
            //service_package_revenue
            let servicePackageRevenue = technicianDataJSON?.data?.revenue_transactions?.filter({$0.service_package_revenue ?? 0 > 0})
            
            for objServicePackageRevenue in servicePackageRevenue! {
                if(objServicePackageRevenue.sku == sku){
                    servicePackageRevenueCount = servicePackageRevenueCount + objServicePackageRevenue.service_package_revenue!
                }
            }
            print("servicePackageRevenueCountafter filter \(servicePackageRevenueCount)")
            
            let servicePackageSalesModel = EarningsCellDataModel(earningsType: .Sales, title: "Service Package Sales", value: [servicePackageRevenueCount.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .PackageType, isExpanded: false, dateRangeType: dateRangeType, customeDateRange: salesCutomeDateRange)
            
            dataModels[seletcedIndex] = servicePackageSalesModel
            
        }
        
        tableView.reloadData()
    }
}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.earningDetailsHeaderCell, for: indexPath) as? EarningDetailsHeaderCell else {
                return UITableViewCell()
            }
            if let model = headerModel {
                var data:[GraphDataEntry] = []
                if let hGraphData = headerGraphData {
                    data = [hGraphData]
                }
                cell.configureCell(model: model, data: data)
                
            }
            cell.delegate = self
            cell.parentVC = self
            
            cell.selectionStyle = .none
            return cell
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.earningDetailsCell, for: indexPath) as? EarningDetailsCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.parentVC = self
            let index = indexPath.row - 1
            let model = dataModels[index]
            let barGraph = graphData[index]
            
            cell.configureCell(model: model, data: [barGraph])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.earningDetailsHeaderFilterCell) as? EarningDetailsHeaderFilterCell else {
//            return UITableViewCell()
//        }
//        cell.delegate = self
//        cell.configureCell(showDateFilter: true, showNormalFilter: false, titleForDateSelection: dateRangeType.rawValue)
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
}
