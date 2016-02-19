//
//  TweetCell.swift
//  twitter1
//
//  Created by Lily on 2/18/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var screenname: UILabel!
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var favorite: UILabel!
    
    @IBOutlet weak var retweet: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var retweetIcon: UIButton!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    var tweet:Tweet?
    
    
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = 6.0
        profileImage.clipsToBounds = true
       
    }
    
    
    @IBAction func Fav(sender: AnyObject) {
        Favorite()
        
    }
    
    
    @IBAction func onReweet(sender: AnyObject) {
        Retweet()
    }
   
    
    func Retweet() {
         if (tweet!.isRetweeted != nil && !tweet!.isRetweeted! && tweet!.user!.name != User.currentUser!.name) {
            TwitterClient.sharedInstance.retweetWithId(tweet!.id!, completion: { (tweet, error) -> () in
                let TWEET = self.tweet
                TWEET!.retweets!++
                TWEET!.isRetweeted = true
                TWEET!.originalId = tweet?.originalId
                self.tweet = TWEET
                self.retweet.hidden = false
                self.retweet.text = String(self.tweet!.retweets!)
                let activeImage = UIImage(named:"retweet-action")
                 self.retweetIcon.setImage(activeImage, forState: UIControlState.Normal)
            })
        }
        
        
    }
    
    func Favorite() {
        if (tweet!.isFavorited != nil && !tweet!.isFavorited! && tweet!.user!.name != User.currentUser!.name) {
            TwitterClient.sharedInstance.favoriteWithId(tweet!.id!, completion: { (tweet, error) -> () in
                let TWEET = self.tweet
                TWEET!.favorites!++
                TWEET!.isFavorited = true
                self.tweet = TWEET
                self.favorite.hidden = false
                self.favorite.text = String(self.tweet!.favorites!)
                let activeImage = UIImage(named:"like-action-on")
                self.favoriteIcon.setImage(activeImage, forState: UIControlState.Normal)
            })
        
    }
    }
    
}


