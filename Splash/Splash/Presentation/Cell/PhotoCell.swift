//
//  PhotoCell.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifider: String = String(describing: PhotoCell.self)
    
    private var task: Cancelable?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = 10
        self.imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.task?.downloadCancel()
        self.imageView.image = nil
    }
    
    func setImage(_ photo: PhotoInformation) {
        guard let url = URL(string: photo.urls.small) else { return }
        self.imageView.addBlurEffect()
        self.task = self.imageView.setImageUrl(id: photo.id, url: url)
    }
}
