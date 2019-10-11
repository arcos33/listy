//
//  ProfileDetailViewController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

enum Affiliation: String {
    case firstOrder = "First Order"
    case sith = "Sith"
    case jedi = "Jedi"
    case resistance = "Resistance"
}

class ProfileDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var forceSensitiveCell: UITableViewCell!
    @IBOutlet weak var birthdateCell: UITableViewCell!
    @IBOutlet weak var affiliation: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var birthdateContentView: UIView!
    @IBOutlet weak var forceSensitiveContentView: UIView!
    
    
    var individual: Individual?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _affiliation = individual?.affiliation {
            setBackgroundColorFor(affiliation: _affiliation)
            affiliation.text = _affiliation
        }
        birthdateCell.textLabel?.text = individual?.birthdate
        forceSensitiveCell.textLabel?.text = "Force Sensitive"
        forceSensitiveCell.imageView?.image = UIImage(imageLiteralResourceName: "force-Jedi-symbol")
        birthdateCell.imageView?.image = UIImage(imageLiteralResourceName: "cake")
        if let _forceSensitive = individual?.forceSensitive {
            forceSensitiveCell.detailTextLabel?.text = _forceSensitive == true ? "Yes" : "No"
        }
        birthdateCell.textLabel?.text = "Birthdate"
        if let dob = individual?.birthdate {
            birthdateCell.detailTextLabel?.text = dob
        }
        
        if let imageData = individual?.profilePicture {
            let image = UIImage(data: imageData)
            profilePictureImageView.image = image
        }
        name.text = individual?.name
        
        // Do any additional setup after loading the view.
    }
    
    func setBackgroundColorFor(affiliation: String) {
        if affiliation == "FIRST_ORDER" {
            setBackgroundColor(color: .white)
        } else if affiliation == "SITH" {
            setBackgroundColor(color: .red)
        } else if affiliation == "JEDI" {
            setBackgroundColor(color: .blue)
        } else {
            setBackgroundColor(color: .orange)
        }
    }
    
    private func setBackgroundColor(color: UIColor) {
        tableView.backgroundView?.backgroundColor = color
        tableView.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
        birthdateContentView.backgroundColor = color
        forceSensitiveContentView.backgroundColor = color
        if color == .white {
            forceSensitiveCell.textLabel?.textColor = .black
            forceSensitiveCell.detailTextLabel?.textColor = .black
            birthdateCell.textLabel?.textColor = .black
            birthdateCell.detailTextLabel?.textColor = .black
            navigationController?.navigationBar.tintColor = .black
        } else {
            forceSensitiveCell.textLabel?.textColor = .white
            forceSensitiveCell.detailTextLabel?.textColor = .white
            birthdateCell.textLabel?.textColor = .white
            birthdateCell.detailTextLabel?.textColor = .white
            navigationController?.navigationBar.tintColor = .white
        }
    }
}
