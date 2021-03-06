//
//  User.swift
//  twitter1
//
//  Created by Lily on 2/15/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

var _currentUser:User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLoginouttification"
class User: NSObject {
    var name: String?
    var screenname:String?
    var profileImageUrl: String?
    var tagline:String?
    var dictionary: NSDictionary
    
    var follower: Int?
    var tweetsNum:Int?
    var following:Int?
    var profileHeaderUrl: String?
    
    init(dictionary:NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
        follower = dictionary["followers_count"] as? Int
        tweetsNum = dictionary["statuses_count"] as? Int
        following = dictionary["friends_count"] as? Int
        profileHeaderUrl = dictionary["profile_banner_url"] as? String
       // profileBackgroundColor = dictionary["profile_background_color"] as? String
       
    }
    
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil )
        
    }
    class var currentUser: User?{
        get{
            if _currentUser == nil{
                let data =  NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil{
                        do {
                            let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                            _currentUser = User(dictionary: dictionary as! NSDictionary)
                        } catch{
                            print("Error in parsing JSON--current user")
                        }
               }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            if _currentUser != nil{
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
}
