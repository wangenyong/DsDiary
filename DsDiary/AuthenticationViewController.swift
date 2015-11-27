//
//  AuthenticationViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/23.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var figureprintButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        figureprintButton.tintColor = UIColor.primaryColor()
        // Do any additional setup after loading the view.
        authenticateUser(figureprintButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     对用户进行指纹验证
     
     - parameter sender: 指纹按钮
     */
    @IBAction func authenticateUser(sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        // 判断是否支持指纹验证
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = NSLocalizedString("Identify", comment: "Identify")
            
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success: Bool, authenticationError: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        // 如果指纹验证成功，显示日记列表
                        self.dismissViewControllerAnimated(true, completion: nil)
                        print("authenticateUser success")
                    } else {
                        if let error = authenticationError {
                            // 当用户选择密码验证时的提示信息
                            if error.code == LAError.UserFallback.rawValue {
                                let ac = UIAlertController(title: NSLocalizedString("Password try", comment: "Password try"), message: NSLocalizedString("Password try info", comment: "Password try info"), preferredStyle: .Alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                self.presentViewController(ac, animated: true, completion: nil)
                                return
                            }
                        }
                        // 指纹验证失败提示信息
                        let ac = UIAlertController(title: NSLocalizedString("Authentication failed", comment: "Authentication failed"), message: NSLocalizedString("Authentication failed info", comment: "Authentication failed info"), preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
                
            }
            
        } else {
            // 设备不支持指纹验证的提示信息
            let ac = UIAlertController(title: NSLocalizedString("No Touch ID", comment: "No Touch ID"), message: NSLocalizedString("No touch ID info", comment: "No touch ID info"), preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }        
    }

}
