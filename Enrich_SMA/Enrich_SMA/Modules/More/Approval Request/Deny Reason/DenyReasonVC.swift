//
//  DenyReasonVC.swift
//  Enrich_SMA
//
//  Created by Harshal on 30/04/20.
//  Copyright © 2020 e-zest. All rights reserved.
//

import UIKit

class DenyReasonVC: UIViewController {

    @IBOutlet weak private var reasonTextView: UITextView!
    @IBOutlet weak private var btnSubmit: UIButton!

    static let ReasonTextViewPlaceHolder = "Enter Reason..."

    var onDoneBlock: ((Bool, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reasonTextView.text = DenyReasonVC.ReasonTextViewPlaceHolder
        reasonTextView.textColor = UIColor.lightGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        KeyboardAnimation.sharedInstance.beginKeyboardObservation(self.view)
        KeyboardAnimation.sharedInstance.extraBottomSpace = 50
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardAnimation.sharedInstance.endKeyboardObservation()
    }

    @IBAction func actionSubmit(_ sender: UIButton) {
        if !sender.isSelected {
            return
        }
        onDoneBlock?(true, reasonTextView.text)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionClose(_ sender: UIButton) {
        onDoneBlock?(false, "")
        self.dismiss(animated: true, completion: nil)
    }

}

extension DenyReasonVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = DenyReasonVC.ReasonTextViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        btnSubmit.isSelected = (textView.textColor == UIColor.black && !textView.text.isEmpty)
    }
}
