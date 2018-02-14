import Foundation
import XCTest
import RxSwift
@testable import deezer

class PlaylistViewModelTest: XCTestCase {
    func testInit() {
        let playlistService = PlaylistServiceMock()
        let playlistViewModel = PlaylistViewModel(playlistService: playlistService)
        XCTAssert(playlistViewModel.privateDataSourcePlaylists.value[0].title == "title")
        XCTAssert(playlistViewModel.privateDataSourcePlaylists.value[0].duration == "44:44:22")
        XCTAssert(playlistViewModel.privateDataSourcePlaylists.value[0].autor == "alain")
        XCTAssert(playlistViewModel.privateDataSourcePlaylists.value[0].tracksurl == "http://www.playlist.com")
    }
}
