//
//  Configurations.swift
//  EnrichSalon
//
//  Created by Harshal Patil on 01/07/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

import UIKit

enum SectionIdentifier: String {

    // ParentViewController Of AnyViewController
    case parentVC = "ParentVC"
    
    // Client Information
    case generalClientInfo = "General"
    case consulationInfo = "Consultation"
    case memebershipInfo = "Membership"
    case historyInfo = "History"
}

enum CellIdentifier{
    
    // Dashboard
    static let dashboardProfileCell = "DashboardProfileCell"
    static let yourTargetRevenueCell = "YourTargetRevenueCell"
    static let revenueCell = "RevenueCell"
    
    // Appointment
    static let todaysAppointmentHeaderCell = "TodaysAppointmentHeaderCell"
    static let appointmentStatusCell = "AppointmentStatusCell"
    
    // Appointment Details
    static let appointmentDetailsCell = "AppointmentDetailsCell"
    static let appointmentTimelineCell = "AppointmentTimelineCell"
    static let appointmentTimelineHeader = "AppointmentTimelineHeader"
    
    // Client Information
    static let topicCell = "TopicCell"
    static let membershipStatusCell = "MembershipStatusCell"
    static let selectGenderCell = "SelectGenderCell"
    static let tagViewCell = "TagViewCell"
    static let serviceHistoryCell = "ServiceHistoryCell"
    static let pointsCell = "PointsCell"
    static let addNotesSingatureCell = "AddNotesSingatureCell"
    
    // Profile
    static let myProfileHeaderCell = "MyProfileHeaderCell"
    static let myProfileCell = "MyProfileCell"
    static let myProfileMultiOptionCell = "MyProfileMultiOptionCell"
    static let serviceListingCell = "ServiceListingCell"
    static let listingCell = "ListingCell"
    
    // Employees
    static let employeeCell = "EmployeeCell"
    
    // Notifications
    static let notificationDetailsCell = "NotificationDetailsCell"
    
    // Header Cells
    static let headerViewWithTitleCell = "HeaderViewWithTitleCell"
    static let headerViewWithSubTitleCell = "HeaderViewWithSubTitleCell"
    
}

struct SectionConfiguration {

    let title: String
    let subTitle: String

    let cellHeight: CGFloat
    let cellWidth: CGFloat

    let showHeader: Bool
    let showFooter: Bool

    let headerHeight: CGFloat
    let footerHeight: CGFloat

    let leftMargin: CGFloat
    let rightMarging: CGFloat

    let isPagingEnabled: Bool

    let textFont: UIFont?
    let textColor: UIColor

    let items: Int

    let identifier: SectionIdentifier
    var data: Any

}

class Configurations {

}
