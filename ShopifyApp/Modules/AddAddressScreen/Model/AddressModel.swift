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


struct Address: Codable {
    var id: Int?
    var customerId: Int?
    var firstName: String?
    var lastName: String?
    var company: String?
    var address1: String?
    var address2: String?
    var city: String?
    var province: String?
    var country: String?
    var zip: String?
    var phone: String?
    var name: String?
    var provinceCode: String?
    var countryCode: String?
    var countryName: String?
    var `default`: Bool?
    

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1
        case address2
        case city
        case province
        case country
        case zip
        case phone
        case name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case `default`
    }
}

struct AddressList: Codable {
    var addresses: [Address]?

    enum CodingKeys: String, CodingKey {
        case addresses = "addresses"
    }
}


struct CustomerAddress: Codable {
    var address: Address
    init(address: Address) {
        self.address = address
    }
}




/*struct CustomerAddress: Codable {
    let address: Address
    
    struct Address: Codable {
        let address1: String
        let city: String
        let province: String
        let country: String
        let zip: String
    }
}*/

struct CustomAddress : Codable{
    
    var customer_address  : ReturnAddress
    
}

struct AddressObject : Codable {
    
    var address : ReturnAddress
    
}

class UserAddresses : Codable {
    
    var addresses : [Address]
    
    init(addresses: [Address]) {
        self.addresses = addresses
    }
}
