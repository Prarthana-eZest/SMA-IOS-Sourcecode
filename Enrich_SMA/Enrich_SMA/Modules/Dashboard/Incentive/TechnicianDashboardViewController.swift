//
//  TechnicianDashboardViewController.swift
//  Enrich_SMA
//
//  Created by Harshal on 24/01/22.
//  Copyright (c) 2022 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CategoryTypes {
    static let services = "Services"
    static let packages = "Packages"
    static let retail = "Retail"
}

enum AppointmentTypes {
    static let salon = "salon"
    static let home = "home"
}

enum platform {
    static let store = "store"
    static let CMA = "CMA"
    
}
enum EarningViewType {
    case list, grid, earnings
}

protocol TechnicianDashboardDisplayLogic: class
{
    func displaySomething(viewModel: TechnicianDashboard.Something.ViewModel)
}

class TechnicianDashboardViewController: UIViewController, TechnicianDashboardDisplayLogic
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewType : EarningViewType = .grid
    var interactor: TechnicianDashboardBusinessLogic?
    var router: (NSObjectProtocol & TechnicianDashboardRoutingLogic & TechnicianDashboardDataPassing)?
    
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
        let interactor = TechnicianDashboardInteractor()
        let presenter = TechnicianDashboardPresenter()
        let router = TechnicianDashboardRouter()
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
        self.collectionView.register(UINib(nibName: "DashboardGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardGridCollectionViewCell")
        self.collectionView.register(UINib(nibName: "DashboardListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardListCollectionViewCell")
        calculateDataForTiles(startDate: Date.today.startOfMonth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Back")
        addFilterButtonOnRight()
        
    }
    
    let button = UIButton(type: .custom)
    var isGridView:Bool = true
    func addFilterButtonOnRight(){
        button.setImage(UIImage(named: "filterList"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(gotoFilterPage), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func gotoFilterPage(){
        if isGridView == false{
            isGridView = true
            button.setImage(UIImage(named: "filterList"), for: .normal)
        }else{
            isGridView = false
            button.setImage(UIImage(named: "filterGrid"), for: .normal)
        }
        self.collectionView.reloadData()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = TechnicianDashboard.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: TechnicianDashboard.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    func calculateDataForTiles(startDate : Date, endDate : Date = Date().startOfDay) {
        let technicianDataJSON = UserDefaults.standard.value(Dashboard.GetRevenueDashboard.Response.self, forKey: UserDefauiltsKeys.k_key_RevenueDashboard)
        
        let filteredRevenue = technicianDataJSON?.data?.revenue_transactions?.filter({ (revenue) -> Bool in
            if let date = revenue.date?.date()?.startOfDay {
                
                return date >= startDate && date <= endDate
            }
            return false
        })
        // Revenue Screen
        let serviceData = filteredRevenue?.filter({($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon)}) ?? []
        var serviceToatal : Double = 0.0
        
        let homeServiceRevenueData = filteredRevenue?.filter({($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home)}) ?? []
        var homeServiceTotal : Double = 0.0
        
        let retailData = filteredRevenue?.filter({($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail)}) ?? []
        var retailTotal : Double = 0.0
        
        
        for objService in serviceData {
            serviceToatal = serviceToatal + objService.total!
        }
        print("serviceToatal conunt : \(serviceToatal)")
        
        for objService in homeServiceRevenueData {
            homeServiceTotal = homeServiceTotal + objService.total!
        }
        print("homeServiceTotal conunt : \(homeServiceTotal)")
        
        
        for objRetail in retailData {
            retailTotal = retailTotal + objRetail.total!
        }
        print("retail conunt : \(retailTotal)")
        let revenueTotal = serviceToatal + homeServiceTotal + retailTotal
        UserDefaults.standard.set(revenueTotal, forKey: UserDefauiltsKeys.k_key_RevenueTotal)
        
        print("Total Revenue \(revenueTotal)")
        
        //membership revenue
        let membershipRevenue = filteredRevenue?.filter({$0.membership_revenue ?? 0 > 0}) ?? []
        var membershipRevenueCount : Double = 0.0
        for objMembershipRevenueCount in membershipRevenue {
            membershipRevenueCount = membershipRevenueCount + objMembershipRevenueCount.membership_revenue!
        }
        print("membershipRevenueCount \(membershipRevenueCount)")
        
        
        //value package revenue
        let valuePackageRevenue = filteredRevenue?.filter({$0.value_package_revenue ?? 0 > 0}) ?? []
        var valuePackageRevenueCount : Double = 0.0
        for objValuePackageRevenueCount in valuePackageRevenue {
            valuePackageRevenueCount = valuePackageRevenueCount + objValuePackageRevenueCount.value_package_revenue!
        }
        print("valuePackageRevenueCount \(valuePackageRevenueCount)")
        
        //service_package_revenue
        let servicePackageRevenue = filteredRevenue?.filter({$0.service_package_revenue ?? 0 > 0}) ?? []
        
        var servicePackageRevenueCount : Double = 0.0
        for objServicePackageRevenue in servicePackageRevenue {
            servicePackageRevenueCount = servicePackageRevenueCount + objServicePackageRevenue.service_package_revenue!
        }
        print("servicePackageRevenueCount \(servicePackageRevenueCount)")
        
        let salesCount = membershipRevenueCount + valuePackageRevenueCount + servicePackageRevenueCount
        
        //let intValSales : Int = (Int(salesCount))
        UserDefaults.standard.set(salesCount.rounded(), forKey: UserDefauiltsKeys.k_key_SalesToatal)
        //print("Sales count \(intValSales)")
        
        //Free services
        var freeServiceRevenueCount : Double = 0.0
        var complimentaryGiftcardCount : Double = 0.0
        var groomingGiftcardCount : Double = 0.0
        
        for freeService in filteredRevenue ?? [] {
            // Reward points
            if let fsRevenue = freeService.free_service_revenue, fsRevenue > 0 {
                freeServiceRevenueCount += fsRevenue
            }
            
            // complimentary_giftcard
            if let cGiftCard = freeService.complimentary_giftcard, cGiftCard > 0, (freeService.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.services) {
                complimentaryGiftcardCount += cGiftCard
            }
            
            // grooming_giftcard
            if let gGiftCard = freeService.grooming_giftcard, gGiftCard > 0, (freeService.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.services) {
                groomingGiftcardCount += gGiftCard
            }
        }
        
        print("reward points \(freeServiceRevenueCount)")
        print("complimentaryGiftcardCount \(complimentaryGiftcardCount)")
        print("groomingGiftcardCount \(groomingGiftcardCount)")
        
        var freeServicesCount = Double(freeServiceRevenueCount + groomingGiftcardCount + complimentaryGiftcardCount)
        freeServicesCount = 0.8 * freeServicesCount
        
        //let intValFreeServices : Int = (Int(freeServicesCount))
        UserDefaults.standard.set(freeServicesCount.rounded(), forKey: UserDefauiltsKeys.k_key_FreeServicesToatal)
        // print("Sales count \(intValSales)")
        
        
        
        //footfall screen
        let invoiceNumber = filteredRevenue?.filter({($0.invoice_number ?? "") != ""})
        let updateUniqueData = invoiceNumber?.unique(map: {$0.invoice_number}) ?? []
        
        
        //service
        let serviceDataFootfall = filteredRevenue?.filter({($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.services) && ($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.salon)})
        
        
        //add condition for product category type
        var serviceToatalFootfall : Int = 0 //= serviceData?.count ?? 0
        let serviceDataUniqueInvoice = serviceDataFootfall?.unique(map: {$0.invoice_number}) ?? []
        for objInvoice in updateUniqueData {
            for objServiceData in serviceDataUniqueInvoice {
                if(objInvoice.invoice_number == objServiceData.invoice_number){
                    serviceToatalFootfall = serviceToatalFootfall + 1
                }
            }
        }
        
        print("serviceToatal conunt : \(serviceToatal)")
        //123
        let homeServiceRevenueDataFootfall = filteredRevenue?.filter({($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.services) && ($0.appointment_type ?? "").containsIgnoringCase(find:AppointmentTypes.home)})
        //add condition for product category type
        
        let homeInvoiceUnique = homeServiceRevenueDataFootfall?.unique(map: {$0.invoice_number}) ?? []
        var homeServiceTotalFootfall : Int = 0
        
        for objInvoice in updateUniqueData {
            for objHomeData in homeInvoiceUnique {
                if(objInvoice.invoice_number == objHomeData.invoice_number){
                    homeServiceTotalFootfall = homeServiceTotalFootfall + 1
                }
            }
        }
        
        print("homeServiceTotal conunt : \(homeServiceTotal)")
        
        let retailDataFootfall = filteredRevenue?.filter({($0.product_category_type ?? "").containsIgnoringCase(find:CategoryTypes.retail)})
        let retialInvoiceUnique = retailDataFootfall?.unique(map: {$0.invoice_number}) ?? []
        var retailCountFootfall : Int = 0
        
        for objInvoice in updateUniqueData {
            for objRetail in retialInvoiceUnique {
                if (objInvoice.invoice_number == objRetail.invoice_number){
                    retailCountFootfall = retailCountFootfall + 1
                }
            }
        }
        
        let footfallCount = serviceToatalFootfall + homeServiceTotalFootfall + retailCountFootfall
        UserDefaults.standard.set(footfallCount, forKey: UserDefauiltsKeys.k_key_FootfallToatal)
    }
    
}

extension TechnicianDashboardViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.isGridView == false{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardListCollectionViewCell", for: indexPath) as! DashboardListCollectionViewCell
            switch indexPath.row {
            case 0://Revenue
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_RevenueTotal)) as! Double)
            case 1: // sales
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_SalesToatal)) as! Double)
            case 2: // free services
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_FreeServicesToatal)) as! Double)
            case 3: // footfall
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_FootfallToatal)) as! Double)
                
            default:
                cell.configureSection(currentIndex: indexPath.row, income: 0000)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardGridCollectionViewCell", for: indexPath) as! DashboardGridCollectionViewCell
            switch indexPath.row {
            case 0://Revenue
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_RevenueTotal)) as! Double)
            case 1: // sales
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_SalesToatal)) as! Double)
            case 2: // free services
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_FreeServicesToatal)) as! Double)
            case 3: // footfall
                cell.configureSection(currentIndex: indexPath.row, income: (UserDefaults.standard.value(forKey: UserDefauiltsKeys.k_key_FootfallToatal)) as! Double)
                
            default:
                cell.configureSection(currentIndex: indexPath.row, income: 0000)
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.isGridView == false{
            let noOfCellsInRow = 1
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 102)
        }else{
            let noOfCellsInRow = 2
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: size - 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0://Revenue
            let vc = RevenuesViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1://Sales
            let vc = SalesViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2://Free services
            let vc = FreeServicesViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 3://Footfall
            let vc = FootfallViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 4://Customer engagement
            let vc = CustomerEngagementViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 5://Productivity
            break
//            let vc = ProductivityViewController.instantiate(fromAppStoryboard: .Incentives)
//            self.navigationController?.pushViewController(vc, animated: true)
        case 6://Penetration ratio
            let vc = PenetrationRatiosViewController.instantiate(fromAppStoryboard: .Incentives)
            self.navigationController?.pushViewController(vc, animated: true)
        case 7://Resource utilization
            break
//            let vc = ResourceUtilisationViewController.instantiate(fromAppStoryboard: .Incentives)
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        
        }
    }
    
}
