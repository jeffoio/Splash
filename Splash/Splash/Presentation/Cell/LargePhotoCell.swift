//
//  LargePhotoCell.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import UIKit

class LargePhotoCell: UICollectionViewCell {
    static let identifider: String = String(describing: LargePhotoCell.self)

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.layer.cornerRadius = 10
        self.imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
