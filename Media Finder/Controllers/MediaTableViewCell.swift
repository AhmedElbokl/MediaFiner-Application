//
//  MediaTableViewCell.swift
//  Media Finder
//
//  Created by ReMoSTos on 26/05/2023.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    //MARK: outlets.
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaDescriptionLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    //MARK: lifeCycleMethod.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
