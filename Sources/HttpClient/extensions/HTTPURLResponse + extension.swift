//
//  HTTPURLResponse + extension.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/20/24.
//

import Foundation

public extension HTTPURLResponse {
    public var isOk_200: Bool {
        return statusCode == 200
    }
}
