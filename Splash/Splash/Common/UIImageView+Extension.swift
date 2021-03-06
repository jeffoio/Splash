//
//  UIImageView+Extension.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import UIKit.UIImage

extension UIImageView {
    func setImageUrl(id: String, url: URL, indexPath: IndexPath) {
        PhotoLoader.shared.load(url: url, id: id, indexPath: indexPath) { data in
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: data)
                self?.removeBlurEffect()
            }
        }
    }
    
    func addBlurEffect(){
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialLight))
        blurView.frame = self.bounds
        self.addSubview(blurView)
    }
    
    func removeBlurEffect(){
        self.subviews.forEach { view in
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}
