//
//  RestCallController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreData

class RESTAPIController {
    static let shared = RESTAPIController()
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    func getIndividualRecords(completion: @escaping () -> ()) {
        let url = NSURL(string: BaseURL.main)
        let request = NSURLRequest(url: url! as URL)
        let dataTask = self.session.dataTask(with: (request as URLRequest)) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            self.parseJson(data: data as NSData, completion: {
                                completion()
                            })
                        }
                    default:
                        print("HTTPResponse code: \(httpResponse.statusCode) Class:\(#file)\n Line:\(#line)")
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func parseJson(data: NSData, completion: @escaping () -> ()) {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            let jsonDict = jsonResponse as! Dictionary<String, AnyObject>
            let arrayOfDictionaries = jsonDict["individuals"] as! [Dictionary<String, AnyObject>]
            
            let group = DispatchGroup()
            
            for dict in arrayOfDictionaries {
                group.enter()
                if let id = dict["id"] as? Int,
                    let firstName = dict["firstName"] as? String,
                    let lastName = dict["lastName"] as? String,
                    let birthdate = dict["birthdate"] as? String,
                    let imageURL = dict["profilePicture"] as? String,
                    let forceSensitive = dict["forceSensitive"] as? Bool,
                    let affiliation = dict["affiliation"] as? String {
                    let name = "\(firstName) \(lastName)"
                    getImageWithURL(imageURL: imageURL) { imageData in
                        
                        let coreDataController = CoreDataController()
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            coreDataController.saveRecordWith(context: context,
                                                            id: id,
                                                          name: name,
                                                          birthdate: birthdate,
                                                          imageData: imageData,
                                                          imageURL: imageURL,
                                                          forceSensitive: forceSensitive,
                                                          affiliation: affiliation)
                        }

                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion()
            }
        }
        catch {
            print("Class:\(#file)\n Line:\(#line)\n Error:\(error)")
        }
    }
    
    private func getImageWithURL(imageURL: String, completion: @escaping (NSData) -> ()) {
        let urlString = imageURL
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(url: url as URL)
        let dataTask = self.session.dataTask(with: request as URLRequest) { (data, response, error) in
            if (error == nil) {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            completion(data as NSData)
                        }
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
            }
            else {
                print("Error Downloading File Class:\(#file)\n Line:\(#line)\n Error:\(String(describing: error))")
            }
        }
        dataTask.resume()
    }
}
