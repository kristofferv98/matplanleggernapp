/// Based on the source code from Christian Selig
/// https://github.com/christianselig/Markdownosaur/blob/main/Sources/Markdownosaur/Markdownosaur.swift

import Foundation
import UIKit
import Markdown
import Highlighter


// This struct is a parser to convert Markdown to NSAttributedString
public struct MarkdownAttributedStringParser: MarkupVisitor {
    // Define the base font size based on system's preferred font size for body text style
    let baseFontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
    // Initialize the code highlighter with the Stackoverflow-dark theme
    let highlighter: Highlighter = {
        let highlighter = Highlighter()!
        highlighter.setTheme("stackoverflow-dark")
        return highlighter
    }()
    
    // Define the font size for new lines
       let newLineFontSize: CGFloat = 12

       // Default initializer
       public init() {}
       
       // Function to create an NSAttributedString from a Markdown Document
       public mutating func attributedString(from document: Document) -> NSAttributedString {
           return visit(document)
       }
    
    // Function to parse a Markdown Document and return parser results
    mutating func parserResults(from document: Document) -> [ParserResult] {
        var results = [ParserResult]()
        var currentAttrString = NSMutableAttributedString()
        
        func appendCurrentAttrString() {
            if !currentAttrString.string.isEmpty {
                let currentAttrStringToAppend = (try? AttributedString(currentAttrString, including: \.uiKit)) ?? AttributedString(stringLiteral: currentAttrString.string)
                results.append(.init(attributedString: currentAttrStringToAppend, isCodeBlock: false, codeBlockLanguage: nil))
            }
        }
        
        document.children.forEach { markup in
            let attrString = visit(markup)
            if let codeBlock = markup as? CodeBlock {
                appendCurrentAttrString()
                let attrStringToAppend = (try? AttributedString(attrString, including: \.uiKit)) ?? AttributedString(stringLiteral: attrString.string)
                results.append(.init(attributedString: attrStringToAppend, isCodeBlock: true, codeBlockLanguage: codeBlock.language))
                currentAttrString = NSMutableAttributedString()
            } else {
                currentAttrString.append(attrString)
            }
        }
         
        appendCurrentAttrString()
        return results
    }
    
    // Function to handle default visits for any markup that is not explicitly handled
    mutating public func defaultVisit(_ markup: Markup) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in markup.children {
            result.append(visit(child))
        }
        
