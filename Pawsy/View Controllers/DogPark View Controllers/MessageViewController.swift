//
//  ChatViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/25/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import SlackTextViewController
import SendBirdSDK


class MessageViewController: SLKTextViewController, SBDChannelDelegate, SBDConnectionDelegate {
    let DEBUG_CUSTOM_TYPING_INDICATOR = false

    var messages = [Message]()
    var username: String?
    var userNickname: String?
    var userImage: UIImage?
    var sbdUser: SBDUser = SBDMain.getCurrentUser()! 
    var park = CheckedInPark.sharedInstance
    var parkName: String?
    var chatRoomURL: String?
    var hasChatRoom: Bool?
    var SBDChannel: SBDOpenChannel?
    var delegateIdentifier: String?

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    //Set up SLKTextViewController as TableView Controller
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }

    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {
        return .plain
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkForChatRoom()
        self.setUpChatView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.SBDChannel{
            let receivedMessage = Message()
            let userMessage = message as! SBDUserMessage
            receivedMessage.text = userMessage.message!
            receivedMessage.userID = userMessage.sender!.userId
            receivedMessage.username = userMessage.sender!.nickname!
            let profileURL = URL(string: userMessage.sender!.profileUrl!)!
            self.getDataFromUrl(url: profileURL, completion: { (imageData, response, httpError) in
                if httpError != nil{
                    print(httpError!.localizedDescription)
                }
                receivedMessage.profileImage = UIImage(data: imageData!)
                DispatchQueue.main.async {
                    self.messages.insert(receivedMessage, at: 0)
                    self.tableView.reloadData()
                }
            })
        }
    }


    func loadSendbirdPublicChannel(channel: SBDOpenChannel){
        //save the channel
        self.SBDChannel = channel
        //enter the channel
        channel.enter(completionHandler: { (enterError) in
            if enterError != nil {
                NSLog("Error: %@", enterError!)
                return
            }
            print("entered channel")
            print(channel.name)
            self.delegateIdentifier = channel.channelUrl + "delegateID"
            SBDMain.add(self as SBDChannelDelegate, identifier: self.delegateIdentifier!)
            let query = channel.createPreviousMessageListQuery()!
            query.loadPreviousMessages(withLimit: 50, reverse: false, completionHandler: { (baseMessageList, error) in
                for message in baseMessageList!{
                    let userMessage = message as! SBDUserMessage
                    let receivedMessage = Message()
                    receivedMessage.text = userMessage.message!
                    receivedMessage.userID = userMessage.sender!.userId
                    receivedMessage.username = userMessage.sender!.nickname!
                    let profileURL = URL(string: userMessage.sender!.profileUrl!)!
                    self.getDataFromUrl(url: profileURL, completion: { (imageData, response, httpError) in
                        if httpError != nil{
                            print(httpError!.localizedDescription)
                        }
                        receivedMessage.profileImage = UIImage(data: imageData!)
                        DispatchQueue.main.async {
                            self.messages.insert(receivedMessage, at: 0)
                            self.tableView.reloadData()
                        }
                    })
                }
            })
        })
    }

    //check if the channel exists: if not, create it
    func getSendBirdPublicChannel(){
        //create new channel
        if self.hasChatRoom == false {
            SBDOpenChannel.createChannel(withName: self.parkName!, coverUrl: nil, data: nil, operatorUserIds: nil, completionHandler: { (channel, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                self.loadSendbirdPublicChannel(channel: channel!)
                self.chatRoomURL = channel!.channelUrl
                self.hasChatRoom = true
                Firestore.firestore().collection("dogParks").document(self.park.parkID!).updateData(["hasChatRoom" : true, "chatRoomURL" : self.chatRoomURL!])
            })
        }

        else{
            print("getting existing channel")
            //this isn't working
            Firestore.firestore().collection("dogParks").document(self.park.parkID!).getDocument(completion: { (snapshot, fireError) in
                if fireError != nil{
                    print(fireError!.localizedDescription)
                }
                self.chatRoomURL = snapshot!.data()!["chatRoomURL"] as! String
                SBDOpenChannel.getWithUrl(self.chatRoomURL!, completionHandler: { (channel, error) in
                    if error != nil {
                        NSLog("Error: %@", error!)
                        return
                    }
                    self.loadSendbirdPublicChannel(channel: channel!)
                })
            })
        }
    }

    func checkForChatRoom() {
        Firestore.firestore().collection("dogParks").document(self.park.parkID!).getDocument { (snapshot, error) in
            if snapshot != nil{
                self.hasChatRoom = snapshot!.data()!["hasChatRoom"] as! Bool
                self.getSendBirdPublicChannel()
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    override func didCommitTextEditing(_ sender: Any) {
        self.SBDChannel!.sendUserMessage(self.textView.text) { (userMessage, error) in
            if error != nil{
                NSLog("Error: %@", error!)
                return
            }
            let newMessage = Message()
            newMessage.text = userMessage!.message!
            newMessage.userID = userMessage!.sender!.userId
            newMessage.username = userMessage!.sender!.nickname!
            let imageURL = URL(string: userMessage!.sender!.profileUrl!)
            let dataTask =  self.getDataFromUrl(url: imageURL!, completion: { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    newMessage.profileImage = UIImage(data: data)
                    self.messages.insert(newMessage, at: 0)
                    self.tableView.reloadData()
                }
            })
            self.textView.slk_clearText(false)
            super.didCommitTextEditing(sender)
        }
    }


    //Message Cell setup
    func messageCellForRowAtIndexPath(_ indexPath: IndexPath) -> MessageTableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: MessengerCellIdentifier) as! MessageTableViewCell


        let message = self.messages[(indexPath as NSIndexPath).row]

        cell.titleLabel.text = message.username
        cell.bodyLabel.text = message.text
        cell.thumbnailView.image = message.profileImage!
        cell.indexPath = indexPath
        cell.usedForMessage = true
        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        cell.transform = self.tableView.transform
        return cell
    }
}
