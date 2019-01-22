

//
//  ChatViewController.swift
//
//  Created by stefano vecchiati .
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar


class ChatViewController: MessagesViewController {
    var albumId: String
    var messages: [ChatMessage] = []
    var user = User.getObject(withId: NetworkManager.getUserId())
    
    let refreshControl = UIRefreshControl()
    
    init(albumId : String) {
        self.albumId = albumId
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var backgroundImage : UIImageView!
    
    
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackgroudImage()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
        title = "Chat"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        NetworkManager.getChatMessagesListener(idAlbum: albumId)
        
        self.loadFirstMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "messagesListener"), object: nil)       
        
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.loadFirstMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func loadFirstMessages() {
        DispatchQueue.main.async {
            self.messages = Message.all(withTopic: self.albumId).map({ (msg) -> ChatMessage in
                return ChatMessage(msg: msg)
            })
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    //    @objc func loadMoreMessages() {
    //
    //        guard let id = reference?.chatId else {
    //            self.refreshControl.endRefreshing()
    //            return
    //
    //        }
    //
    //                DispatchQueue.main.async {
    //                    FirebaseChatDatabase.listenerMessages(chanelID: id, directChat: false) { success in
    //                        self.messages = []
    //                        for message in Message.all() {
    //                            self.messages.append(Msg(text: message.messageText, sender: Sender(id: message.senderId, displayName: message.senderName), messageId: message.id, date: message.sentDate))
    //                        }
    //                        self.messagesCollectionView.reloadDataAndKeepOffset()
    //                        self.refreshControl.endRefreshing()
    //                    }
    //
    //                }
    //
    //    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.backgroundColor = .clear
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        //        messagesCollectionView.addSubview(refreshControl)
        //        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        
        
        messageInputBar.inputTextView.tintColor = UIColor.white
        messageInputBar.sendButton.tintColor = UIColor.gray
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: ChatMessage) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
       
        return Sender(id: user?.id ?? (""), displayName: user?.fullName() ?? (""))
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        debugPrint(messages.count)
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        debugPrint(messages[indexPath.section])
        return messages[indexPath.section]
        
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        

        return nil
    }
    
}


// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        
        for component in inputBar.inputTextView.components {
            
            
            if let str = component as? String {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
                
                let message = Message(topicId: albumId, id: UUID().uuidString, messageText: str, senderName: currentSender().displayName, senderId: currentSender().id, sentDate : dateFormatter.string(from: Date()))
                
                
                NetworkManager.sendMessage(id: UUID().uuidString, senderName: User.getObject(withId: NetworkManager.getUserId())?.fullName() ?? "User", senderId: NetworkManager.getUserId(), sentDate: Date().dateInString, messageText: str, topicId: albumId) { (success, err) in
                    print(success, err)
                }

                    inputBar.inputTextView.text = String()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
                
            }
            
        
        
    }
    
}

