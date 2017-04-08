//
//  ViewController.swift
//  PersonalSpotify
//
//  Created by Pravin Biradar on 4/8/17.
//  Copyright © 2017 pbirada1. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UITableViewController {
    
    var names = [String]()
    
    var searchURL = "https://api.spotify.com/v1/search?q=Enrique+Iglesias&type=track"
    
    typealias JSONStandard = [String: AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAlamo(url: searchURL)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(JSONData: response.data!)
        }
    }
    
    func parseData(JSONData:Data) {
        do{
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            print(readableJSON)
            if let tracks = readableJSON["tracks"]as? JSONStandard{
                if let items = tracks["items"]{
                    
                    for i in 0..<items.count{
                        let item = items[i] as? JSONStandard
                        
                        let name = item?["name"] as! String
                        names.append(name)
                        
                        self.tableView.reloadData()
                    }
                }
            }
            
        }catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        cell?.textLabel?.text = names[indexPath.row]
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

