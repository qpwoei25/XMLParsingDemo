//
//  ShowMapViewController.swift
//  XMLParsingDemo
//
//  Created by kpugame on 2016. 6. 16..
//  Copyright © 2016년 Ju Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShowMap: UIViewController {


    @IBOutlet weak var Map: MKMapView!
    
    var XposSegue = ""
    var YposSegue = ""
    var nameSegue = ""
    
    var myCnt = Int()
    var myName = [String]()
    var myXPos = [String]()
    var myYpos = [String]()
    
    
    // + 버튼 액션함수
    @IBAction func addNotificationTapped(sender: AnyObject) {
        for item in self.tabBarController!.tabBar.items! {
            if item.tag == 3 {
                item.badgeValue = "New"
            }
        }
        
        // 버튼을 누르면
        // 카운트 증가
        myCnt += 1
        
        // 정보 저장(전달하기 위해)
        myName.append(nameSegue)
        myXPos.append(XposSegue)
        myYpos.append(YposSegue)
        
        print("저장되었습닌다!")
        print("나의 리스트 갯수 : \(myCnt)개")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        myCnt = 0
        //
        let location = CLLocationCoordinate2DMake(Double(YposSegue)!, Double(XposSegue)!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.Map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = location.latitude
        annotation.coordinate.longitude = location.longitude
        annotation.title = nameSegue
        annotation.subtitle = "명소"
        // Do any additional setup after loading the view.
        
        self.Map.addAnnotation(annotation)
        
        self.Map.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
