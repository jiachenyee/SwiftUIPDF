//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 1/6/24.
//

import Foundation
import SwiftUI

@resultBuilder
public struct PDFBuilder {
    public static func buildBlock<Content: View>(_ components: Content...) -> [AnyView] {
        components.map { view in
            AnyView(view)
        }
    }
    
    public static func buildEither<TrueContent: View>(first component: TrueContent) -> AnyView {
        AnyView(component)
    }
    
    public static func buildEither<FalseContent: View>(second component: FalseContent) -> AnyView {
        AnyView(component)
    }
    
    public static func buildArray<Content: View>(_ components: [Content]) -> [AnyView] {
        components.map { view in
            AnyView(view)
        }
    }
}
