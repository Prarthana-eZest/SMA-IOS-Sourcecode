//
//  RevenuesViewController.swift
//  Enrich_SMA
//
//  Created by Harshal on 25/01/22.
//  Copyright (c) 2022 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RevenuesDisplayLogic: class
{
  func displaySomething(viewModel: Revenues.Something.ViewModel)
}

//typealias DateRange = (start:Date, end:Date)

typealias BarLineGraphEntry = (barGraph:GraphDataEntry, lineGraph:GraphDataEntry)

class RevenuesViewController: UIViewController, RevenuesDisplayLogic, RevenueDisplayLogic
{
    func displaySomething(viewModel: Revenues.Something.ViewModel) {
        
    }
    
    func displaySuccess<T>(viewModel: T) where T : Decodable {
        
    }
    
    func displayError(errorMessage: String?) {
        
    }
    
    var interactor: RevenueBusinessLogic?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomFilterView: BottomFilterView!
    
    var headerModel: EarningsHeaderDataModel?
    var headerGraphDataGraphEntries:BarLineGraphEntry?
    
    var selectedFilters:[String: String]?
    
    var dataModels = [EarningsCellDataModel]()
    
    var barGraphData = [GraphDataEntry]()
    var lineGraphData = [GraphDataEntry]()
    
    var fromFilters : Bool = false
    
    var fromChartFilter : Bool = false
    
    var dateRangeType : DateRangeType = .mtd
    var revenueCutomeDateRange:DateRange = DateRange(Date.today.lastYear(), Date.today)
        
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
        let interactor = RevenueInteractor()
        let presenter = RevenuePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bottomFilterView.delegate = self
        //doSomething()
        tableView.register(UINib(nibName: CellIdentifier.earningDetailsHeaderCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.earningDetailsHeaderCell)
    
        tableView.register(UINib(nibName: CellIdentifier.earningDetailsCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.earningDetailsCell)
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: UserDefauiltsKeys.k_key_CustomDateRangeSelected)
        userDefaults.synchronize()
        fromFilters = false
        fromChartFilter = false
        dateRangeType = .mtd
        updateRevenueScreenData(startDate: Date.today.startOfMonth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: "Back")
    }
    
