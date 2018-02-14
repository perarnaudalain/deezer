import Foundation
import RxSwift

/**
 * Playlist model
 */
class Playlist {
    var title : String
    var cover : Data?
    var pictureUrl : String
    var autor : String
    var duration : String
    var tracksurl : String
    
    init(title:String, pictureUrl:String, autor:String, duration:String, tracksurl:String, cover:Data? = nil) {
        self.title = title
        self.cover = cover
        self.pictureUrl = pictureUrl
        self.autor = autor
        self.duration = duration
        self.tracksurl = tracksurl
    }
}
