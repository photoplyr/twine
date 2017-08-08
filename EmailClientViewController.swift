//
//  EmailClientViewController.swift
//  Twine
//
//  Created by troy simon on 8/2/17.
//  Copyright © 2017 Gym Farm LLC. All rights reserved.
//

import UIKit

class EmailClientViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var readMessage: UILabel!
    @IBOutlet var tableView: UITableView!
    let UNREAD: String = "UNREAD EMAILS"
    let READ: String = "READ EMAILS"
    
    var emails:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableView.refreshControl!.addTarget(self, action: #selector(EmailClientViewController.refreshControl), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.tableView.refreshControl!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshControl()
    }
    
    func refreshControl() {
        WebServices.sharedInstance.getEmails { (emails, response) in
            
            let emailsData:NSArray = emails.object(forKey: "emails") as! NSArray
            
            self.emails = self.buildLists(data: emailsData)
            
            // Load the emails in their appropriate set
            DispatchQueue.main.async(execute: {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            })
        }
    }
    
    func buildLists(data: NSArray) -> NSMutableDictionary{
        let emaildata:NSMutableDictionary = NSMutableDictionary()
        var unread:NSMutableArray =  NSMutableArray()
        var read:NSMutableArray =  NSMutableArray()
        
        // Place the data in the correct buckets
        for emailData in data  {
            let readStatus = (emailData as AnyObject).object(forKey: "unread") as? Bool
            
            if readStatus == false  {
                unread.add(emailData)
            } else {
                read.add(emailData)
            }
        }
        
        // Sort the arrays
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        unread = (unread.sortedArray(using: [descriptor]) as? NSMutableArray)!
        read = (read.sortedArray(using: [descriptor]) as? NSMutableArray)!
        
        // Save to gloabs
        emaildata.setValue(unread, forKey: UNREAD)
        emaildata.setValue(read, forKey: READ)
        
        return emaildata
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func markAsReadAction(_ sender: Any) {
        
        // Get the ID set for the email collection cell
        let emailID:Int32 =  Int32((sender as! UIButton).tag)
        
        simulateEmailState(emailID: emailID)
        
        // Pass to the service to change the read state... But it had a 402 error so I made a simulator for the call
        //WebServices.sharedInstance.setEmails(emailID: emailID) { (data, error) in
        
        //}
        
    }
    
    func simulateEmailState(emailID:Int32) {
        
        let unread:NSArray =  self.emails.object(forKey: UNREAD) as! NSArray
        let read:NSArray =  self.emails.object(forKey: READ) as! NSArray
        
        // Combine the arrays
        let emails: NSMutableArray = NSMutableArray(array: unread)
        emails.addObjects(from: read as! [Any])
        
        for (index, emailData) in emails.enumerated(){
            
            // get the email index
            let emailid:Int32 =  (((emailData) as AnyObject).object(forKey: "id") as? Int32)!
            
            // Fond a match, lets change the state and reload the data
            if (emailid == emailID) {
                
                let readStatus:Bool = ((emailData as AnyObject).object(forKey: "unread") as? Bool)!
                
                let newEmailDat:NSMutableDictionary = NSMutableDictionary(dictionary: (emailData as? NSDictionary)!)
                
                (newEmailDat as AnyObject).setValue(!readStatus, forKey: "unread")
                
                emails.replaceObject(at: index, with: newEmailDat)
                
                break
            }
        }
        
        // Now rebuild the arrays
        self.emails = self.buildLists(data: emails)
        
        // Load the emails in their appropriate set
        self.tableView.reloadData()
        
        self.tableView.beginUpdates()
        
        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
        
        self.tableView.endUpdates()
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 175
            
        } else {
            return 113
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        
        view.tintColor = AppColor.EmailHeaderColor.Background
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = AppColor.EmailHeaderColor.Title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return emails.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let e:NSArray = self.emails.allKeys as NSArray
        return e.object(at: section) as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            
            self.readMessage.text = "Unread count: \(((self.emails.object(forKey: UNREAD) as? NSArray)?.count)!)"
   
            
            if ( ((self.emails.object(forKey: UNREAD) as? NSArray)?.count)! == 0) {
                return 0
            } else {
                return 1
            }
        } else {
            return ((self.emails.object(forKey: READ) as? NSArray)?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReadCell", for: indexPath) as! ReadTableViewCell
            let read:NSArray =  self.emails.object(forKey: READ) as! NSArray
            
            let readEmail:NSDictionary = read.object(at: indexPath.row) as! NSDictionary
            
            cell.header.text = readEmail.object(forKey: "subject") as? String
            cell.from.text = readEmail.object(forKey: "from") as? String
            cell.message.text = readEmail.object(forKey: "body") as? String
            
            if ((readEmail.object(forKey: "date") as? String) != nil) {
                cell.date.text = formatDate(dateString: readEmail.object(forKey: "date") as! String)
            } else {
                cell.date.text = ""
            }
            
            return cell
        } else {
            let cell:UnreadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UnreadCell", for: indexPath) as! UnreadTableViewCell
            return cell
        }
    }
    
    func formatDate(dateString:String) ->String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        
        if let dateFromString = formatter.date(from: dateString) {
            
            let today = Calendar.current.isDateInToday(dateFromString)
            formatter.dateFormat = "MMM dd"
            
            if (today) {
                formatter.dateFormat = "HH:mm a"
            }
            
            let stringFromDate = formatter.string(from: dateFromString)
            
            return stringFromDate
        }
        
        return ""
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((self.emails.object(forKey: UNREAD) as? NSArray)?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UnreadCollectionViewCell {
        let cell:UnreadCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadColCell", for: indexPath) as! UnreadCollectionViewCell
        
        let unread:NSArray =  self.emails.object(forKey: UNREAD) as! NSArray
        
        let unreadEmail:NSDictionary = unread.object(at: indexPath.row) as! NSDictionary
        
        cell.header.text = unreadEmail.object(forKey: "subject") as? String
        cell.from.text = unreadEmail.object(forKey: "from") as? String
        cell.message.text = unreadEmail.object(forKey: "body") as? String
        
        cell.markButton.tag = Int((unreadEmail.object(forKey: "id") as? Int32)!)
        
        if ((unreadEmail.object(forKey: "date") as? String) != nil) {
            cell.date.text = formatDate(dateString: (unreadEmail.object(forKey: "date") as? String)!)
        } else {
            cell.date.text = ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            return false
        }
        else {
            return true
        }
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let read:NSArray =  self.emails.object(forKey: READ) as! NSArray
            let readEmail:NSDictionary = read.object(at: indexPath.row) as! NSDictionary
            
            let emailID:Int32 =  readEmail.object(forKey: "id") as! Int32
            
            
            simulateEmailState(emailID: emailID)
            
        }
    }
    
}
