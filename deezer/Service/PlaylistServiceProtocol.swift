import Foundation
import RxSwift

protocol PlaylistServiceProtocol {
    func getData() -> Observable<[Playlist]>
}

