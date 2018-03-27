//
//  SBD Delegate Functions.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/27/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import SendBirdSDK
import Firebase

extension MessageViewController {


    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        // Received a chat message
    }

    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        // When read receipt has been updated
    }

    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
        // When typing status has been updated
    }

    func channel(_ sender: SBDGroupChannel, userDidJoin user: SBDUser) {
        // When a new member joined the group channel
    }

    func channel(_ sender: SBDGroupChannel, userDidLeave user: SBDUser) {
        // When a member left the group channel
    }

    func channel(_ sender: SBDOpenChannel, userDidEnter user: SBDUser) {
        // When a new user entered the open channel
    }

    func channel(_ sender: SBDOpenChannel, userDidExit user: SBDUser) {
        // When a new user left the open channel
    }

    func channel(_ sender: SBDOpenChannel, userWasMuted user: SBDUser) {
        // When a user is muted on the open channel
    }

    func channel(_ sender: SBDOpenChannel, userWasUnmuted user: SBDUser) {
        // When a user is unmuted on the open channel
    }

    func channel(_ sender: SBDOpenChannel, userWasBanned user: SBDUser) {
        // When a user is banned on the open channel
    }

    func channel(_ sender: SBDOpenChannel, userWasUnbanned user: SBDUser) {
        // When a user is unbanned on the open channel
    }

    func channelWasFrozen(_ sender: SBDOpenChannel) {
        // When the open channel is frozen
    }

    func channelWasUnfrozen(_ sender: SBDOpenChannel) {
        // When the open channel is unfrozen
    }

    func channelWasChanged(_ sender: SBDBaseChannel) {
        // When a channel property has been changed
    }

    func channelWasDeleted(_ channelUrl: String, channelType: SBDChannelType) {
        // When a channel has been deleted
    }

    func channel(_ sender: SBDBaseChannel, messageWasDeleted messageId: Int64) {
        // When a message has been deleted
    }
}

