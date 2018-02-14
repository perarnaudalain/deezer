import Foundation
import RxSwift
import Alamofire

/**
 * Service used to get the playlist of a specific user
 */
class PlaylistService : PlaylistServiceProtocol {
    /**
     * Parsing json value
     * @param json The json to parse which contains the playlist
     * return The array of playlist
     */
    internal func parsing(json:NSDictionary) -> [Playlist] {
        let playlists = json["data"] as! NSArray
        var list : [Playlist] = []
        for playlist in playlists {
            let playlistinfo = playlist as! NSDictionary
            let title = playlistinfo["title"] as! String
            let pictureUrl = playlistinfo["picture_small"] as! String
            let creatordict = playlistinfo["creator"] as! NSDictionary
            let autor = creatordict["name"] as! String
            let durationInt = playlistinfo["duration"] as! Int64
            let duration = FormatUtil.formatDuration(duration: durationInt)
            let tracksurl = playlistinfo["tracklist"] as! String
            
            let url = URL(string: pictureUrl)
            let data = try? Data(contentsOf: url!)
            
            let pl : Playlist = Playlist(title: title, pictureUrl: pictureUrl, autor:autor, duration:duration, tracksurl:tracksurl, cover: data)
            list.append(pl)
        }
        return list;
    }
    
    /**
     * Get the playlist ot a specific user
     * @return The playlist of a specific user
     */
    public func getData() -> Observable<[Playlist]> {
        let observable = Observable<[Playlist]>.create { observer in
            Alamofire.request("https://api.deezer.com/user/\(DEEZER_ID)/playlists", method: .get, parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                if(response.response?.statusCode  == 200) {
                    let list = self.parsing(json: response.result.value as! NSDictionary)
                    observer.onNext(list)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "network error", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
        return observable
    }
}
