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
    let firestorePrefix = "https://pawsy-c0063.firebaseio.combase/firestore/dogParks/"
    var SBDChannel: SBDOpenChannel?


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
        //creates a unique url identifier for the chat
        self.chatRoomURL = firestorePrefix + park.parkID!
        self.setUpChatView()
        SBDMain.add(self as SBDChannelDelegate, identifier: self.chatRoomURL! + "delegateidentifier")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.SBDChannel{
            let newMessage = Message()
            let messageAsDict = message._toDictionary()
            newMessage.profileImage = messageAsDict!["profileImage"]! as! UIImage
            newMessage.text = messageAsDict!["text"]! as! String
            newMessage.userID = messageAsDict!["userID"]! as! String
            newMessage.username = messageAsDict!["userName"]! as! String
            self.messages.insert(newMessage, at: 0)
            self.tableView.reloadData()
        }
    }

    func loadSendbirdPublicChannel(channel: SBDOpenChannel){
        //save the channel
        self.SBDChannel = channel
        //get existing messages
        let previousMessageQuery = channel.createPreviousMessageListQuery()
        previousMessageQuery?.loadPreviousMessages(withLimit: 50, reverse: false, completionHandler: { (messageList, messageError) in
            if messageError != nil {
                NSLog("Error: %@", messageError!)
                return
            }
            //create new Message from each message
            if messageList != nil{
                for msg in messageList!{
                    let newMsg = msg._toDictionary()!
                    let msgnickname =  newMsg["username"]! as! String
                    let msguserID =  newMsg["userID"]! as! String
                    let msgText = newMsg["text"]! as! String
                    let msgImage = newMsg["profileImage"]! as! UIImage
                    let newMessage = Message()
                    newMessage.profileImage = msgImage
                    newMessage.text = msgText
                    newMessage.username = msgnickname
                    newMessage.userID = msguserID
                    self.messages.insert(newMessage, at: 0)
                    self.tableView.reloadData()
                }
            }
        })
        //enter the channel
        channel.enter(completionHandler: { (enterError) in
            if enterError != nil {
                NSLog("Error: %@", enterError!)
                return
            }
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
                self.hasChatRoom = true
                Firestore.firestore().collection("parks").document(self.parkName!).updateData(["hasChatRoom" : true])
            })
        }

        else{
            //get existing channel
            SBDOpenChannel.getWithUrl(self.chatRoomURL!, completionHandler: { (channel, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                 self.loadSendbirdPublicChannel(channel: channel!)
            })
        }
    }

    func checkForChatRoom() -> Bool{
        Firestore.firestore().collection("dogParks").document(self.park.parkID!).getDocument { (snapshot, error) in
            if snapshot != nil{
                self.hasChatRoom = snapshot!.data()!["hasChatRoom"] as! Bool
                self.getSendBirdPublicChannel()
            }
        }
        return false
    }

    override func didCommitTextEditing(_ sender: Any) {
        self.SBDChannel!.sendUserMessage(self.textView.text) { (userMessage, error) in
            if error != nil{
                NSLog("Error: %@", error!)
                return
            }
            let newMessage = Message()
            let messageAsDict = userMessage!._toDictionary()
            newMessage.profileImage = messageAsDict!["profileImage"]! as! UIImage
            newMessage.text = messageAsDict!["text"]! as! String
            newMessage.userID = messageAsDict!["userID"]! as! String
            newMessage.username = messageAsDict!["userName"]! as! String
            self.messages.insert(newMessage, at: 0)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
        self.textView.slk_clearText(false)

        super.didCommitTextEditing(sender)
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
