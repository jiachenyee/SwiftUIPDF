//
//  Page.swift
//  
//
//  Created by Jia Chen Yee on 19/5/24.
//

import Foundation

struct Page: Identifiable {
    let id = UUID()
    let componentGap: CGFloat
    var components: [PageComponent] = []
    
    var height: CGFloat {
        components.reduce(0.0) { partialResult, component in
            partialResult + component.height
        } + componentGap * Double(components.count)
    }
}
