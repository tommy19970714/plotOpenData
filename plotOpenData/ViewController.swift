//
//  ViewController.swift
//  plotOpenData
//
//  Created by 冨平準喜 on 2016/06/09.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let requestURL = "https://api.frameworxopendata.jp/api/v3/files/digitacho_back/2016-04-01.json"
//        let acl = "321a9095e91da49809fe209f42eba1339944603ed608abdaa1ebae5f514f4e42"
//        
//        let url = "https://api.frameworxopendata.jp/api/v3/files/digitacho_report/2016-04-01.json?acl:consumerKey=321a9095e91da49809fe209f42eba1339944603ed608abdaa1ebae5f514f4e42"
//        
//        Alamofire.request(.GET, url)
//            .responseJSON {json in
//                if json.result.isSuccess {
//                    let json: JSON = JSON(json.result.value!)
//                    
//                    print(json.count)
//                }
//                else
//                {
//                    print("can't open")
//                }
//                
//        }
        
//        if let filePath = NSBundle.mainBundle().pathForResource("plot", ofType: "json") {
//            do {
//                let str = try String(contentsOfFile: filePath,
//                                     encoding: NSUTF8StringEncoding)
//                print(str)
//            }
//            catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
        
        let filePath = NSBundle.mainBundle().pathForResource("plot", ofType: "json")
        let jsonData = NSData(contentsOfFile: filePath!)
        let json = JSON(data:jsonData!)
//        if let title = json[0]["frameworx:operationName"].string {
//            print(title)
//        }
        let count = json.count
        for i in 0...count
        {
            if json[i]["frameworx:operationName"].string == "荷積" || json[i]["frameworx:operationName"].string == "荷卸"
            {
//                print(json[i]["geo:lat"].stringValue)
//                print(json[i]["geo:long"].stringValue)
//                print(json[i]["frameworx:operationEnd"].string)
//                print(json[i]["frameworx:operationStart"].string)
                
                let start = json[i]["frameworx:operationStart"].string!.chopSuffix(6)
                let startTime = start.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let end = json[i]["frameworx:operationEnd"].string!.chopSuffix(6)
                let endTime = end.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                
                
                let date_formatter: NSDateFormatter = NSDateFormatter()
                date_formatter.locale = NSLocale(localeIdentifier: "ja")
                date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date1 = date_formatter.dateFromString(startTime)
                let date2 = date_formatter.dateFromString(endTime)
                
                
                let span = date2!.timeIntervalSinceDate(date1!)
                let daySpan = span/60
                
                
                let latitude = (json[i]["geo:lat"].stringValue as NSString).doubleValue
                let longitude = (json[i]["geo:long"].stringValue as NSString).doubleValue
                
                let annotation = MKPointAnnotation()
                annotation.title = json[i]["frameworx:operationName"].string
                annotation.subtitle = String(daySpan)+"分"

                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension String {
    func chopPrefix(count: Int = 1) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(count))
    }
    
    func chopSuffix(count: Int = 1) -> String {
        return self.substringToIndex(self.endIndex.advancedBy(-count))
    }
}
