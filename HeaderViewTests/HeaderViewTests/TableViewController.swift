//
//  TableViewController.swift
//  HeaderViewTests
//
//  Created by Ermac on 11/13/17.
//  Copyright © 2017 YourMac. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PageableViewController {
    

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = -1
    var scrollHandler: ScrollProgressDelegate? = nil
    var scrollView: UIScrollView {
        return self.tableView
    }
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandler?.scrollViewDidScroll(pageIndex: pageIndex, scrollView: tableView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollHandler?.scrollViewDidEndDragging(pageIndex: pageIndex, scrollView: tableView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollHandler?.scrollViewDidEndDecelerating(pageIndex: pageIndex, scrollView: tableView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollHandler?.scrollViewWillEndDragging(pageIndex: pageIndex, scrollView: tableView, velocity: velocity, targetContentOffset: targetContentOffset)
    }
}
