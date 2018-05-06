//
//  GeneralInfoViewController.swift
//  SeattleParksGame
//
//  Created by Julia Meier on 1/24/18.
//  Copyright © 2018 Julia Meier. All rights reserved.
//

import UIKit
import Foundation

class GeneralInfoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var link: UITextView!
    
    @IBOutlet weak var feedbackPlease: UILabel!
    private var blogspotLink: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: "https://emeraldcityrangers.blogspot.com/")!,
//            .foregroundColor: UIColor.blue,
            //.font: UIFont.init(name: "AvenirNext-Regular", size: 16.0)!
            .underlineStyle: NSNumber(value: true)
        ]
        let inputString = "Emerald City Ranger's Blog"
        let attributedString = NSMutableAttributedString(string: inputString)
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, inputString.count))
        
        link.delegate = self
        //link.dataDetectorTypes = .link
        link.attributedText = attributedString
        link.isUserInteractionEnabled = true
        link.textAlignment = .center
        link.tintColor = UIColor.blue
        link.font = UIFont(name: (link.font?.fontName)!, size: 16)
        //link.font = UIFont(name: "Avenir Next Regular", size: 16)
        link.isEditable = false
        link.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            link.topAnchor.constraint(equalTo: feedbackPlease.bottomAnchor, constant: 0.0),
//            link.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
//        ])
        
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension GeneralInfoViewController: UITextViewDelegate {
//
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        return false
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        return true
//    }
//}

