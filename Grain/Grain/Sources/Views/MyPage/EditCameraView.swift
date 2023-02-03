//
//  EditCameraView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct EditCameraView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 각 장비가 담긴 배열
    @State private var  myBodies: [String] = ["코닥", "캐논", "니콘"]
    @State private var myLenses: [String] = ["렌즈1", "렌즈2", "렌즈3"]
    @State private var myFilms: [String] = ["코닥", "캐논", "니콘"]
    
    //
    @State private var showAddBody = false
    @State private var showAddLens = false
    @State private var showAddFilm = false
    
    @State private var newItem = ""
    
    var trimNewItem: String {
        newItem.trimmingCharacters(in: .whitespaces)
    }

    //    @State private var isShowingModal: Bool = false
    //
    //    @State private var cameraModal: Bool = true
    //    @State private var lensModal: Bool = true
    //    @State private var filmModal: Bool = true
    
    //MARK: - body
    var body: some View {
        NavigationStack{
//            ZStack(alignment: .bottomTrailing){
                VStack {
                    
                    // MARK: 상단 바
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("설정")
                            Spacer()
                            
                            Text("나의 장비 정보")
                                .padding(.trailing)
                            
                            Spacer()
                            
                            EditButton()
                            
                        }
                        .padding(.horizontal)
                    }
                    .accentColor(.black)
                    
                    List{
                        // MARK: 카메라 바디 섹션
                        BodyList(myBodies: $myBodies, showAddBody: $showAddBody, newItem: $newItem)
                        
                        // MARK: 카메라 렌즈 섹션
                        LensList(myLenses: $myLenses, showAddLens: $showAddLens, newItem: $newItem)
                        
                        // MARK: 카메라 필름 섹션
                        FilmList(myFilms: $myFilms, showAddFilm: $showAddFilm, newItem: $newItem)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                
                //                FloatingMenu(isShowingModal: $isShowingModal, cameraModal: $cameraModal, lensModal: $lensModal, filmModal: $filmModal)
                //                    .padding()
//            }
            //            .sheet(isPresented: $isShowingModal) {
            //
            //                    if cameraModal{
            //                        CameraModalView()
            ////                        ListTestView()
            //                        .presentationDetents([.height(250)])
            //                    } else if lensModal{
            //                        VStack{
            //                            Text("렌즈")
            //                        }
            //                    } else if filmModal{
            //                        VStack{
            //                            Text("film")
            //                        }
            //                    }
            //
            //            }
            
        }
    }

}

struct EditCameraView_Previews: PreviewProvider {
    static var previews: some View {
        EditCameraView()
    }
}


// MARK: - 카메라 바디 섹션 선언부
struct BodyList: View {
    @Binding var  myBodies: [String]
    @Binding var showAddBody: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Section(header: Text("바디")){
            
            // 카메라 바디 정보가 담긴 배열로 부터 리스트 생성
            ForEach(myBodies, id: \.self) { camera in
                Text(camera)
            }
            .onDelete(perform: removeCameraList(at:))
            
            // 바디 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
            if showAddBody {
                HStack {
                    TextField("장비를 입력하세요", text: $newItem)
                    
                    Button{
                        if trimNewItem.count > 0{
                            addCamera()
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
    
    // MARK: 바디 추가 함수
    func addCamera() {
        myBodies.append(newItem)
        newItem = ""
    }
    
    // MARK: 바디 삭제 함수
    func removeCameraList(at offsets: IndexSet) {
        self.myBodies.remove(atOffsets: offsets)
    }
    
}

// MARK: - 카메라 렌즈 섹션 선언부
struct LensList: View {
    @Binding var  myLenses: [String]
    @Binding var showAddLens: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        Section(header: Text("렌즈")){
            ForEach(myLenses, id: \.self) { lens in
                Text(lens)
            }
            .onDelete(perform: removeLensList(at:))
            
            // 바디 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
            if showAddLens {
                HStack {
                    TextField("장비를 입력하세요", text: $newItem)
                    
                    Button{
                        if trimNewItem.count > 0{
                            addLens()
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
                    showAddLens.toggle()
                } label: {
                    if showAddLens{
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
    // MARK: 렌즈 추가 함수
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
    @Binding var  myFilms: [String]
    @Binding var showAddFilm: Bool
    @Binding var newItem: String
    
    var trimNewItem: String {
        self.newItem.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        Section(header: Text("필름")){
            ForEach(myFilms, id: \.self) { film in
                Text(film)
            }
            .onDelete(perform: removeFilmList(at:))
            
            // 바디 추가하기 버튼 누르면 입력할 수 있는 창이 나타남
            if showAddFilm {
                HStack {
                    TextField("장비를 입력하세요", text: $newItem)
                    
                    Button{
                        if trimNewItem.count > 0{
                            addFilm()
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
                    showAddFilm.toggle()
                } label: {
                    if showAddFilm{
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
