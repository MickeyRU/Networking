//
//  ImageProperties.swift
//  Networking
//
//  Created by Павел Афанасьев on 19.09.2022.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forkey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
