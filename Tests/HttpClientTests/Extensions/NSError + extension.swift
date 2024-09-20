//
//  NSError + extension.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import Foundation

extension NSError {
    static func anyError() -> NSError {
        return NSError(domain: "Test", code: 0)
    }
}
