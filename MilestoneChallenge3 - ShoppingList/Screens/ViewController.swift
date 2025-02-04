//
//  ViewController.swift
//  MilestoneChallenge3 - ShoppingList
//
//  Created by Noah Pope on 2/4/25.
//

import UIKit

class ViewController: UIViewController
{
    enum Keys
    {
        static let savedList    = "savedList"
        static let loadFromSave = "loadFromSave"
    }
    
    var currentList = [String]()
    var loadList    = false {
        didSet { encodeLoadStatus() }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavigation()
        decodeLoadStatus()
        if loadList { loadCurrentList() }
    }


    // MARK: CONFIGURATION
    func configureNavigation()
    {
        
    }
    
    
    func configureArray()
    {
        
    }
    
    
    // MARK: SAVE & LOAD
    func encodeLoadStatus()
    {
        let jsonEncoder             = JSONEncoder()
        if let encodedLoadStatus    = try? jsonEncoder.encode(loadList)
        {
            let defaults            = UserDefaults.standard
            defaults.set(encodedLoadStatus, forKey: Keys.loadFromSave)
        }
        else { print("unable to encode load status") }
    }
    
    
    func decodeLoadStatus()
    {
        let defaults                = UserDefaults.standard
        
        if let encodedLoadStatus    = defaults.object(forKey: Keys.loadFromSave) as? Data
        {
            let jsonDecoder         = JSONDecoder()
            do { loadList           = try jsonDecoder.decode(Bool.self, from: encodedLoadStatus) }
            catch { print("failed to load list") }
        }
    }
    
    
    func loadCurrentList()
    {
        
    }
}

