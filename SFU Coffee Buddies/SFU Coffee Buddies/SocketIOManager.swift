import UIKit

class SocketIOManager: NSObject {
    // so we can call this anywhere in the code
    static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    } //http://guarded-shore-21847.herokuapp.com
    // basic class SocketIOClient enable us to send  and receive message from the server
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.73:3000")! as URL)
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
        
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    //chatting
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    // sends the name  + message + date to client
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject?
            messageDictionary["message"] = dataArray[1] as! String as AnyObject?
            messageDictionary["date"] = dataArray[2] as! String as AnyObject?
            
            completionHandler(messageDictionary)
        }
    }
    
    
}
