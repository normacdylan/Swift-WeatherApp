//
//  SearchController.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-15.
//  Copyright © 2018 August Posner. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    let weather = WeatherGetter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultLabel.text = ""
        viewButton.isHidden = !weather.foundCity(searchBar.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultLabel.text = getSearchResult(searchBar.text!)
        viewButton.isHidden = !weather.foundCity(searchBar.text!)
    }
    
    @IBAction func pressedView(_ sender: Any) {
     //   performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
    
    func getSearchResult(_ search: String) -> String {
        if searchBar.text!.count < 1 {
            return ""
        }
        if weather.foundCity(searchBar.text!) {
            return "Found weather for \(search)!"
        } else {
            return "Could not find weather for \(search). Please check for spelling errors."
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailController
        destination.city = searchBar.text
    }
    

}
