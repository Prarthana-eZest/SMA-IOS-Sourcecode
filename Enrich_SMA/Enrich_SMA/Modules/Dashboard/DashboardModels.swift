//
//  DashboardModels.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 15/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Dashboard {

    // MARK: Use cases
    enum GetDashboardData {

        struct Request: Codable {
            let is_custom: Bool
            let salon_id: String
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            var data: Data?
        }

        struct Data: Codable {
            let daily_revenue_data: [revenueData]?
            let monthly_revenue_data: [revenueData]?
        }

        struct revenueData: Codable {
            let entity_id: AnyCodable?
            let salon_id: AnyCodable?
            let salon_name: AnyCodable?
            let monthly_date: AnyCodable?
            let membership_target: AnyCodable?
            let membership_revenue: AnyCodable?
            let membership_sold_percentage: AnyCodable?
            let service_target: AnyCodable?
            let service_revenue: AnyCodable?
            let service_revenue_percentage: AnyCodable?
            let products_target: AnyCodable?
            let products_revenue: AnyCodable?
            let products_revenue_percentage: AnyCodable?
            let sales_modified: AnyCodable?
            let total_collection: AnyCodable?
            let total_net_revenue: AnyCodable?
            let total_gross_sales: AnyCodable?
            let total_gross_revenue: AnyCodable?
            let runrate_percentage: AnyCodable?
        }
    }
    enum GetForceUpadateInfo {

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            var data: Data?
        }

        struct Data: Codable {
            let force_update_info: ForceUpdateInfo?
        }

        struct ForceUpdateInfo: Codable {
            let tma_ios: Info?
            let sma_ios: Info?
        }

        struct Info: Codable {
            let latest_version: String?
            let force_update: Bool?
            let app_link: String?
        }
    }
    
    enum GetBMTDashboard {
        
        struct Request: Codable {
            let is_custom: Bool
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            var data: [Data]?
        }

        struct Data: Codable {
            let bmt_incentive_dashboard: Reports.GetReports.Data?
        }
    }
    
    enum GetRevenueDashboard {
        struct Request: Codable {
        }
        
        struct Response : Codable {
            let status : Bool?
            let message : String?
            let data : DataClass?
        }
        
        struct DataClass : Codable {
            let configuration : Configuration?
            let filters : Filters?
            let total_revenue_transactions : Double?
            let revenue_transactions : [Revenue_transaction]?
            let total_rm_consumption_count : Double?
            let rm_consumption : [Rm_consumption]?
            let total_quality_score_count : Double?
            let quality_score_data : [Quality_score_data]?
            let total_attendance_count : Double?
            let attendance_data : [Attendance_data]?
            let technician_feedbacks : [TechnicianFeedback]?
            let total_client_repeat_transactions : Int?
            let client_repeat_transactions : [Client_repeat_transactions]?
        }
        
        struct Configuration : Codable {
            let start_date : String?
            let end_date : String?
            let past_data_limit : Double?
            let free_services_percentage : Double?
            let salon_area : Double?
            let salon_stations : Double?
            let target_achievement_formula : String?
            let ctc : Double?
            let fix_pay : Double?
            let take_home_salary : Double?
            let minimum_rm_consumption : String?
            let minimum_quality_score : String?
            let salon_targets : [Salon_targets]?
        }
        
        struct Filters : Codable {
            let packages : Packages?
            let category_tree : [Category_tree]?
            let service_gender : [String]?
            let service_inclined_other_gender : [String]?
            let penetration_ratios : [Penetration_ratios]?
        }
        
        struct Revenue_transaction : Codable {
            let salon_code : String?
            let salon_name : String?
            let date : String?
            let employee_id : Int?
            let employee_code : String?
            let customer_id : Int?
            let customer_name : String?
            let order_number : String?
            let invoice_number : String?
            let product_category_type : String?
            let package_type : String?
            let appointment_type : String?
            let platform : String?
            let service_gender : String?
            let service_inclined_other_gender : String?
            let sku : String?
            let product_name : String?
            let category : String?
            let sub_category : String?
            let total_discount_amount : Double?
            let total_giftcard_discount : Double?
            let total_technician_charge_giftcard_discount : Double?
            let total_rewards_discount : Double?
            let total_technician_charge_rewards_discount : Double?
            let total_package_redemption : Double?
            let total : Double?
            let grooming_giftcard : Double?
            let complimentary_giftcard : Double?
            let paid_service_revenue : Double?
            let salon_paid_service_revenue : Double?
            let home_paid_service_revenue : Double?
            let app_booking_revenue : Double?
            let retail_products_revenue : Double?
            let membership_count : Double?
            let membership_new_count : Double?
            let membership_renew_count : Double?
            let membership_revenue : Double?
            let membership_new_revenue : Double?
            let membership_renew_revenue : Double?
            let value_package_count : Double?
            let value_package_revenue : Double?
            let service_package_count : Double?
            let service_package_revenue : Double?
            let free_service_revenue : Double?
            
            lazy var formmatedDate: String = {
                return String()
            }()
        }
        
        struct Rm_consumption : Codable {
            let rm_consumption : Double?
            let salon_code : String?
            let consumption_date : String?
        }
        
        struct Quality_score_data : Codable {
            let id : Int?
            let audit_number : String?
            let score : Double?
            let category_code : String?
            let salon_code : String?
            let region : String?
            let date : String?
        }
        
        struct Attendance_data : Codable {
            let id : Int?
            let employee_code : String?
            let salon_code : String?
            let attendance : String?
            let attendance_label : String?
            let date : String?
            let shift_start_time : String?
            let shift_end_time : String?
            let checkin_time : String?
            let checkout_time : String?
        }
        
        struct Salon_targets : Codable {
            let month : Int?
            let target : Double?
        }
        
        struct Packages : Codable {
            let value : [Value]?
            let service : [Service]?
        }
        
        struct Category_tree : Codable {
            let main_category_label : String?
            let sub_categories : [Sub_categories]?
        }
        
        struct Penetration_ratios : Codable {
            let heading : String?
            let compare_categories : [String]?
            let compare_label : String?
            let to_compare_categories : [String]?
            let to_compare_label : String?
        }
        
        struct Value : Codable {
            let id : String?
            let sku : String?
            let name : String?
            let package_type : String?
        }
        
        struct Service : Codable {
            let id : String?
            let sku : String?
            let name : String?
            let package_type : String?
        }
        
        struct Sub_categories : Codable {
            let sub_category_name : String?
        }
        
        // MARK: - TechnicianFeedback
        struct TechnicianFeedback : Codable{
            let employee_id : Int?
            let date : String?
            let no_of_services : Int?
            let no_of_feedbacks : Int?
            let technician_avg_ratings : Double?
            let service_avg_ratings : Double?
        }
        
        //MARK: - Client repeat transactions
        struct Client_repeat_transactions : Codable {
            let employee_id : Int?
            let customer_id : Int?
            let service_revenue : Double?
            let date : String?
            let for_appointment_date : String?
        }
    }
}
