//
//  DateFilterViewController.swift
//  Enrich_TMA
//
//  Created by Harshal on 16/08/21.
//  Copyright (c) 2021 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DateFilterDisplayLogic: class
{
    func displaySomething(viewModel: DateFilter.Something.ViewModel)
}

enum DateRangeType : String {
    case yesterday = "Yesterday"
    case today = "Today"
    case week = "Week"
    case mtd = "MTD"
    case qtd = "QTD"
    case ytd = "YTD"
    case cutome = "Custom Date Range"
    
    var date: Date? {
        switch self {
        case .yesterday:
            return Date.today.yesterday()
        case .today:
            return Date.today
        case .week:
            return Date.today.lastWeek()
        case .mtd:
            return Date.today.startOfMonth
        case .qtd:
            return Date.today.startOfQuarter
        case .ytd:
            return Date.today.startOfYear
        case .cutome:
            return nil
        }
    }
    
    var value: String {
        switch self {
        case .yesterday, .today, .week,.mtd, .qtd, .ytd:
            return self.rawValue
        case .cutome:
            return "Custom"
        }
    }
    
}

enum MonthNames : Int {
    case Jan = 1
    case Feb = 2
    case Mar = 3
    case Apr = 4
    case May = 5
    case Jun = 6
    case Jul = 7
    case Aug = 8
    case Sept = 9
    case Oct = 10
    case Nov = 11
    case Desc = 12
    
    var month: Int{
        switch self {
        case .Jan:
            return 1
        case .Feb:
            return 2
        case .Mar:
            return 3
        case .Apr:
            return 4
        case .May:
            return 5
        case .Jun:
            return 6
        case .Jul:
            return 7
        case .Aug:
            return 8
        case .Sept:
            return 9
        case .Oct:
            return 10
        case .Nov:
            return 11
        case .Desc:
            return 12
        }
    }
}


typealias DateRange = (start:Date, end:Date)

class DateFilterVC: UIViewController, DateFilterDisplayLogic
{
    var interactor: DateFilterBusinessLogic?
    var selectedRangeTypeString : String = "MTD"
    var isSelected : Bool = false
    var fromChartFilter : Bool = false
    var isFromProductivity = false
    var cutomRange:DateRange = DateRange(Date.today.lastYear(), Date.today)
    
    var selectedFilter = PackageFilterModel(title: "", isSelected: false, fromDate: nil, toDate: nil, sku: "")
    // MARK: Object lifecycle
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var parentView: UIView!
    @IBOutlet weak private var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var containerViewBottomConstraint: NSLayoutConstraint!
    
    var selectedData:PackageFilterModel?
    var data = [PackageFilterModel]()
    
    var viewDismissBlock: ((_ success:Bool, _ start:Date?, _ end:Date?, _ title:String?) -> Void)?
    
    //var dateRange : (start:Date, end:Date) = (Date.today, Date.today)
    
