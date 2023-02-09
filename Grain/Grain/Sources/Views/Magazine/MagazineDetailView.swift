import SwiftUI
import FirebaseAuth
import Kingfisher

struct MagazineDetailView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    @State var isHeartToggle: Bool = false    // 하트 눌림 상황
    @StateObject var userVM = UserViewModel()
    @AppStorage("docID") private var docID : String?
    var currentUsers : CurrentUserFields?
    
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
                                    .font(.title2)
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
                userVM.fetchCurrentUser(userID: docID ?? "")
                
                // 이슈화 여기서 디스패치 거냐? 이전 뷰에서 전부 유저 데이터 패치
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                    if userVM.likedMagazineIdArr.filter{$0 == data.fields.id.stringValue}.contains(data.fields.id.stringValue){
//                        isHeartToggle = true  // 정훈 삽질
                    if userVM.likedMagazineIdArr.contains(where: { item in
                        item == data.fields.id.stringValue
                    }){
                        isHeartToggle = true
                    }else{
                        isHeartToggle = false
                    }
                }
                
            }
            .onDisappear{
                Task{
                    if isHeartToggle {
                        /// 추가 부분
                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "likedMagazineId", updateValue: data.fields.id.stringValue, isArray: true)
                    }else{
                        // FIXME: 고치기
                        /// 삭제부분 -> 배열 전체를 지움
                        await userVM.deleteUserSDK(updateDocument: docID ?? "", deleteKey: "likedMagazineId", deleteIndex: data.fields.id.stringValue, isArray: true)
//                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "likedMagazineId", updateValue: "1", isArray: true)
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
