//
//  HomeViewModelTests.swift
//  FlickrViewerTests
//
//  Created by Andrey Doroshko on 9/24/24.
//

import Foundation
import XCTest
@testable import FlickrViewer

final class HomeViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let mockViewDelegate = MockHomeScreenViewModelDelegate()
        let mockNetworkService = MockNetworkService()
        mockNetworkService.stubbedSearchImagesResponse
        = Result.success(FlickrFeed(title: "title",
                                    link: "URL",
                                    description: "description",
                                    modified: "modifiers",
                                    generator: "generator",
                                    items: [FlickrItem(title: "title",
                                                       link: "link",
                                                       media: Media(m: "media"),
                                                       dateTaken: "dateTaken",
                                                       description: "description",
                                                       published: "published",
                                                       author: "author",
                                                       authorID: "authorID",
                                                       tags: "tags")]))
        
        let sut = HomeScreenViewModel(viewDelegate: mockViewDelegate,
                                      networkService: mockNetworkService)
        
        XCTAssertTrue(mockNetworkService.invokedSearchImages)
        XCTAssertEqual(mockNetworkService.invokedSearchImagesCount, 1)
        
        XCTAssertTrue(mockViewDelegate.invokedRefreshData)
        XCTAssertEqual(mockViewDelegate.invokedRefreshDataCount, 1)

    }

}
