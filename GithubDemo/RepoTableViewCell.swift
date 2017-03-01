//
//  RepoTableViewCell.swift
//  GithubDemo
//
//  Created by A on 2/14/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

   
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    
    
    var name: String?
    var owner: String?
    var stars: Int = 0
    var forks: Int = 0
    var repoDescription: String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        repoImageView.layer.cornerRadius = 14.0
        repoImageView.layer.borderWidth = 1.0
        repoImageView.layer.masksToBounds = false
        repoImageView.layer.borderColor = UIColor.black.cgColor
        repoImageView.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    

}
