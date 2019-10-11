//
//  TableViewController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import FLAnimatedImage
import CoreData

class MainTableViewController: UITableViewController {
    let cellIdentifier = "cellIdentifier"
    let mainStoryboard = "Main"
    var individuals = [Individual]()
    let coreDataController = CoreDataController()

    @IBOutlet weak var mainImageView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitleView()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotofication), name: .didFinishSavingObject, object: nil)
        
        if let path1 = Bundle.main.path(forResource: "giphy", ofType: "gif") {
            let url = URL(fileURLWithPath: path1)
            do {
                let gifData = try Data(contentsOf: url)
                let imageData1 = try? FLAnimatedImage(animatedGIFData: gifData)
                mainImageView.animatedImage = imageData1
            } catch {
                print(error)
            }
            
        }
        tableView.backgroundView?.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    private func setupNavBarTitleView() {
        let myTitleView = UIImageView(image: UIImage(named: "star-wars-title"))
         myTitleView.frame.origin = CGPoint(x: 0, y: 0)
         myTitleView.frame.size = CGSize(width: 80, height: 45)
         self.navigationItem.titleView = myTitleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .black

        if individuals.isEmpty {
            let individualRecords = coreDataController.fetchRecords()
            if individualRecords.count > 0 {
                individuals = individualRecords
                tableView.reloadData()
            } else {
                let api = RESTAPIController.shared
                api.getIndividualRecords { [weak self] in
                    self?.showToast(message: "Finished fetching all records", font: UIFont.systemFont(ofSize: 12))
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individuals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
        let individual = individuals[indexPath.row]
        cell.configureCellWith(individual)
        return cell
        }
    }


//  ==============================================================================
//  Internal Methods
//  ==============================================================================
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: mainStoryboard, bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "ProfileDetailTableviewController") as? ProfileDetailTableViewController else { return }
        let individual = individuals[indexPath.row]
        destinationVC.individual = individual
        
        let backgroundView = UIView()
        if let _affiliation = individual.affiliation {
            let affiliationColor = getBackgroundColorFor(affiliation: _affiliation)
            backgroundView.backgroundColor = affiliationColor
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectedBackgroundView = backgroundView
        }
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func getBackgroundColorFor(affiliation: String) -> UIColor {
        if affiliation == "FIRST_ORDER" {
            return .white
        } else if affiliation == "SITH" {
            return .red
        } else if affiliation == "JEDI" {
            return .blue
        } else {
            return .orange
        }
    }
    
    @objc private func didReceiveNotofication(_ notification: Notification) {
        let individualRecords = coreDataController.fetchRecords()
        DispatchQueue.main.async { [weak self] in
            self?.individuals = individualRecords
            self?.tableView.reloadData()
        }
    }
}
