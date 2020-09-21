//
//  DataFetcherTests.swift
//  COVIDGetTests
//
//  Created by Arne Bahlo on 21.09.20.
//

import XCTest
@testable import COVIDGet

class DataFetcherTests: XCTestCase {
    func testRealCall() throws {
        let expectation = self.expectation(description: "data received")
        var output: DistrictData?
        DataFetcher.shared.getDistrictData { (data) in
            output = data
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(output)
        XCTAssertGreaterThan(output!.features.count, 0)
    }
    
    func testDecode() throws {
        let data = """
        {
            "features": [
                {
                    "attributes": {
                        "ADE": 4,
                        "AGS": "01001",
                        "AGS_0": "01001000",
                        "BEM": "--",
                        "BEZ": "Kreisfreie Stadt",
                        "BL": "Schleswig-Holstein",
                        "BL_ID": "1",
                        "BSG": 1,
                        "DEBKG_ID": "DEBKGDL20000002R",
                        "EWZ": 89504,
                        "FK_S3": "R",
                        "GEN": "Flensburg",
                        "GF": 4,
                        "IBZ": 40,
                        "KFL": 56.73,
                        "NBD": "ja",
                        "NUTS": "DEF01",
                        "OBJECTID": 1,
                        "RS": "01001",
                        "RS_0": "010010000000",
                        "SDV_RS": "010010000000",
                        "SN_G": "000",
                        "SN_K": "01",
                        "SN_L": "01",
                        "SN_R": "0",
                        "SN_V1": "00",
                        "SN_V2": "00",
                        "Shape__Area": 49182929.6872559,
                        "Shape__Length": 42752.5920153776,
                        "WSK": "2008/01/01 00:00:00.000",
                        "cases": 83,
                        "cases7_per_100k": 2.23453700393279,
                        "cases_per_100k": 92.7332856632106,
                        "cases_per_population": 0.0927332856632106,
                        "county": "SK Flensburg",
                        "death_rate": 3.6144578313253,
                        "deaths": 3,
                        "last_update": "21.09.2020, 00:00 Uhr",
                        "recovered": null
                    }
                }
            ]
        }
        """
        let decoder = JSONDecoder()
        let districtData = try decoder.decode(DistrictData.self, from: Data(data.utf8))
        XCTAssertEqual(83, districtData.features[0].attributes.cases)
    }
}
