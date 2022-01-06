//
//  PhotoCell.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifider: String = String(describing: PhotoCell.self)

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 10
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
}
