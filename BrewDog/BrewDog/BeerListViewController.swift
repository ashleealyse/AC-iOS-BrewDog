//
//  BeerListViewController.swift
//  BrewDog
//
//  Created by Ashlee Krammer on 11/17/17.
//  Copyright © 2017 AC-iOS. All rights reserved.
//

import UIKit

class BeerListViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var beerEndPoint = "https://api.punkapi.com/v2/beers?page=1&per_page=80"
    
    var beerList: [Beer] = []
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        getData()
        
    }
    
    //Get Data
    func getData(){
        
        guard let url = URL(string: beerEndPoint) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let myData = data {
                
                guard let beerJSONArray = try? JSONSerialization.jsonObject(with: myData, options: []) as? [[String:Any]] else { return }
                
                for beerDict in beerJSONArray! {
                    if let thisBeer = Beer(from: beerDict) {
                        self.beerList.append(thisBeer)
                    }
                }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                
            }
            
            
        }
        task.resume()
        
    }
    
    
}






extension BeerListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aBeer = beerList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Beer Cell", for: indexPath)
        cell.textLabel?.text = aBeer.name
        cell.detailTextLabel?.text = "ABV: \(aBeer.abv)%"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beers: "
    }
    
    //Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BeerDetailedViewController {
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedBeer = beerList[selectedRow!]
            destination.beer = selectedBeer
    }
    }
    
}
