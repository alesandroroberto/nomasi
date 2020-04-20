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
typealias GetDocument<Value: Decodable> = (_ path: String) -> Future<Value,NSError>

struct FirebaseProvider {
    private let version: String
    private let firestore: Firestore
    private let auth: Auth
    private let language: Language
    
    init(version: String, firestore: Firestore, auth: Auth, language: Language) {
        self.version = version
        self.firestore = firestore
        self.auth = auth
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
                                >>> decodeJson)($0.data().mapValues(FirebaseProvider.replaceRefToPath)) }
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
    
    func documentWithVersion<Value: Decodable>(path: String) -> Future<Value,NSError> {
        return document(path: "versions/" + self.version + path)
    }
    
    func document<Value: Decodable>(path: String) -> Future<Value,NSError> {
        return Future<Value, NSError>() { callback in
            self.firestore.document(path).getDocument() {
                if let snapshot = $0?.data(), let documentId = $0?.documentID {
                    let mapper: ([String: Any]) -> Value? = self.liftLocalization
                        >>> FirebaseProvider.addDocumentId(documentId)
                        >>> decodeJson
                    if let value = snapshot.mapValues(FirebaseProvider.replaceRefToPath) |> mapper {
                        callback(.success(value))
                    } else {
                        callback(.failure(NSError()))
                    }
                } else if let error: NSError = $1 as NSError? {
                    callback(.failure(error))
                } else {
                    callback(.failure(NSError()))
                }
            }
        }
    }
    
    func setUserData(path: String, data: [String: Any]) -> Future<Void,NSError> {
        return Future<Void, NSError>() { callback in
            guard let uid = self.auth.currentUser?.uid else { callback(.failure(NSError())); return }
            self.firestore.document("users/" + uid + "/versions/" + self.version + path).setData(data) {
                if let error: NSError = $0 as NSError? {
                    callback(.failure(error))
                } else {
                    callback(.success(()))
                }
            }
        }
    }
    
    func addUserData(path: String, data: [String: Any]) -> Future<Void,NSError> {
        return Future<Void, NSError>() { callback in
            guard let uid = self.auth.currentUser?.uid else { callback(.failure(NSError())); return }
            self.firestore.collection("users/" + uid + "/versions/" + self.version + path).addDocument(data: data) {
                if let error: NSError = $0 as NSError? {
                    callback(.failure(error))
                } else {
                    callback(.success(()))
                }
            }
        }
    }
}

extension FirebaseProvider {
    private static func replaceRefToPath(value: Any) -> Any {
        guard let reference = value as? DocumentReference else { return value }
        return reference.path
    }
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
