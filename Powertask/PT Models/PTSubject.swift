//
//  Subjects.swift
//  Powertask
//
//  Created by Daniel Torres on 31/1/22.
//
// prueba

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import CoreServices


final class PTSubject: NSObject, NSItemProviderReading, NSItemProviderWriting, Codable {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(UTType.data.identifier as String)]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> PTSubject {
        let decoder = JSONDecoder()
            do {
              //Here we decode the object back to it's class representation and return it
                let subject = try decoder.decode(PTSubject.self, from: data)
                print(subject)
              return subject
            } catch {
              fatalError()
            }
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [(UTType.data.identifier as String)]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        print("load data")
        let progress = Progress(totalUnitCount: 100)
            do {
              //Here the object is encoded to a JSON data object and sent to the completion handler
              let data = try JSONEncoder().encode(self)
              progress.completedUnitCount = 100
              completionHandler(data, nil)
            } catch {
              completionHandler(nil, error)
            }
            return progress
    }
    
    
        
    
    var id: Int
    var name: String
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
    }
    
//    init(name: String, color: String) {
//        self.name = name
//        self.color = color
//    }
}


@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
