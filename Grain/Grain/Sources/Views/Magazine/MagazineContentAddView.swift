//
//  MagazineContentAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineContentAddView: View {
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var inputCustomPlace: String = ""
    @State private var selectedImages: [String] = ["1", "2", "3", "editor"]
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    
    // 모달 내리기
    @Binding var presented : Bool
    // insert
    @ObservedObject var magazineVM = MagazineViewModel()
    
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presented.toggle()
                    //글쓰기 취소
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                }
                Spacer()

                Text("매거진")


                Spacer()
                Button {
                    // insert 메서드 들어가고
                    /// cameraInfo, lenseInfo, filmInfo 유저가 가지고 있는 데이터에서 패치를 하고 그거를 피커로 보여지게 만들고 그 다음에 고르면 데이터가 넘어 가게끔
                    /// userID, nickName 은 UserDB에서 가져와야 됨
                    /// comment -> 임시
                    ///
                    magazineVM.insertMagazine(userID: "패스", cameraInfo: "패스", nickName: "패스", image: "패스", content: inputContent , title: inputTitle , lenseInfo: "패스", longitude: "패스", likedNum: "패스", filmInfo: "패스", customPlaceName: "패스", latitude: "패스", comment: "임시", roadAddress: "패스")
                } label: {
                    Text("글쓰기")
                        .foregroundColor(.black)
                }

            }
            .padding(.horizontal)
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth, height: 1)
            
            HStack {
                Button {
                    //MARK: 사진선택 동작 함수
                    // 사진을 선택하면 선택한 사진이 selectedImages 배열으로
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemGray4))
                        .frame(width: 70, height: 70)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                                .frame(width: 68, height: 68)
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { img in
                            Image(img)
                                .resizable()
                                .frame(width: 70, height: 70)
                                .cornerRadius(8)
                        }
                    }
                }
                Spacer()
                
            }
            .padding(.horizontal)
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            
            TextField("글 제목", text: $inputTitle)
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(.horizontal, 15)
                .onSubmit {
                    hideKeyboard()
                }
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            
            TextField("내용을 작성해 주세요.", text: $inputContent, axis: .vertical)
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .lineLimit(...25)
                .padding(.horizontal, 15)
                .onSubmit {
                    hideKeyboard()
                }
            
            Spacer()
            
            Rectangle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: Screen.maxWidth * 0.95, height: 1)
            Group{
                
                HStack {
                    Button {
                        isShowingModal.toggle()
                    } label: {
                        Text("장비 선택 임시 버튼")
                    }
                    .foregroundColor(.black)
                    .sheet(isPresented: $isShowingModal) {
                        CameraLenseFilmModalView()
                            .presentationDetents([.medium, .large])
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
                Button {
                    
                } label: {
                    HStack{
                        Image(systemName: "location.fill")
                        Text("위치 받아오기")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
//            Spacer()
            
        }
        .ignoresSafeArea(.keyboard)
    }
}

//struct MagazineContentAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineContentAddView()
//        }
//    }
//}
