//
//  PhotoSpotDetailView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/23.
//

import SwiftUI

// TODO: 포토스팟 마커 클릭시 넘어올 뷰
struct PhotoSpotDetailView: View {
    
    @State private var isBookMarked: Bool = false
    @State private var isliked: Bool = false
    @Environment(\.dismiss) private var dismiss
    var data : MagazineDocument
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                            VStack(alignment: .leading) {
                                Text(data.fields.nickName.stringValue)
                                    .bold()
                                HStack {
                                    Text("1분전")
                                    Spacer()
                                    Text(data.fields.customPlaceName.stringValue)
                                }
                                .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        .padding(.top, -15)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.9)
                            .background(Color.black)
                            .padding(.top, -5)
                            .padding(.bottom, -10)
                        
                        //            Image("line")
                        //                .resizable()
                        //                .frame(width: Screen.maxWidth, height: 0.3)
                        TabView{
                            ForEach(1..<4, id: \.self) { i in
                                Image("\(i)")
                                    .resizable()
                                    .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(maxHeight: Screen.maxHeight * 0.27)
                        .padding()
                    }
                    .frame(minHeight: 350)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: Header(data: data) ){
                            VStack {
                                Text(data.fields.content.stringValue)
                                    .lineSpacing(4.0)
                                    .padding(.vertical, -9)
                                    .padding()
                                    .foregroundColor(Color.textGray)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 1)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 다른 용도로 쓰일수 있어서 우선 남겨둠
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
            }
        }
        
        
    }
}

//struct PhotoSpotDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoSpotDetailView()   // FIX
//    }
//}
