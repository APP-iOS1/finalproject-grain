//
//  MagazineViewCell.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineViewCell: View {
    
    var body: some View {
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
            Group{
                HStack{
                    Text("크리스마스 사진 찍기")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.vertical, -30)
            
                Text("국회는 헌법 또는 법률에 특별한 규정이 없는 한 재적의원 과반수의 출석과 출석의원 과반수의 찬성으로 의결한다. 가부동수인 때에는 부결된 것으로 본환경권의 내용과 행사에 관하여는 법률로 정한다. 모든 국민은 종교의 자유를 가진다. 법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다.")
                    .lineLimit(2)
                    .padding(.vertical, -30)
                    .foregroundColor(Color.textGray)
                    
            }
            .padding()
                
            Spacer()
        }
        .frame(height: Screen.maxHeight * 0.5)
    }
}

struct MagazineViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MagazineViewCell()
    }
}
