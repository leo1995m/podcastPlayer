//
//  RemoveHTMLTag.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation

public extension String {
    var removeHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
