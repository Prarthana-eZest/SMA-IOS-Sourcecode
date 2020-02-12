//
//  SOSPopUpVC.swift
//  Enrich_SMA
//
//  Created by Harshal Patil on 22/10/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

class SOSPopUpVC: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var btnMobileNo: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtfMessage: UITextField!
    @IBOutlet weak var btnOk: UIButton!

    var viewDismissBlock: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionMobileNo(_ sender: UIButton) {
    }

    @IBAction func actionOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        viewDismissBlock!(true)
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
