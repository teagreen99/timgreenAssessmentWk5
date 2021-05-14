//
//  ContactDetailViewController.swift
//  tgAssessmentWeek5
//
//  Created by Tim Green on 5/14/21.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let contactName = contactNameTextField.text, !contactName.trimmingCharacters(in: .whitespaces).isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty,
              let emailAddress = emailAddressTextField.text, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        ContactController.sharedInstance.createAndSaveContact(contactName: contactName, phoneNumber: phoneNumber, emailAddress: emailAddress) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    } // End of IBACTION function saveButtonTapped

    

    
    
    
    // MARK: - Helper Functions
    func updateViews() {
        if let contact = contact {
            contactNameTextField.text = contact.contactName
            phoneNumberTextField.text = contact.phoneNumber
            emailAddressTextField.text = contact.emailAddress
        }
    }
} // End of class ContactDetailViewController



