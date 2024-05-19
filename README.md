# SwiftUI PDF
Generate PDF documents using SwiftUI, the main draw here is that it automatically moves things to a separate page when it gets too long.

```swift
let pdf = PDF(sections: [
    PDFSection {
        Text("Hello, world!")
            .font(.largeTitle)
        Text("Hello, world!")
            .font(.largeTitle)
        Text("Hello, world!")
            .font(.largeTitle)
    },
    PDFSection {
        Text("🥔")
            .font(.system(size: 300))
        Text("🥔")
            .font(.system(size: 300))
        Text("🥔")
            .font(.system(size: 300))
    }
], footerView: { pageNumber in
    HStack {
        Text("Report generated on \(Date.now.formatted(date: .complete, time: .omitted))")
        Spacer()
        Text("\(pageNumber)")
    }
    .font(.system(size: 11, weight: .regular))
    .kerning(-0.2)
}, footerHeight: 48)

let outputURL = await pdf.exportPDF(name: "test.pdf")
```
