//
//  CTCBreakupViewController.swift
//  Enrich_SMA
//
//  Created by Suraj Kumar on 14/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit
struct CTCBreakUpStruct{
    var isFixedPayTapped:Bool = false
    var isToTalCTCTapped:Bool = false
    var isDeductionsTapped:Bool = false
    var isTakeHomeTapped:Bool = false
    var isOtherBenefitsTapped:Bool = false
}

class CTCBreakupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parentView: Gradient!
    var sections = [SectionConfiguration]()
    private var ctcBreakUpStruct = CTCBreakUpStruct()
    var ctcModelObject: ViewCTC.GetCTCDeatils.Response?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: CellIdentifier.ctcBreakUpTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.ctcBreakUpTableViewCell)
        self.tableView.register(UINib(nibName: CellIdentifier.ctcBreakUpDetailsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell)
        
        self.parentView.dropShadow()
        
        self.configureSection()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.addCustomBackButton(title: "CTC Break-up")
    }
    
}

extension CTCBreakupViewController{
    
    func configureSection() {
        // configureSections
        sections.removeAll()
        
        sections.append(configureSection(sectionTitle: "",idetifier: .fixedPay, items: 1, data: []))
        sections.append(configureSection(sectionTitle: "",idetifier: .totalCTC, items: 1, data: []))
        sections.append(configureSection(sectionTitle: "",idetifier: .deductions, items: 1, data: []))
        sections.append(configureSection(sectionTitle: "",idetifier: .takeHome, items: 1, data: []))
        sections.append(configureSection(sectionTitle: "",idetifier: .otherBenefits, items: 1, data: []))
        
    }
    
    func configureSection(sectionTitle:String = "", idetifier: SectionIdentifier, items: Int, data: Any) -> SectionConfiguration {
        
        let headerHeight: CGFloat = is_iPAD ? 78 : 58
        
        var width: CGFloat = 0.0
        if (self.tableView != nil)
        {
            width = self.tableView.frame.size.width
        }
        
        let font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: is_iPAD ? 22.0 : 16.0)
        let sectionTitleColor = UIColor(hexString: "#2B2A29")
        
        switch idetifier {
        
        case .fixedPay, .totalCTC, .deductions, .takeHome, .otherBenefits:
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: 0, cellWidth: width, showHeader: false, showFooter: false, headerHeight: headerHeight, footerHeight: 0, leftMargin: 0, rightMarging: 0, isPagingEnabled: false, textFont: font, textColor: sectionTitleColor, items: items, identifier: idetifier, data: data)
            
