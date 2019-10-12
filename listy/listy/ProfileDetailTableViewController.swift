//
//  ProfileDetailViewController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ProfileDetailTableViewController: UITableViewController {
    @IBOutlet weak var forceSensitiveCell: UITableViewCell!
    @IBOutlet weak var birthdateCell: UITableViewCell!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var birthdateContentView: UIView!
    @IBOutlet weak var forceSensitiveContentView: UIView!

    var individual: Individual?
    var affiliation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOutlets()
    }
}

//  ==============================================================================
//  Private Methods
//  ==============================================================================
extension ProfileDetailTableViewController {
    private func populateOutlets() {
        populateLabels()
        populateImageViews()
        setColorThemeFor(affiliation: affiliation ?? "rogue")
    }
    
    private func populateImageViews() {
        forceSensitiveCell.imageView?.image = UIImage(imageLiteralResourceName: "force-Jedi-symbol")
        birthdateCell.imageView?.image = UIImage(imageLiteralResourceName: "cake")
        if let imageData = individual?.profilePicture {
            let image = UIImage(data: imageData)
            profilePictureImageView.image = image
        }
    }
    
    private func populateLabels() {
        nameLabel.text = individual?.name
        birthdateCell.textLabel?.text = "Birthdate"
        birthdateCell.textLabel?.text = individual?.birthdate
        forceSensitiveCell.textLabel?.text = "Force Sensitive"
        if let dob = individual?.birthdate {
            birthdateCell.detailTextLabel?.text = dob
        }
        if let _forceSensitive = individual?.forceSensitive {
            forceSensitiveCell.detailTextLabel?.text = _forceSensitive == true ? "Yes" : "No"
        }
        if let _affiliation = individual?.affiliation {
            affiliation = _affiliation
            affiliationLabel.text = _affiliation
        }
    }
    
    private func setColorThemeFor(affiliation: String) {
        if affiliation == "FIRST_ORDER" {
            stylizeUI(color: .white)
        } else if affiliation == "SITH" {
            stylizeUI(color: .red)
        } else if affiliation == "JEDI" {
            stylizeUI(color: .blue)
        } else {
            stylizeUI(color: .orange)
        }
    }
    
    private func stylizeUI(color: UIColor) {
        tableView.backgroundView?.backgroundColor = color
        tableView.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
        birthdateContentView.backgroundColor = color
        forceSensitiveContentView.backgroundColor = color
        if color == .white {
            stylizeNavBarAndTextForBestContrastWith(.black)
        } else {
            stylizeNavBarAndTextForBestContrastWith(.white)
        }
    }
    
    private func stylizeNavBarAndTextForBestContrastWith(_ color: UIColor) {
        forceSensitiveCell.textLabel?.textColor = color
        forceSensitiveCell.detailTextLabel?.textColor = color
        birthdateCell.textLabel?.textColor = color
        birthdateCell.detailTextLabel?.textColor = color
        navigationController?.navigationBar.tintColor = color
    }
}
