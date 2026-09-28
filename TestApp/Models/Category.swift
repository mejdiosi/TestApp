//
//  Category.swift
//  TestApp
//
//  Created by Mejdi Kchouk on 28/9/2026.
//


import Foundation
 
struct Category: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
}