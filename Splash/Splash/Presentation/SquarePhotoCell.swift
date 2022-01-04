//
//  SquarePhotoCell.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//

import UIKit

class SquarePhotoCell: UICollectionViewCell {
    static let identifider: String = String(describing: SquarePhotoCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 10
        self.imageView.contentMode = .scaleAspectFill
    }
}
