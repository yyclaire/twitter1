//
//  TweetsViewController.swift
//  twitter1
//
//  Created by Lily on 2/18/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var headshot: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
       // tableView.estimatedRowHeight = 130
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        let imageURL = NSURL(string: User.currentUser!.profileImageUrl!)
        
        headshot.setImageWithURL(imageURL!)
    }
  
    @IBAction func logout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        cell.username.text = tweet.user!.name!
        cell.screenname.text = "@\((User.currentUser?.screenname)!)"
        cell.tweetContent.numberOfLines = 0
        cell.tweetContent.text = tweet.text
        cell.tweetContent.sizeToFit()

        let calendar = NSCalendar.currentCalendar()
        let timestamp = calendar.components([.Month, .Day, .Year, .Hour, .Minute], fromDate: tweet.createdAt!)
        cell.timestamp.text = "\(timestamp.month)/\(timestamp.day)/\(timestamp.year) "
        let imageUrl = NSURL(string:(tweet.user!.profileImageUrl)!)
        cell.profileImage.setImageWithURL(imageUrl!)
       
        print ("\(indexPath.row): \(tweet.id)")
        if (tweet.favorites > 0){
            cell.favorite.text = String(tweet.favorites!)
        }else{
            cell.favorite.hidden = true
        }
        
        if (tweet.retweets > 0 ){
            cell.retweet.text = String(tweet.retweets!)
        }else{
            cell.retweet.hidden = true
        }
        return cell
    }
    
   

    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            print("reloading data")
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
    }

}
