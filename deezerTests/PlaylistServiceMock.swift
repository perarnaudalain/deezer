import Foundation
import RxSwift
@testable import deezer

class PlaylistServiceMock : PlaylistServiceProtocol {
    func getData() -> Observable<[Playlist]> {
        let observable = Observable<[Playlist]>.create { observer in
            let playlist = Playlist(title: "title", pictureUrl: "http://www.image.com/image.png", autor:"alain", duration:"44:44:22", tracksurl:"http://www.playlist.com")
            var playlists : [Playlist] = ([])
            playlists.append(playlist)
            observer.onNext(playlists)
            observer.onCompleted()
            return Disposables.create()
        }
        return observable
    }
}