    // MARK: Do something

    
    func updateRevenueScreenData(startDate: Date?, endDate: Date = Date().startOfDay) {
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        //        DispatchQueue.main.async { [unowned self] () in
        revenueData(startDate: startDate ?? Date.today, endDate: endDate, otherFilters: selectedFilters, completion: nil)
        //        }
    }
    
    
    func updateRevenueScreenData(atIndex indexPath:IndexPath, withStartDate startDate: Date?, endDate: Date = Date().startOfDay, rangeType:DateRangeType) {
        let selectedIndex = indexPath.row - 1
        let dateRange = DateRange(startDate!, endDate)
    
        //Date filter applied
        let dateFilteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
            if let date = revenue.date?.date()?.startOfDay {
                return date >= dateRange.start && date <= dateRange.end
            }
            return false
        })
        
        
        //Update Data for Index
        if(selectedIndex >= 0){
            let model = dataModels[selectedIndex]
            model.dateRangeType = rangeType
            if model.dateRangeType == .cutome {
                model.customeDateRange = dateRange
            }
            
            update(modeData: model, withData: dateFilteredRevenue, otherFilters: selectedFilters, atIndex: selectedIndex, dateRange: dateRange, dateRangeType: rangeType)
            let graphData = getBarLineGraphEntry(model.title, forData: dateFilteredRevenue, otherFilters: selectedFilters, atIndex: selectedIndex, dateRange: dateRange, dateRangeType: rangeType)
            barGraphData[selectedIndex] = graphData.barGraph
            lineGraphData[selectedIndex] = graphData.lineGraph
        }
        else if let _ = headerModel {
            headerModel?.dateRangeType = rangeType
            if headerModel?.dateRangeType == .cutome {
                headerModel?.customeDateRange = dateRange
            }
            
            updateHeaderModel(withData: dateFilteredRevenue, otherFilters: selectedFilters, dateRange: dateRange, dateRangeType: rangeType)
            headerGraphDataGraphEntries = getTotalRevenueBarLineGraphEntry(forData: dateFilteredRevenue, dateRange: dateRange, dateRangeType: rangeType)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func update(modeData:EarningsCellDataModel, withData data: [Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, otherFilters : [String: String]?, atIndex index : Int, dateRange:DateRange, dateRangeType: DateRangeType) {
        
        var filteredRevenue = data
        
        //Fetch Data incase not having filtered already
        if data == nil, (data?.count ?? 0 <= 0) {
            //Date filter applied
            filteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
                if let date = revenue.date?.date()?.startOfDay {
                    return date >= dateRange.start && date <= dateRange.end
                }
                return false
            })
        }
        
        //Other Filters Applied
        //Gender
        if let gender = otherFilters?["gender"], gender != "All Genders"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.service_gender == gender })
        }
        
        //Category
        if let category = otherFilters?["category"], category != "All Categories"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.category == category })
        }
        
        //Sub-Category
        if let subCategory = otherFilters?["subCategory"], subCategory != "All Categories"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.sub_category == subCategory })
        }
        
        var value : Double = 0.0
        for revenue in filteredRevenue ?? [] {
            
            switch index {
            case 0:
                // Salon Service Revenue Data
                if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon) {
                    value += Double(revenue.total ?? 0.0)
                }
                
            case 1:
                // Home Service Revenue Data
                if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home) {
                    value += Double(revenue.total ?? 0.0)
                }
                
            case 2:
                // Retail Products Revenue Data
                if (revenue.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail) {
                    value += Double(revenue.total ?? 0.0)
                }
            default:
                continue
            }
        }
        dataModels[index] = EarningsCellDataModel(earningsType: modeData.earningsType, title: modeData.title, value: [value.roundedStringValue()], subTitle: modeData.subTitle, showGraph: modeData.showGraph, cellType: modeData.cellType, isExpanded: modeData.isExpanded, dateRangeType: modeData.dateRangeType, customeDateRange: modeData.customeDateRange)
    }
    
    
    func updateHeaderModel(withData data: [Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, otherFilters : [String: String]?, dateRange:DateRange, dateRangeType: DateRangeType) {
        
        var filteredRevenue = data
        
        //Fetch Data incase not having filtered already
        if data == nil, (data?.count ?? 0 <= 0) {

            //Date filter applied
            filteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
                if let date = revenue.date?.date()?.startOfDay {
                    return date >= dateRange.start && date <= dateRange.end
                }
                return false
            })
        }
        
        //Other Filters Applied
        //Gender
        if let gender = otherFilters?["gender"], gender != "All Genders"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.service_gender == gender })
        }
        
        //Category
        if let category = otherFilters?["category"], category != "All Categories"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.category == category })
        }
        
        //Sub-Category
        if let subCategory = otherFilters?["subCategory"], subCategory != "All Categories"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.sub_category == subCategory })
        }
        
        var salonServiceToatal:Double = 0.0
        var homeServiceTotal:Double = 0.0
        var retailTotal:Double = 0.0
        
        for revenue in filteredRevenue ?? [] {
            
            // Retail Products Revenue Data
            if (revenue.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail) {
                retailTotal += Double(revenue.total ?? 0.0)
            }
            
            // Salon Service Revenue Data
            if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon) {
                salonServiceToatal += Double(revenue.total ?? 0.0)
            }
            
            // Home Service Revenue Data
            if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home) {
                homeServiceTotal += Double(revenue.total ?? 0.0)
            }
        }
        
        headerModel?.value = salonServiceToatal + homeServiceTotal + retailTotal
    }
    
    func revenueData(startDate : Date, endDate : Date = Date().startOfDay, otherFilters : [String: String]?, completion: (() -> Void)? ) {
        
        //Handled Wrong function calling to avoid data mismatch
        guard fromChartFilter == false else {
            print("******* Wrong Function Called **********")
            completion?()
            return
        }
        
        dataModels.removeAll()
        barGraphData.removeAll()
        lineGraphData.removeAll()
    
        //Date filter applied
        var filteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
            if let date = revenue.date?.date()?.startOfDay {
                return date >= startDate && date <= endDate
            }
            return false
        })
        
        //Other Filters Applied
        //Gender
        if let gender = otherFilters?["gender"], gender != "All Genders"
        {
            filteredRevenue = filteredRevenue?.filter({ $0.service_gender == gender })
        }
        
        //Category
        if let category = otherFilters?["category"], category != "All Categories" {
            filteredRevenue = filteredRevenue?.filter({ $0.category == category })
        }
        
        //Sub-Category
        if let subCategory = otherFilters?["subCategory"], subCategory != "All Categories" {
            filteredRevenue = filteredRevenue?.filter({ $0.sub_category == subCategory })
        }
        
        //Handle Graph Scenarios
        let dateRange = DateRange(startDate, endDate)
        var graphRangeType = dateRangeType
        var graphDateRange = dateRange
        var filteredRevenueForGraph = filteredRevenue
        if (dateRangeType == .yesterday || dateRangeType == .today) {
            filteredRevenueForGraph = nil
            graphRangeType = .mtd
            graphDateRange = DateRange(graphRangeType.date!, Date().startOfDay)
        }
        
        var salonServiceToatal:Double = 0.0
        var homeServiceTotal:Double = 0.0
        var retailTotal:Double = 0.0
        
        for revenue in filteredRevenue ?? [] {
            
            
            // Retail Products Revenue Data
            if (revenue.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail) {
                retailTotal += Double(revenue.total ?? 0.0)
            }
            
            // Salon Service Revenue Data
            if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon) {
                salonServiceToatal += Double(revenue.total ?? 0.0)
            }
            
            // Home Service Revenue Data
            if (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home) {
                homeServiceTotal += Double(revenue.total ?? 0.0)
            }
        }
        
        print("serviceToatal conunt : \(salonServiceToatal)")
        print("homeServiceTotal conunt : \(homeServiceTotal)")
        print("retail conunt : \(retailTotal)")
        
        // Salon Service Revenue
        //Model Data
        let salonServiceRevenueModel = EarningsCellDataModel(earningsType: .Revenue, title: "Salon Service Revenue", value: [salonServiceToatal.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: revenueCutomeDateRange)
        dataModels.append(salonServiceRevenueModel)
        //GraphDate
        let salonServiceGraphEntries = getBarLineGraphEntry(salonServiceRevenueModel.title, forData: filteredRevenueForGraph, otherFilters: otherFilters, atIndex: 0, dateRange: graphDateRange, dateRangeType: graphRangeType)
        barGraphData.append(salonServiceGraphEntries.barGraph)
        lineGraphData.append(salonServiceGraphEntries.lineGraph)
        
        
        // Home Service Revenue Data
        let homeServiceRevenueModel = EarningsCellDataModel(earningsType: .Revenue, title: "Home Service Revenue", value: [homeServiceTotal.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: revenueCutomeDateRange)
        dataModels.append(homeServiceRevenueModel)
        //GraphDate
        let homeServiceGraphEntries = getBarLineGraphEntry(homeServiceRevenueModel.title, forData: filteredRevenueForGraph, otherFilters: otherFilters, atIndex: 1, dateRange: graphDateRange, dateRangeType: graphRangeType)
        barGraphData.append(homeServiceGraphEntries.barGraph)
        lineGraphData.append(homeServiceGraphEntries.lineGraph)
        
        
        // Retail Products Revenue Data
        let retailProductsRevenueModel = EarningsCellDataModel(earningsType: .Revenue, title: "Retail Products Revenue", value: [retailTotal.roundedStringValue()], subTitle: [""], showGraph: true, cellType: .SingleValue, isExpanded: false, dateRangeType: graphRangeType, customeDateRange: revenueCutomeDateRange)
        dataModels.append(retailProductsRevenueModel)
        //GraphDate
        let retailServiceGraphEntries = getBarLineGraphEntry(retailProductsRevenueModel.title, forData: filteredRevenueForGraph, otherFilters: otherFilters, atIndex: 2, dateRange: graphDateRange, dateRangeType: graphRangeType)
        barGraphData.append(retailServiceGraphEntries.barGraph)
        lineGraphData.append(retailServiceGraphEntries.lineGraph)
        
       
        //Total Revenue for Header data
        headerModel =  EarningsHeaderDataModel(earningsType: .Revenue, value: (salonServiceToatal + homeServiceTotal + retailTotal), isExpanded: false, dateRangeType: graphRangeType, customeDateRange: revenueCutomeDateRange)
    
        headerModel?.dateRangeType = graphRangeType
        headerGraphDataGraphEntries = getTotalRevenueBarLineGraphEntry(forData: filteredRevenueForGraph, dateRange: graphDateRange, dateRangeType: graphRangeType)
        
        
        completion?()
        
        tableView.reloadData()
        EZLoadingActivity.hide()
    }
    
    func getBarLineGraphEntry(_ title:String, forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, otherFilters : [String: String]?, atIndex index : Int, dateRange:DateRange, dateRangeType: DateRangeType) -> BarLineGraphEntry
    {
        let units = xAxisUnits(forDateRange: dateRange, rangeType: dateRangeType)
        let values = graphData(forData: data, otherFilters: otherFilters, atIndex: index, dateRange: dateRange, dateRangeType: dateRangeType)
        let graphColor = EarningDetails.Revenue.graphBarColor
        
        let barGraphEntry = GraphDataEntry(graphType: .barGraph, dataTitle: "Achieved Value", units: units, values: values, barColor: graphColor.first!)
        
        
        let lineGraphEntry = GraphDataEntry(graphType: .linedGraph, dataTitle: "Target Value", units: units, values: graphData(forData: [], otherFilters: otherFilters, atIndex: index, dateRange: dateRange, dateRangeType: dateRangeType), barColor: graphColor.last!)
        
        return BarLineGraphEntry(barGraphEntry, lineGraphEntry)
    }
    
    func getTotalRevenueBarLineGraphEntry(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, dateRange:DateRange, dateRangeType: DateRangeType) -> BarLineGraphEntry
    {
        let units = xAxisUnits(forDateRange: dateRange, rangeType: dateRangeType)
        let values = totalRevenueGraphData(forData: data, dateRange: dateRange, dateRangeType: dateRangeType)
        let graphColor = EarningDetails.Revenue.graphBarColor
        
        let barGraphEntry = GraphDataEntry(graphType: .barGraph, dataTitle: "Achieved Value", units: units, values: values, barColor: graphColor.first!)
        
        
        let lineGraphEntry = GraphDataEntry(graphType: .linedGraph, dataTitle: "Target Value", units: units, values: totalRevenueGraphData(forData: [], dateRange: dateRange, dateRangeType: dateRangeType), barColor: graphColor.last!)
        
        return BarLineGraphEntry(barGraphEntry, lineGraphEntry)
    }
    
    func graphData(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, otherFilters : [String: String]?, atIndex index : Int, dateRange:DateRange, dateRangeType: DateRangeType) -> [Double] {
        
        var dataForBar = [Double]()
        var filteredRevenue = data
        
        //Fetch Data incase not having filtered already
        if data == nil, (data?.count ?? 0 <= 0) {
           
            //Date filter applied
            filteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
                if let date = revenue.date?.date()?.startOfDay {
                    return date >= dateRange.start && date <= dateRange.end
                }
                return false
            })
            
            //Gender
            if let gender = otherFilters?["gender"], gender != "All Genders"
            {
                filteredRevenue = filteredRevenue?.filter({ $0.service_gender == gender })
            }
            
            //Category
            if let category = otherFilters?["category"], category != "All Categories"
            {
                filteredRevenue = filteredRevenue?.filter({ $0.category == category })
            }
            
            //Sub-Category
            if let subCategory = otherFilters?["subCategory"], subCategory != "All Categories"
            {
                filteredRevenue = filteredRevenue?.filter({ $0.sub_category == subCategory })
            }
        }
        
        //salon service
        if (index == 0) {
            filteredRevenue = filteredRevenue?.filter({($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon)})
        }
        else if (index == 1) {//Home services
            filteredRevenue = filteredRevenue?.filter({($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home)})
        }
        else { //retail
            filteredRevenue = filteredRevenue?.filter({($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail)})
        }
        
        switch dateRangeType
        {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                let data = filteredRevenue?.filter({$0.date == objDt})
                let value = data?.compactMap({$0.total}).reduce(0){$0 + $1} ?? 0.0
                dataForBar.append(value)
            }
            
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                let data = filteredRevenue?.filter({($0.date?.contains(month)) ?? false}).map({$0.total})
                let value = data?.reduce(0) {$0 + ($1 ?? 0.0)} ?? 0.0
                dataForBar.append(value)
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    let data = filteredRevenue?.filter({($0.date?.contains(month)) ?? false}).map({$0.total})
                    let value = data?.reduce(0) {$0 + ($1 ?? 0.0)} ?? 0.0
                    dataForBar.append(value)
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    let data = filteredRevenue?.filter({$0.date == objDt})
                    let value = data?.compactMap({$0.total}).reduce(0){$0 + $1} ?? 0.0
                    dataForBar.append(value)
                }
            }
        }
        return dataForBar
    }
    
    func totalRevenueGraphData(forData data:[Dashboard.GetRevenueDashboard.Revenue_transaction]? = nil, dateRange:DateRange, dateRangeType: DateRangeType) -> [Double]
    {
        var totalRevenue = [Double]()
        var filteredRevenue = data
        
        //Fetch Data incase not having filtered already
        if data == nil, (data?.count ?? 0 <= 0){
    
            //Date filter applied
            filteredRevenue = GlobalVariables.technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
                if let date = revenue.date?.date()?.startOfDay {
                    return  (date >= dateRange.start && date <= dateRange.end) &&
                        ((revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon) ||
                            (revenue.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home) ||
                            (revenue.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail))
                }
                return false
            })
        }
        else {
            filteredRevenue = filteredRevenue?.filter({($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon) || ($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home) || ($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail)})
        }
        
        switch dateRangeType  {
        
        case .yesterday, .today, .week, .mtd:
            let dates = dateRange.end.dayDates(from: dateRange.start)
            for objDt in dates {
                if let data = filteredRevenue?.filter({$0.date == objDt}).map({$0.total}), data.count > 0
                {
                    let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                    totalRevenue.append(Double(value))
                }
                else {
                    totalRevenue.append(Double(0.0))
                }
            }
            
        case .qtd, .ytd:
            let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
            for month in months {
                if let data = filteredRevenue?.filter({($0.date?.contains(month)) ?? false}).map({$0.total}), data.count > 0
                {
                    let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                    totalRevenue.append(Double(value))
                }
                else {
                    totalRevenue.append(Double(0.0))
                }
            }
            
        case .cutome:
            
            if dateRange.end.days(from: dateRange.start) > 31
            {
                let months = dateRange.end.monthNames(from: dateRange.start, withFormat: "yyyy-MM")
                for month in months {
                    if let data = filteredRevenue?.filter({($0.date?.contains(month)) ?? false}).map({$0.total}), data.count > 0
                    {
                        let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                        totalRevenue.append(Double(value))
                    }
                    else {
                        totalRevenue.append(Double(0.0))
                    }
                }
            }
            else {
                let dates = dateRange.end.dayDates(from: dateRange.start)
                for objDt in dates {
                    if let data = filteredRevenue?.filter({$0.date == objDt}).map({$0.total}), data.count > 0
                    {
                        let value = data.reduce(0) {$0 + ($1 ?? 0.0)}
                        totalRevenue.append(Double(value))
                    }
                    else {
                        totalRevenue.append(Double(0.0))
                    }
                }
            }
        }
        
        return totalRevenue
    }
}

