//
//  RestCallController.swift
//  listy
//
//  Created by user on 10/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

struct Individual {
    var id: Int?
    var name: String?
    var birthdate: String?
    var profilePicture: UIImage?
    var imageURL: String?
    var forceSensitive: Bool?
    var affiliation: Affiliation?
}

class RESTAPIController {
    static let shared = RESTAPIController()
    let webServiceURL = "https://edge.ldscdn.org/mobile/interview/directory"
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    func getIndividualRecords(completion: @escaping ([Individual]) -> ()) {
        let urlString = webServiceURL
        let url = NSURL(string: urlString)
        let request = NSURLRequest(url: url! as URL)
        let dataTask = self.session.dataTask(with: (request as URLRequest)) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            self.parseJson(data: data as NSData, completion: { individuals in
                                completion(individuals)
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
    
    func parseJson(data: NSData, completion: @escaping ([Individual]) -> () ) {
        var indidivuals = [Individual]()
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            let jsonDict = jsonResponse as! Dictionary<String, AnyObject>
            let arrayOfDictionaries = jsonDict["individuals"] as! [Dictionary<String, AnyObject>]
            
            let group = DispatchGroup()
            
            for dict in arrayOfDictionaries {
                group.enter()
                // TODO get rid of ! operator
                let id = dict["id"] as! Int
                let firstName = dict["firstName"] as! String
                let lastName = dict["lastName"] as! String
                let nameString = "\(firstName) \(lastName)"
                let birthdate = dict["birthdate"] as! String
                let imageURL = dict["profilePicture"] as! String
                let forceSensitive = dict["forceSensitive"] as! Bool
                let affiliation = dict["affiliation"] as! String
                                
                getImage(imageURL: imageURL) { [unowned self] imageData in
                    if let image = UIImage(data: imageData as Data) {
                        var individual = Individual()
                        individual.id = id
                        individual.name = nameString
                        individual.birthdate = birthdate
                        individual.forceSensitive = forceSensitive
                        individual.affiliation = self.getAffiliationFromString(str: affiliation)
                        individual.imageURL = imageURL
                        individual.profilePicture = image
                        indidivuals.append(individual)
                        group.leave()
                    }

                }
            }
            group.notify(queue: .main) {
                completion(indidivuals)
            }
        }
        catch {
            print("Class:\(#file)\n Line:\(#line)\n Error:\(error)")
        }
    }
    
    private func getAffiliationFromString(str: String) -> Affiliation{
        if str == "FIRST_ORDER" {
            return Affiliation.firstOrder
        } else if str == "SITH" {
            return Affiliation.sith
        } else if str == "RESISTANCE" {
            return Affiliation.resistance
        } else {
            return Affiliation.jedi
        }
    }
    
    func getImage(imageURL: String, completion: @escaping (NSData) -> ()) {
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