    let selectCustomDateRangeTitle = "Select Custom Date Range"
    
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
        let interactor = DateFilterInteractor()
        let presenter = DateFilterPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    func isSelected(dateRangeType:DateRangeType) -> Bool {
        let selectedType = DateRangeType(rawValue: selectedRangeTypeString) ?? .cutome
        return selectedType == dateRangeType
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        
        tableView.register(UINib(nibName: CellIdentifier.packageFilterCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.packageFilterCell)
        tableView.register(UINib(nibName: CellIdentifier.selectFilterDateRangeCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.selectFilterDateRangeCell)
        tableView.separatorColor = .clear
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 8
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if fromChartFilter == false && !isFromProductivity {
            data.append(PackageFilterModel(title: DateRangeType.yesterday.rawValue, isSelected: isSelected(dateRangeType: .yesterday), fromDate: DateRangeType.yesterday.date, toDate: DateRangeType.yesterday.date, sku: nil))
            data.append(PackageFilterModel(title: DateRangeType.today.rawValue, isSelected: isSelected(dateRangeType: .today), fromDate: DateRangeType.today.date, toDate: Date.today, sku: nil))
        }
        if(isFromProductivity == false){
        data.append(PackageFilterModel(title: DateRangeType.week.rawValue, isSelected: isSelected(dateRangeType: .week), fromDate: DateRangeType.week.date, toDate: Date.today, sku: nil))
        data.append(PackageFilterModel(title: DateRangeType.mtd.rawValue, isSelected: isSelected(dateRangeType: .mtd), fromDate: DateRangeType.mtd.date, toDate: Date.today, sku: nil))
        data.append(PackageFilterModel(title: DateRangeType.qtd.rawValue, isSelected: isSelected(dateRangeType: .qtd), fromDate: DateRangeType.qtd.date, toDate: Date.today, sku: nil))
        data.append(PackageFilterModel(title: DateRangeType.ytd.rawValue, isSelected: isSelected(dateRangeType: .ytd), fromDate: DateRangeType.ytd.date, toDate: Date.today, sku: nil))
        data.append(PackageFilterModel(title: selectCustomDateRangeTitle, isSelected: isSelected(dateRangeType: .cutome), fromDate: cutomRange.start, toDate: cutomRange.end, sku: nil))
        }
        else {
            data.append(PackageFilterModel(title: DateRangeType.mtd.rawValue, isSelected: isSelected(dateRangeType: .mtd), fromDate: DateRangeType.mtd.date, toDate: Date.today, sku: nil))
            data.append(PackageFilterModel(title: DateRangeType.qtd.rawValue, isSelected: isSelected(dateRangeType: .qtd), fromDate: DateRangeType.qtd.date, toDate: Date.today, sku: nil))
            data.append(PackageFilterModel(title: DateRangeType.ytd.rawValue, isSelected: isSelected(dateRangeType: .ytd), fromDate: DateRangeType.ytd.date, toDate: Date.today, sku: nil))
            data.append(PackageFilterModel(title: selectCustomDateRangeTitle, isSelected: isSelected(dateRangeType: .cutome), fromDate: cutomRange.start, toDate: cutomRange.end, sku: nil))
        }
        containerViewHeightSetup()
        tableView.reloadData()
        
        selectedData = data.filter({ $0.title == selectedRangeTypeString }).first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.containerViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    private func containerViewHeightSetup() {
        let firstViewHeight: CGFloat = 70.0
        let secondViewHeight: CGFloat = 70.0
        let oneRowHeight: CGFloat = 40
        let extraBottomSpace: CGFloat = 10.0
        let tableHeight: CGFloat = CGFloat(data.count) * oneRowHeight
        var containerHeight = firstViewHeight + tableHeight + secondViewHeight + extraBottomSpace
        let hasCustomDateFilter = data.firstIndex { (package) -> Bool in
            package.title == selectCustomDateRangeTitle
        }
        if hasCustomDateFilter != nil {
            containerHeight -= oneRowHeight
            let selectCustomDateRangeHeight: CGFloat = 117.0
            containerHeight += selectCustomDateRangeHeight
        }
        if containerHeight > UIScreen.main.bounds.height * 0.75 {
            containerHeight = UIScreen.main.bounds.height * 0.75
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        containerViewHeightConstraint.constant = containerHeight
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = DateFilter.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: DateFilter.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock?(false, nil, nil,nil)
    }
    @IBAction func actionApplyFilter(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        let rangeType = DateRangeType(rawValue: selectedRangeTypeString) ?? .cutome
        if rangeType == .cutome {
            selectedData = data.last
        }
        
        viewDismissBlock?(true, selectedData?.fromDate?.startOfDay, selectedData?.toDate?.endOfDay, selectedRangeTypeString)
    }
    
    
}

extension DateFilterVC: SelectDateRangeDelegate {

    private func addPickerView(isFrom: Bool) {
         let pickerView = PickerView.instantiateFromNib()
        pickerView?.setTitle(isFrom ? "From Month" : "To Month")
        if (!isFrom){
            if let fromDate = self.data.last?.fromDate{
                pickerView?.setMinimumDate(fromDate)
                
            }
        }
         pickerView?.selectedMonthYear = { [weak self] (selectedDate, monthYear) in
            guard let self = self else { return }
            if(isFrom == true){//from date
                self.data.last?.fromDate = selectedDate
            }
            else {//to date
                self.data.last?.toDate = selectedDate
            }
            self.tableView.reloadData()
         }
         pickerView?.addMeOn(onView: self.view)
        if(isFrom){
            if let fromDate = self.data.last?.fromDate {
                pickerView?.setSelectedDate(fromDate)
            }
        }
        else {
            if let toDate = self.data.last?.toDate {
                pickerView?.setSelectedDate(toDate)
            }
        }
     }
    
    func actionFromDate() {
        guard !isFromProductivity else {
            addPickerView(isFrom: true)
            return
        }
        let model = data.last
        DatePickerDialog().show("From Date", doneButtonTitle: "SELECT", cancelButtonTitle: "CANCEL", defaultDate: model?.fromDate ?? Date.today.lastYear(), minimumDate: Date.today.lastYear(), maximumDate: Date.today, datePickerMode: .date) { (selectedDate) in
            if(selectedDate != nil){
                self.data.last?.fromDate = selectedDate
                let userDefaults = UserDefaults.standard
                //userDefaults.set(selectedDate?.monthNameYearDate, forKey: UserDefauiltsKeys.k_key_FromDate)
            }
            self.tableView.reloadData()
        }
    }
    
    func actionToDate() {
        guard !isFromProductivity else {
            addPickerView(isFrom: false)
            return
        }
        let model = data.last
        DatePickerDialog().show("To Date", doneButtonTitle: "SELECT", cancelButtonTitle: "CANCEL", defaultDate: model?.toDate ?? Date.today, minimumDate: model?.fromDate!, maximumDate: Date.today, datePickerMode: .date) { (selectedDate) in
            if(selectedDate != nil){
                self.data.last?.toDate = selectedDate
                let userDefaults = UserDefaults.standard
                //userDefaults.set(selectedDate?.monthNameYearDate, forKey: UserDefauiltsKeys.k_key_ToDate)
            }
            self.tableView.reloadData()
        }
    }
    
}

extension DateFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCustomDateOrMonthRangeFilter(indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.selectFilterDateRangeCell, for: indexPath) as? SelectFilterDateRangeCell else {
                return UITableViewCell()
            }
            cell.configureCell(model: data[indexPath.row], isFromProductivity: isFromProductivity)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.packageFilterCell, for: indexPath) as? PackageFilterCell else {
                return UITableViewCell()
            }
            cell.configureCell(model: data[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return isCustomDateOrMonthRangeFilter(indexPath.row) ? UITableView.automaticDimension : 40
    }
    
    private func isCustomDateOrMonthRangeFilter(_ row: Int) -> Bool {
        var isCustomRangeFilter = false //custom range- month or date
        if row < data.count {
            let package = data[row]
            isCustomRangeFilter = package.title == selectCustomDateRangeTitle
        }
        return isCustomRangeFilter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selection")
        data.forEach{$0.isSelected = false}
        data[indexPath.row].isSelected = true
        selectedData = data[indexPath.row]
        
        let rangeType = DateRangeType(rawValue: selectedData!.title) ?? .cutome
        selectedRangeTypeString = (rangeType == .cutome) ? "Custom Date Range" : selectedData!.title
        tableView.reloadData()
    }
}
