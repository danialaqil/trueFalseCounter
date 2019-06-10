//
//  ViewController.swift
//  TrueFalseCounter
//
//  Created by Danial Aqil on 22/5/19.
//  Copyright © 2019 imdadsl. All rights reserved.
//

import UIKit
import CoreData

//create array of true/false boolean for alarm
var alarmItems = [Alarm]()
var moc:NSManagedObjectContext!

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource = self
        
        
        loadData()
        
    }
    
    func loadData(){
        let alarmRequest:NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        alarmRequest.sortDescriptors = [sortDescriptor]
        
        do{
            try alarmItems = moc.fetch(alarmRequest)
        }catch{
            print("could not load data")
        }
        self.tableView.reloadData()
        
    }

    @IBAction func addAlarm(_ sender: UIButton) {
        //can also send to database on top of the table view
        let trueFalseAlarm = Alarm(context: moc)
        
        trueFalseAlarm.added = Date()
        
        if sender.tag == 0{
            trueFalseAlarm.trueFalse = "0"
        }else if sender.tag == 2{
            trueFalseAlarm.trueFalse = "1"
        }
        
        appDelegate?.saveContext()
        loadData()
    }
    
    //convert table array into JSON
    //**********************************
    /*
    func convertIntoJSONString(arrayObject: [Any])-> String?{
    do{
    let jsonData: Data = try JSONSerialization.data(withJSONObject: alarmItems, options: [])
    if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue){
    return jsonString as String
    }
    }catch let error as NSError{
    print("Array convertIntoJSON- \(error.description)")
    }
    return nil
    }
    */
    
    //download  above json object into the phone's storage to be emailed or something
    func saveUploadedFilesSet(filename:[String: Any]){
        let file: FileHandle? = FileHandle(forWritingAtPath: "\trueFalse.json")
        
        if file != nil{
            do{
                if let jsonData = try JSONSerialization.data(withJSONObject: alarmItems, options: .init(rawValue: 0)) as? Data{
                    //check if everything went well
                    print(NSString(data: jsonData, encoding: 1)!)
                    file?.write(jsonData)
                }
            }catch{
                
            }
            
            file?.closeFile()
        }
        else{
            print("Something went wrong")
        }
    }
    
    //@IBAction func saveJsonToDevice (_sender: UIButton){
        //localStorage.setItem(jsonData)
    //}
    
    
    /*
    let pathDirectory = getDocumentsDirectory()
    try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
    let filePath = pathDirectory.appendingPathComponent("trueFalseCounter.json")
        
    let toSaveArray = self.alarmItems
    let json = try? JSONEncoder().encode(toSaveArray)
        
    do {
        try json!.write(to: filePath)
    } catch {
        print("Failed to write JSON data: \(error.localizedDescription)")
    }
 
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func numberOfSections (in tableView:UITableView) -> Int{
        return 1
    }
 */
 
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return alarmItems.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let trueFalseAlarm = alarmItems[indexPath.row]
        
        let trueFalse = trueFalseAlarm.trueFalse
        
        cell.textLabel?.text = trueFalse
        
        let alarmDate = trueFalseAlarm.added as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: alarmDate)
    
        print("***********************************")
        print ("alarmItems array:")
        print (alarmItems)
        
        
        if trueFalse == "1"{
            cell.imageView?.image = UIImage(named: "kisspng-arrow-button-computer-icons-encapsulated-postscrip-true-5ac2b15c0ee626.0905439915227088280611")
        }else{
            cell.imageView?.image = UIImage(named: "kisspng-true-false-quiz-world-question-5af52ca0d70422.2539291415260171848807")
        }
        return cell
        
        
    }
    
       // export coredata as string/csv
 /*
    @IBAction func export (sender: AnyObject){
        
        let filename = "trueFalseData.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileName)
        
        var csvText = "Date Added, True(1)/False(0) \n \(alarmItems[0]), \(alarmItems[1])"
        
        alarmItems.cell.sortInPlace({ $0.date.compare($1.date) == .OrderedDescending })
        
        let count = alarmItems.cell.count
        
        if count >0{
            for fillup in alarmItems.cell{
                
            }
        }
    }
 
    */
    /*
    func generateStringForCSV (currentSessionData: [String: String]) -> NSMutableString {
        let delimiter = ","
        let stringData:NSMutableString = NSMutableString()
        
        for data in alarmItems{
            stringData.append(alarmItems[0])
            stringData.append(delimiter)
            stringData.append(alarmItems[1])
            stringData.append("\n")
            
        }
        return stringData
    }
 */
    /*
    
    //exporting the array from the table as JSON file
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJasonObject: object, options: []) else{
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    print("\json(from:alarmItems as Any))")
 
 */
    
    
}



