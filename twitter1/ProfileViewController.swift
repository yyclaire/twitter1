
//
//  ProfileViewController.swift
//  twitter1
//
//  Created by Lily on 2/22/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var headerImage: UIImageView!
    
   
    @IBOutlet weak var totalTweets: UILabel!
    
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var tweets: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var follower: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenname: UILabel!
    
    var user: User?
    
   
    override func viewDidLoad(){
        super.viewDidLoad()
        if user!.profileHeaderUrl != nil {
            headerImage.setImageWithURL(NSURL(string: user!.profileHeaderUrl!)!)
        } else {
                //set default background
            headerImage.image = UIImage(named:"mobile")
        }
        self.profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        self.username.text = user!.name!
        self.name.text = user!.name!
        self.screenname.text = "@\(user!.screenname!)"
        self.followers.text = String(user!.follower!)
        self.totalTweets.text = String(user!.tweetsNum!)
        self.following.text = String(user!.following!)
        self.tagline.text = user!.tagline!
        
            
        
    
    
    }
    
}
