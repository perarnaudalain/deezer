import XCTest
@testable import deezer

class FormatUtilTest: XCTestCase {
    func testFormat1() {
        let duration1 : Int64 = -1;
        let duration1String : String = FormatUtil.formatDuration(duration: duration1)
        XCTAssert(duration1String == "00:00:00")
    }

    func testFormat2() {
        let duration1 : Int64 = 93426832;
        let duration1String : String = FormatUtil.formatDuration(duration: duration1)
        XCTAssert(duration1String == "25951:53:52")
    }

    func testFormat3() {
        let duration1 : Int64 = 1000;
        let duration1String : String = FormatUtil.formatDuration(duration: duration1)
        XCTAssert(duration1String == "00:16:40")
    }

    func testFormat4() {
        let duration1 : Int64 = 0;
        let duration1String : String = FormatUtil.formatDuration(duration: duration1)
        XCTAssert(duration1String == "00:00:00")
    }
}
