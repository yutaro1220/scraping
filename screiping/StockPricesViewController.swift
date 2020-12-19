//
//  StockPricesViewController.swift
//  Gyudon
//
//  Created by RikutoSato on 2020/12/17.
//

import UIKit
import Alamofire
import Kanna

class StockPricesViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGyudonPrice()
    }
    
    func getGyudonPrice() {
        AF.request("https://stocks.finance.yahoo.co.jp/stocks/detail/?code=998407.O").responseString { [self] response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    label.text = doc.xpath("//td[@class='stoksPrice']").first?.text
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
