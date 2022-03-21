//
//  ContentView.swift
//  InfiniteScrollSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 21/03/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var dataSource = ContentDataSource()
    
    var body: some View {
        List {
            ForEach(dataSource.items) { item in
                Text(item.label)
                    .onAppear {
                        dataSource.loadMoreContentIfNeeded(currentItem: item)
                    }
                    .padding(.all, 30)
            }
            
            if dataSource.isLoadingPage {
                ProgressView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
