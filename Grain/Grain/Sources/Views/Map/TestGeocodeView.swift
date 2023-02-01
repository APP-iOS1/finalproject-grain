//
//  TestGeocodeView.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import SwiftUI

struct TestGeocodeView: View {
    @StateObject var naverVM = NaverAPIViewModel()
    func test(){
//        GeocodeService().fetchGeocode(GeocodeAPI.geocode.urlString)
//        print(GeocodeService().geocode)
    }
    var body: some View {
        VStack{
            Button {
                for i in naverVM.reverseGeocodeResult{
                    print(i.region.area1.name)
                    print(i.region.area2.name)
                    print(i.region.area3.name)
                }
                
            } label: {
                Text("geocode")
            }
        }.onAppear{
//            naverVM.fetchGeocode(requestAddress: "경기도 화성시 석우동")
            naverVM.fetchReverseGeocode(latitude: 37.2244573, longitude: 127.0719188)
        }
        

    }
}
//
//struct TestGeocodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestGeocodeView()
//    }
//}
