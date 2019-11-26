//
//  OTPVerificationModuleModels.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 3/4/19.
//  Copyright (c) 2019 Aman Gupta. All rights reserved.
//
//
//

import UIKit

enum OTPVerificationModule
{
    // MARK: Use cases
    
    enum ChangePasswordWithOTPVerification
    {
        struct Request:Codable
        {
            let username: String
            let otp: String
            let password: String
            let confirm_password: String
            let is_custom: String  = "1"
        }
        
        struct Response:Codable
        {
            //let data: Any?
            let message: String?
            let status: Bool?
        }
    }
}
