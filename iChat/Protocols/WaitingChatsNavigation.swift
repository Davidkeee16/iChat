//
//  WaitingChatsNavigation.swift
//  iChat
//
//  Created by David Puksanskis on 25/08/2025.
//

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
