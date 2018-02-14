import Foundation
import RxSwift

protocol TracklistServiceProtocol {
    func getData(url:String, indexStart:Int) -> Observable<[Track]>
}
