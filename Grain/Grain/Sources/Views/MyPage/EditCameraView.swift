//
//  EditCameraView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import FirebaseAuth

struct EditCameraView: View {

    @ObservedObject var userVM : UserViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    // editMode
    @Environment(\.editMode) private var editMode
    
    // 장비 추가 버튼 출현 변수
    @State private var showAddBody = false
    @State private var showAddLens = false
    @State private var showAddFilm = false
    // 각 장비 별 추가 변수
    @State private var newBodyItem = ""
    @State private var newLensItem = ""
    @State private var newFilmItem = ""
    // Alert 변수
    @State private var showAlert: Bool = false
    
    // 장비 추가 변수의 공백 제거한 변수
    var trimNewBodyItem: String {
        newBodyItem.trimmingCharacters(in: .whitespaces)
    }
    var trimNewLensItem: String {
        newLensItem.trimmingCharacters(in: .whitespaces)
    }
    var trimNewFilmItem: String {
        newFilmItem.trimmingCharacters(in: .whitespaces)
    }
  
    //MARK: - body
    var body: some View {
        NavigationStack{
                VStack {
                    
                    // MARK: 상단 바
                    HStack{
                        Button {
                            if trimNewBodyItem.count > 0 || trimNewLensItem.count > 0 || trimNewFilmItem.count > 0 {
                                showAlert.toggle()
                            } else {
                                presentationMode.wrappedValue.dismiss()

                            }

                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("설정")
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("변경 내용을 삭제하시겠어요?"),
                                  message: Text("지금 돌어가면 입력하신 정보가 삭제됩니다."),
                                  primaryButton: .destructive(
                                    Text("변경 내용 삭제")
                                  ){
                                      presentationMode.wrappedValue.dismiss()
                                  },
                                  secondaryButton: .default(
                                    Text("수정 계속하기")
                                  ))
                        }

                        Spacer()

                        Text("나의 장비 정보")
                            .font(.system(size: 17))
                            .bold()
                            .padding(.trailing, 21)

                        Spacer()

                        EditButton()

                    }
                    .padding(.horizontal)
                    .accentColor(.black)
                    
                    List{
                        // MARK: 카메라 바디 섹션
                        BodyList(userVM: userVM, showAddBody: $showAddBody, newItem: $newBodyItem)
                        
                        // MARK: 카메라 렌즈 섹션
                        LensList(userVM: userVM, showAddLens: $showAddLens, newItem: $newLensItem)

                        // MARK: 카메라 필름 섹션
                        FilmList(userVM: userVM, showAddFilm: $showAddFilm, newItem: $newFilmItem)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    

                    Text("첫 번째 장비가 프로필에 보여집니다.")
                        .font(.subheadline)
                        .foregroundColor(.textGray)
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if trimNewBodyItem.count > 0 || trimNewLensItem.count > 0 || trimNewFilmItem.count > 0 {
                                showAlert.toggle()
                            } else {
                                dismiss()
                            }
                        } label: {
                            HStack(spacing: 4){
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("설정")
                                    .font(.system(size: 17))
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("변경 내용을 삭제하시겠어요?"),
                                  message: Text("지금 돌어가면 입력하신 정보가 삭제됩니다."),
                                  primaryButton: .destructive(
                                    Text("변경 내용 삭제")
                                  ){
                                      presentationMode.wrappedValue.dismiss()
                                  },
                                  secondaryButton: .default(
                                    Text("수정 계속하기")
                                  ))
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
        }
        .onAppear{
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        }
        .refreshable {
            do {
                try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
              } catch {}
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
        }
    }

}

//struct EditCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            EditCameraView()
//        }
//    }
//}


// MARK: - 카메라 바디 섹션 선언부
struct BodyList: View {
    @AppStorage("docID") private var docID : String?
    var userVM: UserViewModel

    @Environment(\.editMode) private var editMode

    @Binding var showAddBody: Bool
    @Binding var newItem: String
        
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }

