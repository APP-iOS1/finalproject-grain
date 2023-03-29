import SwiftUI
import FirebaseAuth
import Kingfisher

struct MagazineDetailView: View {
    @ObservedObject var magazineVM : MagazineViewModel
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var mapVM = MapViewModel()
    
    @State private var isHeartToggle: Bool = false // 하트 눌림 상황
    @State private var isBookMarked: Bool = true
    @State private var isHeartAnimation: Bool = false
    @State private var isHeartAnimationTwo: Bool = false
    @State private var heartOpacity: Double = 0
    @State private var heartOpacityTwo: Double = 0
    @State private var saveOpacity: Double = 0
    @State private var showDevices: Bool = false
    @State private var currentAmount: CGFloat = 0
    @State private var dragOffset = CGSize.zero
    @State private var firstImage: Image?
    @State private var renderedImage: Image? = nil
    @State private var isDeleteAlertShown:Bool = false
    @State private var lifetime: Float = 0
    @State private var imageScale: CGFloat = 1
    
    @Environment(\.dismiss) private var dismiss
    
    let data : MagazineDocument
    @State var magazineData: MagazineDocument?
    
    @Binding var ObservingChangeValueLikeNum : String   // 좋아요 수의 변화를 관찰합니다.
    
    @SceneStorage("isZooming") var isZooming: Bool = false
    @SceneStorage("index") var selectedIndex: Int = 0
    @Environment(\.displayScale) var displayScale
    
