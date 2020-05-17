//
//  MenuTableViewController.swift
//  Quran
//
//  Created by Abdulkrum Alatubu on 10/08/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit
import JESideMenuController

class MenuTableViewController: UIViewController {
    private struct Constants {
        static let identifier = "cell"
    }
    
    let q_one = [
        "الفاتحة","البقرة","آل عمران","النساء","المائدة","الأنعام","الأعراف","الأنفال","التوبة","يونس","هود","يوسف","الرعد","ابراهيم","الحجر","النحل","الإسراء","الكهف","مريم","طه","الأنبياء","الحج", "المؤمنون", "النور","الفرقان","الشعراء","النمل","القصص", "العنكبوت", "الروم", "لقمان","السجدة","الأحزاب", "سبإ","فاطر","يس","الصافات", "ص", "الزمر","غافر", "فصلت","الشورى","الزخرف","الدخان", "الجاثية", "الأحقاف","محمد","الفتح","الحجرات","ق","الذاريات", "الطور", "النجم","القمر", "الرحمن", "الواقعة",  "الحديد",
        "المجادلة","الحشر","الممتحنة","الصف","الجمعة",           "المنافقون","التغابن","الطلاق","التحريم","الملك","القلم","الحاقة","المعارج","نوح","الجن","المزمل","المدثر","القيامة",  "الانسان","المرسلات","النبإ","النازعات","عبس","التكوير", "الإنفطار",  "المطففين", "الإنشقاق","البروج","الطارق","الأعلى","الغاشية","الفجر",  "البلد","الشمس","الليل","الضحى","الشرح","التين","العلق","القدر","البينة", "الزلزلة","العاديات","القارعة","التكاثر","العصر","الهمزة","الفيل","قريش","الماعون","الكوثر","الكافرون","النصر","المسد","الإخلاص","الفلق","الناس"]
    
    // private let menuItems = [Item(title: "Home")]
    
