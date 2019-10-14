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
    var individualsArray = [Individual]()
    let coreDataController = CoreDataController()
    
    @IBOutlet weak var mainImageView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitleView()
        setupGIF()
        getDataForTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotofication), name: .didFinishSavingObject, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stylizeTableViewAndNavBar()
    }
}

//  ==============================================================================
//  Private Methods
//  ==============================================================================
extension MainTableViewController {
    private func getDataForTableView() {
        if individualsArray.isEmpty {
            if coreDataController.savedRecordsExist() {
                fetchRecords()
            } else {
                getRecordsFromWebService()
            }
        }
    }
    
    private func fetchRecords() {
            individualsArray = coreDataController.fetchRecords()
            tableView.reloadData()
    }
    
    @objc private func didReceiveNotofication(_ notification: Notification) {
            let individualRecords = coreDataController.fetchRecords()
            DispatchQueue.main.async { [weak self] in
                self?.individualsArray = individualRecords
                self?.tableView.reloadData()
            }
    }
    
    private func getRecordsFromWebService() {
        let api = RESTAPIController.shared
        api.getIndividualRecords { [weak self] in
            self?.showToast(message: "Finished API calls", font: UIFont.systemFont(ofSize: 12))
        }
    }
    
    private func stylizeTableViewAndNavBar() {
        tableView.backgroundView?.backgroundColor = .black
        tableView.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setupGIF() {
        guard let path = Bundle.main.path(forResource: "giphy", ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let gifData = try Data(contentsOf: url)
            let imageData = FLAnimatedImage(animatedGIFData: gifData)
            mainImageView.animatedImage = imageData
        } catch let error as NSError {
            print("Error \(error): \(error.userInfo)")
        }
    }
    
    private func setupNavBarTitleView() {
        let myTitleView = UIImageView(image: UIImage(named: "star-wars-title"))
        myTitleView.frame.origin = CGPoint(x: 0, y: 0)
        myTitleView.frame.size = CGSize(width: 80, height: 45)
        self.navigationItem.titleView = myTitleView
    }
}

//  ==============================================================================
//  Datasource Methods
//  ==============================================================================
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individualsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            return cell
        }
        let individual = individualsArray[indexPath.row]
        cell.configureCellWith(individual)
        return cell
    }
}

//  ==============================================================================
//  Delegate Methods
//  ==============================================================================
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: mainStoryboard, bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "ProfileDetailTableviewController") as? ProfileDetailTableViewController else { return }
        let individual = individualsArray[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell, let affiliation = individual.affiliation {
            cell.setColorForAffiliation(affiliation: affiliation)
        }
        destinationVC.individual = individual
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
