//
//  ChatViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 08/01/2019.
//

/*import UIKit
import Firebase
import MessageKit
import MessageInputBar

class ChatViewController: MessagesViewController {
    
    var messages : [Message] = []
    
    var albumId : String!
    var listener : ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        
        listener = NetworkManager.getChatMessagesListener(idAlbum: albumId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "messagesListener"), object: nil)
        
        /*NetworkManager.sendMessage(id: UUID().uuidString, senderName: User.getObject(withId: NetworkManager.getUserId())?.fullName() ?? "User", senderId: NetworkManager.getUserId(), sentDate: Date().dateInString, messageText: "The crazy forx", topicId: albumId) { (success, err) in
            print(success, err)
        }*/
        loadMessages()
    }
    
    init(albumId: String) {
        super.init(nibName: nil, bundle: nil)
        self.albumId = albumId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func notificationObserver(notification : Notification) {
        messages = Message.all(withTopic: albumId)
    }
    
    func loadMessages() {
        
        DispatchQueue.main.async {
            
            self.messages = []
            for message in Message.all(withTopic: self.albumId) {
                self.messages.append(message)
            }
            
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
            
        }
        
    }
    

}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: NetworkManager.getUserId(), displayName: User.getObject(withId: NetworkManager.getUserId())?.fullName() ?? "User")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return ChatMessage(msg: messages[indexPath.section])
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}



extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        print("Figah")
        /*guard let id = reference?.chatId else {
            return
        }*/
        
        for component in inputBar.inputTextView.components {
            
            //guard let topicId = reference?.chatId else { return }
            
            //FirebaseRemoteNotification.share.updateTokenIdNotificationsForMessages(taskId: topicId)
            
            if let str = component as? String {
                let message = Message(topicId: albumId, id: UUID().uuidString, messageText: str, senderName: currentSender().displayName, senderId: currentSender().id, sentDate: Date())
                
                
                NetworkManager.sendMessage(id: UUID().uuidString, senderName: User.getObject(withId: NetworkManager.getUserId())?.fullName() ?? "User", senderId: NetworkManager.getUserId(), sentDate: Date().dateInString, messageText: str, topicId: albumId) { (success, err) in
                    print(success, err)
                }
                
                //FirebaseChatDatabase.sendMessage(chanelID: id, directChat: false, message: message) { success in
                    //                    if success {
                    //                        do {
                    //                            let text = try Cryptor.share.decryptMessage(encryptedMessage: message.messageText)
                    //                            self.insertMessage(Msg(text: text, sender: Sender(id: message.senderId, displayName: message.senderName), messageId: message.id, date: message.sentDate))
                    //                            inputBar.inputTextView.text = String()
                    //                            self.messagesCollectionView.scrollToBottom(animated: true)
                    //                        } catch {
                    //                            self.insertMessage(Msg(text: message.messageText, sender: Sender(id: message.senderId, displayName: message.senderName), messageId: message.id, date: message.sentDate))
                    //                            inputBar.inputTextView.text = String()
                    //                            self.messagesCollectionView.scrollToBottom(animated: true)
                    //                        }
                    //
                    //                    }
                    inputBar.inputTextView.text = String()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
                
            }// else if let img = component as? UIImage {
                //                let message = Message(image: img, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                //                FirebaseChatDatabase.sendMessage(chanelID: id, directChat: false, message: message) { message in
                //                    if let message = message {
                //                        self.insertMessage(message)
                //                        inputBar.inputTextView.text = String()
                //                        self.messagesCollectionView.scrollToBottom(animated: true)
                //                    }
                //                }
            //}
            
        //}
        
    }
    
}*/


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
    
    var messages: [ChatMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    init() {
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
    
    /*private func addBackgroudImage() {
        backgroundImage = UIImageView(image: R.image.background())
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        //        leftConstraint.priority = .defaultHigh
        
        let rightConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        //        rightConstraint.priority = .defaultHigh
        
        let topConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        //        topConstraint.priority = .defaultHigh
        
        let bottomConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        //        bottomConstraint.priority = .defaultHigh
        
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
    }*/
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackgroudImage()
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
        title = "Aig"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        /*NetworkManager.getChatMessagesListener("BB64C1E3-487B-4E01-B5C6-F481DB9620ED") { listener in
            self.loadFirstMessages()
        }*/
        
        self.loadFirstMessages()
            
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func loadFirstMessages() {
        //        DispatchQueue.global(qos: .userInitiated).async {
        DispatchQueue.main.async {
            
            
            self.messages = []
            for message in Message.all(withTopic: "BB64C1E3-487B-4E01-B5C6-F481DB9620ED") {
                
                guard let date = self.dateFormatter.date(from: message.sentDate) else { continue }
                
                do {
                    let text = message.messageText
                    self.messages.append(ChatMessage(msg: message))
                } catch {
                    self.messages.append(ChatMessage(msg: message))
                }
            }
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
        //        }
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
       
        return Sender(id: "ErrorID", displayName: "Error")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
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
        
        //        let dateString = formatter.string(from: message.sentDate)
        //        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
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
                let message = Message(topicId: "BB64C1E3-487B-4E01-B5C6-F481DB9620ED", id: UUID().uuidString, messageText: str, senderName: currentSender().displayName, senderId: currentSender().id, sentDate: Date())
                
                
                NetworkManager.sendMessage(id: UUID().uuidString, senderName: User.getObject(withId: NetworkManager.getUserId())?.fullName() ?? "User", senderId: NetworkManager.getUserId(), sentDate: Date().dateInString, messageText: str, topicId: "BB64C1E3-487B-4E01-B5C6-F481DB9620ED") { (success, err) in
                    print(success, err)
                }
                    //                    if success {
                    //                        do {
                    //                            let text = try Cryptor.share.decryptMessage(encryptedMessage: message.messageText)
                    //                            self.insertMessage(Msg(text: text, sender: Sender(id: message.senderId, displayName: message.senderName), messageId: message.id, date: message.sentDate))
                    //                            inputBar.inputTextView.text = String()
                    //                            self.messagesCollectionView.scrollToBottom(animated: true)
                    //                        } catch {
                    //                            self.insertMessage(Msg(text: message.messageText, sender: Sender(id: message.senderId, displayName: message.senderName), messageId: message.id, date: message.sentDate))
                    //                            inputBar.inputTextView.text = String()
                    //                            self.messagesCollectionView.scrollToBottom(animated: true)
                    //                        }
                    //
                    //                    }
                    inputBar.inputTextView.text = String()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
                
            }
            
        
        
    }
    
}

