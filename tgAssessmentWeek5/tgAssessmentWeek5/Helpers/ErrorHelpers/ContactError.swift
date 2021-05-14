//
//  ContactError.swift
//  tgAssessmentWeek5
//
//  Created by Tim Green on 5/14/21.
//

import Foundation

enum ContactError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordsFound
    
    var errorDescription: String? {
        switch self {
            
        case .ckError(let error):
            return "There was an error -- |(error) -- \(error.localizedDescription)."
        case .couldNotUnwrap:
            return "There was an error unwrapping the contact."
        case .unexpectedRecordsFound:
            return "There were unexpected contact records found on CloudKit."
        }
    }
} // End of enum
