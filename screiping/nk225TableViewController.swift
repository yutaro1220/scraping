//
//  ViewController.swift
//  screiping
//
//  Created by me to you on 2020/12/15.
//

import UIKit
//HTTP通信してくれるやつ
import Alamofire
//スクレイピングしてくれるやつ
import Kanna

class nk225TableViewController: UITableViewController {
    var beefbowl = [File]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getGyudonPrice()
    }
    func getGyudonPrice() {
    //スクレイピング対象のサイトを指定
        AF.request("https://www.nikkei.com/markets/worldidx/chart/nk225/").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    
                    // 牛丼のサイズをXpathで指定
                    var sizes = [String]()
                    for link in doc.xpath("//span[@class='economic_value_now a-fs26']") {
                        sizes.append(link.text ?? "")
                    }
                    
                    //牛丼の値段をXpathで指定
                    var prices = [String]()
                    for link in doc.xpath("//span[@class='economic_balance_value a-fs18']") {
                        prices.append(link.text ?? "")
                    }
                    
                    //牛丼のサイズ分だけループ
                    for (index, value) in sizes.enumerated() {
                        let gyudon = File()
                        gyudon.size = value
                        gyudon.price = prices[index]
                        self.beefbowl.append(gyudon)
                    }
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
            }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beefbowl.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let nk225 = self.beefbowl[indexPath.row]
        cell.textLabel?.text = nk225.size
        cell.detailTextLabel?.text = nk225.price

        return cell
    }
}
