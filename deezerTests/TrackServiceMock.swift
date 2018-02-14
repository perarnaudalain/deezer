import Foundation
import RxSwift
@testable import deezer

class TrackServiceMock : TracklistServiceProtocol {
    func getData(url:String, indexStart:Int) -> Observable<[Track]> {
        let observable = Observable<[Track]>.create { observer in
            let track = Track(title: "title", name:"alain", duration:"00:03:54")
            var tracks : [Track] = ([])
            tracks.append(track)
            observer.onNext(tracks)
            observer.onCompleted()
            return Disposables.create()
        }
        return observable
    }
}

