//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Piyush Sharma on 7/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


@objc protocol  FiltersViewControllerDelegate {
    optional func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])

}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DealsCellDelegate, CategoriesCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate!
    
    var cellSections = [["deals": "Offering a Deal"], ["distance": "Distance"],
                        ["sort": "Sory By"],["category": "Category"]]
    var isExpanded: [Bool]! // store if the section is expanded or not
    
    var dealSwitchState = Bool()
    
    var distanceOptions = ["Best Match", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var currentDistanceOptionIndex = 0
    
    var sortOptions = ["Best Match", "Distance", "Rating"]
    var currentSortOptionIndex = 0
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categories = self.yelpCategories()
        
        self.filtersTableView.dataSource = self
        self.filtersTableView.delegate = self
        
        isExpanded = [Bool](count: cellSections.count, repeatedValue: false)
        
        var cellNib = UINib(nibName: "DealsCell", bundle: NSBundle.mainBundle())
        self.filtersTableView.registerNib(cellNib, forCellReuseIdentifier: "DealsCell")
        
        cellNib = UINib(nibName: "DistanceCell", bundle: NSBundle.mainBundle())
        self.filtersTableView.registerNib(cellNib, forCellReuseIdentifier: "DistanceCell")
        
        cellNib = UINib(nibName: "SortCell", bundle: NSBundle.mainBundle())
        self.filtersTableView.registerNib(cellNib, forCellReuseIdentifier: "SortCell")
        
        cellNib = UINib(nibName: "CategoriesCell", bundle: NSBundle.mainBundle())
        self.filtersTableView.registerNib(cellNib, forCellReuseIdentifier: "CategoriesCell")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // since cellSections is static, no error handling required
        return cellSections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cellSections[section]["distance"] != nil) {
            
            if (isExpanded[section]) {
               return distanceOptions.count
            }
            return 1
            
        } else if (self.cellSections[section]["sort"] != nil) {
            
            if (isExpanded[section]) {
                return sortOptions.count
            }
            return 1
            
        } else  if (self.cellSections[section]["category"] != nil) {
            
            return categories.count
            
        }
        return 1
    }
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if (self.cellSections[indexPath.section]["deals"] != nil) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DealsCell", forIndexPath: indexPath) as! DealsCell
            cell.dealsLabel.text = self.cellSections[indexPath.section]["deals"]
            cell.delegate = self
            // example of ternary operator in swift
            cell.dealsSwitch.on = self.dealSwitchState ?? false
            return cell
            
        } else if (self.cellSections[indexPath.section]["distance"] != nil) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DistanceCell", forIndexPath: indexPath) as! DistanceCell
            
            // logic to show the checked row in the section
            var rowIndex = 0
            if (tableView.numberOfRowsInSection(indexPath.section) == 1) {
                
                rowIndex = currentDistanceOptionIndex
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            } else {
                
                rowIndex = indexPath.row
                if (indexPath.row == currentDistanceOptionIndex) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                
            }
            cell.distanceLabel.text = self.distanceOptions[rowIndex]
            
            return cell
            
        } else if (self.cellSections[indexPath.section]["sort"] != nil) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SortCell", forIndexPath: indexPath) as! SortCell
            
            // logic to show the checked row in the section
            var rowIndex = 0
            if (tableView.numberOfRowsInSection(indexPath.section) == 1) {
                
                rowIndex = currentSortOptionIndex
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            } else {
                
                rowIndex = indexPath.row
                if (indexPath.row == currentSortOptionIndex) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                
            }
            cell.sortLabel.text = self.sortOptions[rowIndex]
            
            return cell
            
        } else if (self.cellSections[indexPath.section]["category"] != nil) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoriesCell", forIndexPath: indexPath) as! CategoriesCell
            cell.categoriesLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            // example of ternary operator in swift
            cell.categoriesSwitch.on = self.switchStates[indexPath.row] ?? false
            return cell
            
        }
        print ("Something went terribly wrong, we should have returned the cell in the if loop")
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.cellSections[indexPath.section]["distance"] != nil) {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            isExpanded[indexPath.section] = !isExpanded[indexPath.section]
            if (!isExpanded[indexPath.section]) {
                currentDistanceOptionIndex = indexPath.row
            }
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        
        } else if (self.cellSections[indexPath.section]["sort"] != nil) {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            isExpanded[indexPath.section] = !isExpanded[indexPath.section]
            if (!isExpanded[indexPath.section]) {
                currentSortOptionIndex = indexPath.row
            }
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        }
    }

    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerLabel = ""
        if (self.cellSections[section]["distance"] != nil) {
            headerLabel = self.cellSections[section]["distance"]!
        } else if (self.cellSections[section]["sort"] != nil) {
            headerLabel = self.cellSections[section]["sort"]!
        } else  if (self.cellSections[section]["category"] != nil) {
            headerLabel = self.cellSections[section]["category"]!
        }
        return headerLabel
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String:AnyObject]()
        
        filters["deals"] = dealSwitchState
        
        // miles converted to meter (rounded)
        let radiusFilter = [0, 483, 1609, 8047, 32187]
        filters["distance"] = radiusFilter[currentDistanceOptionIndex]
        
        // since the search api input values (YelpSortMode) are matched with the array created
        filters["sort"] = currentSortOptionIndex
        
        var selectedCategories = [String]()
        for (row, isSelected) in self.switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if (selectedCategories.count > 0) {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }    
    
    func categoriesCell(categoriesCell: CategoriesCell, didChangeValue value: Bool) {
        let indexPath = self.filtersTableView.indexPathForCell(categoriesCell)
        self.switchStates[indexPath!.row] = value
    }
    
    func dealsCell(dealsCell: DealsCell, didChangeValue value: Bool) {
        self.dealSwitchState = value
    }
    
    func yelpCategories() -> [[String:String]] {
        return  [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"],
                      ["name" : "Bavarian", "code": "bavarian"],
                      ["name" : "Beer Garden", "code": "beergarden"],
                      ["name" : "Beer Hall", "code": "beerhall"],
                      ["name" : "Beisl", "code": "beisl"],
                      ["name" : "Belgian", "code": "belgian"],
                      ["name" : "Bistros", "code": "bistros"],
                      ["name" : "Black Sea", "code": "blacksea"],
                      ["name" : "Brasseries", "code": "brasseries"],
                      ["name" : "Brazilian", "code": "brazilian"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                      ["name" : "British", "code": "british"],
                      ["name" : "Buffets", "code": "buffets"],
                      ["name" : "Bulgarian", "code": "bulgarian"],
                      ["name" : "Burgers", "code": "burgers"],
                      ["name" : "Burmese", "code": "burmese"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Cajun/Creole", "code": "cajun"],
                      ["name" : "Cambodian", "code": "cambodian"],
                      ["name" : "Canadian", "code": "New)"],
                      ["name" : "Canteen", "code": "canteen"],
                      ["name" : "Caribbean", "code": "caribbean"],
                      ["name" : "Catalan", "code": "catalan"],
                      ["name" : "Chech", "code": "chech"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                      ["name" : "Chicken Shop", "code": "chickenshop"],
                      ["name" : "Chicken Wings", "code": "chicken_wings"],
                      ["name" : "Chilean", "code": "chilean"],
                      ["name" : "Chinese", "code": "chinese"],
                      ["name" : "Comfort Food", "code": "comfortfood"],
                      ["name" : "Corsican", "code": "corsican"],
                      ["name" : "Creperies", "code": "creperies"],
                      ["name" : "Cuban", "code": "cuban"],
                      ["name" : "Curry Sausage", "code": "currysausage"],
                      ["name" : "Cypriot", "code": "cypriot"],
                      ["name" : "Czech", "code": "czech"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                      ["name" : "Danish", "code": "danish"],
                      ["name" : "Delis", "code": "delis"],
                      ["name" : "Diners", "code": "diners"],
                      ["name" : "Dumplings", "code": "dumplings"],
                      ["name" : "Eastern European", "code": "eastern_european"],
                      ["name" : "Ethiopian", "code": "ethiopian"],
                      ["name" : "Fast Food", "code": "hotdogs"],
                      ["name" : "Filipino", "code": "filipino"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Galician", "code": "galician"],
                      ["name" : "Gastropubs", "code": "gastropubs"],
                      ["name" : "Georgian", "code": "georgian"],
                      ["name" : "German", "code": "german"],
                      ["name" : "Giblets", "code": "giblets"],
                      ["name" : "Gluten-Free", "code": "gluten_free"],
                      ["name" : "Greek", "code": "greek"],
                      ["name" : "Halal", "code": "halal"],
                      ["name" : "Hawaiian", "code": "hawaiian"],
                      ["name" : "Heuriger", "code": "heuriger"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                      ["name" : "Hot Dogs", "code": "hotdog"],
                      ["name" : "Hot Pot", "code": "hotpot"],
                      ["name" : "Hungarian", "code": "hungarian"],
                      ["name" : "Iberian", "code": "iberian"],
                      ["name" : "Indian", "code": "indpak"],
                      ["name" : "Indonesian", "code": "indonesian"],
                      ["name" : "International", "code": "international"],
                      ["name" : "Irish", "code": "irish"],
                      ["name" : "Island Pub", "code": "island_pub"],
                      ["name" : "Israeli", "code": "israeli"],
                      ["name" : "Italian", "code": "italian"],
                      ["name" : "Japanese", "code": "japanese"],
                      ["name" : "Jewish", "code": "jewish"],
                      ["name" : "Kebab", "code": "kebab"],
                      ["name" : "Korean", "code": "korean"],
                      ["name" : "Kosher", "code": "kosher"],
                      ["name" : "Kurdish", "code": "kurdish"],
                      ["name" : "Laos", "code": "laos"],
                      ["name" : "Laotian", "code": "laotian"],
                      ["name" : "Latin American", "code": "latin"],
                      ["name" : "Live/Raw Food", "code": "raw_food"],
                      ["name" : "Lyonnais", "code": "lyonnais"],
                      ["name" : "Malaysian", "code": "malaysian"],
                      ["name" : "Meatballs", "code": "meatballs"],
                      ["name" : "Mediterranean", "code": "mediterranean"],
                      ["name" : "Mexican", "code": "mexican"],
                      ["name" : "Middle Eastern", "code": "mideastern"],
                      ["name" : "Milk Bars", "code": "milkbars"],
                      ["name" : "Modern Australian", "code": "modern_australian"],
                      ["name" : "Modern European", "code": "modern_european"],
                      ["name" : "Mongolian", "code": "mongolian"],
                      ["name" : "Moroccan", "code": "moroccan"],
                      ["name" : "New Zealand", "code": "newzealand"],
                      ["name" : "Night Food", "code": "nightfood"],
                      ["name" : "Norcinerie", "code": "norcinerie"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches"],
                      ["name" : "Oriental", "code": "oriental"],
                      ["name" : "Pakistani", "code": "pakistani"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes"],
                      ["name" : "Parma", "code": "parma"],
                      ["name" : "Persian/Iranian", "code": "persian"],
                      ["name" : "Peruvian", "code": "peruvian"],
                      ["name" : "Pita", "code": "pita"],
                      ["name" : "Pizza", "code": "pizza"],
                      ["name" : "Polish", "code": "polish"],
                      ["name" : "Portuguese", "code": "portuguese"],
                      ["name" : "Potatoes", "code": "potatoes"],
                      ["name" : "Poutineries", "code": "poutineries"],
                      ["name" : "Pub Food", "code": "pubfood"],
                      ["name" : "Rice", "code": "riceshop"],
                      ["name" : "Romanian", "code": "romanian"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                      ["name" : "Rumanian", "code": "rumanian"],
                      ["name" : "Russian", "code": "russian"],
                      ["name" : "Salad", "code": "salad"],
                      ["name" : "Sandwiches", "code": "sandwiches"],
                      ["name" : "Scandinavian", "code": "scandinavian"],
                      ["name" : "Scottish", "code": "scottish"],
                      ["name" : "Seafood", "code": "seafood"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                      ["name" : "Singaporean", "code": "singaporean"],
                      ["name" : "Slovakian", "code": "slovakian"],
                      ["name" : "Soul Food", "code": "soulfood"],
                      ["name" : "Soup", "code": "soup"],
                      ["name" : "Southern", "code": "southern"],
                      ["name" : "Spanish", "code": "spanish"],
                      ["name" : "Steakhouses", "code": "steak"],
                      ["name" : "Sushi Bars", "code": "sushi"],
                      ["name" : "Swabian", "code": "swabian"],
                      ["name" : "Swedish", "code": "swedish"],
                      ["name" : "Swiss Food", "code": "swissfood"],
                      ["name" : "Tabernas", "code": "tabernas"],
                      ["name" : "Taiwanese", "code": "taiwanese"],
                      ["name" : "Tapas Bars", "code": "tapas"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                      ["name" : "Tex-Mex", "code": "tex-mex"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
