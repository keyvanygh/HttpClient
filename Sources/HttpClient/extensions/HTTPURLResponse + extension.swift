//
//  HTTPURLResponse + extension.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/20/24.
//

import Foundation

extension HTTPURLResponse {
    var isOk_200: Bool {
        return statusCode == 200
    }
}