extension RevenuesViewController: EarningsFilterDelegate {
    //This function called from "Show Result for..." date filter button
    func actionDateFilter() {
        let vc = DateFilterVC.instantiate(fromAppStoryboard: .Earnings)
        self.view.alpha = screenPopUpAlpha
        vc.fromChartFilter = false
        vc.selectedRangeTypeString = dateRangeType.rawValue
        vc.cutomRange = revenueCutomeDateRange
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
        vc.viewDismissBlock = { [unowned self] (result, startDate, endDate, rangeTypeString) in
            // Do something
            self.view.alpha = 1.0
            if(result){
                fromFilters = false
                fromChartFilter = false
                dateRangeType = DateRangeType(rawValue: rangeTypeString ?? "") ?? .cutome
                bottomFilterView.updateText(dateRangeType)
                if(dateRangeType == .cutome), let start = startDate, let end = endDate
                {
                    revenueCutomeDateRange = DateRange(start,end)
                }
                updateRevenueScreenData(startDate: startDate, endDate: endDate ?? Date().startOfDay)
                EZLoadingActivity.hide()
            }
        }
    }
    
    func actionNormalFilter() {
        print("Normal Filter")
        let vc = EarningsFilterVC.instantiate(fromAppStoryboard: .Earnings)
        self.view.alpha = screenPopUpAlpha
        if let alreadySelectedFilter = selectedFilters {
            vc.selectedFilters = alreadySelectedFilter
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        self.view.alpha = 1.0
        vc.viewDismissBlock = { [unowned self] (result, filterValue) in
            
            if(result){
                
                selectedFilters = filterValue
                fromFilters = true
                
                if(dateRangeType == .cutome) {
                    //handle cutome range here
                    let cStartDate = revenueCutomeDateRange.start
                    let cEndDate = revenueCutomeDateRange.end
                    updateRevenueScreenData(startDate: cStartDate, endDate: cEndDate)
                }
                else {
                    updateRevenueScreenData(startDate: dateRangeType.date!)
                }
            }
        }
    }
}

extension RevenuesViewController: EarningDetailsDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    //This function called from cell-> Graph-> date filter button
    func actionDurationFilter(forCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), dataModels.count >= indexPath.row else { return }
        
