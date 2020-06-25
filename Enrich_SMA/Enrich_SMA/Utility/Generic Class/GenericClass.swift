//
//  GenericClass.swift
//  EnrichSalon
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import Foundation
import UIKit

// MARK: - struct - FilterKeys, ListingDataModel

struct FilterKeys {
    let field: String?
    let value: Any?
    let type: String?
}

func BG(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

func UI(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

class GenericClass: NSObject {

    static let sharedInstance = GenericClass()

    // ------------- SEARCH FIELDS  -------------
    let filterGroups = "searchCriteria[filterGroups]"
    let appendField = "[filters][0][field]"
    let appendValue = "[filters][0][value]"
    let appendConditionType = "[filters][0][conditionType]"
    let searchGroupField = "searchCriteria[sortOrders][0][field]"
    let searchGroupDirection = "searchCriteria[sortOrders][0][direction]"
    // -------------  -------------  -------------

    func convertCodableToJSONString<T: Codable>(obj: T) -> String? {

        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(obj)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? ""

        }
        catch {

        }
        return nil
    }
    func convertJSONToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }

    func getDeviceUUID() -> String {
        let uniqueDeviceId: String? = KeychainWrapper.standard.string(forKey: UserDefauiltsKeys.k_key_UniqueDeviceId)

        guard uniqueDeviceId != nil else {
            let uuid = generateUuid()
            let saveSuccessful: Bool = KeychainWrapper.standard.set(uuid, forKey: UserDefauiltsKeys.k_key_UniqueDeviceId)
            if saveSuccessful {
                return uuid
            }
            else {
                fatalError("Unable to save uuid")
            }

        }
        return uniqueDeviceId!
    }

    private func generateUuid() -> String {

        let uuidRef: CFUUID = CFUUIDCreate(nil)
        let uuidStringRef: CFString = CFUUIDCreateString(nil, uuidRef)
        return uuidStringRef as String
    }

}

extension GenericClass {

    func resetServiceLabels(text: String, rangeText: String, fontName: UIFont, lable: UILabel) {
        let range = (text as NSString).range(of: rangeText)
        let attribute = NSMutableAttributedString(string: text)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: fontName, range: range)
        lable.attributedText = attribute

    }

    func setDefault(text: String, rangeText: String, fontName: UIFont, lable: UILabel) {
        let range = (text as NSString).range(of: rangeText)
        let attribute = NSMutableAttributedString(string: text)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: fontName, range: range)
        lable.attributedText = attribute

    }

    func getUserLoggedInInfoKeyChain() -> LoginModule.UserLogin.UserData? {

        let uniqueUserInfo: Data? = KeychainWrapper.standard.data(forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn)
        guard uniqueUserInfo != nil else {
            return nil
        }
        if let data = uniqueUserInfo,
            let value = try? JSONDecoder().decode(LoginModule.UserLogin.UserData.self, from: data) {
            return value
        }
        return nil
    }

    func setUserLoggedInfoInKeyChain(data: Data) {
        KeychainWrapper.standard.set(data, forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn)
    }

}

extension GenericClass {

    func isuserLoggedIn() ->(status: Bool, accessToken: String, refreshToken: String) {

        var userAccessToken: String = ""
        var userRefreshToken: String = ""
        var userstatus: Bool = false

        if let dummy = getUserLoggedInInfoKeyChain() {
            userstatus = true
            userAccessToken = (dummy.access_token ?? "")
            userRefreshToken = dummy.refresh_token ?? ""
        }

        return(userstatus, userAccessToken, userRefreshToken)
    }
}

extension GenericClass {

    func getConditionalFieldKey(index: Int, indexFilter: Int) -> String {
        let strField = appendField.replacingOccurrences(of: "0", with: "\(indexFilter)")
        return filterGroups + "[\(index)]" + strField
    }

    //searchCriteria[filterGroups] + [1] + [filters][0][value]
    func getConditionalValueKey(index: Int, indexFilter: Int) -> String {
        let strField = appendValue.replacingOccurrences(of: "0", with: "\(indexFilter)")
        return filterGroups + "[\(index)]" + strField
    }

    func getConditionalTypeKey(index: Int, indexFilter: Int) -> String {
        let strField = appendConditionType.replacingOccurrences(of: "0", with: "\(indexFilter)")
        return filterGroups + "[\(index)]" + strField
    }

    func getSortingFieldKey() -> String {
        return searchGroupField
    }

