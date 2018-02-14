import Foundation
import XCTest
import RxSwift
@testable import deezer

class TrackViewModelTest: XCTestCase {
    func testInit() {
        let playlist = Playlist(title: "title", pictureUrl: "http://www.image.com/image.png", autor:"alain", duration:"44:44:22", tracksurl:"http://www.playlist.com")
        let trackService = TrackServiceMock()
        let checkNextPage : Variable<Bool> = Variable(true)
        
        let trackViewModel = TrackViewModel(tracklistService: trackService, playlist : playlist, checkNextPage:checkNextPage.asObservable())
        
        XCTAssert(trackViewModel.privateDataSourcePlaylist.value[0].title == "title")
        XCTAssert(trackViewModel.privateDataSourcePlaylist.value[0].duration == "44:44:22")
        XCTAssert(trackViewModel.privateDataSourcePlaylist.value[0].autor == "alain")
        XCTAssert(trackViewModel.privateDataSourcePlaylist.value[0].pictureUrl == "http://www.image.com/image.png")
        XCTAssert(trackViewModel.privateDataSourcePlaylist.value[0].tracksurl == "http://www.playlist.com")
        
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].title == "title")
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].duration == "00:03:54")
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].name == "alain")
    }
    
    func testInit2() {
        let playlist = Playlist(title: "title", pictureUrl: "http://www.image.com/image.png", autor:"alain", duration:"44:44:22", tracksurl:"http://www.playlist.com")
        let trackService = TrackServiceMock()
        let checkNextPage : Variable<Bool> = Variable(false)
        
        let trackViewModel = TrackViewModel(tracklistService: trackService, playlist : playlist, checkNextPage:checkNextPage.asObservable())
        
        XCTAssert(trackViewModel.privateDataSourceTracks.value.count == 0)
    }
    
    func testInit3() {
        let playlist = Playlist(title: "title", pictureUrl: "http://www.image.com/image.png", autor:"alain", duration:"44:44:22", tracksurl:"http://www.playlist.com")
        let trackService = TrackServiceMock()
        let checkNextPage : Variable<Bool> = Variable(false)
        
        let trackViewModel = TrackViewModel(tracklistService: trackService, playlist : playlist, checkNextPage:checkNextPage.asObservable())
        
        XCTAssert(trackViewModel.privateDataSourceTracks.value.count == 0)
    
        checkNextPage.value = true
        
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].title == "title")
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].duration == "00:03:54")
        XCTAssert(trackViewModel.privateDataSourceTracks.value[0].name == "alain")
    }
}
