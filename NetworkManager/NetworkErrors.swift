//
//  NetworkErrors.swift
//  PokedexFinal
//
//  Created by Redghy on 5/5/22.
//

//Just network errors enum just in case
import Foundation

enum networkError: Error {
    case badURL
    case badData
    case badServerResponse(Int)
    case decodeError(String)
    case generalError(Error)
}

extension networkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("Bad URL, could not convert input string to a URL", comment: "Bad URL")
        case .badData:
            return NSLocalizedString("Bad Data, the data was corrupted or missing", comment: "Bad Data")
        case .badServerResponse(let statusCode):
            return NSLocalizedString("The network was not successful, received error code \(statusCode)", comment: "Bad Server Response")
        case .decodeError(let message):
            return NSLocalizedString("Decoding failure. Something is missing in the model object or incorrect. Docding message: \(message)", comment: "Decode Error")
        case .generalError(let err):
            return NSLocalizedString("General Error that is unknown. Logged info: \(err)", comment: "General Error")
        }
    }
    
}
