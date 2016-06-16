

import Foundation

class postData {
    var posts : NSMutableArray
    
    //title과 date같은 feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var title1 = NSMutableString()
    var date = NSMutableString()
    //var imageurl = NSMutableString()
    
    init(posts: NSMutableArray, elements: NSMutableDictionary, element: NSString, title1:NSMutableString, date: NSMutableString) {
        self.posts = posts
        self.elements = elements
        self.element = element
        self.title1 = title1
        self.date = date
    }
}