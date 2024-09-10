//
//  numberOfLines.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation
import UIKit
public extension String {
    func numberOfLines() -> Int {
        let label = UILabel()
        label.text = self
        label.numberOfLines = 0
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude)
        let charSize = label.font.lineHeight
        let text = NSString(string: self)
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font ?? UIFont()], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height / charSize))
        return linesRoundedUp
    }
}
