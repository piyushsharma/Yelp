//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var yelpTableView: UITableView!

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar = UISearchBar()
    var searchActive: Bool = false
    var isMoreDataLoading = false
    
    var loadingMoreView:InfiniteScrollActivityView?
    var filters = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, self.yelpTableView.contentSize.height, self.yelpTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        self.yelpTableView.addSubview(loadingMoreView!)
        
        var insets = self.yelpTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        self.yelpTableView.contentInset = insets
        
        yelpTableView.delegate = self
        yelpTableView.dataSource = self
        yelpTableView.rowHeight = UITableViewAutomaticDimension
        yelpTableView.estimatedRowHeight = 120

        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar.sizeToFit()
        searchBar.delegate = self
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        self.filters["term"] = "Restaurants"
        self.filters["sort"] = 0
        self.loadBusinessData(false)
        
    }
    
    
    func loadBusinessData(append: Bool) {
        let term = self.filters["term"] as! String
        let sortIndex = self.filters["sort"] as? Int
        let sort = YelpSortMode(rawValue: sortIndex!)
        
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let radius = filters["radius"] as? NSNumber
        var offset = 0
        if (append) {
            offset = self.businesses.count + 1
        }
        
        Business.searchWithTerm(term, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            // Update flag
            self.isMoreDataLoading = false
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            if (append) {
                self.businesses.appendContentsOf(businesses)
            } else {
                self.businesses = businesses
            }
            self.filteredBusinesses = self.businesses
            
            self.yelpTableView.reloadData()
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.yelpTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.yelpTableView.bounds.size.height
        
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.yelpTableView.dragging) {
                isMoreDataLoading = true
            
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, self.yelpTableView.contentSize.height, self.yelpTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
            
                if(!searchActive) {
                    self.loadBusinessData(true)
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    
    // This method updates filteredBusinesses based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // The user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        self.filteredBusinesses = self.businesses.filter {
            business in
            // If dataItem matches the searchText, return true to include it
            if business.name?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                return true
            } else {
                return false
            }
        }
        
        if (filteredBusinesses.count == 0) {
            if (searchText.isEmpty) {
                self.searchActive  = false
            }
        } else {
            self.searchActive = true
        }
        
        yelpTableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredBusinesses.count
        }
        if (businesses != nil) {
            return businesses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = yelpTableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        if searchActive {
            cell.business = self.filteredBusinesses[indexPath.row]
        } else {
            cell.business = self.businesses[indexPath.row]
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        self.filters["deals"] = filters["deals"] as? Bool
        var radiusFilter = filters["distance"] as? NSNumber
        if (radiusFilter == 0) {
            radiusFilter = nil
        }
        self.filters["radius"] = radiusFilter
        self.filters["sort"] = filters["sort"]
    
        self.filters["categories"] = filters["categories"] as? [String]
        
        
        self.loadBusinessData(false)
        
//        Business.searchWithTerm("Restaurants", sort: sortBy, categories: categories, deals: dealSwitchState, radius: radiusFilter, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.yelpTableView.reloadData()
//        })
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
