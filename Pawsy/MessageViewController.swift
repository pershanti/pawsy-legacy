//
//  ChatViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/25/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import SlackTextViewController


class MessageViewController: SLKTextViewController {
    let DEBUG_CUSTOM_TYPING_INDICATOR = false

    var messages = [Message]()

    var users: Array = ["Allen", "Anna", "Alicia", "Arnold", "Armando", "Antonio", "Brad", "Catalaya", "Christoph", "Emerson", "Eric", "Everyone", "Steve"]
    var channels: Array = ["General", "Random", "iOS", "Bugs", "Sports", "Android", "UI", "SSB"]
    var emojis: Array = ["-1", "m", "man", "machine", "block-a", "block-b", "bowtie", "boar", "boat", "book", "bookmark", "neckbeard", "metal", "fu", "feelsgood"]
    var commands: Array = ["msg", "call", "text", "skype", "kick", "invite"]

    var searchResult: [String]?

    var pipWindow: UIWindow?

    var editingMessage = Message()

    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }


    // MARK: - Initialisation

    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {

        return .plain
    }

    func commonInit() {

        NotificationCenter.default.addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        NotificationCenter.default.addObserver(self,  selector: #selector(MessageViewController.textInputbarDidMove(_:)), name: NSNotification.Name.SLKTextInputbarDidMove, object: nil)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.commonInit()

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

        self.autoCompletionView.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: AutoCompletionCellIdentifier)
        self.registerPrefixes(forAutoCompletion: ["@",  "#", ":", "+:", "/"])

        self.textView.placeholder = "Message";

        self.textView.registerMarkdownFormattingSymbol("*", withTitle: "Bold")
        self.textView.registerMarkdownFormattingSymbol("_", withTitle: "Italics")
        self.textView.registerMarkdownFormattingSymbol("~", withTitle: "Strike")
        self.textView.registerMarkdownFormattingSymbol("`", withTitle: "Code")
        self.textView.registerMarkdownFormattingSymbol("```", withTitle: "Preformatted")
        self.textView.registerMarkdownFormattingSymbol(">", withTitle: "Quote")
    }


    // MARK: - Lifeterm

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == self.tableView {
            return self.messages.count
        }
        else {
            if let searchResult = self.searchResult {
                return searchResult.count
            }
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == self.tableView {
            return self.messageCellForRowAtIndexPath(indexPath)
        }
        else {
            return self.autoCompletionCellForRowAtIndexPath(indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == self.tableView {
            let message = self.messages[(indexPath as NSIndexPath).row]

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left

            let pointSize = MessageTableViewCell.defaultFontSize()

            let attributes = [
                NSFontAttributeName : UIFont.systemFont(ofSize: pointSize),
                NSParagraphStyleAttributeName : paragraphStyle
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

        if cell.gestureRecognizers?.count == nil {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MessageViewController.didLongPressCell(_:)))
            cell.addGestureRecognizer(longPress)
        }

        let message = self.messages[(indexPath as NSIndexPath).row]

        cell.titleLabel.text = message.username
        cell.bodyLabel.text = message.text

        cell.indexPath = indexPath
        cell.usedForMessage = true

        // Cells must inherit the table view's transform
        // This is very important, since the main table view may be inverted
        cell.transform = self.tableView.transform

        return cell
    }

    func autoCompletionCellForRowAtIndexPath(_ indexPath: IndexPath) -> MessageTableViewCell {

        let cell = self.autoCompletionView.dequeueReusableCell(withIdentifier: AutoCompletionCellIdentifier) as! MessageTableViewCell
        cell.indexPath = indexPath
        cell.selectionStyle = .default

        guard let searchResult = self.searchResult else {
            return cell
        }

        guard let prefix = self.foundPrefix else {
            return cell
        }

        var text = searchResult[(indexPath as NSIndexPath).row]

        if prefix == "#" {
            text = "# " + text
        }
        else if prefix == ":" || prefix == "+:" {
            text = ":\(text):"
        }

        cell.titleLabel.text = text

        return cell
    }
}