        default :
            return SectionConfiguration(title: idetifier.rawValue, subTitle: "", cellHeight: 0, cellWidth: width, showHeader: false, showFooter: false, headerHeight: headerHeight, footerHeight: 0, leftMargin: 0, rightMarging: 0, isPagingEnabled: false, textFont: nil, textColor: sectionTitleColor, items: items, identifier: idetifier, data: data)
        }
    }
    
    func calculateFixedPayMonthlyIncome() -> Int{
        
        let basics = self.ctcModelObject?.data?.basic ?? 0
        let speial_allowance = self.ctcModelObject?.data?.special_allowance ?? 0
        let houseRent = self.ctcModelObject?.data?.home_rent_allowance ?? 0
        let StatutoryBonus = self.ctcModelObject?.data?.statutory_bonus ?? 0
        let DearnessAllowance = self.ctcModelObject?.data?.dearness_allowance ?? 0

        let washingAllownace = self.ctcModelObject?.data?.washing_allowance ?? 0
        let FoodAllowance = self.ctcModelObject?.data?.food_allowance ?? 0
        let conveyanceAllowance = self.ctcModelObject?.data?.conveyance_allowance ?? 0
        let educationAllowance = self.ctcModelObject?.data?.education_allowance ?? 0
        
        let meicalAllowance = self.ctcModelObject?.data?.medical_allowance ?? 0
        let otherAllowance = self.ctcModelObject?.data?.other_allowance ?? 0
        let AdditionalSpecialAllowance = self.ctcModelObject?.data?.additional_special_allowance ?? 0
        let AdditionalPayOut = self.ctcModelObject?.data?.additional_payout ?? 0
        
        let AssuredPayout = self.ctcModelObject?.data?.assured_payout ?? 0
        let BooksPeriodicals = self.ctcModelObject?.data?.books_and_periodicals_allowance ?? 0
        let CarMaintenance = self.ctcModelObject?.data?.car_maintenance ?? 0
        let DriverSalary = self.ctcModelObject?.data?.driver_salary ?? 0
        let DriverAllowance = self.ctcModelObject?.data?.driver_allowance ?? 0
        
        let ExGratia = self.ctcModelObject?.data?.ex_gratia ?? 0
        let SkillBonus = self.ctcModelObject?.data?.skill_bonus ?? 0
        let TeaAllowance = self.ctcModelObject?.data?.tea_allowance ?? 0
        let TravelAllowance = self.ctcModelObject?.data?.travel_allowance ?? 0
        let TrainingAllowance = self.ctcModelObject?.data?.training_allowance ?? 0
        let CommunicationAllowance = self.ctcModelObject?.data?.communication_allowance ?? 0
        let FUELALLOWANCECARABOVE1600CC = self.ctcModelObject?.data?.fuel_allowance_above ?? 0
        let FUELALLOWANCECARBELOW1600CC = self.ctcModelObject?.data?.communication_allowance ?? 0
        let FUELALLOWANCETWOWHEELER = self.ctcModelObject?.data?.fuel_allowance_below ?? 0
        let UHSAllow = self.ctcModelObject?.data?.fuel_allowance_two_wheeler ?? 0
        
                
        let firts = basics + speial_allowance + houseRent + StatutoryBonus + DearnessAllowance
        let second = washingAllownace + FoodAllowance + conveyanceAllowance + educationAllowance
        let third = meicalAllowance + otherAllowance + AdditionalSpecialAllowance + AdditionalPayOut
        let fourth = AssuredPayout + BooksPeriodicals + CarMaintenance + DriverSalary + DriverAllowance
        let fifth = ExGratia + SkillBonus + TeaAllowance + TravelAllowance + TrainingAllowance + CommunicationAllowance + FUELALLOWANCECARABOVE1600CC + FUELALLOWANCECARBELOW1600CC + FUELALLOWANCETWOWHEELER + UHSAllow
        
        let totalCount = firts + second + third + fourth + fifth
        return totalCount
        
    }

    //Take home = fixedpay - deductions
    func calculateTotalCTCMonthlyIncome() -> Int{
        let fixed_pay = calculateFixedPayMonthlyIncome()
        let company_pf = self.ctcModelObject?.data?.company_pf ?? 0
        let admin_pf = self.ctcModelObject?.data?.admin_pf ?? 0
        let company_esic = self.ctcModelObject?.data?.company_esic ?? 0
        
        let totalCount = fixed_pay + company_pf + admin_pf + company_esic
        return totalCount
    }
    
    func calculateDeductionsMonthlyIncome() -> Int{
        let employee_pf = self.ctcModelObject?.data?.employee_pf ?? 0
        let employee_esic = self.ctcModelObject?.data?.employee_esic ?? 0
        let professional_tax = self.ctcModelObject?.data?.professional_tax ?? 0
        let mediclaim = self.ctcModelObject?.data?.mediclaim ?? 0

        let totalCount = employee_pf + employee_esic + professional_tax + mediclaim
        return totalCount
    }
    
    func calculateOthersBenefitsMonthlyIncome() -> Int{
        let grooming_points = self.ctcModelObject?.data?.grooming_points ?? 0
        let mediclaim_coverage = self.ctcModelObject?.data?.mediclaim_coverage ?? 0
        let life_insurance_coverage = self.ctcModelObject?.data?.life_insurance_coverage ?? 0
        
        let totalCount = grooming_points + mediclaim_coverage + life_insurance_coverage
        return totalCount
    }
    
}
extension CTCBreakupViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = sections[section]
        guard data.items > 0 else {
            return 0
        }
        switch data.identifier {
        case .fixedPay:
            if self.ctcBreakUpStruct.isFixedPayTapped == false{
                return 1
            }
            return 1 + 28 + 1
            
        case .totalCTC:
            if self.ctcBreakUpStruct.isToTalCTCTapped == false{
                return 1
            }
            return 1 + 4 + 1
        case .deductions:
            if self.ctcBreakUpStruct.isDeductionsTapped == false{
                return 1
            }
            return 1 + 4 + 1
        case .takeHome:
            return 1
        case .otherBenefits:
            if self.ctcBreakUpStruct.isOtherBenefitsTapped == false{
                return 1
            }
            return 1 + 3 + 1
        default:
            return data.items
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = sections[indexPath.section]
        
        switch data.identifier {
        
        case .fixedPay:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpTableViewCell) as! CTCBreakUpTableViewCell

                cell.imgDropDownView.isHidden = false
                
                cell.parentView.backgroundColor = .white
                cell.lbltitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.textColor = UIColor(hexString: "#14B28D")
                cell.lblYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.lblMonthlyTitle.textColor = UIColor(hexString: "#2B2A29")
                cell.lblYearTitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.isHidden = true
                cell.lblYear.isHidden = true
                
                if self.ctcBreakUpStruct.isFixedPayTapped == false{
                    cell.imgDropDownIcon.image = UIImage(named: "dropDownIcon")
                    cell.lblMonthly.isHidden = false
                    cell.lblYear.isHidden = false
                    cell.buttomBorderHideView.isHidden = true
                }else{
                    cell.imgDropDownIcon.image = UIImage(named: "dropUpIcon")
                    cell.buttomBorderHideView.isHidden = false
                }
                
                cell.lbltitle.text = CTCDetailsCode.fixedPay
                
                cell.lblMonthly.text = self.calculateFixedPayMonthlyIncome().roundedStringValue()
                let yearLyValue = self.calculateFixedPayMonthlyIncome() * 12
                cell.lblYear.text = yearLyValue.roundedStringValue()
                
                return cell
            }
            else if indexPath.row == 29{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#14B28D")
                cell.lblBasicYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.lblBasicTopTitle.isHidden = true
                cell.parentStackView.alignment = .center
                
                cell.lblBasicTitle.text = CTCDetailsCode.total
                cell.lblBasicMonth.text = self.calculateFixedPayMonthlyIncome().roundedStringValue()
                
                let yearLyValue = self.calculateFixedPayMonthlyIncome() * 12
                cell.lblBasicYear.text = yearLyValue.roundedStringValue()
                
                cell.parentView.layer.cornerRadius = 10
                cell.parentView.layer.masksToBounds = true
                
                cell.topBorderHideView.isHidden = false
                
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicYear.textColor = UIColor(hexString: "#7D7D7C")
                
                cell.parentView.layer.cornerRadius = 0
                cell.parentView.layer.masksToBounds = true
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                cell.topBorderHideView.isHidden = true
                
                if indexPath.row == 1{
                    cell.lblBasicTitle.text = CTCDetailsCode.basic
                    if(self.ctcModelObject?.data?.basic == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.basic ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.basic ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 2{
                    cell.lblBasicTitle.text = CTCDetailsCode.SpecialAllowance
                    if(self.ctcModelObject?.data?.special_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.special_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.special_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 3{
                    cell.lblBasicTitle.text = CTCDetailsCode.HRA
                    if(self.ctcModelObject?.data?.home_rent_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.home_rent_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.home_rent_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 4{
                    cell.lblBasicTitle.text = CTCDetailsCode.StatutoryBonus
                    if(self.ctcModelObject?.data?.statutory_bonus == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.statutory_bonus ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.statutory_bonus ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 5{
                    cell.lblBasicTitle.text = CTCDetailsCode.DearnessAllowance
                    if(self.ctcModelObject?.data?.dearness_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.dearness_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.dearness_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 6{
                    cell.lblBasicTitle.text = CTCDetailsCode.WashingAllowance
                    if(self.ctcModelObject?.data?.washing_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.washing_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.washing_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 7{
                    cell.lblBasicTitle.text = CTCDetailsCode.FoodAllowance
                    if(self.ctcModelObject?.data?.food_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.food_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.food_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 8{
                    cell.lblBasicTitle.text = CTCDetailsCode.ConveyanceAllowance
                    if(self.ctcModelObject?.data?.conveyance_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.conveyance_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.conveyance_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 9{
                    cell.lblBasicTitle.text = CTCDetailsCode.EducationAllowance
                    if(self.ctcModelObject?.data?.education_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.education_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.education_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 10{
                    cell.lblBasicTitle.text = CTCDetailsCode.MedicalAllowance
                    if(self.ctcModelObject?.data?.medical_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.medical_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.medical_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 11{
                    cell.lblBasicTitle.text = CTCDetailsCode.OtherAllowance
                    if(self.ctcModelObject?.data?.other_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {

                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.other_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.other_allowance ?? 0) * 12).roundedStringValue()

                    }
                }
                if indexPath.row == 12{
                    cell.lblBasicTitle.text = CTCDetailsCode.AdditionalSpecialAllowance
                    if(self.ctcModelObject?.data?.additional_special_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.additional_special_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.additional_special_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 13{
                    cell.lblBasicTitle.text = CTCDetailsCode.AdditionalPayOut
                    if(self.ctcModelObject?.data?.additional_payout == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.additional_payout ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.additional_payout ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 14{
                    cell.lblBasicTitle.text = CTCDetailsCode.AssuredPayout
                    if(self.ctcModelObject?.data?.assured_payout == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.assured_payout ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.assured_payout ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 15{
                    cell.lblBasicTitle.text = CTCDetailsCode.BooksPeriodicals
                    if(self.ctcModelObject?.data?.books_and_periodicals_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.books_and_periodicals_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.books_and_periodicals_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 16{
                    cell.lblBasicTitle.text = CTCDetailsCode.CarMaintenance
                    if(self.ctcModelObject?.data?.car_maintenance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.car_maintenance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.car_maintenance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 17{
                    cell.lblBasicTitle.text = CTCDetailsCode.DriverSalary
                    if(self.ctcModelObject?.data?.driver_salary == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.driver_salary ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.driver_salary ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 18{
                    cell.lblBasicTitle.text = CTCDetailsCode.DriverAllowance
                    if(self.ctcModelObject?.data?.driver_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.driver_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.driver_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 19{
                    cell.lblBasicTitle.text = CTCDetailsCode.ExGratia
                    if(self.ctcModelObject?.data?.ex_gratia == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.ex_gratia ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.ex_gratia ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 20{
                    cell.lblBasicTitle.text = CTCDetailsCode.SkillBonus
                    if(self.ctcModelObject?.data?.skill_bonus == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.skill_bonus ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.skill_bonus ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 21{
                    cell.lblBasicTitle.text = CTCDetailsCode.TeaAllowance
                    if(self.ctcModelObject?.data?.tea_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.tea_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.tea_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 22{
                    cell.lblBasicTitle.text = CTCDetailsCode.TravelAllowance
                    if(self.ctcModelObject?.data?.travel_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.travel_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.travel_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 23{
                    cell.lblBasicTitle.text = CTCDetailsCode.TrainingAllowance
                    if(self.ctcModelObject?.data?.training_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.training_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.training_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 24{
                    cell.lblBasicTitle.text = CTCDetailsCode.CommunicationAllowance
                    if(self.ctcModelObject?.data?.communication_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.communication_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.communication_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 25{
                    cell.lblBasicTitle.text = CTCDetailsCode.FUELALLOWANCECARABOVE1600CC
                    if(self.ctcModelObject?.data?.fuel_allowance_above == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.fuel_allowance_above ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.fuel_allowance_above ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 26{
                    cell.lblBasicTitle.text = CTCDetailsCode.FUELALLOWANCECARBELOW1600CC
                    if(self.ctcModelObject?.data?.fuel_allowance_below == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.fuel_allowance_below ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.fuel_allowance_below ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 27{
                    cell.lblBasicTitle.text = CTCDetailsCode.FUELALLOWANCETWOWHEELER
                    if(self.ctcModelObject?.data?.fuel_allowance_two_wheeler == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.fuel_allowance_two_wheeler ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.fuel_allowance_two_wheeler ?? 0) * 12).roundedStringValue()
                    }
                }
                if indexPath.row == 28{
                    cell.lblBasicTitle.text = CTCDetailsCode.UHSAllow
                    if(self.ctcModelObject?.data?.uhs_allowance == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.uhs_allowance ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.uhs_allowance ?? 0) * 12).roundedStringValue()
                    }
                }
                
                
                return cell
            }
            
        case .totalCTC:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpTableViewCell) as! CTCBreakUpTableViewCell
                
                cell.imgDropDownView.isHidden = false
                
                cell.parentView.backgroundColor = .white
                cell.lbltitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.textColor = UIColor(hexString: "#14B28D")
                cell.lblYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.lblMonthlyTitle.textColor = UIColor(hexString: "#2B2A29")
                cell.lblYearTitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.isHidden = true
                cell.lblYear.isHidden = true
                
                if self.ctcBreakUpStruct.isToTalCTCTapped == false{
                    cell.imgDropDownIcon.image = UIImage(named: "dropDownIcon")
                    cell.lblMonthly.isHidden = false
                    cell.lblYear.isHidden = false
                    cell.buttomBorderHideView.isHidden = true
                }else{
                    cell.imgDropDownIcon.image = UIImage(named: "dropUpIcon")
                    cell.buttomBorderHideView.isHidden = false
                }
                
                cell.lbltitle.text = CTCDetailsCode.totalCTC
                
                cell.lblMonthly.text = self.calculateTotalCTCMonthlyIncome().roundedStringValue()
                cell.lblYear.text = (self.calculateTotalCTCMonthlyIncome() * 12).roundedStringValue()
                
                return cell
            }
            else if indexPath.row == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#14B28D")
                cell.lblBasicYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                
                cell.lblBasicTitle.text = CTCDetailsCode.total
                cell.lblBasicMonth.text = self.calculateTotalCTCMonthlyIncome().roundedStringValue()
                cell.lblBasicYear.text = (self.calculateTotalCTCMonthlyIncome() * 12).roundedStringValue()
                       
                cell.parentView.layer.cornerRadius = 10
                cell.parentView.layer.masksToBounds = true
                
                cell.topBorderHideView.isHidden = false
                return cell
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicYear.textColor = UIColor(hexString: "#7D7D7C")
                
                cell.parentView.layer.cornerRadius = 0
                cell.parentView.layer.masksToBounds = true
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                
                cell.topBorderHideView.isHidden = true
                
                if indexPath.row == 1{
                    cell.lblBasicTitle.text = CTCDetailsCode.fixedPay
                    cell.lblBasicMonth.text = self.calculateFixedPayMonthlyIncome().roundedStringValue()
                    
                    cell.lblBasicYear.text = (self.calculateFixedPayMonthlyIncome() * 12 ).roundedStringValue()
                    
                }
                else if indexPath.row == 2{
                    
                    cell.parentStackView.alignment = .bottom
                    cell.lblBasicTopTitle.isHidden = false
                    
                    cell.lblBasicTopTitle.text = CTCDetailsCode.EmployerContribution
                    cell.lblBasicTitle.text = CTCDetailsCode.CompContPF
                    if(self.ctcModelObject?.data?.company_pf == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.company_pf ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.company_pf ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 3{
                    cell.lblBasicTitle.text = CTCDetailsCode.ADPF
                    if(self.ctcModelObject?.data?.admin_pf == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.admin_pf ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.admin_pf ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 4{
                    cell.lblBasicTitle.text = CTCDetailsCode.CompanyContributiontoESIC
                    if(self.ctcModelObject?.data?.company_esic == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.company_esic ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.company_esic ?? 0) * 12).roundedStringValue()
                    }
                }
                
                return cell
            }
            
        case .deductions:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpTableViewCell) as! CTCBreakUpTableViewCell
                
                cell.imgDropDownView.isHidden = false
                
                cell.parentView.backgroundColor = .white
                cell.lbltitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.textColor = UIColor(hexString: "#14B28D")
                cell.lblYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.lblMonthlyTitle.textColor = UIColor(hexString: "#2B2A29")
                cell.lblYearTitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.isHidden = true
                cell.lblYear.isHidden = true
                
                if self.ctcBreakUpStruct.isDeductionsTapped == false{
                    cell.imgDropDownIcon.image = UIImage(named: "dropDownIcon")
                    cell.lblMonthly.isHidden = false
                    cell.lblYear.isHidden = false
                    cell.buttomBorderHideView.isHidden = true
                }else{
                    cell.imgDropDownIcon.image = UIImage(named: "dropUpIcon")
                    cell.buttomBorderHideView.isHidden = false
                }
                
                cell.lblMonthly.textColor = UIColor(hexString: "#F28088")
                cell.lblYear.textColor = UIColor(hexString: "#F28088")
                
                cell.lbltitle.text = CTCDetailsCode.deductions
                
                cell.lblMonthly.text = self.calculateDeductionsMonthlyIncome().roundedStringValue()
                cell.lblYear.text = (self.calculateDeductionsMonthlyIncome() * 12).roundedStringValue()
                
                return cell
            }
            else if indexPath.row == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#F28088")
                cell.lblBasicYear.textColor = UIColor(hexString: "#F28088")
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                
                cell.lblBasicTitle.text = CTCDetailsCode.total
                cell.lblBasicMonth.text = self.calculateDeductionsMonthlyIncome().roundedStringValue()
                cell.lblBasicYear.text = (self.calculateDeductionsMonthlyIncome() * 12).roundedStringValue()
                
                cell.parentView.layer.cornerRadius = 10
                cell.parentView.layer.masksToBounds = true
                
                cell.topBorderHideView.isHidden = false
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicYear.textColor = UIColor(hexString: "#7D7D7C")
                
                cell.parentView.layer.cornerRadius = 0
                cell.parentView.layer.masksToBounds = true
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                
                cell.topBorderHideView.isHidden = true
                
                if indexPath.row == 1{
                    cell.parentStackView.alignment = .bottom
                    cell.lblBasicTopTitle.isHidden = false
                    cell.lblBasicTopTitle.text = CTCDetailsCode.EmployeeContribution
                    
                    cell.lblBasicTitle.text = CTCDetailsCode.PF_ded
                    if(self.ctcModelObject?.data?.employee_pf == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.employee_pf ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.employee_pf ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 2{
                    cell.lblBasicTitle.text = CTCDetailsCode.ESIC_ded
                    if(self.ctcModelObject?.data?.employee_esic == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.employee_esic ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.employee_esic ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 3{
                    cell.lblBasicTitle.text = CTCDetailsCode.PT_ded
                    if(self.ctcModelObject?.data?.professional_tax == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.professional_tax ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = (((self.ctcModelObject?.data?.professional_tax ?? 0) * 12) + 100).roundedStringValue()
                    }
                }
                else if indexPath.row == 4{
                    cell.lblBasicTitle.text = CTCDetailsCode.MEDICLAIM_DEDUCTION
                    if(self.ctcModelObject?.data?.mediclaim == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.mediclaim ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.mediclaim ?? 0) * 12).roundedStringValue()
                    }
                }
                
                return cell
            }
        case .takeHome:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpTableViewCell) as! CTCBreakUpTableViewCell
            
            cell.imgDropDownView.isHidden = true
            cell.parentView.backgroundColor = UIColor(hexString: "#4AA0CC")
            cell.lbltitle.textColor = UIColor.white
            cell.lblMonthly.textColor = UIColor.white
            cell.lblYear.textColor = UIColor.white
            cell.lblMonthlyTitle.textColor = UIColor.white
            cell.lblYearTitle.textColor = UIColor.white
            
            cell.lblMonthly.isHidden = false
            cell.lblYear.isHidden = false
            cell.buttomBorderHideView.isHidden = true
            
            cell.lbltitle.text = CTCDetailsCode.takeHome
            
            //Take home = fixedpay - deductions
            let takeHomeCount = self.calculateFixedPayMonthlyIncome() - self.calculateDeductionsMonthlyIncome()
            cell.lblMonthly.text = takeHomeCount.roundedStringValue()
            cell.lblYear.text = (takeHomeCount * 12).roundedStringValue()
            
            return cell
            
        case .otherBenefits:
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpTableViewCell) as! CTCBreakUpTableViewCell
                
                cell.imgDropDownView.isHidden = false
                
                cell.parentView.backgroundColor = .white
                cell.lbltitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.textColor = UIColor(hexString: "#14B28D")
                cell.lblYear.textColor = UIColor(hexString: "#14B28D")
                
                cell.lblMonthlyTitle.textColor = UIColor(hexString: "#2B2A29")
                cell.lblYearTitle.textColor = UIColor(hexString: "#2B2A29")
                
                cell.lblMonthly.isHidden = true
                cell.lblYear.isHidden = true
                
                if self.ctcBreakUpStruct.isOtherBenefitsTapped == false{
                    cell.imgDropDownIcon.image = UIImage(named: "dropDownIcon")
                    cell.lblMonthly.isHidden = false
                    cell.lblYear.isHidden = false
                    cell.buttomBorderHideView.isHidden = true
                }else{
                    cell.imgDropDownIcon.image = UIImage(named: "dropUpIcon")
                    cell.buttomBorderHideView.isHidden = false
                }
                
                cell.lbltitle.text = CTCDetailsCode.otherBenefits
                if(calculateOthersBenefitsMonthlyIncome() == 0){
                    cell.lblMonthly.text = "-"
                    cell.lblYear.text = "-"
                }
                else {
                cell.lblMonthly.text = self.calculateOthersBenefitsMonthlyIncome().roundedStringValue()
                cell.lblYear.text = (self.calculateOthersBenefitsMonthlyIncome() * 12).roundedStringValue()
                }
                return cell
            }
            else if indexPath.row == 4{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTDemi.rawValue, size: 16)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#4AA0CC")
                cell.lblBasicYear.textColor = UIColor(hexString: "#4AA0CC")
                
                cell.lblBasicTitle.text = CTCDetailsCode.total
                if(self.calculateOthersBenefitsMonthlyIncome() == 0)
                {
                    cell.lblBasicMonth.text = "-"
                    cell.lblBasicYear.text = "-"
                }
                else {
                cell.lblBasicMonth.text = self.calculateOthersBenefitsMonthlyIncome().roundedStringValue()
                cell.lblBasicYear.text = (self.calculateOthersBenefitsMonthlyIncome() * 12).roundedStringValue()
                }
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                        
                cell.parentView.layer.cornerRadius = 10
                cell.parentView.layer.masksToBounds = true
                
                cell.topBorderHideView.isHidden = false
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ctcBreakUpDetailsTableViewCell) as! CTCBreakUpDetailsTableViewCell
                cell.lblBasicTitle.font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 14)
                cell.lblBasicMonth.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                cell.lblBasicYear.font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 14)
                
                cell.lblBasicTitle.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicMonth.textColor = UIColor(hexString: "#7D7D7C")
                cell.lblBasicYear.textColor = UIColor(hexString: "#7D7D7C")
                
                cell.parentView.layer.cornerRadius = 0
                cell.parentView.layer.masksToBounds = true
                
                cell.parentStackView.alignment = .center
                cell.lblBasicTopTitle.isHidden = true
                
                cell.topBorderHideView.isHidden = true
                if indexPath.row == 1{
                    cell.lblBasicTitle.text = CTCDetailsCode.GroomingPoints
                    if(self.ctcModelObject?.data?.grooming_points == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.grooming_points ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.grooming_points ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 2{
                    cell.lblBasicTitle.text = CTCDetailsCode.MediclaimCoverage
                    if(self.ctcModelObject?.data?.mediclaim_coverage == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.mediclaim_coverage ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.mediclaim_coverage ?? 0) * 12).roundedStringValue()
                    }
                }
                else if indexPath.row == 3{
                    cell.lblBasicTitle.text = CTCDetailsCode.LifeInsuranceCoverage
                    if(self.ctcModelObject?.data?.life_insurance_coverage == 0){
                        cell.lblBasicMonth.text = "-"
                        cell.lblBasicYear.text = "-"
                    }
                    else {
                    cell.lblBasicMonth.text = (self.ctcModelObject?.data?.life_insurance_coverage ?? 0).roundedStringValue()
                    cell.lblBasicYear.text = ((self.ctcModelObject?.data?.life_insurance_coverage ?? 0) * 12).roundedStringValue()
                    }
                }
                
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = sections[indexPath.section]
        
        switch data.identifier {
        
        case .fixedPay, .takeHome:
            if indexPath.row == 0 || indexPath.row == 29{
                return 60
            }
            return 40
            
        case .totalCTC:
            if indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 2{
                return 60
            }
            return 40
            
        case .deductions:
            if indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 1{
                return 60
            }
            return 40
            
        case .otherBenefits:
            if indexPath.row == 0 || indexPath.row == 5{
                return 60
            }
            return 40
            
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = sections[indexPath.section]
        switch data.identifier {
            
        case .fixedPay:
            self.ctcBreakUpStruct.isToTalCTCTapped = false
            self.ctcBreakUpStruct.isOtherBenefitsTapped = false
            self.ctcBreakUpStruct.isDeductionsTapped = false
            self.ctcBreakUpStruct.isTakeHomeTapped = false
            
            if self.ctcBreakUpStruct.isFixedPayTapped == false{
                self.ctcBreakUpStruct.isFixedPayTapped = true
            }else{
                self.ctcBreakUpStruct.isFixedPayTapped = false
            }
             
        case .totalCTC:
            self.ctcBreakUpStruct.isFixedPayTapped = false
            self.ctcBreakUpStruct.isDeductionsTapped = false
            self.ctcBreakUpStruct.isTakeHomeTapped = false
            self.ctcBreakUpStruct.isOtherBenefitsTapped = false
            
            if self.ctcBreakUpStruct.isToTalCTCTapped == false{
                self.ctcBreakUpStruct.isToTalCTCTapped = true
            }else{
                self.ctcBreakUpStruct.isToTalCTCTapped = false
            }
            
        case .deductions:
            self.ctcBreakUpStruct.isFixedPayTapped = false
            self.ctcBreakUpStruct.isToTalCTCTapped = false
            self.ctcBreakUpStruct.isTakeHomeTapped = false
            self.ctcBreakUpStruct.isOtherBenefitsTapped = false
            
            if self.ctcBreakUpStruct.isDeductionsTapped == false{
                self.ctcBreakUpStruct.isDeductionsTapped = true
            }else{
                self.ctcBreakUpStruct.isDeductionsTapped = false
            }
            
        case .takeHome:
            self.ctcBreakUpStruct.isFixedPayTapped = false
            self.ctcBreakUpStruct.isToTalCTCTapped = false
            self.ctcBreakUpStruct.isDeductionsTapped = false
            self.ctcBreakUpStruct.isOtherBenefitsTapped = false
            
            if self.ctcBreakUpStruct.isTakeHomeTapped == false{
                self.ctcBreakUpStruct.isTakeHomeTapped = true
            }else{
                self.ctcBreakUpStruct.isTakeHomeTapped = false
            }
            
        case .otherBenefits:
            self.ctcBreakUpStruct.isFixedPayTapped = false
            self.ctcBreakUpStruct.isToTalCTCTapped = false
            self.ctcBreakUpStruct.isDeductionsTapped = false
            self.ctcBreakUpStruct.isTakeHomeTapped = false
            
            if self.ctcBreakUpStruct.isOtherBenefitsTapped == false{
                self.ctcBreakUpStruct.isOtherBenefitsTapped = true
            }else{
                self.ctcBreakUpStruct.isOtherBenefitsTapped = false
            }
            
        default:
            break
        }
        
        self.tableView.reloadData()
        
    }
            
}