    @FocusState private var focus: Bool
    
    var body: some View {
        Section(header: Text("바디").font(.subheadline).bold()){
            
            // 유저의 바디 정보가 담긴 배열로 부터 리스트 생성
            ForEach(userVM.myCamera, id: \.self) { camera in
                if camera != "카메라 바디는 필수 선택입니다 :)" { //계정 등록 시 장비정보에 기본으로 들어가는 "필수" 안보여주기위함
                    Text(camera)
                }
            }
            .onDelete(perform: removeCameraList(at:))
            .onMove(perform: moveCameraList)

            if editMode?.wrappedValue.isEditing == true {
                // 바디 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
                if showAddBody {
                    HStack {
                        TextField("장비를 입력하세요", text: $newItem)
                            .focused($focus)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                if trimNewItem.count > 0 {
                                        userVM.myCamera.append(newItem)
                                        if let user = userVM.currentUsers {
                                            let arr = userVM.myCamera
                                            let docID =  user.id.stringValue
                                            userVM.updateCurrentUserArray(type: "myCamera", arr: arr, docID: docID)
                                        }
                                        newItem = ""
                                        userVM.fetchCurrentUser(userID: docID ?? "")
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
                                    userVM.myCamera.append(newItem)
                                    if let user = userVM.currentUsers {
                                        let arr = userVM.myCamera
                                        let docID =  user.id.stringValue
                                        userVM.updateCurrentUserArray(type: "myCamera", arr: arr, docID: docID)
                                    }
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: docID ?? "")
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                // 바디 추가하기 버튼
                HStack{
                    Spacer()
                    Button{
                        self.showAddBody.toggle()
                        focus.toggle()
                    } label: {
                        if showAddBody{
                            Text("완료")
                                .foregroundColor(Color(UIColor.systemGray2))
                        } else {
                            HStack{
                                Image(systemName: "plus.circle")
                                Text("바디 추가하기")
                            }
                            .foregroundColor(Color(UIColor.systemGray))
                            .font(.subheadline)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
        
    }
    
    // MARK: 바디 삭제 함수
    func removeCameraList(at offsets: IndexSet) {
        if let user = userVM.currentUsers {
            userVM.myCamera.remove(atOffsets: offsets)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myCamera", arr: userVM.myCamera, docID: docID)
        }
    }
    
    // MARK: 카메라 위치 변경 함수
    func moveCameraList(from source: IndexSet, to destination: Int) {
        if let user = userVM.currentUsers {
            userVM.myCamera.move(fromOffsets: source, toOffset: destination)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myCamera", arr: userVM.myCamera, docID: docID)
        }
    }
    
}

// MARK: - 카메라 렌즈 섹션 선언부
struct LensList: View {
    var userVM: UserViewModel
    
    @Environment(\.editMode) private var editMode

    @Binding var showAddLens: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    @FocusState private var focus: Bool

    var body: some View {
        Section(header: Text("렌즈").font(.subheadline).bold()){
            
            // 유저의 렌즈 정보가 담긴 배열로 부터 리스트 생성
            ForEach(userVM.myLens , id: \.self) { lens in
                if lens != "렌즈는 선택사항입니다." {
                    Text(lens)
                }
            }
            .onDelete(perform: removeLensList(at:))
            .onMove(perform: moveLensList)
            
            if editMode?.wrappedValue.isEditing == true {
                // 렌즈 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
                if showAddLens {
                    HStack {
                        TextField("장비를 입력하세요", text: $newItem)
                            .focused($focus)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                if trimNewItem.count > 0 {
                                        userVM.myLens.append(newItem)
                                        if let user = userVM.currentUsers {
                                            let arr = userVM.myLens
                                            let docID =  user.id.stringValue
                                            userVM.updateCurrentUserArray(type: "myLens", arr: arr, docID: docID)
                                        }
                                        newItem = ""
                                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
                                    userVM.myLens.append(newItem)
                                    if let user = userVM.currentUsers {
                                        let arr = userVM.myLens
                                        let docID =  user.id.stringValue
                                        userVM.updateCurrentUserArray(type: "myLens", arr: arr, docID: docID)
                                    }
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                // 렌즈 추가하기 버튼
                HStack{
                    Spacer()
                    Button{
                        showAddLens.toggle()
                        focus.toggle()
                    } label: {
                        if showAddLens{
                            Text("완료")
                                .foregroundColor(Color(UIColor.systemGray2))
                        } else {
                            HStack{
                                Image(systemName: "plus.circle")
                                Text("렌즈 추가하기")
                            }
                            .foregroundColor(Color(UIColor.systemGray))
                            .font(.subheadline)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: 렌즈 삭제 함수
    func removeLensList(at offsets: IndexSet) {
        if let user = userVM.currentUsers {
            userVM.myLens.remove(atOffsets: offsets)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myLens", arr: userVM.myLens, docID: docID)
        }
    }
    
    // MARK: 렌즈 위치 변경 함수
    func moveLensList(from source: IndexSet, to destination: Int) {
        if let user = userVM.currentUsers {
            userVM.myLens.move(fromOffsets: source, toOffset: destination)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myLens", arr: userVM.myLens, docID: docID)
        }
    }
}

// MARK: - 카메라 필름 섹션 선언부
struct FilmList: View {
    var userVM: UserViewModel

    @Environment(\.editMode) private var editMode
    
    @Binding var showAddFilm: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    @FocusState private var focus: Bool

    var body: some View {
        Section(header: Text("필름").font(.subheadline).bold()){
            ForEach(userVM.myFilm, id: \.self) { film in
                if film != "필름은 선택사항입니다." {
                    Text(film)
                }
            }
            .onDelete(perform: removeFilmList(at:))
            .onMove(perform: moveFilmList)
            
            if editMode?.wrappedValue.isEditing == true {
                // 필름 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
                if showAddFilm {
                    HStack {
                        TextField("장비를 입력하세요", text: $newItem)
                            .focused($focus)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                if trimNewItem.count > 0 {
                                    userVM.myFilm.append(newItem)
                                    if let user = userVM.currentUsers {
                                        let arr = userVM.myFilm
                                        let docID =  user.id.stringValue
                                        userVM.updateCurrentUserArray(type: "myFilm", arr: arr, docID: docID)
                                    }
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
                                userVM.myFilm.append(newItem)
                                if let user = userVM.currentUsers {
                                    let arr = userVM.myFilm
                                    let docID =  user.id.stringValue
                                    userVM.updateCurrentUserArray(type: "myFilm", arr: arr, docID: docID)
                                }
                                newItem = ""
                                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                // 필름 추가하기 버튼
                HStack{
                    Spacer()
                    Button{
                        showAddFilm.toggle()
                        focus.toggle()
                    } label: {
                        if showAddFilm{
                            Text("완료")
                                .foregroundColor(Color(UIColor.systemGray2))
                        } else {
                            HStack{
                                Image(systemName: "plus.circle")
                                Text("필름 추가하기")
                            }
                            .foregroundColor(Color(UIColor.systemGray))
                            .font(.subheadline)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: 필름 삭제 함수
    func removeFilmList(at offsets: IndexSet) {
        if let user = userVM.currentUsers {
            userVM.myFilm.remove(atOffsets: offsets)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myFilm", arr: userVM.myFilm, docID: docID)
        }
    }
    
    // MARK: 필름 위치 변경 함수
    func moveFilmList(from source: IndexSet, to destination: Int) {
        if let user = userVM.currentUsers {
            userVM.myFilm.move(fromOffsets: source, toOffset: destination)
            let docID = user.id.stringValue
            userVM.updateCurrentUserArray(type: "myFilm", arr: userVM.myFilm, docID: docID)
        }
    }
}
