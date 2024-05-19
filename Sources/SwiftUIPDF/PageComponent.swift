//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 19/5/24.
//

import Foundation
import SwiftUI

struct PageComponent: Identifiable {
    let id = UUID()
    let image: UIImage
    
    var height: CGFloat {
        image.size.height
    }
}
