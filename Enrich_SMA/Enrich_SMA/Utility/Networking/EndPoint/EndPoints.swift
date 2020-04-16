//  Created by Aman Gupta on 07/09/2018.
//  Copyright © 2018 Aman Gupta. All rights reserved.

import Foundation

public enum ConstantAPINames: String {
    case getOnBoarding = "banner/onboarding/" // Custom API
    case postListOfSalons = "salonlocator/salon/list" // Custom API
    case createData = "customers"
    case validateReferalCode = "customer/refercode/check"
    case validateOTPOnSignUp = "digimiles/otp/verify"
    case validateEmailSignUp = "customers/me/activate" // OOTB API
    case resendEmailConfirmation = "customer/resendconfirmation"
    case informationOfLoggedInCustomer = "customers/me"
    // Select star/unstar Location apis
    case addfavouriteSalon = "salonlocator/favourite/salon"// Custom API
    case removefavouriteSalon = "salonlocator/favourite/salon/remove"// Custom API

    // Home Landing API
    case home = "home"

    // Salon service And Details api
    case salonServiceCategory = "categories/children"// Custom API
    case salonTestimonials = "testimonials/"// Custom API
    case productCategory  = "products/?searchCriteria" //Product Category
    case addWishList = "wishlist/add"
    case removeFromWishList = "wishlist/delete"
    case productDetails = "products/" /// Service Details
    case bestsellerproducts = "bestsellerproducts/" /// Service Details

    case productReview = "product/reviews" /// Product Review
    case frquentlyAvailedProduct = "customer/frequentlyavailedservices" // Frequently Availed Service
    case rateAService =  "review/save" // Rate a Service

    // Product Module APIS
    case categorydetails = "category/details" // Products Landing Screen
    case blogDetails = "blog/details" // GetInsightfull section
    case productsShopby = "products/shop-by" // GetInsightfull section
    case recentlyviewedproducts = "recentlyviewedproducts"

    // Product Cart APIS
    case getQuoteIdMine = "carts/$$$"  // Append Mine // Same for Delete Product from cart
    case addToCartGuest = "guest-carts" // Add To cart For Guest // Same API to Get all Cart Items from cart in case for Guest// DeleteFroCart API also Same
    case getAllCartItemsCustomer = "carts/mine/items"  // Get All Customer Cart Items
    case moveToWishListFromCart = "wishlist/move"
    case moveToCartFromWishlist  = "wishlist/move/tocart"
    case addUpdateAddress = "customers/mine/address"
    case getStates = "directory/countries"

    // BLOGS
    case blogListingCategories = "blog/categories"
    case blogList = "blog/lists" // GetInsightfull section

    // PayTM Integration
    case paytmpayonline = "paytm/payonline"
    // More Tab

    //.............................SMA New API........................................

    // Login Module
    case userLogin = "rest/V1/integration/admin/token"
    case getTermsAndConditions = "rest/V1/cms/block"

    //case sendOTPOnMobile = "digimiles/sms/sendotp"
    case sendOTPOnMobile = "rest/V1/employee/reset/password/generate/otp"

    case validateOTPOnLogin =  "rest/V1/digimiles/customer/login"

    case forgotPassword = "rest/V1/employee/reset/password"

    // My Profile
    case getUserProfile = "rest/V1/employee/profile?is_custom=true"
    case getServiceList = "rest/V1/employee/services?is_custom=true"
    case getEmployeeList = "esa/roster" // L

    // Appoitments
    case getAppointments = "rest/V1/appointments/appointment-list?is_custom=true"

    // Client Information
    case membershipDetails = "rest/V1/membership?is_custom=true"
    case clientPreferences = "rest/V1/customer-preferences?is_custom=true"
    case clientNotes = "rest/V1/customer/ratingandnotes?is_custom=true"
    case addClientNote = "/rest/V1/customer/addnotes"

    // Notifications
    case getNotificationList = "rest/V1/notifications/get?is_custom=true"

    // Salon Ratings
    case getSalonRatings = "rest/V1/customer/appointmentfeedbacklist"

    // Check In
    case getCheckInStatus = "rest/V1/biometric/employeeCheckinoutDetails"
    case markCheckInOut = "rest/V1/biometric/checkinoutMobile"
    case getCheckInOutDetails = "rest/V1/biometric/employeeCheckinoutDetailsMobile"

    // SOS
    case sendSOSFeedback = "rest/V1/notifications/acknowledgeSos"

    // Dashboard
    case getDashboardData = "rest/V1/getsalonmanagerdashboard"
    case getOneClickRevenueData = "rest/V1/getsmaoneclick"

    // Consultaion Form
    case getConsulationForm = "rest/V1/getform"
    case setConsulationForm = "rest/V1/setform"

    // Reports
    case getReports = "rest/V1/getmisreports?is_custom=true"
}
