//
//  EmployeeListingModels.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum EmployeeListing
{
    // MARK: Use cases
    
    enum GetEmployeeList {
        
        struct Request: Codable {
            let salon_code: String
            let fromDate: String
            let toDate: String
        }
        
        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            var data: [EmployeeData]?
            var time_stamp: String = ""
        }
        
        struct EmployeeData: Codable {
            let first_name: String?
            let last_name: String?
            let category_name: String?
            let shift_name: String?
            let start_time: String?
            let end_time: String?
            let date: String?
            let is_leave: Int?
            let leave_type_id: Int?
            let leave_type: String?
            let employee_id: Int?
            let roster_id: Int?
            let shift_id: Int?
            let designation: String?
            let rating: Double?
            let attendance_status: String?
        }
    }
}
