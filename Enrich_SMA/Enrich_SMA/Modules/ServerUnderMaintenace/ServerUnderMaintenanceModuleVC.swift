//
//  ServerUnderMaintenanceModuleVC.swift
//  EnrichSalon
//
//  Created by Aman Gupta on 24/06/20.
//  Copyright © 2020 Aman Gupta. All rights reserved.
//

import UIKit
import MessageUI

class ServerUnderMaintenanceModuleVC: UIViewController {
    @IBOutlet weak private var labelMsg: UILabel!
    @IBOutlet weak private var labelEmail: LabelButton!
    let textToDisplay = "Enrich app is undergoing maintenance, and will be back shortly.\n\nIn the meantime, you can call us on 1800 266 5300, or WhatsApp us on 9339 777 777 or write to us at"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        let range1 = (textToDisplay as NSString).range(of: "1800 266 5300")
        let range2 = (textToDisplay as NSString).range(of: "9339 777 777")

        let attribute = NSMutableAttributedString(string: textToDisplay)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range1)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range2)

        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: FontName.FuturaPTDemi.rawValue, size: is_iPAD ? 24.0 : 16.0)!, range: range1)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: FontName.FuturaPTDemi.rawValue, size: is_iPAD ? 24.0 : 16.0)!, range: range2)

        labelMsg.attributedText = attribute

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.labelMsg.addGestureRecognizer(tapgesture)

        self.labelEmail.onClick = {
            self.sendEmail()
        }

    EZLoadingActivity.hide()
    AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.navigationBar.isHidden = false

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false

    }
    // MARK: - tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        let privacyPolicyRange = (textToDisplay as NSString).range(of: "1800 266 5300")
        let termsAndConditionRange = (textToDisplay as NSString).range(of: "9339 777 777")

        if gesture.didTapAttributedTextInLabel(label: self.labelMsg, inRange: privacyPolicyRange) {
            print("user tapped on 1800 266 5300")
            "1800 266 5300".makeACall()
        }
        else if gesture.didTapAttributedTextInLabel(label: self.labelMsg, inRange: termsAndConditionRange) {
            print("user tapped on 9339 777 777")
            "9339 777 777".makeACall()

        }
    }
    func clickToEmail(text: String) {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ServerUnderMaintenanceModuleVC: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([salonCustomerCareEmail])
            mail.setMessageBody("<p>Hi Enrich,</p>", isHTML: true)

            present(mail, animated: true)
        }
        else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
