//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 19/5/24.
//

import Foundation
import SwiftUI

public struct PDFSection {
    
    public var alignment: HorizontalAlignment = .leading
    public var componentGap: CGFloat = 0
    
    private var rawContentViews: [AnyView]
    
    private let footerHeight: CGFloat
    
    public init(alignment: HorizontalAlignment = .leading,
                @PDFBuilder _ content: () -> [PDFViewGroup],
                footerHeight: CGFloat = 48) {
        
        rawContentViews = content().flatMap({
            $0.views
        })
        
        self.footerHeight = footerHeight
    }
    
    @MainActor func createPages(margins: CGFloat, paper: Paper, dynamicTypeSize: DynamicTypeSize) -> [Page] {
        var output: [Page] = []
        
        let effectiveWidth = paper.width - margins * 2
        let effectiveContentHeight = paper.height - margins * 2 - footerHeight
        
        for view in transformViewsToA4(effectiveWidth: effectiveWidth, dynamicTypeSize: dynamicTypeSize) {
            guard let image = renderSingleComponent(effectiveWidth: effectiveWidth, view: view) else { continue }
            
            let component = PageComponent(image: image, view: view, alignment: alignment)
            
            if let lastPage = output.last,
               lastPage.height + componentGap + component.height < effectiveContentHeight {
                output[output.count - 1].components.append(component)
            } else {
                output.append(Page(componentGap: componentGap, components: [component]))
            }
        }
        
        return output
    }
    
    func transformViewsToA4(effectiveWidth: CGFloat, dynamicTypeSize: DynamicTypeSize) -> [AnyView] {
        rawContentViews.map({ view in
            AnyView(
                view
                    .frame(width: effectiveWidth,
                           alignment: Alignment(horizontal: alignment, vertical: .center))
                    .clipped()
                    .environment(\.dynamicTypeSize, dynamicTypeSize)
            )
        })
    }
    
    @MainActor
    func renderSingleComponent(effectiveWidth: Double, view: AnyView) -> UIImage? {
        let renderer = ImageRenderer(content: view)
        renderer.proposedSize = .init(width: effectiveWidth, height: nil)
        
        return renderer.uiImage
    }
}
