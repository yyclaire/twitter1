//
//  TwitterClient.swift
//  twitter1
//
//  Created by Lily on 2/15/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "kBejxCcKcshyTi74iPQmPfbJW"
let twitterConsumerSecret = "uGOPC37oF5BrHxdAa6BPzE9h0HZAfh30rY5i7TetW0OtSdv4Iq"
let twitterBaseURL = NSURL(string:"https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion:((user: User?, error: NSError?)->())?
    class var sharedInstance: TwitterClient {
        struct Static{
            
            static let instance =  TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func tweetWithParams(params: NSDictionary!, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successful tweet")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("failed tweet")
                completion(tweet: nil, error: error)
        })
    }

    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion:(user: User?, error: NSError?)->()){
        loginCompletion = completion
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error:NSError!) -> Void in
                print("fail to get request token")
                self.loginCompletion?(user:nil,error: error)
        }
        
    }
    
    func openURL(url:NSURL){
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:NSURLSessionDataTask!, response:AnyObject?) -> Void in
                //print("user\(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user:\(user.name)")
                self.loginCompletion?(user: user, error:nil)
                }, failure: { (operation:NSURLSessionDataTask?,error:NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user:nil,error: error)
            })
            }) { (error:NSError!) -> Void in
                print("Fail to receive access token")
                self.loginCompletion?(user:nil,error: error)
        }
        
        

    }
    
    func retweetWithId(id: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(String(id)).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweet successfully")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Retweet failure")
                completion(tweet: nil, error: error)
        })
    }
    
        func favoriteWithId(id: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
            
        POST("1.1/favorites/create.json?id=\(String(id))", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Favorite!!!!")
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Fav failure")
                completion(tweet: nil, error: error)
                
        })
    }
    
   

}