    func render() {
        let renderer = ImageRenderer(content: sharedView)
        
        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
    @MainActor
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    if let magazineData = self.magazineData {
                        VStack {
                            // MARK: 닉네임 헤더
                            HStack {
                                if let user = userVM.users.first(where: { $0.fields.id.stringValue == magazineData.fields.userID.stringValue })
                                {
                                    NavigationLink {
                                        UserDetailView(userVM: userVM, magazineVM: magazineVM, user: user)
                                    } label: {
                                        MagazineProfileImage(imageName: user.fields.profileImage.stringValue)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        Text(user.fields.nickName.stringValue)
                                            .bold()
                                        Text(magazineData.createTime.toDate()?.renderTime() ?? "")
                                            .font(.caption)
                                            .foregroundColor(.textGray)
                                        
                                    }
                                } else {
                                    Text("유저 없음")
                                }
                                Spacer()
                                VStack{
                                    Spacer()
                                    Text(magazineData.fields.customPlaceName.stringValue)
                                        .foregroundColor(.textGray)
                                        .font(.caption)
                                        .padding(.trailing , Screen.maxWidth * 0.03)
                                    
                                }
                            }
                            .padding(5)
                            
                            // MARK: 이미지
                            ForEach(Array(data.fields.image.arrayValue.values.enumerated()), id: \.1.self) { (index, item) in
                                Rectangle()
                                    .frame(width: Screen.maxWidth, height: Screen.maxWidth)
                                    .overlay {
                                        KFImage(URL(string: item.stringValue) ?? URL(string: "https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .tag(index)
                                
                            }
                            .addPinchZoom()
                            .onTapGesture(count: 2) {
                                isHeartAnimationTwo = false
                                HapticManager.instance.impact(style: .medium)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    withAnimation(.interpolatingSpring(mass: 0.35, stiffness: 100, damping: 4.5, initialVelocity: 25)) {
                                        
                                        self.isHeartAnimationTwo = true
                                        
                                    }
                                    self.heartOpacityTwo = 1
                                    
                                }
                                
                                self.isHeartToggle = true
                                
                                withAnimation(Animation.linear(duration: 0.1)) {
                                    self.imageScale = 0.8
                                    
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(Animation.linear(duration: 0.17)) {
                                        self.imageScale = 1
                                        self.lifetime = 1
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    withAnimation {
                                        self.lifetime = 0
                                        
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    self.heartOpacityTwo = 0
                                    
                                }
                                
                                
                                
                            }
                            .frame(width: Screen.maxWidth , height: Screen.maxWidth)
                            .overlay{
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: isHeartAnimation ? 95 : 60 ))
                                    .opacity(heartOpacity)
                            }
                            .overlay{
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: isHeartAnimationTwo ? 95 : 30 ))
                                    .opacity(heartOpacityTwo)
                            }
                            .overlay{
                                Group{
                                    Rectangle()
                                        .frame(width:
                                                Screen.maxWidth * 0.3, height: Screen.maxWidth * 0.3, alignment: .center)
                                        .foregroundColor(.black)
                                        .cornerRadius(7)
                                        .opacity(0.8)
                                        .overlay{
                                            VStack{
                                                Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark.slash.fill")
                                                    .foregroundColor(.white)
                                                    .font(.title)
                                                    .padding(.bottom,5)
                                                Text(isBookMarked ? "저장됨" : "저장 취소됨")
                                                    .foregroundColor(.white)
                                                    .bold()
                                            }
                                        }
                                    
                                }
                                .opacity(saveOpacity)
                            }
                            .zIndex(.infinity)
                            
                            //.tag(index) // 문제시 고치기
                            
                            
                            
                            VStack(alignment: .leading){
                                HStack{
                                    VStack{
                                        Button{
                                            showDevices.toggle()
                                            //                                transitionView.toggle()
                                        } label: {
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Text("장비 정보")
                                                        .font(.subheadline)
                                                    Image(systemName: "chevron.right")
                                                        .font(.caption)
                                                        .rotationEffect(Angle(degrees: self.showDevices ? 90 : 0))
                                                        .animation(.linear(duration: self.showDevices ? 0.1 : 0.1), value: showDevices)
                                                }
                                                .bold()
                                            }
                                            .padding(.top, 5)
                                        }
                                        
                                    }
                                    .padding(.leading, 20)
                                    .padding(.top, -5)
                                    .foregroundColor(.textGray)
                                    
                                    Spacer()
                                    // 하트버튼이 true -> false : userVM.likedMagazineID.remove(**) -> update
                                    // 하트버튼이 false -> true : userVM.likedMagazineID.append(**)update
                                    HeartButton(lifetime: $lifetime, imageScale: $imageScale, isHeartToggle: $isHeartToggle, isHeartAnimation: $isHeartAnimation, heartOpacity: $heartOpacity)
                                        .padding(.leading)
                                    
                                    NavigationLink {
                                        MagazineCommentView(userVM: userVM, magazineVM: magazineVM, collectionName: "Magazine", collectionDocId: magazineData.fields.id.stringValue)
                                    } label: {
                                        Image(systemName: "bubble.right")
                                            .font(.system(size: 23))
                                            .foregroundColor(.black)
                                            .padding(.top, 2)
                                    }
                                    //                        Spacer()
                                    
                                    //MARK: 북마크 버튼
                                    Button {
                                        self.isBookMarked.toggle()
                                        self.saveOpacity = 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.saveOpacity = 0
                                        }
                                    } label: {
                                        Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.trailing)
                                    
                                }
                                .padding(.top, 5)
                                
                                if showDevices {
                                    VStack(alignment: .leading){
                                        Text("바디 | \(magazineData.fields.cameraInfo.stringValue)")
                                        Text("렌즈 | \(magazineData.fields.lenseInfo.stringValue)")
                                        Text("필름 | \(magazineData.fields.filmInfo.stringValue)")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.textGray)
                                    .padding(.top, -9)
                                    .padding(.leading, 20)
                                }
                            }
                            
                        }//VStack
                        .frame(minHeight: 350)
                        .zIndex(1)
                        
                        VStack{
                            
                            // MARK: 제목
                            Text(magazineData.fields.title.stringValue)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                                .frame(width: Screen.maxWidth , alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(.top)
                                .padding(.bottom, 6)
                            
                            
                            // MARK: 내용
                            Text(magazineData.fields.content.stringValue)
                                .lineSpacing(7.0)
                                .padding(.horizontal)
                                .foregroundColor(Color.textGray)
                                .frame(width: Screen.maxWidth , alignment: .leading)
                            
                            Spacer()
                        }
                        .zIndex(0)
                    }//VStack
                }
            }//스크롤뷰
            .alert(isPresented: $isDeleteAlertShown) {
                Alert(title: Text("게시물을 삭제하시겠어요?"),
                      message: Text("게시물을 삭제하면 영구히 삭제되고 복원할 수 없습니다."),
                      primaryButton:  .cancel(Text("취소")),
                      secondaryButton:.destructive(Text("삭제"),
                                                   action: {
                    if let magazineData = self.magazineData {
                        magazineVM.deleteMagazine(docID: magazineData.fields.id.stringValue)
                        mapVM.deleteMap(docID: magazineData.fields.id.stringValue)
                        dismiss()
                    }
                }))
            }
            .onAppear{
                magazineData = data
                // 희경: 유저 팔로워, 팔로잉 업데이트 후 뒤로가기했다가 다시 들어갔을때 바로 반영안되는 issue
                // [해결] magazineDetailView의 onAppear 에서 fetchUser를 해주는 방식에서 userVM의 updateCurrentUserArray 메소드의 receivedValue 블록에 fetchUser 해주는 방식으로 변경
                // [이유] UserDetailView의 onDisappear메소드와 onAppear메소드간의 비동기처리가 문제였던것같다.
                // onDisappear에서 updateUser를 실행하는데 완료되기전에 onAppear를 해준듯.
                // 유저가 좋아요를 눌렀는지 / 유저가 저장을 눌렀는지 를 통해  심볼을 fill 해줄건지 판단
                // 좋아요 버튼
                if let magazineData = self.magazineData {
                    if userVM.likedMagazineID.contains(where: { item in
                        item == magazineData.fields.id.stringValue})
                    {
                        isHeartToggle = true
                    }else{
                        isHeartToggle = false
                    }
                    if userVM.bookmarkedMagazineID.contains(where: { item in
                        item == magazineData.fields.id.stringValue})
                    {
                        isBookMarked = true
                    }else{
                        isBookMarked = false
                    }
                    ObservingChangeValueLikeNum = magazineData.fields.likedNum.integerValue
                }
            }
            .task(id: magazineVM.magazines) {
                if let data = magazineVM.sortedTopLikedMagazineData.first(where: {
                    $0.fields.id.stringValue == data.fields.id.stringValue
                }) {
                    self.magazineData = data
                }
            }
            .onDisappear{
                selectedIndex = 0
                if isHeartToggle {
                    // 좋아요 누름
                    if !userVM.likedMagazineID.contains(data.fields.id.stringValue){
                        userVM.likedMagazineID.append(data.fields.id.stringValue)
                        if let user = userVM.currentUsers {
                            let arr = userVM.likedMagazineID
                            let docID =  user.id.stringValue
                            userVM.updateCurrentUserArray(type: "likedMagazineId", arr: arr, docID: docID)
                            
                            magazineVM.updateMagazine(num: Int(ObservingChangeValueLikeNum)! + 1, docID: data.fields.id.stringValue)  //좋아요 갯수 증가
                            ObservingChangeValueLikeNum = String(Int(ObservingChangeValueLikeNum)! + 1) //.task(id: ObservingChangeValueLikeNum) -> await magazineVM.fetchMagazine() 실행
                        }
                    }
                } else {
                    // 좋아요 취소
                    if userVM.likedMagazineID.contains(data.fields.id.stringValue){
                        if let user = userVM.currentUsers {
                            if userVM.likedMagazineID.contains(data.fields.id.stringValue) {
                                let index = userVM.likedMagazineID.firstIndex(of: data.fields.id.stringValue)
                                userVM.likedMagazineID.remove(at: index!)
                            }
                            //                            let arr = userVM.likedMagazineID.filter {$0 != data.fields.id.stringValue}
                            let docID = user.id.stringValue
                            userVM.updateCurrentUserArray(type: "likedMagazineId", arr: userVM.likedMagazineID, docID: docID)
                            
                            magazineVM.updateMagazine(num:  Int(ObservingChangeValueLikeNum)! - 1 , docID: data.fields.id.stringValue)    //좋아요 갯수 감소
                            ObservingChangeValueLikeNum = String(Int(ObservingChangeValueLikeNum)! - 1)  //.task(id: ObservingChangeValueLikeNum) -> await magazineVM.fetchMagazine() 실행
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                        }
                    })
                    .accentColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            //저장시 코드
                            self.isBookMarked.toggle()
                            self.saveOpacity = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.saveOpacity = 0
                            }
                        } label: {
                            HStack{
                                Text(isBookMarked ? "저장 취소" : "저장")
                                Spacer()
                                Image(systemName: isBookMarked ? "bookmark.slash.fill" : "bookmark.fill")
                            }
                        }
                        // MARK: 현재 유저 Uid 값과 magazineDB userId가 같으면 수정 삭제 보여주기
                        if data.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                            NavigationLink {
                                MagazineEditView(magazineVM: magazineVM, userVM: userVM, data: $magazineData)
                            }label: {
                                Text("수정")
                                Spacer()
                                Image(systemName: "square.and.pencil")
                            }
                            Button {
                                self.isDeleteAlertShown.toggle()
                            } label: {
                                Text("삭제")
                                Spacer()
                                Image(systemName: "trash")
                            }
                            
                            if let renderedImage{
                                
                                ShareLink(item: renderedImage,
                                          subject: Text("Flame Photo"),
                                          message: Text("\(data.fields.title.stringValue)"),
                                          preview: SharePreview(data.fields.title.stringValue, image: renderedImage))
                                
                            }
                            
                        }
                        
                    } label: {
                        Label("더보기", systemImage: "ellipsis")
                        
                    }
                    .onTapGesture {
                        DispatchQueue.main.async {
                            
                            render()
                        }
                    }
                }
            }
        }
    }
    var sharedView: some View {
        ForEach(Array(data.fields.image.arrayValue.values.enumerated()), id: \.1.self) { (index, item) in
            if index == selectedIndex{
                KFImage(URL(string: item.stringValue) ?? URL(string: "https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                    .resizable()
                    .frame(width: Screen.maxWidth, height: Screen.maxWidth)
                    .aspectRatio(contentMode: .fit)
                    .padding(0)
            }
        }
    }
}

struct SharingPhoto: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    public var image: Image
    public var caption: String
}


//struct MagazineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineDetailView(data: MagazineDocument(fields: MagazineFields(filmInfo: MagazineString(stringValue: ""), id: MagazineString(stringValue: ""), customPlaceName: MagazineString(stringValue: ""), longitude: MagazineLocation(doubleValue: 0), title: MagazineString(stringValue: ""), comment: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), lenseInfo: MagazineString(stringValue: ""), userID: MagazineString(stringValue: ""), image: MagazineComment(arrayValue: MagazineArrayValue(values: [MagazineString(stringValue: "")])), likedNum: LikedNum(integerValue: ""), latitude: MagazineLocation(doubleValue: 0), content: MagazineString(stringValue: ""), nickName: MagazineString(stringValue: ""), roadAddress: MagazineString(stringValue: ""), cameraInfo: MagazineString(stringValue: "")), name: "", createTime: "", updateTime: ""))
//        }
//
//    }
//}
