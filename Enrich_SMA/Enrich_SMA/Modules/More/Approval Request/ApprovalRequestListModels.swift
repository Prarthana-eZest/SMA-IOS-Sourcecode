//
//  ApprovalRequestListModels.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 09/03/20.
//  Copyright (c) 2020 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ApprovalRequestList {
    // MARK: Use cases

    enum GetRequestData {

        struct Request: Codable {
            let addData: SalonDetails?
            let is_custom: Bool?
        }

        struct SalonDetails: Codable {
            let salon_id: String?
        }

        struct Response: Codable {
            var status: String?
            var message: String?
            let data: [Data]?
        }

        struct Data: Codable {
            let id: Int64?
            let module_name: String?
            let ref_id: Int64?
            let category: String?
            let description: String?
            let approval_status: String?
            let denied_reason: String?
            let approved_by: Int64?
            let approval_data: AnyCodable?
            let created_at: String?
            let updated_at: String?
            let customer_name: String?
            let customer_id: Int64?
            let technician_name: String?
            let technician: Int64?
        }
    }
}
