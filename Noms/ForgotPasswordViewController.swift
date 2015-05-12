//
//  ForgotPasswordViewController.swift
//  Noms
//
//  Created by Evelyn Ding on 5/7/15.
//  Copyright (c) 2015 COS333. All rights reserved.
//


import UIKit
import Parse
import Foundation
import MessageUI

class ForgotPasswordViewController: UIViewController, MFMailComposeViewControllerDelegate {
        
    @IBOutlet weak var emailAddr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
        
    }
    @IBAction func sendPass(sender: UIButton) {
        // preferably gives some response that it has sent its password
        // need to send email the password of their account
        let email = emailAddr.text;
        PFCloud.callFunctionInBackground("sendMail", withParameters:["email":email]) {
            (result: AnyObject?, error: NSError?) -> Void in
            if error == nil {
                println(result);
            }
        }
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}

