//
//  EditCameraView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import FirebaseAuth
/*
 @Environment(\.editMode) private var editMode

 ...

 .onChange(of: editMode!.wrappedValue, perform: { value in
   if value.isEditing {
      // Entering edit mode (e.g. 'Edit' tapped)
   } else {
      // Leaving edit mode (e.g. 'Done' tapped)
   }
 */

// 텍스트 필드 포커스를 위한 열거형
//private enum FocusableField: Hashable {
//    case body
//    case lens
//    case film
//}

struct EditCameraView: View {

//    var userVM: UserViewModel
    @StateObject var userVM: UserViewModel = UserViewModel()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    // editMode
    @Environment(\.editMode) private var editMode
    
    // 사용자 장비가 담긴 배열
    @State private var  myBodies: [String] = ["코닥", "캐논", "니콘"]
//    @State private var myBodies: [CurrentUserStringValue] = []
    @State private var myLenses: [String] = ["렌즈1", "렌즈2", "렌즈3"]
    @State private var myFilms: [String] = ["코닥", "캐논", "니콘"]
    
    // 장비 추가 버튼 출현 변수
    @State private var showAddBody = false
    @State private var showAddLens = false
    @State private var showAddFilm = false
    
    // 각 장비 별 추가 변수
    @State private var newBodyItem = ""
    @State private var newLensItem = ""
    @State private var newFilmItem = ""
    
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
    
    // Alert 변수
    @State private var showAlert: Bool = false

    //
//    @FocusState var focus: FocusableField

    //MARK: - body
    var body: some View {
        NavigationStack{
//            ZStack(alignment: .bottomTrailing){
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
                        BodyList(userVM: userVM, myBodies: $myBodies, newItem: $newBodyItem)
                        
                        // MARK: 카메라 렌즈 섹션
                        LensList(userVM: userVM, myLenses: $myLenses, showAddLens: $showAddLens, newItem: $newLensItem)
                        
                        // MARK: 카메라 필름 섹션
                        FilmList(userVM: userVM, myFilms: $myFilms, showAddFilm: $showAddFilm, newItem: $newFilmItem)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    
                }
//                .navigationTitle("나의 장비 정보")
//                .navigationBarTitleDisplayMode(.inline)
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
    }

}

struct EditCameraView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            EditCameraView()
        }
    }
}


// MARK: - 카메라 바디 섹션 선언부
struct BodyList: View {
    @AppStorage("docID") private var docID : String?
    var userVM: UserViewModel

    @Environment(\.editMode) private var editMode

    @Binding var  myBodies: [String]
//    @Binding var myBodies: [CurrentUserStringValue]
//    @Binding var showAddBody: Bool
    @State private var showAddBody: Bool = false
    @Binding var newItem: String
    
//    @State private var isAdded: Bool = false
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }

    @FocusState private var focus: Bool
    
    var body: some View {
        Section(header: Text("바디").bold()){
            
            // 유저의 바디 정보가 담긴 배열로 부터 리스트 생성
            ForEach(userVM.currentUsers?.myCamera.arrayValue.values ?? [], id: \.self) { camera in
                if camera.stringValue != "필수" { //계정 등록 시 장비정보에 기본으로 들어가는 "필수" 안보여주기위함
                    Text(camera.stringValue)
                }
            }
            .onDelete(perform: removeCameraList(at:))

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
                                    Task{
                                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "myCamera", updateValue: newItem, isArray: true)
                                        newItem = ""
                                        userVM.fetchCurrentUser(userID: docID ?? "")
                                        
                                    }
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
//                                addCamera()
                                Task{
                                    await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "myCamera", updateValue: newItem, isArray: true)
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: docID ?? "")
                                    
                                }
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
    
    // MARK: 바디 추가 함수 - 필요 없을 듯...
    func addCamera(docID: String, newItem: String) async {
//        CurrentUserStringValue(stringValue: newItem)
//        myBodies.append(newItem)
        await userVM.updateUserUsingSDK(updateDocument: docID , updateKey: "myCamera", updateValue: newItem, isArray: true)

//        userVM.fetchCurrentUser(userID: userID)
        return self.newItem = ""
        
    }
    
    // MARK: 바디 삭제 함수
    func removeCameraList(at offsets: IndexSet) {
        self.myBodies.remove(atOffsets: offsets)
    }
    
}

// MARK: - 카메라 렌즈 섹션 선언부
struct LensList: View {
    @AppStorage("docID") private var docID : String?
    var userVM: UserViewModel
    
    @Environment(\.editMode) private var editMode

    @Binding var  myLenses: [String]
    @Binding var showAddLens: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    @FocusState private var focus: Bool

    var body: some View {
        Section(header: Text("렌즈").bold()){
            
            // 유저의 렌즈 정보가 담긴 배열로 부터 리스트 생성
            ForEach(userVM.currentUsers?.myLens.arrayValue.values ?? [], id: \.self) { lens in
                if lens.stringValue != "선택" {
                    Text(lens.stringValue)
                }
            }
            .onDelete(perform: removeLensList(at:))
            
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
//                                    Task{
//                                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "myLens", updateValue: newItem, isArray: true)
                                        userVM.myLens.append(newItem)
                                        if let user = userVM.currentUsers {
                                            let arr = userVM.myLens
                                            let docID =  user.id.stringValue
                                            userVM.updateCurrentUserArray(type: "myLens", arr: arr, docID: docID)
                                        }
                                        newItem = ""
                                        userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
//                                    }
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
                                Task{
                                    userVM.myLens.append(newItem)
                                    if let user = userVM.currentUsers {
                                        let arr = userVM.myLens
                                        let docID =  user.id.stringValue
                                        userVM.updateCurrentUserArray(type: "myLens", arr: arr, docID: docID)
                                    }
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: docID ?? "")
                                }
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
    // MARK: 렌즈 추가 함수 .. 필요 없을 듯
    func addLens() {
        myLenses.append(newItem)
        newItem = ""
    }
    
    // MARK: 렌즈 삭제 함수
    func removeLensList(at offsets: IndexSet) {
        myLenses.remove(atOffsets: offsets)
        
    }
}

// MARK: - 카메라 필름 섹션 선언부
struct FilmList: View {
    @AppStorage("docID") private var docID : String?
    var userVM: UserViewModel

    @Environment(\.editMode) private var editMode
    @Binding var  myFilms: [String]
    @Binding var showAddFilm: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    @FocusState private var focus: Bool

    var body: some View {
        Section(header: Text("필름").bold()){
            ForEach(userVM.currentUsers?.myFilm.arrayValue.values ?? [], id: \.self) { film in
                if film.stringValue != "선택" {
                    Text(film.stringValue)
                }
            }
            .onDelete(perform: removeFilmList(at:))
            
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
                                    Task{
                                        await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "myFilm", updateValue: newItem, isArray: true)
                                        newItem = ""
                                        userVM.fetchCurrentUser(userID: docID ?? "")
                                    }
                                }
                            }
                        
                        Button{
                            if trimNewItem.count > 0{
                                Task{
                                    await userVM.updateUserUsingSDK(updateDocument: docID ?? "", updateKey: "myFilm", updateValue: newItem, isArray: true)
                                    newItem = ""
                                    userVM.fetchCurrentUser(userID: docID ?? "")
                                }
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
    // MARK: 필름 추가 함수
    func addFilm() {
        myFilms.append(newItem)
        newItem = ""
    }
    
    // MARK: 필름 삭제 함수
    func removeFilmList(at offsets: IndexSet) {
        myFilms.remove(atOffsets: offsets)
    }
}
