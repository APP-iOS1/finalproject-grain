//
//  MagazineViewCell.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

import Kingfisher

struct MagazineViewCell: View {
    let data : MagazineDocument
    
    @ObservedObject var userVM: UserViewModel
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["ThumbnailImageError"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.9)
                .foregroundColor(.black)
                .overlay{
                    KFImage(URL(string: data.fields.image.arrayValue.values[0].stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Screen.maxWidth * 0.9, height: Screen.maxWidth * 0.9 )
                        .clipShape(Rectangle())
                      
                }
            
            Text(data.fields.title.stringValue)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .font(.title2)
                .frame(alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.top, 0)
                .padding(.bottom, -2)
                .frame(width: Screen.maxWidth * 0.9, alignment: .leading)
            
            Divider()
            
            HStack{
                Text("by")
                    .foregroundColor(.middleDarkGray)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                   
                
                Divider()
                
                if let user = userVM.users.first(where: { $0.fields.id.stringValue == data.fields.userID.stringValue })
                {
                    Text(user.fields.nickName.stringValue)
                        .font(.subheadline)
                        .bold()
                }

                Spacer()
                Text(data.createTime.toDate()?.renderTime() ?? "")
                    .font(.caption)
                    .foregroundColor(.middleDarkGray)
            }
            .padding(.horizontal,5)
            .padding(.top, -2)
            
            
            Spacer()
        }
        .padding()
        .padding(.bottom, 13)
        
    }
}

struct MagazineViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MagazineViewCell(data: MagazineDocument(fields: MagazineFields(filmInfo: MagazineString(stringValue: ""), id: MagazineString(stringValue: ""), customPlaceName: MagazineString(stringValue: ""), longitude: MagazineLocation(doubleValue: 0), title: MagazineString(stringValue: ""), comment: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), lenseInfo: MagazineString(stringValue: ""), userID: MagazineString(stringValue: ""), image: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), likedNum: LikedNum(integerValue: ""), latitude: MagazineLocation(doubleValue: 0), content: MagazineString(stringValue: ""), nickName: MagazineString(stringValue: ""), roadAddress: MagazineString(stringValue: ""), cameraInfo: MagazineString(stringValue: "")), name: "", createTime: "", updateTime: ""), userVM: UserViewModel())
    }
}
