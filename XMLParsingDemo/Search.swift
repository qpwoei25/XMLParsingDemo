//
//  Search.swift
//  XMLParsingDemo
//
//  Created by kpugame on 2016. 6. 5..
//  Copyright © 2016년 Ju Lee. All rights reserved.
//

import UIKit

class Search: UITableViewController, UISearchResultsUpdating, NSXMLParserDelegate {
    
    var filteredPosts = [String]()
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    //-------------아래 파싱 선언----------------------------------------------------
    //-------------아래 파싱 선언----------------------------------------------------
    //xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = NSXMLParser()
    
    //feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    //title과 date같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var title1 = NSMutableString()
    var intro = NSMutableString()
    var date = NSMutableString()
    var mpX = NSMutableString() //좌표
    var mpY = NSMutableString()
    
    var SpotName = [String]()
    var SpotNumber = [String]()
    var SpotPositionX = [String]()
    var SpotPositionY = [String]()
    var SpotIntro = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //파싱 시작
        beginParsing()
        
        //네비게이션 바 컬러
        self.navigationController?.navigationBar.barTintColor = UIColor.MyColor()
        self.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "magnifying-glass-2"), tag: 1)
        
        //검색
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    
    //검색결과 저장
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //Filter through the dogs
        self.filteredPosts = self.SpotName.filter {
            (post:String) -> Bool in
            if post.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) {
                return true
            } else {
                return false
            }
        }
        //Update the results TAbleView
        self.resultsController.tableView.reloadData()
    }
    
    
    //parser 오브젝트를 초기화하고 NSXMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        posts = []
        parser = NSXMLParser(contentsOfURL:(NSURL(string: "http://openapi.jejutour.go.kr:8080/openapi/service/TourMapService/getTourMapRelSpot?numOfRows=999&serviceKey=iRLXd1PrWovxuTZxFcKgPIpfnWxneXKaaxWnY0l9cWXMW3kjuT3b6tLbALWHgxmMpRFLllbzIJOcK0NHrlDHaQ%3D%3D"))!)!
        //parser = NSXMLParser(contentsOfURL:(NSURL(string: "http://openapi.jejutour.go.kr:8080/openapi/service/TourMapService/getTourMapView?numOfRows=999&serviceKey=iRLXd1PrWovxuTZxFcKgPIpfnWxneXKaaxWnY0l9cWXMW3kjuT3b6tLbALWHgxmMpRFLllbzIJOcK0NHrlDHaQ%3D%3D"))!)!
        
        parser.delegate = self
        parser.parse()
        self.tableView.reloadData()
    }
    
    
    //parser가 새로운 element를 발견하면 변수를 생성한다.
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            intro = NSMutableString()
            intro = ""
            date = NSMutableString()
            date = ""
            mpX = NSMutableString()
            mpX = ""
            mpY = NSMutableString()
            mpY = ""
            //국회의원 이미지 파일 url
            //imageurl = NSMutableString()
            //imageurl = ""
        }
    }
    
    //title과 pubDate을 발견하면 title1과 date에 완성한다.
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        if element.isEqualToString("tmName") { //관광지 명
            title1.appendString(string)
            SpotName.append(title1 as String)
            
        } else if element.isEqualToString("tmSeq") { //관광지 번호
            date.appendString(string)
            SpotNumber.append(date as String)
            
        } else if element.isEqualToString("mpX") { //x 좌표
            mpX.appendString(string)
            SpotPositionX.append(mpX as String)
            
        } else if element.isEqualToString("mpY") { //y 좌표
            mpY.appendString(string)
            SpotPositionY.append(mpY as String)
            
        } else if element.isEqualToString("tmdescript") { //관광지 소개
            intro.appendString(string)
            SpotIntro.append(intro as String)
        }
    }
    
    //element의 끝에서 feed데이터를 dictionary에 저장
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqualToString("item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title")
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "date")
            }
            if !mpX.isEqual(nil) {
                elements.setObject(mpX, forKey: "mpX")
            }
            if !mpY.isEqual(nil) {
                elements.setObject(mpY, forKey: "mpY")
            }
            if !intro.isEqual(nil) {
                elements.setObject(intro, forKey: "intro") //Key
            }
            posts.addObject(elements)
        }
    }
    //-----------위-- 파싱 선언----------------------------------------------------
    //-----------위-- 파싱 선언----------------------------------------------------
    
    
    //셀 갯수
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.posts.count
        } else {
            return self.filteredPosts.count
        }
    }
    
    //셀 내용
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SpotListCell") else {
            return UITableViewCell()
        }
        
        if tableView == self.tableView {
            cell.textLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("title") as! NSString as String
        } else {
            cell.textLabel?.text = filteredPosts[indexPath.row]
        }
        
        return cell as UITableViewCell
    }
    
    //override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //    _ = tableView.indexPathForSelectedRow!
    //    if let _ = tableView.cellForRowAtIndexPath(indexPath) {
    //        //self.performSegueWithIdentifier("SenderDataSegue", sender: self)
    //        self.performSegueWithIdentifier("ShowMap", sender: self)
    //        print("indexPathForSelecteRow")
    //    }
    //}
 
    //데이터를 ShowInfo에 전송
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue 시작 ")
        if segue.identifier == "ShowMap" {
            if let destination = segue.destinationViewController as? ShowMap {
                let path = tableView.indexPathForSelectedRow
                destination.nameSegue = posts.objectAtIndex((path?.row)!).valueForKey("title") as! NSString as String
                destination.XposSegue = posts.objectAtIndex((path?.row)!).valueForKey("mpX") as! NSString as String
                destination.YposSegue = posts.objectAtIndex((path?.row)!).valueForKey("mpY") as! NSString as String
                print("prepareForSegue 내부 ")
            }
        }
    }
}
