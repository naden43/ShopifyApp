import Foundation

struct ReturnAddress: Codable {
    var id : Int?
    var customer_id : Int?
    var first_name: String?
    var last_name: String?
    var address1: String?
    var city: String?
    var country: String?
    var phone: String?
    var `default`:Bool?
    
}


struct CustomerAddress: Codable {
    let address: Address
    
    struct Address: Codable {
        let address1: String
        let city: String
        let province: String
        let country: String
        let zip: String
    }
}

struct CustomAddress : Codable{
    
    var customer_address  : ReturnAddress
    
}

struct AddressObject : Codable {
    
    var address : ReturnAddress
    
}

class UserAddresses : Codable {
    
    var addresses : [ReturnAddress]
    
    init(addresses: [ReturnAddress]) {
        self.addresses = addresses
    }
}
