//
//  Dictinary + extension.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import Foundation

extension [String: Any] {
    var data: Data {
        return try! JSONSerialization.data(withJSONObject: self)
    }
}
