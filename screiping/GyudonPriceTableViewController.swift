import UIKit
import Alamofire
import Kanna

class GyudonPriceTableViewController: UITableViewController {
    var beefbowl = [Gyudon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getGyudonPrice()
    }
    func getGyudonPrice() {
        //スクレイピング対象のサイトを指定
        AF.request("https://www.nikkei.com/markets/worldidx/chart/nk225/").responseString { response in
            switch response.result {
            case let .success(value):
                if let doc = try? HTML(html: value, encoding: .utf8) {
                    
                    // 牛丼のサイズをXpathで指定
                    var sizess = [String]()
                    for link in doc.xpath("//span[@class='economic_value_now a-fs26']") {
                        sizess.append(link.text ?? "")
                    }
                    //牛丼の値段をXpathで指定
                    var prices = [String]()
                    for link in doc.xpath("//span[@class='economic_balance_value a-fs18']") {
                        prices.append(link.text ?? "")
                    }
                    //牛丼のサイズ分だけループ
                    for (index, value) in sizess.enumerated() {
                        let gyudo = Gyudon()
                        gyudo.size = value
                        gyudo.price = prices[index]
                        self.beefbowl.append(gyudo)
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
        
        let gyudonn = self.beefbowl[indexPath.row]
        cell.textLabel?.text = gyudonn.size
        cell.detailTextLabel?.text = gyudonn.price
        
        return cell
    }

    @IBAction func button(_ sender: Any) {
    }
    

}
