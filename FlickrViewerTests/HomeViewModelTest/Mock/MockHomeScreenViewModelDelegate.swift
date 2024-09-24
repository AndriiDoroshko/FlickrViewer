//
//  MockHomeScreenViewModelDelegate.swift
//  FlickrViewerTests
//
//  Created by Andrey Doroshko on 9/24/24.
//

import Foundation
@testable import FlickrViewer

class MockHomeScreenViewModelDelegate: HomeScreenViewModelDelegate {
    
    var invokedRefreshData = false
    var invokedRefreshDataCount = 0
    func refreshData() {
        invokedRefreshData = true
        invokedRefreshDataCount += 1
    }
    
    var invokedLoading = false
    var invokedLoadingCount = 0
    func loading(_ isLoading: Bool) {
        invokedLoading = true
        invokedLoadingCount += 1
    }
    
    var invokedDisplayError = false
    var invokedDisplayErrorCount = 0
    func displayError(_ message: String) {
        invokedDisplayError = true
        invokedDisplayErrorCount += 1
    }
}
