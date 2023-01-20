//
//  MagazineDetail.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineDetailView: View {
    @State private var offsetY: CGFloat = CGFloat.zero
    
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
                                Text("희경쨩")
                                    .bold()
                                
                                HStack {
                                    Text("1분전")
                                    Spacer()
                                    Text("연남동 어딘가 ")
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
                     Section(header: Header() ){
                        
                         
                         VStack {
                             Text("국회는 헌법 또는 법률에 특별한 규정이 없는 한 재적의원 과반수의 출석과 출석의원 과반수의 찬성으로 의결한다. 가부동수인 때에는 부결된 것으로 본환경권의 내용과 행사에 관하여는 법률로 정한다. 모든 국민은 종교의 자유를 가진다. 법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다.ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ.ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ.ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ")
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
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("크리스마스 사진 찍기")
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
struct MagazineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagazineDetailView()
        }
        
    }
}
