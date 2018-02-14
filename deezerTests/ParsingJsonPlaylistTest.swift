import XCTest
@testable import deezer

class ParsingJsonPlaylistTest: XCTestCase {
    func testParsing1() {
        let dict : NSMutableDictionary = NSMutableDictionary (capacity: 1)
        let playlist : NSMutableArray = NSMutableArray (capacity:1)
        let playlistDict : NSMutableDictionary = NSMutableDictionary (capacity: 5)
        playlistDict["title"] = "title"
        playlistDict["picture_small"] = "http://www.image.com/image.png"
        let autorDict : NSMutableDictionary = NSMutableDictionary (capacity:1)
        autorDict.setValue("alain", forKey: "name")
        playlistDict["creator"] = autorDict
        playlistDict["duration"] = 234
        playlistDict["tracklist"] = "http://www.playlist.com"
        playlist.add(playlistDict)
        dict.setValue(playlist, forKey: "data")
        
        let playlistService = PlaylistService()
        let playlistParsed: [Playlist] = playlistService.parsing(json: dict)
        
        XCTAssert(playlistParsed[0].title == "title")
        XCTAssert(playlistParsed[0].pictureUrl == "http://www.image.com/image.png")
        XCTAssert(playlistParsed[0].autor == "alain")
        XCTAssert(playlistParsed[0].duration == "00:03:54")
        XCTAssert(playlistParsed[0].tracksurl == "http://www.playlist.com")
    }
}
