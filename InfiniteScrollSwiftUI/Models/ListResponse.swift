//
//  ListResponse.swift
//  InfiniteScrollSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 21/03/2022.
//

import Foundation

struct ListResponse: Codable {
    let items: [ListItem]
    let hasMorePages: Bool
}

struct ListItem: Codable, Identifiable {
    let id: String
    let label: String
}
