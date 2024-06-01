//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 1/6/24.
//

import Foundation
import SwiftUI

public struct PDFViewGroup {
    var views: [AnyView]
    
    public init(_ views: [AnyView]) {
        self.views = views
    }
    
    public init(_ view: AnyView) {
        self.views = [view]
    }
    
    public init<Content: View>(_ view: Content) {
        self.views = [AnyView(view)]
    }
    
}

@resultBuilder
public struct PDFBuilder {
    public static func buildBlock<Content: View>(_ components: Content...) -> [PDFViewGroup] {
        components.map { view in
            PDFViewGroup(view)
        }
    }
    
    public static func buildBlock(_ components: PDFViewGroup...) -> [PDFViewGroup] {
        return components
    }
    
    public static func buildEither<TrueContent: View>(first component: TrueContent) -> PDFViewGroup {
        PDFViewGroup(component)
    }
    
    public static func buildEither<FalseContent: View>(second component: FalseContent) -> PDFViewGroup {
        PDFViewGroup(component)
    }
    
    public static func buildEither(first component: PDFViewGroup) -> PDFViewGroup {
        return component
    }
    
    public static func buildEither(second component: PDFViewGroup) -> PDFViewGroup {
        return component
    }
    
    public static func buildArray(_ components: [some View]) -> PDFViewGroup {
        PDFViewGroup(components.map { view in
            AnyView(view)
        })
    }
    
    public static func buildArray(_ components: [[some View]]) -> PDFViewGroup {
        let views = components.flatMap { viewGroups in
            viewGroups.flatMap {
                if let pdfViewGroup = $0 as? PDFViewGroup {
                    return pdfViewGroup.views
                } else {
                    return [AnyView($0)]
                }
            }
        }
        
        return PDFViewGroup(views)
    }
    
    public static func buildArray(_ components: [PDFViewGroup]) -> PDFViewGroup {
        PDFViewGroup(components.flatMap { view in
            view.views
        })
    }
    
    public static func buildArray(_ components: [[PDFViewGroup]]) -> PDFViewGroup {
        let views = components.flatMap { groups in
            groups.flatMap { view in
                view.views
            }
        }
        
        return PDFViewGroup(views)
    }
}

