//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet weak var yelpTableView: UITableView!

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar = UISearchBar()
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.yelpTableView.reloadData()
            for business in businesses {
                print(business.name!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
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
        let dealSwitchState = filters["deals"] as? Bool
        var radiusFilter = filters["distance"] as? NSNumber
        if (radiusFilter == 0) {
            radiusFilter = nil
        }
        let sortBy = filters["sort"] as? YelpSortMode
        
        let categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("Restaurants", sort: sortBy, categories: categories, deals: dealSwitchState, radius: radiusFilter, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.yelpTableView.reloadData()
        })
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
