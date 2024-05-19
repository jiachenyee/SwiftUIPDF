//
//  Paper.swift
//  
//
//  Created by Jia Chen Yee on 20/5/24.
//

import Foundation

public struct Paper {
    public var width: CGFloat
    public var height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public static let a4 = Paper(width: 595, height: 842)
}
