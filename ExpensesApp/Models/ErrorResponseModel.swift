//
//  ErrorResponseModel.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/28/21.
//

import Foundation
import Alamofire

class ErrorResponseModel: Error, Codable {
//MARK: - Properties
    var statusCode: Int = 1
    var status: Bool = false
    var responseCode: Int = -1
    var message: String = "Defualt Error"
    var titleMessage: String = "Error"
    var error: AFError?
    enum CodingKeys: String, CodingKey {
        case status, responseCode, message
        case titleMessage = "title"
    }
//MARK: - Initializer
    init<T: Codable>(base: BaseModel<T>, error: AFError?, statusCode: Int) {
        self.statusCode = statusCode
        self.status = base.status
        self.responseCode = base.responseCode
        self.message = base.message
        self.titleMessage = base.titleMessage
        self.error = error
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status) ?? false
        self.responseCode = try container.decodeIfPresent(Int.self, forKey: .responseCode) ?? -1
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? "Defualt Error"
        self.titleMessage = try container.decodeIfPresent(String.self, forKey: .titleMessage) ?? "Error"
    }
    init() {
    }
}
