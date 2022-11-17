//
//  UIImageView+Extension.swift
//  CurrencyConverter
//
//  Created by Eslam Shaker on 16/11/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    //load normal image size
    func loadImage(url: URL){
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
    
    //load smaller image sizes for usage in small imageviews (ex: like in tableviewcell or collectionviewcell), rather than displaying the larger image
    func loadDownsampledImage(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}
