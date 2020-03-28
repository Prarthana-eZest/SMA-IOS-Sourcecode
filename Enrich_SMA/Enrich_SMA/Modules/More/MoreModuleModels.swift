//
//  MoreModuleModels.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

enum MoreModule {
    // MARK: Use cases

    enum GetCheckInStatus {

        struct Request: Codable {
            let emp_code: String
            let date: String
            let is_custom: Bool
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            var count: Int?
        }
    }

    enum MarkCheckInOut {

        struct Request: Codable {
            let emp_code: String
            let emp_name: String
            let branch_code: String
            let checkinout_time: String
            let checkin: String
            let employee_latitude: String
            let employee_longitude: String
            let is_custom: Bool
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
        }
    }
}
