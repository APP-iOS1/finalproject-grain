//
//  GridToScrollTest.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/13.
//

import SwiftUI

struct GridToScrollTest: View {
    var magazineArray = ["1","2","3"]
    @State private var selectedIndex: Int?
    
    let columns = [
//        GridItem(.adaptive(minimum: 100), spacing: 1)
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(magazineArray, id: \.self) { data in
                    NavigationLink {
//                        ScrollViewTest2(magazineArray: magazineArray, selectedIndex: $selectedIndex)
                    } label: {
                        Button {
                            selectedIndex = magazineArray.firstIndex(of: data)
                            
                        } label: {
                            Image(data)
                               .resizable()
    //                                   .aspectRatio(contentMode: .fit)
    //                                   .frame(width: 100)
                               .scaledToFill()
                               .frame(width: Screen.maxWidth / 3 - 1, height: Screen.maxWidth / 3 - 1)
                               .clipped()
                        }
                        
                    }
                    
                }
            }
        }
    }
}

struct GridToScrollTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            GridToScrollTest()
        }
    }
}

//struct ScrollViewTest2: View {
//    var magazineArray: [String]
//    @Binding var selectedIndex: Int?
//
//    var body: some View {
//        ScrollView{
//            ScrollViewReader { scrollview in
//                VStack{
////                    Button{
////                        selectedIndex = 3
////                    }label: {
////                        Text("dfd")
////                    }
//
//                    ForEach(magazineArray, id: \.self) { data in
//                        Image(data)
//                            .frame(width: 200, height: 100)
//                    }
//                    .onAppear {
//                        scrollview.scrollTo(selectedIndex, anchor: .top)
//                    }
//                }
//            }
//
//        }
//    }
//}

//struct ScrollViewTest2: View {
//    var magazineArray: [String]
//    @Binding var selectedIndex: Int?
//
//    var body: some View {
//        ScrollView{
//            ScrollViewReader { scrollView in
//
//                ForEach(0 ..< magazineArray.count) { index in
//                    Image(self.magazineArray[index])
//                        .frame(width: 200, height: 100)
//                        .id(index)
//                }
//
//                if selectedIndex != nil {
//                    Text("")
//                        .frame(width: 0, height: 0)
//                        .onAppear {
//                            scrollView.scrollTo(selectedIndex, anchor: .top)
//                        }
//                }
//            }
//        }
//    }
//}

