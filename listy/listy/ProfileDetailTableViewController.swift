//
//  ProfileDetailViewController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

enum Affiliation: String {
    case firstOrder = "FIRST_ORDER"
    case sith = "SITH"
    case jedi = "JEDI"
    case rebels = "REBELS"
}

class ProfileDetailTableViewController: UITableViewController {
    @IBOutlet weak var forceSensitiveCell: UITableViewCell!
    @IBOutlet weak var birthdateCell: UITableViewCell!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var birthdateContentView: UIView!
    @IBOutlet weak var forceSensitiveContentView: UIView!

    var individual: Individual?
    var affiliation: Affiliation? {
        didSet {
            switch affiliation {
            case .firstOrder:
                stylizeUI(color: .white)
            case .sith:
                stylizeUI(color: .red)
            case .jedi:
                stylizeUI(color: .blue)
            case .rebels:
                stylizeUI(color: .orange)
            case .none:
                print("rogue")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        affiliation = convertAffiliation(individual?.affiliation ?? "rogue")
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
    }
    
    private func convertAffiliation(_ str: String) -> Affiliation {
        if str == Affiliation.firstOrder.rawValue {
            return Affiliation.firstOrder
        } else if str == Affiliation.sith.rawValue {
            return Affiliation.sith
        } else if str == Affiliation.jedi.rawValue {
            return Affiliation.jedi
        } else {
            return Affiliation.rebels
        }
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
            affiliationLabel.text = _affiliation
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
