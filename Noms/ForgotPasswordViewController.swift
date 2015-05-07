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
    
    @IBAction func sendPass(sender: UIButton) {
        // preferably gives some response that it has sent its password
        // need to send email the password of their account
        let email = emailAddr.text;
        if (email != nil) {
            let emailTitle = "Your Noms account password"
            let messageBody = "Your password is: "
            var toRecipients = [String]()
            toRecipients.append(email);
            var mc: MFMailComposeViewController = MFMailComposeViewController();
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false);
            mc.setToRecipients(toRecipients);
            //self.presentViewController(mc, animated: false, completion: nil);
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

