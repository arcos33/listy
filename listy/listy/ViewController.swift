//
//  ViewController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myTitleView = UIImageView(image: UIImage(named: "star-wars-title"))
         myTitleView.frame.origin = CGPoint(x: 0, y: 0)
         myTitleView.frame.size = CGSize(width: 80, height: 45)
         self.navigationItem.titleView = myTitleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .black
    }


}

