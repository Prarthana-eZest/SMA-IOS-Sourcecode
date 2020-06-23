//
//  ConstantsStrings.swift
//  EnrichSalon
//
//  Created by Mugdha Mundhe on 4/2/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import UIKit

let is_iPAD = UIDevice.current.model.hasPrefix("iPad")
let screenPopUpAlpha: CGFloat = 0.50
let kProductCountPerPageForListing = 10
let searchBarInsideBackgroundColor: UIColor = UIColor(red: 251 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1.0)
let toastMessageDuration: Double = 2.0
let tableViewNoDataAvailable = "No data available"
let tableViewNoSalonAvailable = "No salons available"
let tableViewNoServiceAvailable = "No services available"
let tableViewNoAddOnsAvailable = "No add-ons available"
let noReviewsMessage = "Be the first one to review"
let tableViewNoAddressAvailable = "No addresses available"

let navigationBarTitleTrimTo = 28
let GenericErrorLoginRefreshToken = "Something went wrong. Please do login again."
let GenericError = "Unable to fetch all the information from server. Please try after some time."
let alertTitle = "Alert!"
let alertTitleSuccess = "Success!"
let maxlimitToProductQuantity: Int64 = 5
let country = "IN"
//let minlimitToProductQuantity = 1

let sessionExpire = "Your session is expired. Please do re-login again."

let forceUpdateNotNowDuration = 15

enum ImageNames: String {
    case enabledRed = "enabledButton.png"
    case disabledGray = "disabledButton.png"
    case enabledLogo = "iconImgOtpSelected"
    case disabledLogo = "iconImgOtpNonSelected"
}

class ConstantsStrings: NSObject {

}

enum TableViewNoData {
    static let tableViewNoDataAvailable = "No data available"
    static let tableViewNoSalonAvailable = "No salons available"
    static let tableViewNoServiceAvailable = "No services available"
    static let tableViewNoAddOnsAvailable = "No add-ons available"
    static let tableViewNoReviewsAvailable = "No reviews available"
    static let tableViewNoAddressAvailable = "No addresses available"
    static let tableViewNoGiftSentAvailable = "No gifts sent data available"
    static let tableViewNoGiftReceivedAvailable = "No gifts received data available"
    static let tableViewNoPastBookingsAvailable = "No bookings available"
    static let tableViewNoValuePackagesAvailable = "No value package data available"
    static let tableViewNoServicePackagesAvailable = "No service package data available"
    static let tableViewNoReferalPointsAvailable = "No referral points available"
    static let tableViewNoOrdersAvailable = "No orders available"
    static let tableViewNoNotificationsAvailable = "No notifications available"

}

enum FontName: String {
    case FuturaPTBook = "FuturaPT-Book"
    case FuturaPTDemi = "FuturaPT-Demi"
    case FuturaPTMedium = "FuturaPT-Medium"
    case NotoSansSemiBold = "NotoSans-SemiBold"
    case NotoSansRegular = "NotoSans-Regular"

}

enum NavigationBarTitle {
    static let orderConfirmation = "Order Confirmation"
    static let bookingDetails = "Booking Details"
    static let detailedSummary = "Detailed Summary"
    static let addNewAddress = "Add New Address"
    static let editAddress = "Edit Address"
    static let myWishList = "My Wishlist"
    static let myBookings = "My Bookings"

}

enum SalonServiceTypes {
    static let simple = "simple"
    static let configurable = "configurable"
    static let bundle = "bundle"

}
enum SalonServiceAt {
    static let home = "Home"
    static let Salon = "Salon"
    static let Anny = "Any"

}
enum PersonType {
    static let male = "Male"
    static let female = "Female"
}
enum SalonServiceSpecifierFormat {
    static let priceFormat = "%.1f"
    static let reviewFormat = "%.0f"
}

enum ServiceStaticID: String {
    case salonId = "34"
    case homeId = "91"
}
enum ProductConfigurableDetailType {
    static let quantity = "container_qty"
    static let color = "color"
}

enum AlertMessagesSuccess {
    static let removedService = "Service Removed Successfully."
    static let userCancelPayTmTransaction = "User cancelled transaction."
    static let orderPlacedSuccessfully = "Order Placed Successfully."
    static let logoutSuccessfully = "Logout successfully."
    static let eventSuccess = "Event added successfully"
    static let newAppVersion = "New version available. Update now & get new features."
    static let savedCustomerSignature = "Signature saved successfully"
}
enum AlertMessagesToAsk {
    static let removeService = "Are you sure you want to remove this service?"
    static let askToLogout = "Are you sure you want to logout?"
    static let askToPunchIn = "Are you sure you want to punch in?"
    static let askToPunchOut = "Are you sure you want to punch out?"
    static let askToDeleteAddress = "Are you sure you want to delete address?"
    static let defaultAddress = "Dafault address cannot be removed."
    static let addNewNote = "Please add note"
    static let termsAdnConditions = "Please accept terms and conditions"
    static let takeCustomerSignature = "Please take customer signature"
    static let saveCustomerSignature = "Please save customer signature"
    static let formValidation = "Please fill all required fields"

    // Device Authentication
    static let deviceAuthentication = "Device is not authorised. Do you want to authenticate this device?"
}
enum AlertButtonTitle {
    static let yes = "Yes"
    static let no = "No"
    static let ok = "Ok"
    static let home = "Home"
    static let salon = "Salon"
    static let cancel = "Cancel"
    static let gotToCart = "Go To Cart"
    static let proceed = "Proceed"
    static let callUs = "Call"
    static let emailUs = "Email"
    static let alertTitle = "Alert!"
    static let done = "Done"
    static let select = "Select"
    static let addToCart = "ADD TO CART"
    static let needHelp = "Need Help?"
    static let error = "Error"
    static let save = "Save"
    static let continuebtn = "Continue"
    static let apply = "Apply"
    static let update = "Update"
    static let updateNotNow = "Not Now"
}

enum AlertToWarn {
    static let selectedSalonNotInRange = "We are sorry!\nAt the moment our Home Services are not available in your selected location. \n You can try some other location\nor\nAvail our Salon Services."
    static let eventError = "Event not added."

}

enum FCMTopicKeys {
    static let employee = "EMPLOYEE_"
    static let employeeAll = "EMPLOYEE"
    static let salon = "SALON_"
    static let manager = "MANAGER"
}
