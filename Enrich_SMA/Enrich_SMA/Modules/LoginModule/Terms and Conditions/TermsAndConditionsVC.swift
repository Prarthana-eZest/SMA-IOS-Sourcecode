//
//  TermsAndConditionsVC.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 17/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnAccept: UIButton!
    
    var viewDismissBlock: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textView.delegate = self
        btnAccept.isSelected = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !btnAccept.isSelected{
            btnAccept.isSelected = !(scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.OrientationLock.lock(to: UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.navigationController?.addCustomBackButton(title: "Enrich Terms & Conditions")
    }
    
    
    @IBAction func actionAccept(_ sender: Any) {
        if btnAccept.isSelected{
            self.navigationController?.popViewController(animated:true)
            viewDismissBlock?(true)
        }
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


