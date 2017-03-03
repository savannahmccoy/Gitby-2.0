//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(sender: SearchSettingsViewController,settings: GithubRepoSearchSettings)
    func didCancelSettings()
}


// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsPresentingViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    //weak var delegate: SettingsPresentingViewControllerDelegate?
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings(searchString: nil, minStars: 0)
    var repos: [GithubRepo]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize tableview
        tableView.dataSource = self //repos as! UITableViewDataSource?
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        tableView.reloadData()

    }
    
    
    // Perform the search.
    fileprivate func doSearch() {
        //var repos = [GithubRepo]()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            
            self.repos = newRepos
            
            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }   
        
            
         self.tableView.reloadData()
        
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error!)
        })
        
       
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repo = repos {
            return repo.count
        }
        else    {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as!
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoTableViewCell
        
        let repo = repos[indexPath.row]
        cell.repoImageView.setImageWith(URL(string: repo.ownerAvatarURL!)!)
        cell.forksLabel.text = String(format: "%d", repo.forks!)
        cell.descriptionLabel.text = repo.repoDescription
        cell.ownerLabel.text = repo.ownerHandle
        cell.nameLabel.text = repo.name
        cell.starsLabel.text = String(format: "%d", repo.stars!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! SearchSettingsViewController
        vc.settings =  searchSettings // ... Search Settings ...
        vc.delegate = self
    }
    
    func didSaveSettings(sender: SearchSettingsViewController, settings: GithubRepoSearchSettings) {
        
        self.searchSettings = settings
        doSearch()
        
        self.dismiss(animated: true, completion: nil)
        print("called save")
    }
    
    func didCancelSettings() {
        self.dismiss(animated: true, completion: nil)
        print("called cancel")
    }

}






// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}
