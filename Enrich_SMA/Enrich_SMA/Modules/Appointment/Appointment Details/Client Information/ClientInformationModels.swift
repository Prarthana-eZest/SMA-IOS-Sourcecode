//
//  ClientInformationModels.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 08/11/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ClientInformation {
    // MARK: Use cases

    enum GetAppointnentHistory {
        struct Request: Codable {
            let salon_code: String
            let employee_code: String
            let customer_id: String
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data: [Data]?
            let time_stamp: String?
        }

        struct Data: Codable {
            let appointment_id: Int?
            let appointment_date: String?
            let booking_technician_id: Int?
            let appointment_type: String?
            let status: String?
            let booked_by: String?
            let customer_address: String?
            let booked_by_contact: String?
            let booked_by_id: Int?
            let booking_technician: String?
            let payment_status: String?
            let landmark: String?
            let last_visit: String?
            let avg_rating: Double?
            let services: [Services]?
            let serviceCount: Int?
            let total_duration: Int?
            let start_time: String?
            let end_time: String?
            let customer_latitude: Double?
            let customer_longitude: Double?

            // Now params
            let customer_name: String?
            let customer_email: String?
            let customer_mobile_number: String?
            let customer_ratings: Double?
            let high_expensive: Bool?
            let membership: String?
            let gender_label: String?
            let gender: Int?
            let profile_picture: String?
            let is_customer_rated: Bool?

        }

        struct Services: Codable {
            let service_id: Int?
            let service_code: String?
            let service_name: String?
            let service_duration: Int?
            let price: AnyCodable?
            let start_time: String?
            let end_time: String?
            let customer_latitude: Double?
            let customer_longitude: Double?
            let station_id: Int?
            let reason: String?
            let category_name: String?
            let technician_preference: String?
            let technician_designation: String?
            let status: String?
            let previous_service_id: String?
            let id: Int?
            let technician_id: Int?
            let servicing_technician: String?
            let booked_for: String?
            let booked_for_contact: String?
        }
    }

    enum MembershipDetails {

        struct Request: Codable {
            let customer_id: String
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data: MembershipData?
        }
        struct MembershipData: Codable {
            let id: String?
            let name: String?
            let start_date: String?
            let end_date: String?
            let no_of_addon: String?
            let validity_in_days: String?
            let is_renew_period: Bool?
            let no_days_left: Int?
            let no_of_addon_added: Int?
            let offers: [String]? // This is for Frindge Benefits
        }
    }

    enum Preferences {

        struct Request: Codable {
            let customer_id: String
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data: PreferencesData?
        }
        struct PreferencesData: Codable {
            let preferred_bevarages: String?
            let preferred_salon: [PrefferedSalon]?
            let preferred_stylist: [PrefferedStylist]?
        }

        struct PrefferedStylist: Codable {
            let user_id: String?
            let name: String?
        }

        struct PrefferedSalon: Codable {
            let salon_name: String?
            let salon_location: String?
        }

    }

    enum ClientNotes {

        struct Request: Codable {
            let customer_id: String
            let is_custom: Bool
        }

        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data: Data?
        }

        struct Data: Codable {
            let ask: [NotesData]?
            let observe: [NotesData]?
            let ratings: [NotesData]?
        }

        struct NotesData: Codable {
            let entity_id: String?
            let customer_id: String?
            let note_type: String?
            let note: String?
            let note_by: String?
            let customer_rating: String?
            let customer_rating_comment: String?
            let updated_by: String?
            let created_at: String?
            let updated_at: String?
        }

    }

}

let consulationData: [TagViewModel] = [TagViewModel(title: "Type of hair", tagView: [TagViewString(text: "DRY", isSelected: true),
                                                                                    TagViewString(text: "FRIZZY", isSelected: false),
                                                                                    TagViewString(text: "SENSITIVE", isSelected: false),
                                                                                    TagViewString(text: "VERGIN", isSelected: false),
                                                                                    TagViewString(text: "CHEMICALLY TREATED", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Hair Elasticity", tagView: [TagViewString(text: "POOR", isSelected: false),
                                                                                       TagViewString(text: "GOOD", isSelected: true)], isSingleSelection: true),
                                      TagViewModel(title: "Hair Sensitivity", tagView: [TagViewString(text: "POROUS", isSelected: false),
                                                                                        TagViewString(text: "SENSITIZED", isSelected: false)], isSingleSelection: true),
                                      TagViewModel(title: "Scalp Sensitivity", tagView: [TagViewString(text: "HEALTHY", isSelected: false),
                                                                                         TagViewString(text: "ALLERGIC", isSelected: false),
                                                                                         TagViewString(text: "ITCHY", isSelected: false),
                                                                                         TagViewString(text: "INFECTED", isSelected: false),
                                                                                         TagViewString(text: "REDNESS", isSelected: false)], isSingleSelection: false),

                                      TagViewModel(title: "Hair Texture", tagView: [TagViewString(text: "FINE", isSelected: false),
                                                                                    TagViewString(text: "MEDIUM", isSelected: false),
                                                                                    TagViewString(text: "THICK", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Skin Type", tagView: [TagViewString(text: "NORMAL", isSelected: false),
                                                                                 TagViewString(text: "OILY", isSelected: false),
                                                                                 TagViewString(text: "DRY", isSelected: false),
                                                                                 TagViewString(text: "COMBINATION", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Skin Sensitivity", tagView: [TagViewString(text: "NORMAL", isSelected: false),
                                                                                        TagViewString(text: "SENSITIVE", isSelected: false),
                                                                                        TagViewString(text: "HYPERSENSITIVE", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Muscle Tone", tagView: [TagViewString(text: "POOR", isSelected: false),
                                                                                   TagViewString(text: "AVERAGE", isSelected: false),
                                                                                   TagViewString(text: "GOOD", isSelected: false)], isSingleSelection: true),

                                      TagViewModel(title: "Skin Concerns", tagView: [TagViewString(text: "PIGMENTATION", isSelected: false),
                                                                                     TagViewString(text: "DEHYGRATION", isSelected: false),
                                                                                     TagViewString(text: "BLACK HEADS", isSelected: false),
                                                                                     TagViewString(text: "ACNE", isSelected: false),
                                                                                     TagViewString(text: "HYPERSENSITIVE", isSelected: false)], isSingleSelection: false),

                                      TagViewModel(title: "Contraindications for facial using high frequency or galvanic", tagView: [TagViewString(text: "PIGMENTATION", isSelected: false),
                                                                                                                                     TagViewString(text: "HIGH BLOOD PRESSURE", isSelected: false),
                                                                                                                                     TagViewString(text: "DIABETES", isSelected: false),
                                                                                                                                     TagViewString(text: "CLAUSTROPHOBIA", isSelected: false),
                                                                                                                                     TagViewString(text: "ASTHAMA", isSelected: false),
                                                                                                                                     TagViewString(text: "METAL TOOTH FILLINGS", isSelected: false),
                                                                                                                                     TagViewString(text: "PREGNANCY", isSelected: false)], isSingleSelection: false)]
