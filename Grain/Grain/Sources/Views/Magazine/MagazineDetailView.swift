import SwiftUI
import FirebaseAuth
import Kingfisher

struct MagazineDetailView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    @State var isHeartToggle: Bool = false    // 하트 눌림 상황
    @StateObject var userVM = UserViewModel()
    @AppStorage("docID") private var docID : String?
    var currentUsers : CurrentUserFields?
    
    @State private var isBookMarked: Bool = false
    @State private var isHeartAnimation: Bool = false
    @State private var heartOpacity: Double = 0
    
    @Environment(\.dismiss) private var dismiss // <- 임시 방편
    
    let data : MagazineDocument
    
   
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    VStack {
                        // MARK: 닉네임 헤더
                        HStack {
                            Circle()
                                .frame(width: 40)
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
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.9)
                            .background(Color.black)
                            .padding(.top, -5)
                            .padding(.bottom, -10)
                        
                        // MARK: 이미지
                        TabView{
                            ForEach(data.fields.image.arrayValue.values, id: \.self) { item in
                                KFImage(URL(string: item.stringValue) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(maxHeight: Screen.maxHeight * 0.27)
                        .padding()
                        .overlay{
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .font(.system(size: isHeartAnimation ? 110 : 70 ))
                            //                                .scaleEffect(isHeartAnimation ? 5 : 1)
                                .opacity(heartOpacity)
                        }
                        HStack{
                            HeartButton(isHeartToggle: $isHeartToggle, isHeartAnimation: $isHeartAnimation, heartOpacity: $heartOpacity)
                                .padding(.leading)
                            NavigationLink {
                                MagazineCommentView()
                            } label: {
                                Image(systemName: "bubble.right")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                            //MARK: 북마크 버튼
                            Button {
                                isBookMarked.toggle()
                            } label: {
                                Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                    }//VStack
                    .frame(minHeight: 350)
                    // MARK: 스티키 헤더 제목과 건텐츠
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: MagazineDetailHeader(data: data) ){
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
                }//VStack
            }//스크롤뷰
            .onAppear{
                /// 뷰가 처음 생길떄 fetch 한번 한다.
                /// 유저가 좋아요를 눌렀는지 / 유저가 저장을 눌렀는지 를 통해  심볼을 fill 해줄건지 판단
                userVM.fetchCurrentUser(userID: docID ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){

                    if userVM.likedMagazineIdArr.contains(where: { item in
                        item == data.fields.id.stringValue})
                    {
                        isHeartToggle = true
                    }else{
                        isHeartToggle = false
                    }
                    
                    if userVM.userBookmarkedMagazine.contains(where: { item in
                        item == data.fields.id.stringValue})
                    {
                        isBookMarked = true
                    }else{
                        isBookMarked = false
                    }
                }
                
            }
            
            .onDisappear{
                /// restAPI 방식으로 수정 해야할 부분
                Task{
                    // 유저 DB에 좋아요 상태 저장/삭제
                    if isHeartToggle {
                        /// 추가 부분
                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "likedMagazineId", updateValue: data.fields.id.stringValue, isArray: true)
                    }else{
                        /// 삭제부분
                        await userVM.deleteUserUsingSDK(updateDocument: docID ?? "", deleteKey: "likedMagazineId", deleteIndex: data.fields.id.stringValue, isArray: true)
                    }
                    
                    // 유저 DB에 북마크 상태 저장/삭제
                    if isBookMarked {
                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "bookmarkedMagazineID", updateValue: data.fields.id.stringValue, isArray: true)
                    }else{
                        await userVM.deleteUserUsingSDK(updateDocument: docID ?? "", deleteKey: "bookmarkedMagazineID", deleteIndex: data.fields.id.stringValue, isArray: true)
                    }
                }
            }
            .padding(.top, 1)
        }
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

struct MagazineDetailHeader: View {
    var data : MagazineDocument
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(data.fields.title.stringValue)
                .font(.title2)
                .bold()
                .padding(.horizontal)
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
//            MagazineDetailView(data: MagazineDocument(fields: MagazineFields(filmInfo: MagazineString(stringValue: ""), id: MagazineString(stringValue: ""), customPlaceName: MagazineString(stringValue: ""), longitude: MagazineLocation(doubleValue: 0), title: MagazineString(stringValue: ""), comment: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), lenseInfo: MagazineString(stringValue: ""), userID: MagazineString(stringValue: ""), image: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), likedNum: LikedNum(integerValue: ""), latitude: MagazineLocation(doubleValue: 0), content: MagazineString(stringValue: ""), nickName: MagazineString(stringValue: ""), roadAddress: MagazineString(stringValue: ""), cameraInfo: MagazineString(stringValue: "")), name: "", createTime: "", updateTime: ""))
//        }
//
//    }
//}


//123 == 123 t
//123 == 1234 f
//12345 == 12345 f
//
