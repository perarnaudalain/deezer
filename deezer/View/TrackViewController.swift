import UIKit
import RxSwift

/**
 * Page with the collapsed toolbar header and the list of tracks
 */
class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var headerCover: UIImageView!
    @IBOutlet weak var headerDuration: UILabel!
    @IBOutlet weak var headerAutor: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    /**
     * Indicate when we arrive at the end on the scroll
     * Informe the viewmodel about that
     */
    private var isEndScroll : Variable<Bool> = Variable(true)

    /**
     * List of tracks
     * Ths list can be only modified by the binding with the viewmodel
     * The tableview use this list in readonly to display the track list
     */
    var trackslist : [Track] = []
    
    /**
     * The viewmodel of this page
     */
    var trackViewModel : TrackViewModel!
    
    /**
     * Playlist selected
     * Note1 : this playlist is mandatory when we arrive on this page
     * Note2 : this member is public to be set by the previous page..
     * I think there a best manner to do this properly
     */
    public var playlist : Playlist!
    
    /**
     * Max position of the tableview
     */
    private var yMax : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Instanciate the viewmodel
        // The viewmodel should know the current playlist and if the user arrives at the end of the page
        trackViewModel = TrackViewModel(tracklistService:TracklistService(), playlist:playlist!, checkNextPage:isEndScroll.asObservable())
        
        // Binding viewmodel to view to refresh the tracks list (lazyloading)
        let _ = trackViewModel!.dataSourceTracks.asObservable().subscribe(onNext: { tracks in
            // Add the tracks
            self.trackslist = tracks
            // Reload the new data on the tableview
            self.tableView.reloadData()
            
            // Inform the data is loaded
            self.isEndScroll.value = false
        })
        
        // Binding viewmodel to view to reafresh the information in the collapsed toolbar header
        let _ = trackViewModel!.dataSourcePlaylist.asObservable().subscribe(onNext: { list in
            self.headerTitle.text = list[0].title
            self.headerAutor.text = list[0].autor
            self.headerDuration.text = list[0].duration
            
            if list[0].cover != nil {
                self.headerCover.image = UIImage(data: list[0].cover!)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.frame.size.height = self.view.frame.size.height
        yMax = tableView.frame.origin.y
    }
    
    /**
     * Update the number of tracks in the tableview
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackslist.count
    }
    
    /**
     * Create or modify the cell in the tableview
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackcell", for: indexPath) as! MyTableViewCell
        cell.name.text = trackslist[indexPath.row].name
        cell.title.text = trackslist[indexPath.row].title
        cell.duration.text = trackslist[indexPath.row].duration
        return cell
    }
    
    /**
     * Manage the collapse of the toolbar header according the scroll of the tableview
     * @param scrollView the scrollview
     */
    private func manageCollapsedToolbarHeader(_ scrollView: UIScrollView) {
        if HEADER_TOOLBAR_COLLAPSED_MODEL_1_ENABLED {
            tableView.frame.origin.y = tableView.frame.origin.y - scrollView.contentOffset.y
            if tableView.frame.origin.y < 0 {
                tableView.frame.origin.y = 0
            }
            if tableView.frame.origin.y > yMax {
                tableView.frame.origin.y = yMax
            }
        } else {
            var multi = CONSTRAINT_COLLAPSED_HEADER_MAX - ((CONSTRAINT_COLLAPSED_HEADER_MAX - CONSTRAINT_COLLAPSED_HEADER_MIN) * scrollView.contentOffset.y) / UIScreen.main.bounds.height
            if multi < CONSTRAINT_COLLAPSED_HEADER_MIN {
                multi = CONSTRAINT_COLLAPSED_HEADER_MIN
            } else if multi > CONSTRAINT_COLLAPSED_HEADER_MAX  {
                multi = CONSTRAINT_COLLAPSED_HEADER_MAX
            }
            let newConstraint = self.constraint.constraintWithMultiplier(multi)
            self.view!.removeConstraint(self.constraint)
            self.constraint = newConstraint
            self.view!.addConstraint(self.constraint)
            self.view!.layoutIfNeeded()
        }
    }
    
    /**
     * Check the scroll ended
     * @param scrollView the scrollview
     */
    private func checkScrollEnded(_ scrollView: UIScrollView) {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        if (self.isEndScroll.value == false && endScrolling >= scrollView.contentSize.height-1)
        {
            self.isEndScroll.value = true
        }
    }
    
    /**
     * Operation during the scroll of the tableview
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Collapsed toolbar header
        self.manageCollapsedToolbarHeader(scrollView)
        
        // End of scroll : lazy loading
        self.checkScrollEnded(scrollView)
    }
    
    /**
     * Action to return to the list of playlist
     * Note : this part contains screen changing logic.
     */
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
