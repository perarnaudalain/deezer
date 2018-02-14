import UIKit
import RxSwift

/**
 * Page which displays the playlist of a specific user (Constants.DEEZER_ID)
 */
class PlaylistViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    /**
     * List of playlists
     * Ths list can be only modified by the binding with the viewmodel
     * The collectionview use this list in readonly to display the playlist
     */
    private var playlists : [Playlist]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Compute the cell size
        let sizeCell = (UIScreen.main.bounds.width - 10 - 10) / 3
        let cellSize = CGSize(width:sizeCell , height:sizeCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 0.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        // instanciate the viewmodel
        let playlistViewModel = PlaylistViewModel(playlistService:PlaylistService())
        
        // Binding viewmodel to view
        // The viewmodel informs the view the playlist was updated
        // The datasource of the collectionview could be setted and the display refreshs
        let _ = playlistViewModel.dataSourcePlaylists.asObservable().subscribe(onNext: { playlists in
            self.playlists = playlists
            self.collectionView.reloadData()
        })
    }
    
    /**
     * Fill the collectionview with the datasource
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playlistcell", for: indexPath) as! MyCollectionViewCell
        cell.label.text = playlists![indexPath.row].title
        if playlists![indexPath.row].cover != nil {
            cell.imageview.image = UIImage(data: playlists![indexPath.row].cover!)
        } else {
            cell.imageview.image = UIImage(named:"noimage.png")
        }
        return cell
    }
    
    /**
     * Number of cell in the grid
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists!.count
    }
    
    /**
     * Handle the click on a cell in the grid
     * Note : this part contains screen changing logic.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TrackViewController") as! TrackViewController
        controller.playlist = playlists![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

