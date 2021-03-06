//
//  PdfDetailViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/19.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

class PdfDetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var path: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(PdfDetailViewController.shareTapped))

        if path != nil {
            let url = NSURL.fileURLWithPath(path!)
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareTapped() {
        if path != nil {
            let url = NSURL.fileURLWithPath(path!)
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            presentViewController(vc, animated: true, completion: nil)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
