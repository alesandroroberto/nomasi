//
//  FirebaseProvider.swift
//  nomasi
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import Foundation
import Firebase
import Prelude

typealias GetDocuments<Value: Decodable> = (_ path: String) -> Future<[Value],NSError>

struct FirebaseProvider {
    private let version: String
    private let firestore: Firestore
    private let language: Language
    
    init(version: String, firestore: Firestore, language: Language) {
        self.version = version
        self.firestore = firestore
        self.language = language
    }
    
    func documents<Value: Decodable>(path: String) -> Future<[Value],NSError> {
        return Future<[Value], NSError>() { callback in
            self.firestore.collection("versions/" + self.version + path).getDocuments() {
                if let snapshot = $0 {
                    let values: [Value] = snapshot
                        .documents
                        .map {
                            (self.liftLocalization
                                >>> FirebaseProvider.addDocumentId($0.documentID)
                                >>> decodeJson)($0.data()) }
                        .compactMap(id)
                    callback(.success(values))
                } else if let error: NSError = $1 as NSError? {
                    callback(.failure(error))
                } else {
                    callback(.failure(NSError()))
                }
            }
        }
    }
}

extension FirebaseProvider {
    private static func addDocumentId(_ documentId: String) -> ([String: Any]) -> [String: Any] {
        return { list in
            return list.merging(["id": documentId], uniquingKeysWith: { arg1, _ in arg1 })
        }
    }
    private static func liftLocalizable(lang: Language) -> ([String: Any]) -> [String: Any] {
        return { list in
            guard
                let langLocalizable = list[lang.rawValue] as? [String: Any]
                else { return list }
            return list.merging(langLocalizable, uniquingKeysWith: { arg1, _ in arg1 })
        }
    }
    
    var liftLocalization: ([String: Any]) -> [String: Any] {
        FirebaseProvider.liftLocalizable(lang: self.language)
    }
}

func decodeJson<Value: Decodable>(data: [String: Any]) -> Value? {
    do {
        let serialization = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(Value.self, from: serialization)
    } catch {
        return nil
    }
}

enum Language: String {
    case ru
    case en
}

extension Language {
    init(locale: String) {
        if locale == "ru_RU" {
            self = .ru
            return
        }
        self = .en
    }
}
