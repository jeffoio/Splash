//
//  UIImageView+Extension.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import UIKit

extension UIImageView {
    func setImageUrl(id: String, url: URL) {
        PhotoLoader.shared.download(url: url, id: id) { data in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
