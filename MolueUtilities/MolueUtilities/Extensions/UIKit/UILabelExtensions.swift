//
//  UILabelExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 9/23/16.
//  Copyright © 2016 SwifterSwift
//

#if os(iOS) || os(tvOS)
import UIKit

// MARK: - Methods
public extension UILabel {
	
	/// SwifterSwift: Initialize a UILabel with text
	public convenience init(text: String?) {
		self.init()
		self.text = text
	}
	
	/// SwifterSwift: Required height for a label
	public var requiredHeight: CGFloat {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = font
		label.text = text
		label.attributedText = attributedText
		label.sizeToFit()
		return label.frame.height
	}
    
    public func setLineSpacing(_ lineSpacing: CGFloat) {
        do {
            let text = try self.text.unwrap()
            let attributedText = NSMutableAttributedString(string: text)
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = lineSpacing
            let range = NSRange(location: 0, length: text.count)
            let style = NSAttributedString.Key.paragraphStyle
            attributedText.addAttribute(style, value: paragraphStye, range: range)
            self.attributedText = attributedText
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
#endif
