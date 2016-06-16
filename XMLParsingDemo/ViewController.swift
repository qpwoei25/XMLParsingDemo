//
//  ViewController.swift
//  XMLParsingDemo
//
//  Created by kpugame on 2016. 5. 17..
//  Copyright © 2016년 Ju Lee. All rights reserved.
//
/*
import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {
    
    
    //xml 파일을 다운로드 및 파싱하는 오브젝트
    var parser = NSXMLParser()
    
    //feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    
    //title과 date같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var title1 = NSMutableString()
    var date = NSMutableString()
    var imageurl = NSMutableString()
    var mpX = NSMutableString()
    var mpY = NSMutableString()
    
    
    @IBOutlet weak var tbData: UITableView!
    
    // + 버튼 액션함수
    @IBAction func addNotificationTapped(sender: AnyObject) {
        for item in self.tabBarController!.tabBar.items! {
            if item.tag == 3 {
                item.badgeValue = "New"
            }
        }
    }
    
    
    //parser 오브젝트를 초기화하고 NSXMLParserDelegate로 설정하고 XML 파싱 시작
    func beginParsing()
    {
        posts = []
        //기존 : parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://images.apple.com/main/rss/hotnews/hotnews.rss"))!)!
        //daum openAPI
        //parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberCurrStateList?ServiceKey=sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"))!)!
        parser = NSXMLParser(contentsOfURL:(NSURL(string: "http://openapi.jejutour.go.kr:8080/openapi/service/TourMapService/getTourMapRelSpot?serviceKey=iRLXd1PrWovxuTZxFcKgPIpfnWxneXKaaxWnY0l9cWXMW3kjuT3b6tLbALWHgxmMpRFLllbzIJOcK0NHrlDHaQ%3D%3D"))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
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
            date = NSMutableString()
            date = ""
            //국회의원 이미지 파일 url
            imageurl = NSMutableString()
            imageurl = ""
            //좌표
            mpX = NSMutableString()
            mpX = ""
            mpY = NSMutableString()
            mpY = ""
        }
    }
    
    //title과 pubDate을 발견하면 title1과 date에 완성한다.
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
//        if element.isEqualToString("title") {
//        if element.isEqualToString("empNm") { //국회의원 이름
        if element.isEqualToString("tmName") { //관광지 명
            title1.appendString(string)
        }
//        } else if element.isEqualToString("pubDate") { //애플최신소식
//        } else if element.isEqualToString("author") { //책저자
//        } else if element.isEqualToString("origNm") { //국회의원 지역구
            else if element.isEqualToString("tmSeq") { //관광지 번호
            date.appendString(string)
        } else if element.isEqualToString("jpgLink") { //국회의원 이미지
            imageurl.appendString(string)
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
            //국회의원 이미지
            if !imageurl.isEqual(nil) {
                elements.setObject(imageurl, forKey: "imageurl")
            }
            posts.addObject(elements)
        }
    }
    
    //row의 개수는 posts 배열 원소의 개수
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    //테이블뷰 셀의 내용은 title과 subtitle을 posts배열의 원소에서 title과 date에 해당하는 value로 설정
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        if(cell.isEqual(NSNull))
        {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! UITableViewCell;
        }
        
        cell.textLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("title") as! NSString as String
        cell.detailTextLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("date") as! NSString as String
        
        //url사진을 다운로드하여 표시
        if let url = NSURL(string: posts.objectAtIndex(indexPath.row).valueForKey("imageurl") as! NSString as String)
        {
            if let data = NSData(contentsOfURL: url)
            {
                cell.imageView!.image = UIImage(data: data)
            }
        }
        
        
        
        
        return cell as UITableViewCell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        //네비게이션 바 컬러
        self.navigationController?.navigationBar.barTintColor = UIColor.MyColor()
        //tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "magnifying-glass-2"), tag: 1)
        self.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "magnifying-glass-2"), tag: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}*/


