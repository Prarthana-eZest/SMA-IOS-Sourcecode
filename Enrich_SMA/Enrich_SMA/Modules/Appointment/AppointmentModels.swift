//
//  AppointmentModels.swift
//  Enrich_SMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright (c) 2019 e-zest. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Appointment
{
  // MARK: Use cases
  
    enum GetAppointnents
    {
        struct Request: Codable {
            let status: String
            let salon_code: String
            let date: String
        }
        
        struct Response: Codable {
            var status: Bool = false
            var message: String = ""
            let data : [Data]?
            let time_stamp : String?
        }
        
        struct Data : Codable {
            let appointment_id : Int?
            let appointment_date : String?
            let booking_technician_id : Int?
            let appointment_type : String?
            let status : String?
            let booked_by : String?
            let customer_address : String?
            let booked_by_contact : String?
            let booked_by_id : Int?
            let booking_technician : String?
            let payment_status : String?
            let landmark : String?
            let last_visit : String?
            let avg_rating : Double?
            let services : [Services]?
            let serviceCount : Int?
            let total_duration : Int?
            let start_time : String?
            let end_time : String?
            let customer_latitude : Double?
            let customer_longitude : Double?
            
            // Now params
            let customer_name : String?
            let customer_email : String?
            let customer_mobile_number : String?
            let customer_ratings : Double?
            let high_expensive : Bool?
            let membership : String?
            let gender_label : String?
            let gender: Int?
            let profile_picture : String?
            let is_customer_rated: Bool?

        }
        
        
        struct Services : Codable {
            let appointment_type : String?
            let service_id : Int?
            let service_code : String?
            let service_name : String?
            let service_duration : Int?
            let price : AnyCodable?
            let start_time : String?
            let end_time : String?
            let customer_latitude : Double?
            let customer_longitude : Double?
            let station_id : Int?
            let reason : String?
            let category_name : String?
            let technician_preference : String?
            let technician_designation : String?
            let status : String?
            let previous_service_id : Int?
            let id : Int?
            let technician_id : Int?
            let servicing_technician : String?
            let booked_for : String?
            let booked_for_id : Int?
            let booked_for_contact : String?
        }
    }
}