        return result
    }
    
    // Function to handle the visit to a Text node in the markup
    mutating public func visitText(_ text: Text) -> NSAttributedString {
        return NSAttributedString(string: text.plainText, attributes: [.font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular)])
    }
    
    // Function to handle the visit to an Emphasis node in the markup
    mutating public func visitEmphasis(_ emphasis: Emphasis) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in emphasis.children {
            result.append(visit(child))
        }
        
        result.applyEmphasis()
        
        return result
    }
    
    // Function to handle the visit to a Strong node in the markup
    mutating public func visitStrong(_ strong: Strong) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strong.children {
            result.append(visit(child))
        }
        
        result.applyStrong()
        
        return result
    }
    
    // Function to handle the visit to a Paragraph node in the markup
    mutating public func visitParagraph(_ paragraph: Paragraph) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in paragraph.children {
            result.append(visit(child))
        }
        
        if paragraph.hasSuccessor {
            result.append(paragraph.isContainedInList ? .singleNewline(withFontSize: newLineFontSize) : .doubleNewline(withFontSize: newLineFontSize))
        }
        
        return result
    }
    
    // Function to handle the visit to a Heading node in the markup
    mutating public func visitHeading(_ heading: Heading) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in heading.children {
            result.append(visit(child))
        }
        
        result.applyHeading(withLevel: heading.level)
        
        if heading.hasSuccessor {
            result.append(.doubleNewline(withFontSize: newLineFontSize))
        }
        
        return result
    }
    
    // Function to handle the visit to a Link node in the markup
    mutating public func visitLink(_ link: Link) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in link.children {
            result.append(visit(child))
        }
        
        let url = link.destination != nil ? URL(string: link.destination!) : nil
        
        result.applyLink(withURL: url)
        
        return result
    }
    
    // Function to handle the visit to an InlineCode node in the markup
    mutating public func visitInlineCode(_ inlineCode: InlineCode) -> NSAttributedString {
        return NSAttributedString(string: inlineCode.code, attributes: [.font: UIFont.monospacedSystemFont(ofSize: baseFontSize - 1.0, weight: .regular), .foregroundColor: UIColor.systemPink])
    }
    
    // Function to handle the visit to a CodeBlock node in the markup
    public func visitCodeBlock(_ codeBlock: CodeBlock) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: highlighter.highlight(codeBlock.code, as: codeBlock.language) ?? NSAttributedString(string: codeBlock.code))
        
        if codeBlock.hasSuccessor {
            result.append(.singleNewline(withFontSize: newLineFontSize))
        }
    
        return result
    }
    
    // Function to handle the visit to a Strikethrough node in the markup
    mutating public func visitStrikethrough(_ strikethrough: Strikethrough) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strikethrough.children {
            result.append(visit(child))
        }
        
        result.applyStrikethrough()
        
        return result
    }
    
    // Function to handle the visit to an UnorderedList node in the markup
    mutating public func visitUnorderedList(_ unorderedList: UnorderedList) -> NSAttributedString {
        let result = NSMutableAttributedString()

        _ = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)

        for listItem in unorderedList.listItems {
            var listItemAttributes: [NSAttributedString.Key: Any] = [:]

            listItemAttributes[.font] = UIFont.systemFont(ofSize: baseFontSize, weight: .medium)
            listItemAttributes[.listDepth] = unorderedList.listDepth

            let listItemAttributedString = visit(listItem).mutableCopy() as! NSMutableAttributedString
            listItemAttributedString.insert(NSAttributedString(string: "• ", attributes: listItemAttributes), at: 0)

            result.append(listItemAttributedString)
        }

        if unorderedList.hasSuccessor {
            result.append(.doubleNewline(withFontSize: newLineFontSize))
        }

        return result
    }
    
    // Function to handle the visit to a ListItem node in the markup
    mutating public func visitListItem(_ listItem: ListItem) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in listItem.children {
            result.append(visit(child))
        }
        
        if listItem.hasSuccessor {
            result.append(.singleNewline(withFontSize: newLineFontSize))
        }
        
        return result
    }
    
    // Function to handle the visit to an OrderedList node in the markup
    mutating public func visitOrderedList(_ orderedList: OrderedList) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        let font = UIFont.systemFont(ofSize: baseFontSize, weight: .bold) // use bold font for ordered list
        
        for (index, listItem) in orderedList.listItems.enumerated() {
            var listItemAttributes: [NSAttributedString.Key: Any] = [:]
            
            listItemAttributes[.font] = font
            listItemAttributes[.listDepth] = orderedList.listDepth

            let subheadingFont = UIFont.systemFont(ofSize: baseFontSize)
            let subheadingString = NSAttributedString(string: "\(index + 1):\n", attributes: [.font: subheadingFont])
            result.append(subheadingString)

            let listItemAttributedString = visit(listItem).mutableCopy() as! NSMutableAttributedString

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.headIndent = 20.0
            listItemAttributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: listItemAttributedString.length))

            result.append(listItemAttributedString)

            result.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular)]))
        }

        if orderedList.hasSuccessor {
            result.append(orderedList.isContainedInList ? .singleNewline(withFontSize: newLineFontSize) : .doubleNewline(withFontSize: newLineFontSize))
        }

        return result
    }
    
    // Function to handle the visit to a BlockQuote node in to get to next content
    mutating public func visitBlockQuote(_ blockQuote: BlockQuote) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in blockQuote.children {
            var quoteAttributes: [NSAttributedString.Key: Any] = [:]
            
            let quoteParagraphStyle = NSMutableParagraphStyle()
            
            let baseLeftMargin: CGFloat = 15.0
            let leftMarginOffset = baseLeftMargin + (20.0 * CGFloat(blockQuote.quoteDepth))
            
            quoteParagraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: leftMarginOffset)]
            quoteParagraphStyle.headIndent = leftMarginOffset
            
            quoteAttributes[.paragraphStyle] = quoteParagraphStyle
            quoteAttributes[.font] = UIFont.italicSystemFont(ofSize: baseFontSize) // use italic font for block quote
            quoteAttributes[.foregroundColor] = UIColor.gray // change color to gray
            quoteAttributes[.listDepth] = blockQuote.quoteDepth
            
            let quoteAttributedString = visit(child).mutableCopy() as! NSMutableAttributedString
            quoteAttributedString.insert(NSAttributedString(string: "\t", attributes: quoteAttributes), at: 0)
            
            result.append(quoteAttributedString)
        }
        
        if blockQuote.hasSuccessor {
            result.append(.doubleNewline(withFontSize: newLineFontSize))
        }
        
        return result
    }

}

