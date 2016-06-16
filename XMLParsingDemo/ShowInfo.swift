//
//  Info.swift
//  XMLParsingDemo
//
//  Created by kpugame on 2016. 6. 3..
//  Copyright © 2016년 Ju Lee. All rights reserved.
//

import UIKit

class ShowInfo: UIViewController {

    
    @IBOutlet weak var SpotNameLabel: UILabel!
    @IBOutlet weak var SpotInfoTextView: UITextView!
    
    var NameSegue = ""
    var InfoSegue = ""
    
    // + 버튼 액션함수
    @IBAction func addNotificationTapped(sender: AnyObject) {
        for item in self.tabBarController!.tabBar.items! {
            if item.tag == 3 {
                item.badgeValue = "New"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpotNameLabel.textColor = UIColor.darkGrayColor()
        SpotNameLabel.text = NameSegue //관광지 이름을 전송 받는다.
        
        SpotInfoTextView.text = InfoSegue //관광지 정보를 전송 받는다.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
