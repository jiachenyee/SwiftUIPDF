import Foundation
import SwiftUI

public struct PDF<FooterView> where FooterView: View {
    public var margins: CGFloat = 57
    public var paper: Paper = .a4
    
    private let footerView: (Int) -> FooterView
    private let footerHeight: CGFloat
    
    private var sections: [PDFSection]
    
    public init(sections: [PDFSection],
                margins: CGFloat = 57,
                paper: Paper = .a4,
                @ViewBuilder footerView: @escaping (Int) -> FooterView,
                footerHeight: CGFloat) {
        self.margins = margins
        self.paper = paper
        self.footerView = footerView
        self.footerHeight = footerHeight
        self.sections = sections
    }
    
    @MainActor
    @discardableResult
    public func exportPDF(name: String, directory: URL = .temporaryDirectory) async -> URL {
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: paper.width, height: paper.height),
                                             format: format)
        
        let url = directory.appendingPathComponent(name)
        
        let pages = await generatePages()
        
        try? renderer.writePDF(to: url) { context in
            for (index, page) in pages.enumerated() {
                context.beginPage()
                let imageRenderer = ImageRenderer(content: createPageView(from: page, pageNumber: index + 1))
                imageRenderer.uiImage?.draw(at: CGPoint.zero)
            }
        }
        
        return url
    }
    
    private func generatePages() async -> [Page] {
        await sections.concurrentMap { section in
            await section.createPages(margins: margins, paper: paper)
        }
        .flatMap { $0 }
    }
    
    private func createPageView(from page: Page, pageNumber: Int) -> some View {
        return VStack(spacing: 0) {
            VStack(spacing: page.componentGap) {
                ForEach(page.components) { component in
                    Image(uiImage: component.image)
                }
            }
            Spacer(minLength: 0)
            
            footerView(pageNumber)
        }
        .padding(margins)
        .frame(width: paper.width, height: paper.height)
        .clipped()
    }
}

