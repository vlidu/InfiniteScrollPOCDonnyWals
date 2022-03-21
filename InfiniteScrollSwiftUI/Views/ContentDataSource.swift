//
//  ContentDataSource.swift
//  InfiniteScrollSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 21/03/2022.
//

import Combine
import SwiftUI

class ContentDataSource: ObservableObject {
    @Published var items = [ListItem]()
    @Published var isLoadingPage = false
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    init() {
        loadMoreContent()
    }
    
    func loadMoreContentIfNeeded(currentItem item: ListItem?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
}

private extension ContentDataSource {
    func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        let url = URL(string: "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = response.hasMorePages
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                return self.items + response.items
            })
            .catch({ _ in Just(self.items) })
                    .assign(to: &$items)
    }
}
