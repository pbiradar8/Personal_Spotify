//
//  ViewController.swift
//  PersonalSpotify
//
//  Created by Pravin Biradar on 4/8/17.
//  Copyright © 2017 pbirada1. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()


struct post {
    let mainImage : UIImage!
    let name : String!
    let previewURL:String!
    
}

class MainViewController: UITableViewController,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var posts = [post]()
    
    var searchURL = "https://api.spotify.com/v1/search?q=Enrique+Iglesias&type=track"
    
    typealias JSONStandard = [String: AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        print(searchURL)
        callAlamo(url: searchURL)
        
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
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
            
            if let tracks = readableJSON["tracks"]as? JSONStandard{
                if let items = tracks["items"] as? [JSONStandard]{
                    
                    for i in 0..<items.count{
                        let item = items[i]
                        
                        let name = item["name"] as? String
                        let previewURL = item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONStandard{
                            if let images = album["images"] as? [JSONStandard]{
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"]as! String )
                                let mainIamgedata = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainIamgedata as! Data)
                                posts.append(post.init(mainImage: mainImage, name: name, previewURL: previewURL))
                                
                                
                                self.tableView.reloadData()

                            }
                        
                        }
                        
                    }
                }
            }
            
        }catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        let mainImageView  = cell?.viewWithTag(2)as!UIImageView
        mainImageView.image = posts[indexPath.row].mainImage
        
        let mainlabel  = cell?.viewWithTag(1)as!UILabel
        
        mainlabel.text = posts[indexPath.row].name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! audioView
        vc.image = posts[indexPath!].mainImage
        vc.songTitle = posts[indexPath!].name
        vc.previewURL = posts[indexPath!].previewURL
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

