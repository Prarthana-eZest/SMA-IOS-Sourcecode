//
//  AddNotesSingatureCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 28/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit

protocol AddNotesSingatureDelegate {
    func actionClearSignature()
    func actionSaveSignature(image: UIImage)
    func reloadCell()
}

class AddNotesSingatureCell: UITableViewCell {
    
    @IBOutlet private weak var signatureView: YPDrawSignatureView!
    @IBOutlet private weak var txtfNotesOne: CustomTextField!
    @IBOutlet private weak var txtfNotesTwo: CustomTextField!
    
    @IBOutlet private weak var btnClear: UIButton!
    @IBOutlet private weak var btnSave: UIButton!
    
    var delegate: AddNotesSingatureDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnClear.isHidden = true
        btnSave.isHidden = true
        signatureView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionClear(_ sender: UIButton) {
        self.signatureView.clear()
        btnClear.isHidden = true
        btnSave.isHidden = true
        delegate?.actionClearSignature()
    }

    @IBAction func actionSaveSignature(_ sender: UIButton) {
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
           // UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            self.signatureView.clear()
            delegate?.actionSaveSignature(image: signatureImage)
        }
    }
}

extension AddNotesSingatureCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddNotesSingatureCell: YPSignatureDelegate {

    func didStart(_ view: YPDrawSignatureView) {
    }
    
    func didFinish(_ view: YPDrawSignatureView) {
        btnClear.isHidden = false
        btnSave.isHidden = false
        delegate?.reloadCell()
    }
}

