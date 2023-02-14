import SwiftUI
import FirebaseAuth
import Kingfisher

struct MagazineDetailView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    @State private var isHeartToggle: Bool = false// 하트 눌림 상황
    @State private var isBookMarked: Bool = true
    @State private var isHeartAnimation: Bool = false
    @State private var heartOpacity: Double = 0
    
    @Environment(\.dismiss) private var dismiss
    
    let userVM: UserViewModel
    let currentUsers : CurrentUserFields?
    let data : MagazineDocument
    
    var body: some View {
        ScrollView {
            VStack{
                VStack {
                    // MARK: 닉네임 헤더
                    HStack {
                        ForEach(userVM.users.filter{
                            $0.fields.id.stringValue == data.fields.userID.stringValue
                        }, id: \.self){ item in
                            MagazineProfileImage(imageName: item.fields.profileImage.stringValue )
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text(data.fields.nickName.stringValue)
                                .bold()
                            HStack {
                                Text(data.createdDate?.renderTime() ?? "")
                                Spacer()
                                Text(data.fields.customPlaceName.stringValue)
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.top, -15)
                    
                    // MARK: 이미지
                    TabView{
                        ForEach(data.fields.image.arrayValue.values, id: \.self) { item in
                            Rectangle()
                                .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                                .overlay{
                                    KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            
                        }
                    }
                    .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                    .tabViewStyle(.page)
                    .overlay{
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                            .font(.system(size: isHeartAnimation ? 110 : 70 ))
                            .opacity(heartOpacity)
                    }
                    HStack{
                        // 하트버튼이 true -> false : userVM.likedMagazineID.remove(**) -> update
                        // 하트버튼이 false -> true : userVM.likedMagazineID.append(**)update
                        HeartButton(isHeartToggle: $isHeartToggle, isHeartAnimation: $isHeartAnimation, heartOpacity: $heartOpacity)
                            .padding(.leading)
                        NavigationLink {
                            MagazineCommentView(currentUser: userVM.currentUsers, collectionName: "Magazine", collectionDocId: data.fields.id.stringValue)
                        } label: {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        //MARK: 북마크 버튼
                        
                        Button {
                            isBookMarked.toggle()
                           
                        } label: {
                            Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                        }
                    }
                }//VStack
                .frame(minHeight: 350)
                // MARK: 제목
                Text(data.fields.title.stringValue)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                // MARK: 내용
                Text(data.fields.content.stringValue)
                    .lineSpacing(4.0)
                    .padding(.vertical, -9)
                    .padding()
                    .foregroundColor(Color.textGray)
                
                
                
                Spacer()
            }//VStack
        }//스크롤뷰
        .onAppear{
            // 유저가 좋아요를 눌렀는지 / 유저가 저장을 눌렀는지 를 통해  심볼을 fill 해줄건지 판단
            // 좋아요 버튼
            userVM.fetchUser()
            if userVM.likedMagazineID.contains(where: { item in
                item == data.fields.id.stringValue})
            {
                isHeartToggle = true
            }else{
                isHeartToggle = false
            }
            if userVM.bookmarkedMagazineID.contains(where: { item in
                item == data.fields.id.stringValue})
            {
                isBookMarked = true
            }else{
                isBookMarked = false
            }
        }
        .onDisappear{
            if isHeartToggle {
                // 좋아요 누름
                if !userVM.likedMagazineID.contains(data.fields.id.stringValue){
                    userVM.likedMagazineID.append(data.fields.id.stringValue)
                    if let user = userVM.currentUsers {
                        let arr = userVM.likedMagazineID
                        let docID =  user.id.stringValue
                        userVM.updateCurrentUserArray(type: "likedMagazineId", arr: arr, docID: docID)
                    }
                }
            } else {
                // 좋아요 취소
                if userVM.likedMagazineID.contains(data.fields.id.stringValue){
                    if let user = userVM.currentUsers {
                        if userVM.likedMagazineID.contains(data.fields.id.stringValue) {
                            let index = userVM.likedMagazineID.firstIndex(of: data.fields.id.stringValue)
                            userVM.likedMagazineID.remove(at: index!)
                            print("likedMagazineIDARR: \(userVM.likedMagazineID)")
                        }
                        //                            let arr = userVM.likedMagazineID.filter {$0 != data.fields.id.stringValue}
                        let docID = user.id.stringValue
                        userVM.updateCurrentUserArray(type: "likedMagazineId", arr: userVM.likedMagazineID, docID: docID)
                    }
                }
            }
            
            if isBookMarked {
                // 저장 누름
                if !userVM.bookmarkedMagazineID.contains(data.fields.id.stringValue){
                    userVM.bookmarkedMagazineID.append(data.fields.id.stringValue)
                    if let user = userVM.currentUsers {
                        let arr = userVM.bookmarkedMagazineID
                        let docID = user.id.stringValue
                        userVM.updateCurrentUserArray(type: "bookmarkedMagazineID", arr: arr, docID: docID)
                    }
                }
            } else {
                // 저장 취소
                if userVM.bookmarkedMagazineID.contains(data.fields.id.stringValue){
                    if let user = userVM.currentUsers {
                        let arr = userVM.bookmarkedMagazineID.filter {$0 != data.fields.id.stringValue}
                        let docID = user.id.stringValue
                        userVM.updateCurrentUserArray(type: "bookmarkedMagazineID", arr: arr, docID: docID)
                    }
                }
            }
            
        }
        .padding(.top, 1)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    // MARK: 현재 유저 Uid 값과 magazineDB userId가 같으면 수정 삭제 보여주기
                    if data.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                        NavigationLink {
                            MagazineEditView(data: data)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            //삭제
                            magazineVM.deleteMagazine(docID: data.name)
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

//struct MagazineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineDetailView(data: MagazineDocument(fields: MagazineFields(filmInfo: MagazineString(stringValue: ""), id: MagazineString(stringValue: ""), customPlaceName: MagazineString(stringValue: ""), longitude: MagazineLocation(doubleValue: 0), title: MagazineString(stringValue: ""), comment: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), lenseInfo: MagazineString(stringValue: ""), userID: MagazineString(stringValue: ""), image: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), likedNum: LikedNum(integerValue: ""), latitude: MagazineLocation(doubleValue: 0), content: MagazineString(stringValue: ""), nickName: MagazineString(stringValue: ""), roadAddress: MagazineString(stringValue: ""), cameraInfo: MagazineString(stringValue: "")), name: "", createTime: "", updateTime: ""))
//        }
//
//    }
//}

