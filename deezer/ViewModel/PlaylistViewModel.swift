import Foundation
import RxSwift

/**
 * Viewmodel of PlaylistViewController
 */
class PlaylistViewModel
{
    /**
     * Playlist model
     */
    internal let privateDataSourcePlaylists: Variable<[Playlist]> = Variable([])
    public let dataSourcePlaylists: Observable<[Playlist]>
    
    /**
     * Init
     */
    init(playlistService:PlaylistServiceProtocol) {
        self.dataSourcePlaylists = privateDataSourcePlaylists.asObservable()
        
        let _ = playlistService.getData().asObservable().subscribe(onNext: {list in
            self.privateDataSourcePlaylists.value = list
        }, onError: {error in
            let alert = UIAlertController(title: "Erreur réseau", message: "Vérifier votre connexion internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        })
    }
}
