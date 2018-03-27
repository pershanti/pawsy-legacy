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


class MessageViewController: SLKTextViewController {
    let DEBUG_CUSTOM_TYPING_INDICATOR = false

    var messages = [Message]()
    var username: String?
    var userNickname: String?
    var userImage: UIImage?
    var park: Park?
    var delegate: MessageViewControllerDelegate?
    var chatRoomURL: String?
    let firestorePrefix = "https://pawsy-c0063.firebaseio.combase/firestore/dogParks/"

    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }


    // MARK: - Initialisation

    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {
        return .plain
    }

    override func viewDidLoad() {
        self.delegate!.setUpMessageViewController()
        super.viewDidLoad()

        let currentUser = SBDMain.getCurrentUser()
        self.userNickname = currentDog.sharedInstance.name!
        self.username = currentDog.sharedInstance.documentID!
        self.userImage = currentDog.sharedInstance.image!

        // SLKTVC's configuration
        self.bounces = true
        self.shakeToClearEnabled = true
        self.isKeyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.isInverted = true

        self.leftButton.setImage(UIImage(named: "icn_upload"), for: UIControlState())
        self.leftButton.tintColor = UIColor.gray

        self.rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState())

        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 256
        self.textInputbar.counterStyle = .split
        self.textInputbar.counterPosition = .top

        self.textInputbar.editorTitle.textColor = UIColor.darkGray
        self.textInputbar.editorLeftButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        self.textInputbar.editorRightButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)

        if DEBUG_CUSTOM_TYPING_INDICATOR == false {
            self.typingIndicatorView!.canResignByTouch = true
        }

        self.tableView.separatorStyle = .none
        self.tableView.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: MessengerCellIdentifier)

        self.textView.placeholder = "Message";

    }

    //SLKViewController delegate functions
    override func didCommitTextEditing(_ sender: Any) {
        let message: Message = Message()
        message.text =  self.textView.text
        message.username = self.userNickname!
        message.userID = self.username!
        message.profileImage = self.userImage!


        self.messages.insert(message, at: 0)

        self.tableView.reloadData()
        self.textView.slk_clearText(false)

        super.didCommitTextEditing(sender)
    }

    override func didCancelTextEditing(_ sender: Any) {

        super.didCancelTextEditing(sender)
    }

    override func didPressRightButton(_ sender: Any?) {
        self.didCommitTextEditing(self.textView)
    }

    override func didPressReturnKey(_ keyCommand: UIKeyCommand?) {
        self.didCommitTextEditing(self.textView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //TableView Delegate functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return self.messageCellForRowAtIndexPath(indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == self.tableView {
            let message = self.messages[(indexPath as NSIndexPath).row]

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left

            let pointSize = MessageTableViewCell.defaultFontSize()

            let attributes = [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: pointSize),
                NSAttributedStringKey.paragraphStyle : paragraphStyle
            ]

            var width = tableView.frame.width-kMessageTableViewCellAvatarHeight
            width -= 25.0

            let titleBounds = (message.username as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let bodyBounds = (message.text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

            if message.text.characters.count == 0 {
                return 0
            }

            var height = titleBounds.height
            height += bodyBounds.height
            height += 40

            if height < kMessageTableViewCellMinimumHeight {
                height = kMessageTableViewCellMinimumHeight
            }

            return height
        }
        else {
            return kMessageTableViewCellMinimumHeight
        }
    }

    override func ignoreTextInputbarAdjustment() -> Bool {
        return super.ignoreTextInputbarAdjustment()
    }

    override func forceTextInputbarAdjustment(for responder: UIResponder!) -> Bool {

        if #available(iOS 8.0, *) {
            guard let _ = responder as? UIAlertController else {
                // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
                return UIDevice.current.userInterfaceIdiom == .pad
            }
            return true
        }
        else {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }

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


