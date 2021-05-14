//
//  Contact.swift
//  tgAssessmentWeek5
//
//  Created by Tim Green on 5/14/21.
//

import CloudKit

class Contact {
    
    let contactName: String
    let phoneNumber: String?
    let emailAddress: String?
    var recordID: CKRecord.ID
    
    init(contactName: String, phoneNumber: String?, emailAddress: String?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.contactName = contactName
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.recordID = recordID
    }
} // End of class Contact

// MARK: - Extensions
extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let contactName = ckRecord[ContactStrings.contactNameTypeKey] as? String,
              let phoneNumber = ckRecord[ContactStrings.phoneNumberTypeKey] as? String,
              let emailAddress = ckRecord[ContactStrings.emailAddressTypeKey] as? String
        else { return nil }
        
        self.init(contactName: contactName, phoneNumber: phoneNumber, emailAddress: emailAddress, recordID: ckRecord.recordID)
    }
} // End of extension Contact

extension CKRecord {
    
    convenience init(contact: Contact) {
        
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.recordID)
        self.setValuesForKeys([
        
            ContactStrings.contactNameTypeKey : contact.contactName,
            ContactStrings.phoneNumberTypeKey : contact.phoneNumber as Any,
            ContactStrings.emailAddressTypeKey : contact.emailAddress as Any
        ])
    }
} // End of extension CKRecord

extension Contact: Equatable {
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
} // End of extension Contact: Equatable
