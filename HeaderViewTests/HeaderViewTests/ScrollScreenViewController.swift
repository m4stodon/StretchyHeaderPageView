//
//  ScrollScreenViewController.swift
//  HeaderViewTests
//
//  Created by Ermac on 11/10/17.
//  Copyright © 2017 YourMac. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollProgressDelegate {
    func scrollViewDidScroll(pageIndex: Int, scrollView: UIScrollView)
    func scrollViewDidEndDragging(pageIndex: Int, scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(pageIndex: Int, scrollView: UIScrollView)
    func scrollViewWillEndDragging(pageIndex: Int, scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

}

protocol PageableViewController {
    var pageIndex: Int {
        get
        set
    }
    var scrollHandler: ScrollProgressDelegate? {
        get
        set
    }
    var scrollView: UIScrollView {
        get
    }
}

class ScrollScreenViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, ScrollProgressDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarShadowImageView: UIImageView!
    @IBOutlet weak var tabsTopOffset: NSLayoutConstraint!
    
    var pages: [PageableViewController]? = nil
    var currentPageIndex: Int = 0
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageViewControllerEmbedded" {
            initPages()
            let pageViewController = segue.destination as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            let initialVC = pages![0] as! UIViewController
            pageViewController.setViewControllers([initialVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    
    
    ////////////////
    
    var previousScrollOffset: CGFloat = 0.0
    var draggingToTop = false
    
    func scrollViewDidScroll(pageIndex: Int, scrollView: UIScrollView) {
        
        draggingToTop = previousScrollOffset - scrollView.contentOffset.y > 0
        
        guard pageIndex == currentPageIndex else { return }
        
        if scrollView.contentOffset.y <= 0 { // height of inset is height of the header
            var offset = max(44, abs(scrollView.contentOffset.y) - 40)
            if draggingToTop { offset = max(offset, tabsTopOffset.constant) } // not to resize already resized header when dragging to top
            tabsTopOffset.constant = offset
            for page in pages! {
                if page.pageIndex != currentPageIndex {
                    if page.scrollView.contentOffset.y < 0 {
                        let twickedOffset = CGPoint(x: scrollView.contentOffset.x, y: min(-40 * 2, scrollView.contentOffset.y))
                        page.scrollView.setContentOffset(twickedOffset, animated: false)
                    }
                }
            }
        }
        previousScrollOffset = scrollView.contentOffset.y
    }
    
    var needToAdjustHeight: Bool = false
    
    func scrollViewWillEndDragging(pageIndex: Int, scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let threshhold: CGFloat = -200.0
        
        if targetContentOffset.pointee.y < threshhold {
            targetContentOffset.pointee.y = -304
        } else {
            if tabsTopOffset.constant != 44.0 {
                targetContentOffset.pointee.y = -80
            }
        }
    }
    
    func scrollViewDidEndDragging(pageIndex: Int, scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(pageIndex: Int, scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -200 && tabsTopOffset.constant > 44 {
            tabsTopOffset.constant = 44
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    ////////////////
    
    func initPages() {
        let insets = UIEdgeInsetsMake(304, 0, 0, 0)
        currentPageIndex = 0
        //
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        firstVC.view.backgroundColor = UIColor.red
        firstVC.pageIndex = 0
        firstVC.tableView.contentInset = insets
        firstVC.scrollHandler = self
        //
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        secondVC.view.backgroundColor = UIColor.green
        secondVC.pageIndex = 1
        secondVC.tableView.contentInset = insets
        secondVC.scrollHandler = self
        //
        let thirdVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        thirdVC.view.backgroundColor = UIColor.blue
        thirdVC.pageIndex = 2
        thirdVC.tableView.contentInset = insets
        thirdVC.scrollHandler = self
        //
        pages = [firstVC, secondVC, thirdVC]
    }
    
    ////////////////
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var nextViewController: UIViewController? = nil
        
        if (self.currentPageIndex + 1 <= self.pages!.count - 1) {
            nextViewController = self.pages![self.currentPageIndex + 1] as? UIViewController
        }
        
        return nextViewController;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var previousViewController: UIViewController? = nil
        
        if (self.currentPageIndex - 1 >= 0) {
            previousViewController = self.pages![self.currentPageIndex - 1] as? UIViewController
        }
        
        return previousViewController;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else { return }
        let vc = pageViewController.viewControllers!.first as! TableViewController
        self.currentPageIndex = vc.pageIndex
    }
}
