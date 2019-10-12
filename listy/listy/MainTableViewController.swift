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
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var mainImageView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContext()
        setupNavBarTitleView()
        setupGIF()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotofication), name: .didFinishSavingObject, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stylizeTableViewAndNavBar()
        
        if individuals.isEmpty {
            if savedRecordsExist() {
                if let context = context {
                    individuals = coreDataController.fetchRecordsWith(context)
                    tableView.reloadData()
                }
            } else {
                getRecordsFromWebService()
            }
        }
    }
}

//  ==============================================================================
//  Private Methods
//  ==============================================================================
extension MainTableViewController {
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
        if let context = context {
            let individualRecords = coreDataController.fetchRecordsWith(context)
            DispatchQueue.main.async { [weak self] in
                self?.individuals = individualRecords
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    private func savedRecordsExist() -> Bool {
        guard let context = context else { return false }
        if coreDataController.getCountWith(context) > 0 {
            return true
        } else {
            return false
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
    
    private func setCellColorForAffiliation(_ individual: Individual, _ indexPath: IndexPath) {
        if let _affiliation = individual.affiliation {
            let affiliationColor = getBackgroundColorFor(affiliation: _affiliation)
            let backgroundView = UIView()
            backgroundView.backgroundColor = affiliationColor
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectedBackgroundView = backgroundView
        }
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
//  Delegate Methods
//  ==============================================================================
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: mainStoryboard, bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(identifier: "ProfileDetailTableviewController") as? ProfileDetailTableViewController else { return }
        let individual = individuals[indexPath.row]
        destinationVC.individual = individual
        
        setCellColorForAffiliation(individual, indexPath)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
