//
//  Tweet.swift
//  twitter1
//
//  Created by Lily on 2/15/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweets: Int?
    var favorites: Int?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var id: Int?
    var originalId: Int?

    init(dictionary: NSDictionary){
        user = User (dictionary:dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
       
        let  formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        retweets = dictionary["retweet_count"] as? Int
        favorites = dictionary["favorite_count"] as? Int
        
        isRetweeted = dictionary["retweeted"] as? Bool
        isFavorited = dictionary["favorited"] as? Bool
        id = dictionary["id"] as? Int
        

    }
    
    class func tweetsWithArray(array:[NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in array{
            tweets.append(Tweet(dictionary:dictionary))
        } 
        return tweets
    }
}
