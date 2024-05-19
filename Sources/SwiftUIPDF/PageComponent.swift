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
    let height: CGFloat
    let view: AnyView
    let alignment: HorizontalAlignment
    
    init(image: UIImage, view: AnyView, alignment: HorizontalAlignment) {
        self.height = image.size.height
        self.view = view
        self.alignment = alignment
    }
}
