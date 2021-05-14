//
//  ContactController.swift
//  tgAssessmentWeek5
//
//  Created by Tim Green on 5/14/21.
//

import CloudKit

class ContactController {
    
    // MARK: - Shared Instance
    static let sharedInstance = ContactController()
    
    // MARK: - SOURCE OF TRUTH
    var contacts: [Contact] = []
    
    // MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD Functions
    func createAndSaveContact(contactName: String, phoneNumber: String?, emailAddress: String?, completion: @escaping (Result<String, ContactError>) -> Void) {
        
        let newContact = Contact(contactName: contactName, phoneNumber: phoneNumber, emailAddress: emailAddress)
        let record = CKRecord(contact: newContact)
        
        privateDB.save(record) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record else { return completion(.failure(.couldNotUnwrap)) }
            guard let savedContact = Contact(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            self.contacts.insert(savedContact, at: 0)
            completion(.success("Successfully created and stored a new contact."))
        }
    } // End of function createAndSaveContact
    
    func updateContact(contact: Contact, completion: @escaping (Result<Contact, ContactError>) -> Void) {
        
        let record = CKRecord(contact: contact)
        let updateOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        updateOperation.savePolicy = .changedKeys
        updateOperation.qualityOfService = .userInteractive
        updateOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else { return completion(.failure(.couldNotUnwrap)) }
            guard let updatedContact = Contact(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            completion(.success(updatedContact))
        }
        
        privateDB.add(updateOperation)
    } // End of function updateContact
    
    func deleteContact(contact: Contact, completion: @escaping (Result<Bool, ContactError>) -> Void) {
        
        let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [contact.recordID])
        
        deleteOperation.savePolicy = .changedKeys
        deleteOperation.qualityOfService = .userInteractive
        deleteOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            if records?.count == 0 {
                print("Deleted conteact from CloudKit.")
                completion(.success(true))
            } else {
                return completion(.failure(.unexpectedRecordsFound))
            }
        }
        
        privateDB.add(deleteOperation)
    } // End of function deleteContact
    
    func fetchAllContacts(completion: @escaping (Result<String, ContactError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            let fetchedContacts = records.compactMap ({ Contact(ckRecord: $0) })
            self.contacts = fetchedContacts
            completion(.success("Sucessfully fetched contacts."))
        }
    } // End of function fetchAllContacts
} // End of class ContactController
