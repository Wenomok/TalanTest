//
//  TODOItemTableViewCell.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit
import SDWebImage

protocol TODOItemTableViewCellDelegate {
    func didUpdateCheck(isChecked: Bool, forItem item: TODOItem)
}

class TODOItemTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "todo_item_cell"
    
    @IBOutlet weak var checkboxButton: CheckboxButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    
    private(set) var item: TODOItem?
    
    var delegate: TODOItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func removeFromSuperview() {
        checkboxButton.observer = nil
        delegate = nil
        item = nil
        
        super.removeFromSuperview()
    }
    
    func configure(item: TODOItem, delegate: TODOItemTableViewCellDelegate) {
        self.item = item
        
        titleLabel.text = item.title
        dateLabel.text = item.createDate.toStringFormat(format: "dd MMM YYYY HH:mm")
        
        checkboxButton.isChecked = item.isDone
        checkboxButton.observer = self
        
        self.delegate = delegate
    }
    
    func configureImage(fromURL url: URL?) {
        DispatchQueue.main.async {
            self.picImageView?.sd_setImage(with: url, placeholderImage: nil, completed: nil)
        }
    }
}

extension TODOItemTableViewCell: CheckButtonObserver {
    func didUpdateCheck(isChecked: Bool) {
        if let item = item {
            delegate?.didUpdateCheck(isChecked: isChecked, forItem: item)
        }
    }
}
