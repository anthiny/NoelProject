import Foundation

class ContactInfo {
    let name: String
    var phoneNumber: String
    var companyName: String
    var email: String
    
    init(name: String, phoneNumber: String, companyName: String, email: String)
    {
        self.name = name
        self.phoneNumber = phoneNumber
        self.companyName = companyName
        self.email = email
    }
    
    func exchangeToQRString() -> String{
        let QRString = "\(name)$\(phoneNumber)$\(companyName)$\(email)"
        return QRString
    }
}

