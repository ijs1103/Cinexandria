//
//  ImageCacheManager.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/23.
//

import Kingfisher
import SwiftUI

struct KfManager {
    
    static func cachedImage(url: URL) -> KFImage {
        // 캐시가 존재하면
        if ImageCache.default.isCached(forKey: url.absoluteString) {
            return KFImage(url)
        } else {
        // 캐시가 없으면, 캐시 생성
            let resource = KF.ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            return KFImage(source: .network(resource))
        }
    }
    static func downSampledImage(url: URL, size: CGSize) -> KFImage {
        return KFImage(url)
                .downsampling(size: size)
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
    }
}

extension KFImage {
    func imageFill() -> some View {
        self.resizable().scaledToFill()
    }
}

