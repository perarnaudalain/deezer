import Foundation
import RxSwift
import Alamofire

/**
 * Service 
 */
class TracklistService : TracklistServiceProtocol {
    /**
     * Parsing json value
     * @param json The json to parse which contains the playlist
     * return The array of playlist
     */
    internal func parsing(json:NSDictionary, indexStart:Int) -> [Track] {
        let tracklists = json["data"] as! NSArray
        var list : [Track] = []
        var max = indexStart + TRACK_BY_PAGE
        if tracklists.count < max {
            max = tracklists.count
        }
        for i in indexStart..<max {
            let trackjson = tracklists[i]
            let playlistinfo = trackjson as! NSDictionary
            let title = playlistinfo["title"] as! String
            let artist = playlistinfo["artist"] as! NSDictionary
            let name = artist["name"] as! String
            let durationInt = playlistinfo["duration"] as! Int64
            let duration = FormatUtil.formatDuration(duration: durationInt)
            
            let track : Track = Track(title:title, name:name, duration:duration)
            list.append(track)
        }
        return list
    }

    /**
     * Get the track
     * @param url The url of the playlist
     * @param page
     * @param number
     * @return The playlist of a specific user
     */
    public func getData(url:String, indexStart:Int) -> Observable<[Track]>  {
        let observable = Observable<[Track]>.create { observer in
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                if(response.response?.statusCode  == 200 && response.result.value is NSDictionary) {
                    let tracklist = self.parsing(json:response.result.value as! NSDictionary, indexStart:indexStart)
                    observer.onNext(tracklist)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "network error", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
        return observable.share()
    }
}
