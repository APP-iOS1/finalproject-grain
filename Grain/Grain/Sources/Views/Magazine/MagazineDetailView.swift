//
//  MagazineDetail.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineDetailView: View {
    @State private var offsetY: CGFloat = CGFloat.zero
    var data : MagazineDocument
    
    private func setOffset(offset: CGFloat) -> some View {
           DispatchQueue.main.async {
               self.offsetY = offset
           }
           return EmptyView()
       }
    var body: some View {
        ScrollView {
            
             VStack{
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    setOffset(offset: offset)
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                            VStack(alignment: .leading
                            ) {
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
                    }
                .frame(minHeight: 350)
                 
                 
                 LazyVStack(pinnedViews: [.sectionHeaders]) {
                     Section(header: Header(data: data) ){


                         VStack {
                             Text(data.fields.content.stringValue)
                                 .padding(.vertical, -30)
                                 .foregroundColor(Color.textGray)

                         }


                     }
                     .padding()
                 }
                 .overlay(
                    Rectangle()
                        .border(.black)
                        .foregroundColor(.white)
                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(offsetY > -350 ? 0 : 1)
                    , alignment: .top
                 )
                 
                 Spacer()
                
                
            }
        }
    
    }
}
struct Header: View {
    var data : MagazineDocument
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(data.fields.title.stringValue)
                .font(.title2)
                .bold()
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        .background(Rectangle().foregroundColor(.white))
    }
}
//struct MagazineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineDetailView()
//        }
//
//    }
//}