// MARK: - Extensions Land

// Extend NSMutableAttributedString to add markup formatting
extension NSMutableAttributedString {
    // Apply italics to all text with a certain attribute
    func applyEmphasis() {
        // Enumerate through all font attributes in the NSMutableAttributedString
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            // If the attribute is a font...
            guard let font = value as? UIFont else { return }
            
            // ...create a new font with italics, and apply it to the same range
            let newFont = font.apply(newTraits: .traitItalic)
            addAttribute(.font, value: newFont, range: range)
        }
    }

    // Similarly for bold...
    func applyStrong() {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UIFont else { return }
            let newFont = font.apply(newTraits: .traitBold)
            addAttribute(.font, value: newFont, range: range)
        }
    }

    // Similarly for links...
    func applyLink(withURL url: URL?) {
        addAttribute(.foregroundColor, value: UIColor.systemBlue)
        if let url = url {
            addAttribute(.link, value: url)
        }
    }

    // Similarly for blockquotes...
    func applyBlockquote() {
        addAttribute(.foregroundColor, value: UIColor.systemGray)
    }

    // Apply a heading style, with a level (1 for H1, 2 for H2, etc.)
    func applyHeading(withLevel headingLevel: Int) {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UIFont else { return }
            let newFont = font.apply(newTraits: .traitBold, newPointSize: 28.0 - CGFloat(headingLevel * 2))
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    // Similarly for strikethrough...
    func applyStrikethrough() {
        addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
    }
}

// Extend UIFont to allow applying traits and size changes
extension UIFont {
    // Apply new traits (bold, italic, etc.) and optionally a new size to this font
    func apply(newTraits: UIFontDescriptor.SymbolicTraits, newPointSize: CGFloat? = nil) -> UIFont {
        var existingTraits = fontDescriptor.symbolicTraits
        existingTraits.insert(newTraits)
        
        guard let newFontDescriptor = fontDescriptor.withSymbolicTraits(existingTraits) else { return self }
        return UIFont(descriptor: newFontDescriptor, size: newPointSize ?? pointSize)
    }
}

// Extend ListItemContainer and BlockQuote to calculate depth of nesting
extension ListItemContainer {
    var listDepth: Int {
        var index = 0
        var currentElement = parent
        while currentElement != nil {
            if currentElement is ListItemContainer {
                index += 1
            }
            currentElement = currentElement?.parent
        }
        return index
    }
}
// Apply a blockquote style to the text (changes text color to gray)
extension BlockQuote {
    var quoteDepth: Int {
        var index = 0
        var currentElement = parent
        while currentElement != nil {
            if currentElement is BlockQuote {
                index += 1
            }
            currentElement = currentElement?.parent
        }
        return index
    }
}

// Create new NSAttributedString.Key for list and quote depth
extension NSAttributedString.Key {
    static let listDepth = NSAttributedString.Key("ListDepth")
    static let quoteDepth = NSAttributedString.Key("QuoteDepth")
}

// Extend NSMutableAttributedString to simplify adding attributes
extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: NSRange(location: 0, length: length))
    }
    
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        addAttributes(attrs, range: NSRange(location: 0, length: length))
    }
}

// Extend Markup to check if it has a successor or is contained in a list
extension Markup {
    var hasSuccessor: Bool {
        guard let childCount = parent?.childCount else { return false }
        return indexInParent < childCount - 1
    }
    
    var isContainedInList: Bool {
        var currentElement = parent
        while currentElement != nil {
            if currentElement is ListItemContainer {
                return true
            }
            currentElement = currentElement?.parent
        }
        return false
    }
}

// Extend NSAttributedString to generate newline characters with a specific font size
extension NSAttributedString {
    static func singleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)]) // Creates a new NSAttributedString with one newline character and a font of specified size.
    }
    
    static func doubleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)]) // Creates a new NSAttributedString with two newline characters and a font of specified size.
    }
}
