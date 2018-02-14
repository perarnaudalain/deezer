import XCTest
@testable import deezer

class ParsingJsonTrackTest: XCTestCase {
    func testParsing1() {
        let dict : NSMutableDictionary = NSMutableDictionary (capacity: 1)
        let tracklist : NSMutableArray = NSMutableArray (capacity:1)
        let trackDict : NSMutableDictionary = NSMutableDictionary (capacity: 5)
        trackDict["title"] = "title"
        let artistdict : NSMutableDictionary = NSMutableDictionary (capacity: 1)
        artistdict["name"] = "alain"
        trackDict["artist"] = artistdict
        trackDict["duration"] = 234
        tracklist.add(trackDict)
        dict.setValue(tracklist, forKey: "data")
        
        let tracklistService = TracklistService()
        let trackParsed: [Track] = tracklistService.parsing(json: dict, indexStart: 0)
        
        XCTAssert(trackParsed[0].title == "title")
        XCTAssert(trackParsed[0].name == "alain")
        XCTAssert(trackParsed[0].duration == "00:03:54")
    }
}

