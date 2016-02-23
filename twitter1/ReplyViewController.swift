//
//  ReplyViewController.swift
//  twitter1
//
//  Created by Lily on 2/22/16.
//  Copyright © 2016 yyclaire. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var replyToText: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var replyTo: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        if replyTo != nil {
            replyToText.text = "@\(replyTo!.user!.screenname!): "
           
        }
        
        let currentUser = User.currentUser!
        profileImage.setImageWithURL(NSURL(string: currentUser.profileImageUrl!)!)
      

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        textView.resignFirstResponder()
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = self.view.frame.minY
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        replyToText.hidden = true
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    



}
