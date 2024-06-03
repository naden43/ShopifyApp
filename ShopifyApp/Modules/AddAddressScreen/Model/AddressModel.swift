import Foundation

struct Address: Codable {
    var first_name: String?
    var last_name: String?
    var address1: String?
    var city: String?
    var country: String?
    var phone: String?
    
    init(){
        
    }
    

}


struct customAddress : Codable{
    
    var customer_address  : Address
    
}

class userAddress : Codable {
    
    var addresses : [Address]
    
    init(addresses: [Address]) {
        self.addresses = addresses
    }
}
