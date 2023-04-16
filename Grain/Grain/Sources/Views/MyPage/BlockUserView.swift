//
//  BlockUserView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/15.
//

import SwiftUI
import Kingfisher

struct BlockUserView: View {
    @ObservedObject var userVM: UserViewModel
    
    func defaultProfileImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["FailProfileImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//TODO: - 차단한 유저만 보여주는 뷰인데 지금 모든 유저 보여주고 있음 이거 차단한 유저 리스트 보여지게 하고 차단 풀면 바로 사라지게 해야함(버튼의 기능은 다 작동함, UserViewModel에 filterUserBlocking(user: UserDocument)는 만들어 놨는데 userDocument를 어떤식으로 전달받아햐하는지 헷갈려서 못함)
                ForEach(userVM.users, id: \.self) { item in
                    HStack {
                        KFImage(URL(string: item.fields.profileImage.stringValue) ?? URL(string: defaultProfileImage()))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(64)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 0.1)
                            }
                            .padding([.trailing, .leading], 10)
                        
                        Text(item.fields.nickName.stringValue)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 5)
                            .padding(.bottom, 1)
                        
                        Spacer()
                        Button {
                                
                                if let currentUser = userVM.currentUsers {
                                    var currentUserBlockingList: [String] = userVM.blockingList
                                    var UserBlockedList: [String] =  userVM.parsingBlockedDataToStringArr(data: item)
                                    
                                    /// 내 팔로잉리스트에 이사람 id 삭제
                                    currentUserBlockingList.removeAll {$0 ==  item.fields.id.stringValue}
                                    /// 이사람 팔로워리스트에 내 id 삭제
                                    UserBlockedList.removeAll {$0 == currentUser.id.stringValue}
                                    
                                    userVM.updateCurrentUserArray(type: "blocking", arr: currentUserBlockingList, docID: currentUser.id.stringValue)
                                    
                                    userVM.updateCurrentUserArray(type: "blocked", arr: UserBlockedList, docID: item.fields.id.stringValue)
                                }
                            
                            
                        } label: {
                            Text("차단해제")
                                .padding(.vertical, 6)
                                .padding(.horizontal, 8)
                                .foregroundColor(.black)
                                .bold()
                                .font(.caption)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .padding()
                        
                    }//hstack
                    .padding(.vertical, 2)
                } // foreach
            } // vstack
        } //scrollview
        .padding([.leading, .top], 10)
    }
}

//struct BlockUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlockUserView()
//    }
//}


