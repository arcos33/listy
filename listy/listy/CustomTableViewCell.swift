//
//  CustomTableViewCell.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    func configureCellWith(_ individual: Individual) {
        textLabel?.text = individual.name
        textLabel?.textColor = .white
        imageView?.contentMode = .scaleAspectFill
        if let imageData = individual.profilePicture {
            let image = UIImage(data: imageData)
            imageView?.image = image
        }
        imageView?.layer.cornerRadius = frame.height / 2
        imageView?.clipsToBounds = true
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _imageView = imageView {
            _imageView.frame = CGRect(x: 10, y: 0, width: 80, height: 80)
        }
        textLabel?.textAlignment = .center
    }
    
    func setColorForAffiliation(affiliation: String) {
        let affiliationColor = getBackgroundColorFor(affiliation: affiliation)
        let backgroundView = UIView()
        backgroundView.backgroundColor = affiliationColor
        selectedBackgroundView = backgroundView
    }
    
    private func getBackgroundColorFor(affiliation: String) -> UIColor {
        if affiliation == Affiliation.firstOrder.rawValue {
            return .white
        } else if affiliation == Affiliation.sith.rawValue {
            return .red
        } else if affiliation == Affiliation.jedi.rawValue {
            return .blue
        } else {
            return .orange
        }
    }
}
