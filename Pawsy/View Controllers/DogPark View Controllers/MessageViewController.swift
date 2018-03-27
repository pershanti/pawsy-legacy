//
//  ChatViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/25/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import SlackTextViewController
import SendBirdSDK


class MessageViewController: SLKTextViewController, SBDChannelDelegate, SBDConnectionDelegate {
    let DEBUG_CUSTOM_TYPING_INDICATOR = false

    var messages = [Message]()
    var username: String?
    var userNickname: String?
    var userImage: UIImage?
    var park: Park?
    var delegate: MessageViewControllerDelegate?
    var chatRoomURL: String?
    var hasChatRoom: Bool?
    let firestorePrefix = "https://pawsy-c0063.firebaseio.combase/firestore/dogParks/"


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
        SBDMain.add(self as SBDChannelDelegate, identifier: self.chatRoomURL + "delegateidentifier")
        self.delegate!.setUpMessageViewController()
        super.viewDidLoad()
        let parkDocID = self.park!.placeID!
        self.chatRoomURL = firestorePrefix + parkDocID
        self.setUpChatView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadSendBirdPublicChannel(){
        //create new channel
        if self.park?.hasChatRoom == false {
            SBDOpenChannel.createChannel(withName: self.park!.name!, coverUrl: nil, data: nil, operatorUserIds: nil, completionHandler: { (channel, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                //get existing messages
               let previousMessageQuery = SBDOpenChannel.createPreviousMessageListQuery(channel!)()
                previousMessageQuery?.loadPreviousMessages(withLimit: 50, reverse: false, completionHandler: { (messageList, messageError) in
                    if error != nil {
                        NSLog("Error: %@", error!)
                        return
                    }
                    //create new Message from each message
                    if messageList != nil{
                        for msg in messageList!{
                            let newMsg = msg._toDictionary()
                            let msgnickname =  newMsg["username"]! as! String
                            let msguserID =  newMsg["userID"]! as! String
                            let msgText = newMsg["text"]! as! String
                            let msgImageData = newMsg["profileImage"]! as! Data
                            let msgImage = UIImage(data: msgImageData)
                            let newMessage = Message()
                            newMessage.profileImage = msgImage
                            newMessage.text = msgText
                            newMessage.username = msgnickname
                            newMessage.userID = msguserID
                            self.messages.insert(newMessage, at: 0)
                            self.tableView.reloadData()
                    }
                    })
                })
            })
        }

        else{
            //get existing channel
            SBDOpenChannel.getWithUrl(self.chatRoomURL!, completionHandler: { (channel, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                //get existing messages
                let previousMessageQuery = SBDOpenChannel.createPreviousMessageListQuery(channel)()
                previousMessageQuery?.loadPreviousMessages(withLimit: 50, reverse: false, completionHandler: { (messageList, messageError) in
                    if error != nil {
                        NSLog("Error: %@", error!)
                        return
                    }
                    //create new Message from each message
                    if messageList != nil{
                        for msg in messageList!{
                            let newMsg = msg._toDictionary()
                            let msgnickname =  newMsg["username"]! as! String
                            let msguserID =  newMsg["userID"]! as! String
                            let msgText = newMsg["text"]! as! String
                            let msgImageData = newMsg["profileImage"]! as! Data
                            let msgImage = UIImage(data: msgImageData)
                            let newMessage = Message()
                            newMessage.profileImage = msgImage
                            newMessage.text = msgText
                            newMessage.username = msgnickname
                            newMessage.userID = msguserID
                            self.messages.insert(newMessage, at: 0)
                            self.tableView.reloadData()
                        }
                    })
                })
            }
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

protocol MessageViewControllerDelegate {
    func setUpMessageViewController()
}