    //        private struct Item {
    //            let title: String
    //        }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private var cache = NSCache<NSString, UIViewController>()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheRootViewController()
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44.0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.tableFooterView = UIView()
    }
    
    // Cache the view controllers
    private func viewController(with identifier: String) -> UIViewController? {
        if let viewController = cache.object(forKey: identifier as NSString) {
            return viewController
        } else if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            cache.setObject(viewController, forKey: identifier as NSString)
            return viewController
        } else {
            return nil
        }
    }
    
    // An example to access the currently visible view controller and cache it.
    private func cacheRootViewController() {
        guard let visibleViewController = sideMenuController?.visibleViewController else { return }
        cache.setObject(visibleViewController, forKey: ("root") as NSString)
    }
    
    func getNumbers(name:String)-> Int {
        var start_num = 1
        
        switch name {
            
        case "1":
            start_num = 1
            return start_num
            
        case "2":
            start_num = 2
            
            return start_num
            
        case "3":
            start_num = 50
            
            return start_num
            
        case "4":
            start_num = 77
            
            return start_num
            
        case "5":
            start_num = 106
            
            return start_num
            
        case "6":
            start_num = 128
            
            return start_num
            
        case "7":
            start_num = 151
            
            return start_num
            
        case "8":
            start_num = 177
            
            return start_num
            
        case "9":
            start_num = 187
            
            return start_num
            
        case "10":
            start_num = 208
            
            return start_num
            
        case "11":
            start_num = 221
            
            return start_num
            
        case "12":
            start_num = 235
            return start_num
            
        case "13":
            start_num = 249
            return start_num
            
        case "14":
            start_num = 255
            return start_num
            
        case "15":
            start_num = 262
            return start_num
            
        case "16":
            start_num = 267
            return start_num
            
        case "17":
            start_num = 282
            return start_num
            
        case "18":
            start_num = 293
            return start_num
            
        case "19":
            start_num = 305
            return start_num
            
        case "20":
            start_num = 312
            return start_num
            
        case "21":
            start_num = 322
            return start_num
            
        case "22":
            start_num = 332
            return start_num
            
        case "23":
            start_num = 342
            return start_num
            
        case "24":
            start_num = 350
            return start_num
            
        case "25":
            start_num = 359
            return start_num
            
        case "26":
            start_num = 367
            return start_num
            
        case "27":
            start_num = 377
            return start_num
            
        case "28":
            start_num = 385
            return start_num
            
        case "29":
            start_num = 396
            return start_num
            
        case "30":
            start_num = 404
            return start_num
            
        case "31":
            start_num = 411
            return start_num
            
        case "32":
            start_num = 415
            return start_num
            
        case "33":
            start_num = 418
            return start_num
            
        case "34":
            start_num = 428
            return start_num
            
        case "35":
            start_num = 434
            return start_num
            
        case "36":  start_num = 440
        return start_num
            
        case "37":  start_num = 446
        return start_num
            
        case "38":  start_num = 453
        return start_num
            
        case "39": start_num = 458
        return start_num
            
        case "40": start_num = 467
        return start_num
            
        case "41": start_num = 477
        return start_num
            
        case "42": start_num = 483
        return start_num
            
        case "43": start_num = 489
        return start_num
            
        case "44": start_num = 496
        return start_num
            
        case "45": start_num = 499
        return start_num
            
        case "46": start_num = 502
        return start_num
            
        case "47":  start_num = 507
        return start_num
            
        case "48": start_num = 511
        return start_num
            
        case "49": start_num = 515
        return start_num
            
        case "50":  start_num = 518
        return start_num
            
        case "51": start_num = 520
        return start_num
            
        case "52": start_num = 523
        return start_num
            
        case "53": start_num = 526
        return start_num
            
        case "54": start_num = 528
        return start_num
            
        case "55": start_num = 531
        return start_num
            
        case "56": start_num = 534
        return start_num
            
        case "57": start_num = 537
        return start_num
            
        case "58": start_num = 542
        return start_num
            
        case "59": start_num = 545
        return start_num
            
        case "60": start_num = 549
        return start_num
            
        case "61": start_num = 551
        return start_num
            
        case "62": start_num = 553
        return start_num
            
        case "63": start_num = 554
        return start_num
            
        case "64": start_num = 556
        return start_num
            
        case "65": start_num = 558
        return start_num
            
        case "66": start_num = 560
        return start_num
            
        case "67": start_num = 562
        return start_num
            
        case "68": start_num = 564
        return start_num
            
        case "69": start_num = 566
        return start_num
            
        case "70": start_num = 568
        return start_num
            
        case "71": start_num = 570
        return start_num
            
        case "72": start_num = 572
        return start_num
            
        case "73": start_num = 574
        return start_num
            
        case "74": start_num = 575
        return start_num
            
        case "75": start_num = 577
        return start_num
            
        case "76": start_num = 578
        return start_num
            
        case "77": start_num = 580
        return start_num
            
        case "78": start_num = 582
        return start_num
            
        case "79": start_num = 583
        return start_num
            
        case "80": start_num = 585
        return start_num
            
        case "81": start_num = 586
        return start_num
            
        case "82": start_num = 587
        return start_num
            
        case "83": start_num = 587
        return start_num
            
        case "84": start_num = 589
        return start_num
            
        case "85": start_num = 590
        return start_num
            
        case "86": start_num = 591
        return start_num
            
        case "87": start_num = 591
        return start_num
            
        case "88": start_num = 592
        return start_num
            
        case "89": start_num = 593
        return start_num
            
        case "90": start_num = 594
        return start_num
            
        case "91": start_num = 595
        return start_num
            
        case "92": start_num = 595
        return start_num
            
        case "93": start_num = 596
        return start_num
            
        case "94": start_num = 596
        return start_num
            
        case "95": start_num = 597
        return start_num
            
        case "96": start_num = 597
        return start_num
            
        case "97": start_num = 598
        return start_num
            
        case "98": start_num = 598
        return start_num
            
        case "99": start_num = 599
        return start_num
            
        case "100": start_num = 599
        return start_num
            
        case "101": start_num = 600
        return  start_num
            
        case "102": start_num = 600
        return  start_num
            
        case "103": start_num = 601
        return  start_num
            
        case "104": start_num = 601
        return  start_num
            
        case "105": start_num = 601
        return  start_num
            
        case "106": start_num = 602
        return  start_num
            
        case "107": start_num = 602
        return  start_num
            
        case "108": start_num = 602
        return  start_num
            
        case "109": start_num = 603
        return  start_num
            
        case "110": start_num = 603
        return  start_num
            
        case "111": start_num = 603
        return  start_num
            
        case "112": start_num = 604
        return  start_num
            
        case "113": start_num = 604
        return  start_num
            
        case "114": start_num = 604
        return start_num
            
            
            
            
        default: return start_num
            
        }
    }
    
}

// MARK: - Table view dataSource

extension MenuTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return q_one.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        
        let item = q_one[indexPath.row]
        cell.imageView?.image = UIImage(named:"comment")
        cell.backgroundColor = .white
        cell.textLabel?.font = UIFont(name:"Droid Arabic Kufi", size:16)
        cell.textLabel?.text = item
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    
}

// MARK: - Table view delegate

extension MenuTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        // let item = menuItems[indexPath.row]
        guard let viewController = viewController(with: "root") else { return }
        sideMenuController?.setViewController(viewController, animated: true)
        
        let indexInfo:[String: Int] = ["index": getNumbers(name: "\(indexPath.row + 1)")]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Go"), object: nil, userInfo: indexInfo)
        
    }
    
}
