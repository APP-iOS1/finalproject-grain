//
//  EditorView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct EditorView: View {
    
    @ObservedObject var editorVM : EditorViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM : MagazineViewModel
    
    let pastedboard = UIPasteboard.general
    @State private var copiedComplete: Bool = false
    
    func errorImage() -> String{
        var https : String = "https://"
        if let infolist = Bundle.main.infoDictionary {
            if let url = infolist["PreparingImage"] as? String {
                https += url
            }
        }
        return https
    }
    
    var body: some View {
        ScrollView {
            VStack{
                //MARK: 장소
                HStack{
                    Text(editorVM.editorData[0].fields.region.stringValue)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.leading , 15)
                .padding(.bottom, -10)
                //MARK: 제목
                HStack{
                    Text(editorVM.editorData[0].fields.title.stringValue)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .padding(.bottom, 6)
                    Spacer()
                }
                
                HStack {
                    if let user = userVM.users.first(where: { $0.fields.id.stringValue == editorVM.editorData[0].fields.userID.stringValue})
                    {
                        NavigationLink {
                            UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                        } label: {
                            MagazineProfileImage(imageName: user.fields.profileImage.stringValue)   // 에디터 프로필 이미지 뷰를 만들 수 있었지만 재사용해도 문제없을 거 같아 사용
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text(editorVM.editorData[0].fields.nickName.stringValue)
                            .bold()
                        Text(editorVM.editorData[0].createTime.toDate()?.renderTime() ?? "")
                            .font(.caption)
                            .foregroundColor(.textGray)
                        
                    }
                    Spacer()
                }
                .padding(5)

            }
            Divider()
                .frame(maxWidth: Screen.maxWidth * 0.94)
                .background(Color.black)
                .padding(.top, 5)
                .padding(.bottom, 15)
                .padding(.horizontal, Screen.maxWidth * 0.04)
            
            VStack{
                
                // MARK: - 포스트 첫 번째
                VStack{
                  
                    KFImage(URL(string: editorVM.editorData[0].fields.postImage1.stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    
                    Text(editorVM.editorData[0].fields.postContent1.stringValue)
                        .lineSpacing(4.0)
                        .padding()
                        .foregroundColor(Color.textGray)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                }
                
                // MARK: - 포스트 두 번째
                VStack{
                    
                    KFImage(URL(string: editorVM.editorData[0].fields.postImage2.stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    Text(editorVM.editorData[0].fields.postContent2.stringValue)
                        .lineSpacing(4.0)
                        .padding()
                        .foregroundColor(Color.textGray)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                       
                }
                
                // MARK: - 포스트 세 번째
                VStack{
                    KFImage(URL(string: editorVM.editorData[0].fields.postImage3.stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    Text(editorVM.editorData[0].fields.postContent3.stringValue)
                        .lineSpacing(4.0)
                        .padding()
                        .foregroundColor(Color.textGray)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                }

                // MARK: - 포스트 네 번째
                VStack{

                    KFImage(URL(string: editorVM.editorData[0].fields.postImage4.stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    Text(editorVM.editorData[0].fields.postContent4.stringValue)
                        .lineSpacing(4.0)
                        .padding()
                        .foregroundColor(Color.textGray)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                }
                
                // MARK: - 포스트 다섯 번째
                VStack{
                    KFImage(URL(string: editorVM.editorData[0].fields.postImage5.stringValue) ?? URL(string: errorImage()))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    Text(editorVM.editorData[0].fields.postContent5.stringValue)
                        .lineSpacing(4.0)
                        .padding()
                        .foregroundColor(Color.textGray)
                        .frame(width: Screen.maxWidth , alignment: .leading)
                }

            }
            
            Divider()
                .frame(maxWidth: Screen.maxWidth * 0.94)
                .background(Color.black)
                .padding(.top, 5)
                .padding(.bottom, 10)
                .padding(.horizontal, Screen.maxWidth * 0.04)
            
            // MARK: - 공고 모집
            VStack(alignment: .leading){
                Text("그레인 에디터를 희망하시는 분은")
                
                HStack(spacing: 0){
                    Text(verbatim: "filmgrain.official@gmail.com")
                        .foregroundColor(.vivaMagenta)
                        .onTapGesture {
                            pastedboard.string = "filmgrain.official@gmail.com"
                            self.copiedComplete = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.copiedComplete = false
                            }
                        }
                    Text(" 으로 메일을 보내주세요.")
                }
                
            }
            .font(.caption)
            .foregroundColor(.gray)
            .bold()
            .padding(.trailing)
           
        }
    }
}

//struct EditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditorView(editorVM: EditorViewModel(), userVM: UserViewModel(), magazineVM: MagazineViewModel())
//    }
//}
