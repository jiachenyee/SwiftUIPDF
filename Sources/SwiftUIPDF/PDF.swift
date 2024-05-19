import Foundation
import SwiftUI
import PDFKit

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
        
        let url = directory.appendingPathComponent(name)
        
        let pages = await generatePages()
        
        let jobId = UUID().uuidString
        
        var urls: [URL] = []
        
        for (index, page) in pages.enumerated() {
            let url = URL.temporaryDirectory.appending(path: "\(jobId)-\(index).pdf")
            let pageView = createPageView(from: page, pageNumber: index + 1)
            let renderer = ImageRenderer(content: pageView.preferredColorScheme(.light))
            
            renderer.render { size, context in
                var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                    return
                }
                
                pdf.beginPDFPage(nil)
                
                context(pdf)
                
                pdf.endPDFPage()
                pdf.closePDF()
            }
            
            urls.append(url)
        }
        
        let mergedPdfDocument = PDFDocument()
        
        for url in urls {
            guard let pdfDocument = PDFDocument(url: url) else {
                continue
            }
            
            let pageCount = pdfDocument.pageCount
            for pageIndex in 0..<pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                mergedPdfDocument.insert(page, at: mergedPdfDocument.pageCount)
            }
            
            try? FileManager.default.removeItem(at: url)
        }
        
        mergedPdfDocument.write(to: url)
        
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
                    component.view
                        .frame(width: paper.width - margins * 2,
                               alignment: Alignment(horizontal: component.alignment, vertical: .center))
                        .clipped()
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

