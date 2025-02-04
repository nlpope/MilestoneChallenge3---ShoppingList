//
//  ListTVC.swift
//  MilestoneChallenge3 - ShoppingList
//
//  Created by Noah Pope on 2/4/25.
//

import UIKit

class ListTVC: UITableViewController
{
    var currentList         = [String]()
    var shouldILoadList     = false { didSet { encodeLoadStatus() } }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavigation()
        decodeLoadStatus()
        if shouldILoadList { loadCurrentList() }
    }

    
    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX//
    // MARK: CONFIGURATION
    func configureNavigation()
    {
        print("configuring navigation")
        navigationItem.rightBarButtonItem   = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        navigationItem.leftBarButtonItem    = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearList))
    }
    
    
    func submit(_ item: String)
    {
        currentList.insert(item, at: 0)
        shouldILoadList = true
    }
    
    
    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX//
    // MARK: OBJC SELECTOR CALLS
    @objc func promptForItem()
    {
        let ac              = UIAlertController(title: "Enter Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction    = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let self      = self else { return }
            guard let item      = ac?.textFields?[0].text else { return }
            guard !item.isEmpty else { print("nothing here"); return }
            self.submit(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    @objc func clearList()
    {
        shouldILoadList = false
        currentList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX//
    // MARK: SAVE & LOAD
    func encodeLoadStatus()
    {
        let jsonEncoder             = JSONEncoder()
        if let encodedLoadStatus    = try? jsonEncoder.encode(shouldILoadList)
        {
            let defaults            = UserDefaults.standard
            defaults.set(encodedLoadStatus, forKey: PersistenceManager.loadFromSaveStatus)
        }
        else { print("unable to encode load status") }
    }
    
    
    func decodeLoadStatus()
    {
        let defaults                = UserDefaults.standard
        
        if let encodedLoadStatus    = defaults.object(forKey: PersistenceManager.loadFromSaveStatus) as? Data
        {
            let jsonDecoder         = JSONDecoder()
            do { shouldILoadList    = try jsonDecoder.decode(Bool.self, from: encodedLoadStatus) }
            catch { print("failed to load list") }
        }
    }
    
    
    func saveCurrentList()
    {
        let jsonEncoder             = JSONEncoder()
        if let encodedList          = try? jsonEncoder.encode(currentList)
        {
            let defaults            = UserDefaults.standard
            defaults.set(encodedList, forKey: PersistenceManager.savedList)
        }
        else { print("unable to encode list") }
    }
    
    
    func loadCurrentList()
    {
        let defaults                = UserDefaults.standard
        
        if let encodedList          = defaults.object(forKey: PersistenceManager.savedList) as? Data
        {
            let jsonDecoder         = JSONDecoder()
            do { currentList        = try jsonDecoder.decode([String].self, from: encodedList) }
            catch { print("failed to decode list") }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text    = currentList[indexPath.row]
        return cell
    }
}

