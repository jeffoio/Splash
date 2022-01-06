//
//  UIImageView+Extension.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import UIKit

extension UIImageView {
    func setImageUrl(id: String, url: URL) -> Cancelable? {
        return PhotoLoader.shared.download(url: url, id: id) { data in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                self.removeBlurEffect()
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
