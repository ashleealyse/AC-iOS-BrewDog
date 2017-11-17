//
//  BeerDetailedViewController.swift
//  BrewDog
//
//  Created by Ashlee Krammer on 11/17/17.
//  Copyright © 2017 AC-iOS. All rights reserved.
//

import UIKit

class BeerDetailedViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var detailedTextScroll: UITextView!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    
    
    
    
    func getImage() {
        guard let url = URL(string: (beer?.imageUrlString)!) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let myData = data {
                let thisImage = UIImage(data: myData)
                
                DispatchQueue.main.async {
                    self.beerImage.image = thisImage
                }
                
                
            }
        }
        task.resume()
        
        
    }
    var beer: Beer?
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        beerNameLabel.text = beer?.name
        detailedTextScroll.text =
        """
        ABV: \(String(describing: beer!.abv))%
        
        Tagline: \(String(describing: beer!.tagline))
        
        Beer Description: \(String(describing: beer!.beerDescription))
        """
    }
    
    
}
