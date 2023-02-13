//
//  ScrollViewTest.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/08.
//

import SwiftUI

//struct ScrollViewTest: View {
//    let items: [String] = ["1","2","3","4","5","6","7"]
//
//       var body: some View {
//          ScrollView {
//             GeometryReader { geo in
//                VStack {
//                   ForEach(0 ..< items.count) { index in
//                      Text("Index: \(index)")
//                         .background(GeometryReader { innerGeo in
//                            Color.clear
//                               .onAppear {
//                                  print("Index \(index) frame: \(innerGeo.frame(in: .global))")
//                               }
//                         })
//                   }
//                }
//             }
//          }
//       }
//}
//
//struct ScrollViewTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollViewTest()
//    }
//}
