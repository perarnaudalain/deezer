import Foundation
import RxSwift

/**
 * Viewmodel of TrackViewController
 */
class TrackViewModel
{
    /**
     * Playlist model
     */
    internal let privateDataSourcePlaylist: Variable<[Playlist]> = Variable([])
    public let dataSourcePlaylist: Observable<[Playlist]>
    
    /**
     * Tracks list model
     */
    internal let privateDataSourceTracks: Variable<[Track]> = Variable([])
    public let dataSourceTracks: Observable<[Track]>
    
    /**
     * Init
     * @param playlist The selected playlist
     * @param checkNextPage Indicate we could try to ask the next page
     */
    init(tracklistService : TracklistServiceProtocol, playlist : Playlist, checkNextPage:Observable<Bool>) {
        self.dataSourcePlaylist = privateDataSourcePlaylist.asObservable()
        privateDataSourcePlaylist.value.append(playlist)
        
        self.dataSourceTracks = privateDataSourceTracks.asObservable()
        
        // Get the tracks
        let _ = checkNextPage.asObservable().subscribe(onNext: { value in
            // We ask a next page
            if value == true {
                // Try to load new tracks for this playlit
                let _ = tracklistService.getData(url: playlist.tracksurl, indexStart:self.privateDataSourceTracks.value.count).asObservable().subscribe(onNext: { list in
                        // Add new tracks to the model
                        for track in list {
                            self.privateDataSourceTracks.value.append(track)
                        }
                }, onError: {error in
                    let alert = UIAlertController(title: "Erreur réseau", message: "Vérifier votre connexion internet", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
        })
    }
}
