//
//  TestGeocodeView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import SwiftUI

struct TestGeocodeView: View {
    @StateObject var geocodeVM = GeocodeAPIViewModel()
    func test(){
//        GeocodeService().fetchGeocode(GeocodeAPI.geocode.urlString)
//        print(GeocodeService().geocode)
    }
    var body: some View {
        VStack{
            Button {
                print(geocodeVM.addresses)
            } label: {
                Text("geocode")
            }
        }.onAppear{
            geocodeVM.fetchGeocode()
        }
        

    }
}
//
//struct TestGeocodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestGeocodeView()
//    }
//}
