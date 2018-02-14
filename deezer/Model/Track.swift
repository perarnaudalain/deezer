import Foundation
import RxSwift

/**
 * Track model
 */
class Track {
    var title : String
    var name : String
    var duration : String
    
    init(title:String, name:String, duration:String) {
        self.title = title
        self.name = name
        self.duration = duration
    }
}
