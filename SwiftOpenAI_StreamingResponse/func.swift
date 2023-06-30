//
//  func.swift
//  Matplanleggern2
//
//  Created by Kristoffer Vatnehol on 21/06/2023.
//

import Foundation

struct FunctionParameters: Codable {
    let name: String
    let introduction: String
    let preparation_time: String
    let total_time: String
    let serving_quantity: String
    let ingredients: [String]
    let method: [String]
    let cost: String
    let conclusion: String
}

struct Function: Codable {
    let name: String
    let description: String
    let parameters: FunctionParameters
}
