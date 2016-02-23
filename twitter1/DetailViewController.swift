//
//  DetailViewController.swift
//  twitter1
//
//  Created by Lily on 2/22/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
  
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var screenname: UILabel!
    
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var retweets: UILabel!
    
    @IBOutlet weak var favorites: UILabel!
    
    @IBOutlet weak var favoriteIcon: UIButton!
    
    @IBOutlet weak var retweetIcon: UIButton!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    let tapProfileImage = UITapGestureRecognizer()
    
    var tweet: Tweet?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print(tweet!.text)
        self.username.text = tweet!.user!.name!
        self.screenname.text =  "@\((User.currentUser?.screenname)!)"
        
        let calendar = NSCalendar.currentCalendar()
        let timestamp = calendar.components([.Month, .Day, .Year, .Hour, .Minute], fromDate: tweet!.createdAt!)
        self.timestamp.text = "\(timestamp.month)/\(timestamp.day)/\(timestamp.year) "
        self.tweetContent.text = tweet!.text
        self.retweets.text = String(tweet!.retweets!)
        self.favorites.text = String(tweet!.favorites!)
        let imageURL =  NSURL(string:(tweet!.user!.profileImageUrl)!)
        self.profileImage.setImageWithURL(imageURL!)
    
        //segue to profile detail view
        tapProfileImage.addTarget(self, action: "toProfileViewSegue")
        profileImage.addGestureRecognizer(tapProfileImage)
        profileImage.userInteractionEnabled = true
        
        if ((tweet?.isRetweeted) != nil && tweet!.isRetweeted!){
            let activeImage = UIImage(named:"retweet-action")
            self.retweetIcon.setImage(activeImage, forState: UIControlState.Normal)
        }
        
        if ((tweet?.isFavorited) != nil && tweet!.isFavorited!){
            let activeImage = UIImage(named:"like-action-on")
            self.favoriteIcon.setImage(activeImage, forState: UIControlState.Normal)
            
        }
    }
    
    @IBAction func retweet(sender: AnyObject) {
        Retweet()
    }
    
    @IBAction func fav(sender: AnyObject) {
        Favorite()
    }
    
   
    
    func toProfileViewSegue(){
        performSegueWithIdentifier("toProfileView", sender: tweet!.user)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toProfileView" {
            let user = sender as! User
            let profileDetailViewController = segue.destinationViewController as! ProfileViewController
            profileDetailViewController.user = user
        }else if segue.identifier == "toReplyView" {
            //let tweet = sender as! Tweet
            let DestReplyVC = segue.destinationViewController as! ReplyViewController
            DestReplyVC.replyTo = tweet
        }
    }
    
    func Retweet() {
        if (tweet!.isRetweeted != nil && !tweet!.isRetweeted! && tweet!.user!.name != User.currentUser!.name) {
            TwitterClient.sharedInstance.retweetWithId(tweet!.id!, completion: { (tweet, error) -> () in
                let TWEET = self.tweet
                TWEET!.retweets!++
                TWEET!.isRetweeted = true
                self.tweet = TWEET
                self.retweets.hidden = false
                self.retweets.text = String(self.tweet!.retweets!)
                let activeImage = UIImage(named:"retweet-action")
                self.retweetIcon.setImage(activeImage, forState: UIControlState.Normal)
                
                if(self.tweet!.retweets==1){
                    self.retweetLabel.text = "Retweet"
                }
               
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
                self.favorites.hidden = false
                self.favorites.text = String(self.tweet!.favorites!)
                let activeImage = UIImage(named:"like-action-on")
                self.favoriteIcon.setImage(activeImage, forState: UIControlState.Normal)
                
                if(self.tweet!.favorites == 1){
                    self.favoriteLabel.text = "Favorite"
                }
                
            })
            
        }

    }

}
