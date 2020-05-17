//
//  ViewController.swift
//  Quran
//
//  Created by Abdulkrum Alatubu on 10/08/1441 AH.
//  Copyright © 1441 Abdulkrum Alatubu. All rights reserved.
//

import UIKit
import JESideMenuController
import ImageSlideShowSwift
import CoreData

class HomeViewController: UIViewController {
    
    var arrayList = [Page]();
    fileprivate var images:[Image] = []
    var check = 0
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.backgroundColor = .black
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        
        if check_if_the_DataBaseIsempty() == true {
            let Data = Page(context: context)
            Data.num = 0
            Data.the_page = "الصفحة \(1)"
            Data.number = 0
            Data.end_number = 1
            ad.saveContext()
        }
        generateImages()
        setup()
        
    }
    
    
    func check_if_the_DataBaseIsempty() -> Bool {
        
        let fetchRegeust:NSFetchRequest<Page> = Page.fetchRequest()
        
        do{
            arrayList =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        return arrayList.isEmpty
        
    }
    // one OR two
    func Update_The_DataBase_end(number:Int) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        
        do {
            let results = try context.fetch(fetchRequest);
            
            let  managedObject = results[0] as AnyObject
            let number_plus = number
            managedObject.setValue(number_plus, forKey: "end_number")
            
            try context.save()
        }
        catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
    }
    // one OR two
    func getNumberOfDataBase_end_number() -> Int{
        
        let fetchRegeust:NSFetchRequest<Page> = Page.fetchRequest()
        
        do{
            arrayList =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        return Int(arrayList[0].end_number)
    }
    //  number of the page plus - second save
    func Update_The_DataBase_number(number:Int) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        
        do {
            let results = try context.fetch(fetchRequest);
            
            let  managedObject = results[0] as AnyObject
            let number_plus = number
            managedObject.setValue(number_plus, forKey: "number")
            
            try context.save()
        }
        catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
    }
    //  number of the page plus - second save
    func getNumberOfDataBase_theNumber() -> Int{
        
        let fetchRegeust:NSFetchRequest<Page> = Page.fetchRequest()
        
        do{
            arrayList =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        return Int(arrayList[0].number)
    }
    //  number of the page - first save
    func getNumberOfDataBase() -> Int{
        
        let fetchRegeust:NSFetchRequest<Page> = Page.fetchRequest()
        
        do{
            arrayList =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        return Int(arrayList[0].num)
    }
    //  number of the page - first save
    func Update_The_DataBase(number:Int) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        
        do {
            let results = try context.fetch(fetchRequest);
            
            let  managedObject = results[0] as AnyObject
            let number_plus = number
            managedObject.setValue(number_plus, forKey: "num")
            
            try context.save()
        }
        catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func Update_The_DataBase_Title(n :String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        
        do {
            let results = try context.fetch(fetchRequest);
            
            let  managedObject = results[0] as AnyObject
            
            managedObject.setValue(n, forKey: "the_page")
            
            try context.save()
        }
        catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
    }
    fileprivate func generateImages()
    {
        
        for i in 1...604 {
            self.images.append(Image(image_id: i,title: "الصفحة \(i)", url: "page\(i)"))
        }
        
        
    }
    private func setup(){
        
        
        
        DispatchQueue.main.async {
            
            ImageSlideShowViewController.presentFrom(self){ [weak self] controller in
                
                if (self?.getNumberOfDataBase_end_number())! == 1{
                    controller.initialIndex = (self?.getNumberOfDataBase())!
                    
                }else{
                    controller.initialIndex = (self?.getNumberOfDataBase_theNumber())!
                    
                }
                controller.dismissOnPanGesture = true
                controller.slides = self?.images
                controller.enableZoom = true
                
                
                
                controller.slideShowViewWillAppear = { animated in
                    debugPrint("Will Appear Animated: \(animated)")
                }
                
                controller.slideShowViewDidAppear = { animated in
                    debugPrint("Did Appear Animated: \(animated)")
                }
                controller.controllerDidupdate = {
                    self?.Update_The_DataBase_Title(n: (controller.currentSlide?.title)!)
                    
                    
                    if (self?.getNumberOfDataBase_end_number())! == 1{
                        self?.Update_The_DataBase(number: controller.currentIndex)
                        
                    }else{
                        self?.Update_The_DataBase_number(number: controller.currentIndex)
                    }
                    
                }
                controller.controllerDetails = {
                    
                    self?.sideMenuController?.toggle()
                    
                }
                controller.UpdateTheEndNumber = {
                    if (self?.getNumberOfDataBase_end_number())! == 1{
                        self?.Update_The_DataBase_end(number: 2)
                    }else{
                        self?.Update_The_DataBase_end(number: 1)
                    }
                    
                }
                
                controller.ShowThepreviousPage = {
                    
                    if (self?.getNumberOfDataBase_end_number())! == 2{
                        self?.Update_The_DataBase_end(number: 1)
                        controller.goToPage(withIndex: (self?.getNumberOfDataBase())!)
                        
                    }else{
                        self?.Update_The_DataBase_end(number: 2)
                        controller.goToPage(withIndex: (self?.getNumberOfDataBase_theNumber())!)
                        
                        
                    }
                    
                }
            }
        }
        
        
    }
    
    
    
    
    @objc private func toggle(_ sender: UIBarButtonItem) {
        sideMenuController?.toggle()
    }
    
}

class Image: NSObject, ImageSlideShowProtocol
{
    func image(completion: @escaping (String?, Error?) -> Void) {
        let image = self.url
        completion(image, nil)
    }
    
    
    private let url: String
    let title: String?
    let image_id :Int?
    
    init(image_id:Int, title: String, url: String) {
        self.image_id = image_id
        self.title = title
        self.url = url
    }
    
    func slideIdentifier() -> String {
        return String(describing: url)
    }
    
    
    
    
    
}
