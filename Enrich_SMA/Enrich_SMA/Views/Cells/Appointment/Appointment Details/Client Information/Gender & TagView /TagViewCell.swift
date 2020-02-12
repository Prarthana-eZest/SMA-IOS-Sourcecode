//
//  TagViewCell.swift
//  Enrich_TMA
//
//  Created by Harshal Patil on 04/11/19.
//  Copyright © 2019 e-zest. All rights reserved.
//

import UIKit
import TagListView

protocol TagViewSelectionDelegate: class {
    func actionTagSelection(tag: String)
}

class TagViewCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tagListView: TagListView!

    var indexPath: IndexPath?
    var isSingleSelection = false
    var delegate: TagViewSelectionDelegate?
    var tagViewModel: TagViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: TagViewModel) {
        tagViewModel = model
        isSingleSelection = model.isSingleSelection
        if let font = UIFont(name: FontName.FuturaPTBook.rawValue, size: 16) {
            tagListView.textFont = font
        }
        lblTitle.text = model.title
        tagListView.delegate = self
        tagListView.removeAllTags()
        tagListView.alignment = .center

        model.tagView.forEach {
            tagListView.addTag($0.text)
            tagListView.tagViews.last?.isSelected = $0.isSelected
        }

    }

    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        let status = !tagView.isSelected
        if isSingleSelection {tagListView.selectedTags().forEach {$0.isSelected = false}}
        tagView.isSelected = status
        self.delegate?.actionTagSelection(tag: title)

        if isSingleSelection {
            self.tagViewModel?.tagView.forEach {$0.isSelected = false}
            let tags = self.tagViewModel?.tagView.filter {$0.text == title}
            tags?.first?.isSelected = status
        } else {
            let tags = self.tagViewModel?.tagView.filter {$0.text == title}
            tags?.first?.isSelected = status
        }

    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        // sender.removeTagView(tagView)
    }

}

class TagViewString {
    let text: String
    var isSelected: Bool

    init(text: String, isSelected: Bool) {
        self.text = text
        self.isSelected = isSelected
    }
}
class TagViewModel {
    let title: String
    let tagView: [TagViewString]
    let isSingleSelection: Bool

    init(title: String, tagView: [TagViewString], isSingleSelection: Bool) {
        self.title = title
        self.tagView = tagView
        self.isSingleSelection = isSingleSelection
    }
}
