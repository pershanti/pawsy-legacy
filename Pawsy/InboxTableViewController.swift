//
//  InboxTableViewController.swift
//  Alamofire
//
//  Created by Shantini Vyas on 3/7/18.
//

import UIKit
import Firebase
import Cloudinary

class InboxTableViewController: UITableViewController {
    
    
    //change userIDs to dogIDS, use currentDog singleton!!!
    
    let user = Auth.auth().currentUser
    var current: DocumentReference?
    var messages: [DocumentSnapshot]? = [DocumentSnapshot]()
    var senders: [String] = [String]()
    var messageChains: [messageChain] = [messageChain]()
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var dogImages = [UIImage]()
    
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMessages()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
    }
    
    func loadMessages(){
        let db = Firestore.firestore()
        let msgQuery = db.collection("messages").whereField("receiverID", isEqualTo: currentDog.sharedInstance.currentReference?.documentID)
        msgQuery.getDocuments { (snapshot, error) in
            if snapshot!.documents.count > 0 {
                for doc in snapshot!.documents{
                    let senderID = doc.data()["senderID"] as? String
                    let sentTime = doc.data()["sentTime"] as? Date
                    let receivedTime = doc.data()["receivedTime"] as? Date
                    let content = doc.data()["content"] as? String
                    let unread = doc.data()["unread"] as? Bool
                    var senderName = ""
                    let newMessage = message(content: content!, timeSent: sentTime!, timeReceived: receivedTime!, unread: unread!)
                    if !self.senders.contains(senderID!){
                        let senderDoc = db.collection("dogs").document(senderID!)
                        senderDoc.getDocument(completion: { (snap, err) in
                            if snap != nil{
                                senderName = (snap!.data()!["name"] as? String)!
                                newMessage.senderName = senderName
                                let newChain = messageChain(senderName: senderName, senderID: senderID!, message: newMessage)
                                newChain.profilePicLink = (snap!.data()!["photo"] as? String)!
                                
                                print (self.messageChains.count)
                                let photoURL = newChain.profilePicLink
                                self.cloudinary!.createDownloader().fetchImage(photoURL!, nil, completionHandler: { (image, cloudError) in

                                    self.dogImages.append(image!)
                                    self.messageChains.append(newChain)
                                     self.senders.append(senderID!)
                                    print ("dogImages:",self.dogImages.count)
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                    else{
                        for msgChn in self.messageChains{
                            if msgChn.senderID == senderID{
                                msgChn.messages.append(newMessage)
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageChains.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! InboxCell
        let msgChain = messageChains[indexPath.row]
        
//        label.text = msgChain.messages![msgChain.messages!.count-1].timeReceived
        let image = self.dogImages[indexPath.row]
        cell.myimageView!.image = image
        cell.setCircularImageView()
        cell.textLabel!.text = msgChain.senderName
        let newString = msgChain.messages[msgChain.messages.count-1].content
        cell.detailTextLabel?.text = newString
        let label = UILabel()
        label.text = "time"
        cell.accessoryView = label
       
    
        return cell
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}

class message {
    var senderName: String?
    var content: String?
    var timeSent: Date?
    var timeReceived: Date?
    var unread: Bool?
    
    init(content: String, timeSent: Date, timeReceived: Date, unread: Bool) {
        self.timeSent = timeSent
        self.content = content
        self.timeReceived = timeReceived
        self.unread = unread
    }
}

class messageChain {
    var senderName: String?
    var senderID: String?
    var messages: [message] = [message]()
    var profilePicLink: String?
    init(senderName: String, senderID: String, message: message) {
        self.senderName = senderName
        self.messages.append(message)
    }
}

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var myimageView: UIImageView!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.myimageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setCircularImageView()
    }
    
    func setCircularImageView() {
        self.myimageView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        self.myimageView.layer.cornerRadius = CGFloat(roundf(Float(self.myimageView.frame.size.width / 2.0)))
    }
}



