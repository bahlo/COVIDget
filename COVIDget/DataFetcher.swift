//
//  DataFetcher.swift
//  COVIDget
//
//  Created by Arne Bahlo on 21.09.20.
//

import Foundation
import Combine

public class DataFetcher: ObservableObject {
    var cancellable: Set<AnyCancellable> = []
    
    static let shared = DataFetcher()
    
    func getDistrictData(completion: @escaping (DistrictData) -> Void) {
        let urlComponents = URLComponents(string: "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=1%3D1&outFields=OBJECTID,GEN,cases,cases_per_100k,cases7_per_100k,last_update&returnGeometry=false&outSR=4326&f=json")!
        URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map{ $0.data }
            .decode(type: DistrictData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // nop
            }) { response in
            completion(response)
        }
        .store(in: &cancellable)
    }
    
    func getAttributes(objectId: Int, completion: @escaping (DistrictAttributes) -> Void) {
        let urlComponents = URLComponents(string: "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=OBJECTID%3D\(objectId)&outFields=OBJECTID,GEN,cases,cases_per_100k,cases7_per_100k,last_update&returnGeometry=false&outSR=4326&f=json")!
        URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map{ $0.data }
            .decode(type: DistrictData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // nop
            }) { response in
                completion(response.features[0].attributes)
        }
        .store(in: &cancellable)
    }
}

struct DistrictData: Decodable {
    let features: [DistrictFeature]
    
    enum CodingKeys: String, CodingKey {
        case features = "features"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        features = try values.decode([DistrictFeature].self, forKey: .features)
    }
}

struct DistrictFeature: Decodable {
    let attributes: DistrictAttributes

    enum CodingKeys: String, CodingKey {
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try values.decode(DistrictAttributes.self, forKey: .attributes)
    }
}

struct DistrictAttributes: Decodable {
    let gen: String
    let cases: Int
    let casesPer100k: Float64
    let cases7Per100k: Float64
    let lastUpdate: String
    let objectId: Int
    
    enum CodingKeys: String, CodingKey {
        case gen = "GEN"
        case cases = "cases"
        case casesPer100k = "cases_per_100k"
        case cases7Per100k = "cases7_per_100k"
        case lastUpdate = "last_update"
        case objectId = "OBJECTID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gen = try values.decode(String.self, forKey: .gen)
        cases = try values.decode(Int.self, forKey: .cases)
        casesPer100k = try values.decode(Float64.self, forKey: .casesPer100k)
        cases7Per100k = try values.decode(Float64.self, forKey: .cases7Per100k)
        lastUpdate = try values.decode(String.self, forKey: .lastUpdate)
        objectId = try values.decode(Int.self, forKey: .objectId)
    }
}
