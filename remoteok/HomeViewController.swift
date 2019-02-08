//
//  HomeViewController.swift
//  remoteok
//
//  Created by ivan koop on 10/27/18.
//  Copyright © 2018 vikm. All rights reserved.
//

import UIKit
import SDWebImage

struct field {
    var name : String?
}

class ItemCell : UITableViewCell {
    
    @IBOutlet weak var company_label: UILabel!
    @IBOutlet weak var position_label: UILabel!
    @IBOutlet weak var company_logo_image: UIImageView!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var tag_1: UIView!
    @IBOutlet weak var tag_1_label: UILabel!
    @IBOutlet weak var tag_2: UIView!
    @IBOutlet weak var tag_2_label: UILabel!
    @IBOutlet weak var tag_3: UIView!
    @IBOutlet weak var tag_3_label: UILabel!
    @IBOutlet weak var tag_4: UIView!
    @IBOutlet weak var tag_4_label: UILabel!
    
}


class HomeViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var ws_data : [[String : AnyObject]] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        IKRequest.request(endpoint: "", post: nil) { (response, status_code) in
            
            // error interno
            if status_code == 500 {
                print("ERROR 500")
                return
            }
            
            // request válido
            if status_code == 200 {
                
                //holis
                if let data = response as? [[String: AnyObject]] {
                   
                    self.ws_data = data
                    self.tableView.reloadData()
                    
                    print(data)
                    
                }
                
            } else {
                print("ERROR: \(status_code)")
                return
            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ws_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell", for: indexPath) as! ItemCell;
        
        cell.tag_1.isHidden = true
        cell.tag_2.isHidden = true
        cell.tag_3.isHidden = true
        cell.tag_4.isHidden = true
        
        let item = ws_data[indexPath.row]
        
        if let company = item["company"] as? String {
            cell.company_label.text = company
        }
    
        
        if let position =  item["position"] as? String {
            cell.position_label.text = position
        }
        
        if let company_logo = item["company_logo"] as? String {
            
            if company_logo != "" {
                cell.company_logo_image.sd_setShowActivityIndicatorView(true);
                cell.company_logo_image.sd_setIndicatorStyle(.gray);
                cell.company_logo_image.sd_setImage(with: URL(string: company_logo))
            } else {
                cell.company_logo_image.sd_setShowActivityIndicatorView(true);
                cell.company_logo_image.sd_setIndicatorStyle(.gray);
                cell.company_logo_image.sd_setImage(with: URL(string: "https://penguinbootcamp.netlify.com/img/pengusup1.png"))
            }
            
        }
        
        if let tags = item["tags"] as? [String] {
            
            for (index,tag) in tags.enumerated() {
             
                switch index {
                case 0:
                    cell.tag_1.isHidden = false
                    cell.tag_1_label.text = tag
                case 1:
                    cell.tag_2.isHidden = false
                    cell.tag_2_label.text = tag
                case 2:
                    cell.tag_3.isHidden = false
                    cell.tag_3_label.text = tag
                case 3:
                    cell.tag_4.isHidden = false
                    cell.tag_4_label.text = tag
                default:
                    cell.tag_1.isHidden = false
                    cell.tag_1_label.text = tag
                }
            }
        
            
        }
        
        
        return cell
    }
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}
