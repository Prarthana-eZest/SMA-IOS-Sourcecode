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
            let page_no: Int?
            let limit: Int?
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String?
            let data: ResponseDetails?
        }

        struct ResponseDetails: Codable {
            let total_records: Int?
            let records: [Data]?
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
            let approval_request_details: RequestDetails?
        }

        struct ApprovalData: Codable {
            let service_id: String?
            let service_name: String?
            let service_code: String?
            let service_category: String?
            let service_duration: String?
            let price: String?
            let start_time: String?
            let end_time: String?
        }

        struct RequestDetails: Codable {
            let appointment: Appointment?
            let services: [Service]?
            let original: TimeSlotDetails?
            let requested: TimeSlotDetails?
            let service: [AddDeleteService]?
        }

        struct Appointment: Codable {
            let appointment_date: String?
            let service_at: String?
            let booking_number: String?
            let payment_status: String?
            let customer_name: String?
            let customer_last_name: String?
            let customer_id: Int64?
            let customer_gender: String?
            let customer_contact: String?
            let customer_address1: String?
            let customer_address2: String?
            let customer_email: String?
            let landmark: String?
            let notes: String?
            let booking_technician_id: Int64?
            let booking_technician: String?
        }

        struct Service: Codable {
            let service_name: String?
            let service_duration: Int?
            let start_time: String?
            let end_time: String?
            let technician_preference: String?
            let appointment_type: String?
            let notes: String?
            let price: Double?
            let customer_name: String?
            let customer_last_name: String?
            let customer_gender: String?
            let customer_contact: String?
            let customer_address1: String?
            let customer_address2: String?
            let parent_sku: String?
            let customer_email: String?
            let parent_name: String?
            let product_type: String?
            let is_consultation_required: Int?
            let consultation_form_list: String?
            let servicing_technician: String?
            let booking_technician: String?

        }

        struct AddDeleteService: Codable {
            let appointment_date: String?
            let service_name: String?
            let service_code: String?
            let service_category: String?
            let service_duration: Int?
            let price: Double?
            let booked_by: String?
            let booked_by_contact: String?
            let booked_by_email: String?
            let booked_for: String?
            let booked_for_contact: String?
            let booking_technician: String?
            let servicing_technician: String?
            let service_for: String?
            let start_time: String?
            let end_time: String?
            let technician_preference: String?
            let appointment_type: String?
            let servicing_technician_designation: String?
        }

        struct TimeSlotDetails: Codable {
            let service_name: String?
            let start_time: String?
            let end_time: String?
            let date: String?
            let price: AnyCodable?
            let service_duration: AnyCodable?
            let total_duration: AnyCodable?
        }
    }

    enum ProcessRequest {

        struct Request: Codable {
            let addData: RequestDetails?
            let is_custom: Bool?
        }

        struct RequestDetails: Codable {
            let status: String?
            let ref_id: Int64?
            let category: String?
            let employee_id: String?
            let module_name: String?
            let reason: String?
            let customer_id: Int64?
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String?
        }
    }
}
