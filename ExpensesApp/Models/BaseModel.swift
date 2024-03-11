//
//  BaseModel.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/21/21.
//

import Foundation

class BaseModel<Element: Codable>: Codable, Error {
//MARK: - Properties
    var status: Bool = false
    var data: Element?
    var dataArray: [Element] = []
    var dataInt: Int = 0
    var responseCode: Int = -1
    var message: String = "Defualt Error"
    var titleMessage: String = "Error"
    var totalCount: Int = 0
    enum CodingKeys: String, CodingKey {
        case status, data, dataInt, responseCode, message, totalCount
        case titleMessage = "title"
    }
//MARK: - Initializers
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BaseModel<Element>.CodingKeys> = try decoder.container(keyedBy: BaseModel<Element>.CodingKeys.self)
        self.status = try container.decodeIfPresent(Bool.self, forKey: BaseModel<Element>.CodingKeys.status) ?? false
        if let decodedData = try? container.decodeIfPresent(Element.self, forKey: BaseModel<Element>.CodingKeys.data) {
            self.data = decodedData
        }else if let decodedData = try? container.decodeIfPresent([Element].self, forKey: BaseModel<Element>.CodingKeys.data) {
            self.dataArray = decodedData
        }
//        self.data = try container.decodeIfPresent(Element.self, forKey: BaseModel<Element>.CodingKeys.data)
        self.dataInt = try container.decodeIfPresent(Int.self, forKey: BaseModel<Element>.CodingKeys.dataInt) ?? 0
        self.responseCode = try container.decodeIfPresent(Int.self, forKey: BaseModel<Element>.CodingKeys.responseCode) ?? -1
        self.message = try container.decodeIfPresent(String.self, forKey: BaseModel<Element>.CodingKeys.message) ?? "Defualt Error"
        self.totalCount = try container.decodeIfPresent(Int.self, forKey: BaseModel<Element>.CodingKeys.totalCount) ?? 0
        self.titleMessage = try container.decodeIfPresent(String.self, forKey: BaseModel<Element>.CodingKeys.titleMessage) ?? "Error"
    }
    init() {
    }
}
