//
//  ViewController.swift
//  NoteCopy
//
//  Created by Gabriel Gheorghian on 2014-09-20.
//  Copyright (c) 2014 genunine. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIView {
    func center(otherView: UIView) {
        self.center = otherView.center
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var cameraUI = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func action(name:String){
        var tv = self.textView
        
        // Spinner
        tv.text = ""
        var spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        spinner.center(tv)
        tv.addSubview(spinner)
        spinner.startAnimating()
        
        
        Agent.post("http://localhost:3000/")
            .attachImage(name)
            .end({ (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void in
                if(error == nil) {
                    dispatch_sync(dispatch_get_main_queue(), {
                        var text = data as String
                        tv.text = text
                        spinner.stopAnimating()
                    })
                    println(data)
                }
            })
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        action("test")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func convert(sender: AnyObject) {
        var picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }
}

