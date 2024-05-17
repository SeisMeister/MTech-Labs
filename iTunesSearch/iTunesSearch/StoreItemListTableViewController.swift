
import UIKit

class StoreItemListTableViewController: UITableViewController {
    // 10:32 am
    // This implementation got lost
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.blue
//   }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

