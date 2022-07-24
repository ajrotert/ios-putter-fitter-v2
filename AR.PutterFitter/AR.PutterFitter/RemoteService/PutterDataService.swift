//
//  PutterDataService.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation
import FirebaseFirestore

protocol PutterDataService {
    func getPutterData(success: (([PutterData]) -> ())?, failure: ((Error?) -> ())?)
}

class RemotePutterDataService {
    private let db = Firestore.firestore()
}

extension RemotePutterDataService : PutterDataService {
    func getPutterData(success: (([PutterData]) -> ())?, failure: ((Error?) -> ())?) {
        db.collection("putterData").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                failure?(error)
                return
            }
            
            let data = documents.map { (queryDocumentSnapshot) -> PutterData in
                let data = queryDocumentSnapshot.data()
                let json = data["json"] as? String ?? ""
                
                let jsonData = json.data(using: .utf8)!
                let putterData: PutterData = try! JSONDecoder().decode(PutterData.self, from: jsonData)
                
                return putterData
            }
            
            success?(data)
        }
    }
}