        let selectedIndex = indexPath.row - 1
        
        let vc = DateFilterVC.instantiate(fromAppStoryboard: .Earnings)
        self.view.alpha = screenPopUpAlpha
        vc.isFromProductivity = false
        vc.fromChartFilter = true
        if(selectedIndex >= 0){
            let model = dataModels[selectedIndex]
            vc.selectedRangeTypeString = model.dateRangeType.rawValue
            vc.cutomRange = model.customeDateRange
        }
        else if let model = headerModel {
            vc.selectedRangeTypeString = model.dateRangeType.rawValue
            vc.cutomRange = model.customeDateRange
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: false, completion: nil)
        vc.viewDismissBlock = { [unowned self] (result, startDate, endDate, rangeTypeString) in
            // Do something
            self.view.alpha = 1.0
            if result == true, startDate != nil, endDate != nil {
                fromFilters = false
                fromChartFilter = true
                
                let rangeType = DateRangeType(rawValue: rangeTypeString ?? "") ?? .cutome
                updateRevenueScreenData(atIndex: indexPath, withStartDate: startDate!, endDate: endDate!, rangeType:rangeType)
                
                let text = "You have selected \(rangeTypeString ?? "MTD") filter from Charts."
                self.showToast(alertTitle: alertTitle, message: text, seconds: toastMessageDuration)
            }
        }
    }
}

extension RevenuesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.selectionStyle = .none
            cell.delegate = self
            cell.parentVC = self
            
            if let model = headerModel {
                var data:[GraphDataEntry] = []
                if let graphEntries = headerGraphDataGraphEntries {
                    data = [graphEntries.lineGraph, graphEntries.barGraph]
                }
                cell.configureCell(model: model, data: data)
            }
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
            let barGraph = barGraphData[index]
            let lineGraph = lineGraphData[index]
            
            cell.configureCell(model: model, data: [lineGraph, barGraph], isFromRevenueScreen: true)
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
//        cell.configureCell(showDateFilter: true, showNormalFilter: true, titleForDateSelection: dateRangeType.rawValue)
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
}