    func getSortingDirectionKey() -> String {
        return searchGroupDirection
    }

//    func getURLForType(arrSubCat_type: [FilterKeys], pageSize: Int, currentPageNo: Int) -> String
    func getURLForType(arrSubCat_type: [FilterKeys]) -> String {

        var strFinal = ""
        for (index, value) in arrSubCat_type.enumerated() {

            let model = value

            //  ---------- FILTER And Description CONDITIONS -----
            if model.field == "filter" || model.field == "description_own" {
                if let arrFilters = model.value as? [FilterKeys] {
                    for (indexObj, modelObj) in arrFilters.enumerated() {
                        strFinal = strFinal.isEmpty ? (strFinal + "?") : (strFinal + "&")

                        let strFieldKey0 = "\(GenericClass.sharedInstance.getConditionalFieldKey(index: index, indexFilter: indexObj))"
                        let strValueKey0 = "\(GenericClass.sharedInstance.getConditionalValueKey(index: index, indexFilter: indexObj))"
                        let strTypeKey0 = "\(GenericClass.sharedInstance.getConditionalTypeKey(index: index, indexFilter: indexObj))"

                        strFinal += "\(strFieldKey0)=\(modelObj.field ?? "")" + "&\(strValueKey0)=\(modelObj.value ?? "")" + "&\(strTypeKey0)=\(modelObj.type ?? "")"
                    }
                }
                //  ---------- SORT CONDITIONS -----
            }
            else if model.field == "sort" {
                strFinal = strFinal.isEmpty ? (strFinal + "?") : (strFinal + "&")

                strFinal +=  "\(GenericClass.sharedInstance.getSortingFieldKey())=\(model.type ?? "")" + "&\(GenericClass.sharedInstance.getSortingDirectionKey())=\(model.value ?? "")"
            }
            else {
                strFinal = strFinal.isEmpty ? (strFinal + "?") : (strFinal + "&")

                // GET KEYS
                let strFieldKey0 = "\(GenericClass.sharedInstance.getConditionalFieldKey(index: index, indexFilter: 0))"
                let strValueKey0 = "\(GenericClass.sharedInstance.getConditionalValueKey(index: index, indexFilter: 0))"
                let strTypeKey0 = "\(GenericClass.sharedInstance.getConditionalTypeKey(index: index, indexFilter: 0))"

                // CREATE PARAMETERS WITH VALUES
                let strFieldKey2 = "\(strFieldKey0)=\(model.field ?? "")"
                let strValueKey2 = "&\(strValueKey0)=\(model.value ?? 0)"
                let strTypeKey2 = "&\(strTypeKey0)=\(model.type ?? "")"

                //  ---------- PARAMETERS -----
                strFinal += "\(strFieldKey2)" + "\(strValueKey2)" + "\(strTypeKey2)"
            }
        }

//        // IF CATEGORYID AVAIALABLE ADD
//        if(customer_id != 0 && isCustomerIdNeed) {
//            strFinal = strFinal + "&" + "customer_id=\(customer_id)"
//        }

//        //  ---------- PAGINATION -----
//        strFinal = strFinal + "&" + "searchCriteria[pageSize]=\(pageSize)"
//        strFinal = strFinal + "&" + "searchCriteria[currentPage]=\(currentPageNo)"

        print("\(strFinal)")
        return strFinal
    }
}

extension GenericClass {
    func getSalonId() -> String? {
//        if  let userSelectionForService = UserDefaults.standard.value( UserSelectedLocation.self, forKey: UserDefauiltsKeys.k_Key_SelectedSalonAndGenderForService) {
//            return userSelectionForService.salon_id
//        }
        return nil
    }

    func getCustomerId() -> (toDouble: Double, toString: String) {

//        if let userLoggedIn = UserDefaults.standard.value( OTPVerificationModule.ChangePasswordWithOTPVerification.Response.self, forKey: UserDefauiltsKeys.k_Key_LoginUserSignIn) {
//            //            if let accessToken = userLoggedIn.data?.access_token,!accessToken.isEmpty{
//            return (Double(userLoggedIn.data?.customer_id ?? "")!, (userLoggedIn.data?.customer_id ?? ""))
//            //            }
//        }
        return (0, "")
    }

    func getGender() -> String? {
        //        if  let userSelectionForService = UserDefaults.standard.value( UserSelectedLocation.self, forKey: UserDefauiltsKeys.k_Key_SelectedSalonAndGenderForService.rawValue){
        //            return userSelectionForService.gender
        //        }

        return nil
    }

    func getFCMTopicKeys(keyFor: String) -> String {

        var  fcmTopicKeys = "DEV_"
        #if DEBUG
        print("DEBUG")
        fcmTopicKeys =  "DEV_" + keyFor
        #elseif STAGE
        print("STAGE")
        fcmTopicKeys =  "STG_" + keyFor
        #elseif RELEASE
        print("RELEASE")
        fcmTopicKeys = "PROD_" + keyFor
        #endif

        return fcmTopicKeys
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
