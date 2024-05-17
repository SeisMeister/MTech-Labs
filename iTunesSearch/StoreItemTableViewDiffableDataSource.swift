//
//  StoreItemTableViewDiffableDataSource.swift
//  iTunesSearch
//
//  Created by Cesar Fernandez on 5/14/24.
//

import UIKit

@MainActor
class StoreItemTableViewDiffableDataSource: UITableViewDiffableDataSource<String, StoreItem.ID> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section]
    }
}
