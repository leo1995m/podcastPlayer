//
//  CachedImage.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 09/09/24.
//

import Foundation
import Kingfisher
import KingfisherWebP
import UIKit

public extension UIImageView {
 
    func cachedImage(url: URL) {
        kf.indicatorType = .activity
        let options: KingfisherOptionsInfo = [
            .processor(WebPProcessor.default),
            .cacheSerializer(WebPSerializer.default)
        ]
        
        kf.setImage(
            with: url,
            options: options
        )
    }
}
