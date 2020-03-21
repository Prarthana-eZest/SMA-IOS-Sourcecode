//
//  AllReviewsModuleModels.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

enum AllReviewsModule {
  // MARK: Use cases

    enum SalonRatings {

        struct Request: Codable {
            let salon_code: String
            let date: String
            let is_custom: Bool
            let customer_id: String
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data: Data?
        }

        struct Data: Codable {
            let appointmentFeedbacks: [AppointmentFeedbacks]?
        }

        struct AppointmentFeedbacks: Codable {
            let entity_id: String?
            let customer_id: String?
            let appointment_id: String?
            let appointment_date: String?
            let service_feedback_data: [ServiceFeedback]?
            let technician_feedback_data: [TechnicianFeedback]?
            let salon_feedback_data: [SalonFeedback]?
            let recommend_to_other: String?
            let share_feedback: String?
            let feedback_comment: String?
            let status: String?
            let customer_name: String?
            let customer_email: String?
            let customer_mobile_number: String?
        }

        struct ServiceFeedback: Codable {
            let name: String?
            let id: String?
            let rating: String?
        }

        struct TechnicianFeedback: Codable {
            let name: String?
            let id: String?
            let rating: String?
        }

        struct SalonFeedback: Codable {
            let code: String?
            let rating: String?
        }

    }

}
