//
//  MagazineContentAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI
import NMapsMap

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
   
    // 지도에서 좌표 값 가져오기
    @State var updateNumber : NMGLatLng
    
    
    var myCamera = ["camera1", "camera2", "camera3", "camera4"]
    
    var body: some View {
        /// 지도뷰로 이동하기 위해 전체적으로 걸어줌
        ///NavigationStack으로 걸어주면 앱이 폭팔하길래 NavigationView 변경
        NavigationView{
            VStack {
                
                // MARK: 상단 기능 ( 취소, 매거진, 글쓰기 )
                VStack{
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
                        // 정훈
                        VStack{
                            Text("매거진")
                        }
                        Spacer()
                        Button {
                            // insert 메서드 들어가고
                            /// cameraInfo, lenseInfo, filmInfo 유저가 가지고 있는 데이터에서 패치를 하고 그거를 피커로 보여지게 만들고 그 다음에 고르면 데이터가 넘어 가게끔
                            /// userID, nickName 은 UserDB에서 가져와야 됨
                            /// comment -> 임시
                            ///
                            magazineVM.insertMagazine(userID: "패스", cameraInfo: "패스", nickName: "패스", image: "패스", content: inputContent , title: inputTitle , lenseInfo: "패스", longitude: updateNumber.lng, likedNum: 0, filmInfo: "패스", customPlaceName: "패스", latitude: updateNumber.lat, comment: "임시", roadAddress: "패스")
                        } label: {
                            Text("글쓰기")
                                .foregroundColor(.black)
                        }
                        
                    }
                    .padding(.horizontal)
                }
                
                
                /// 상단 기능과 구분선
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: Screen.maxWidth, height: 1)
                
                // MARK: 이미지 피커 쪽인거 같음 확인 필요
                VStack{
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
                }
                
                // MARK: 게시물 글 제목 작성 란
                VStack{
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
                }
           
                // MARK: 게시물 내용 작성 란
                VStack{
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
                }
                
                
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
                        ///지도뷰로 이동하기 위해 NavigationLink걸어줌
                        NavigationLink(destination: AddMarkerMapView(updateNumber: $updateNumber)) {
                            Image(systemName: "location.fill")
                            Text("위치 받아오기")
                        }
                        // FIXME: 170 ~ 177번에 있는 적용 값? 들 원하시는 부분에 적용이 됐는지 확인해 주시면 감사합니다.
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading) //
                    }
                    .padding(.horizontal, 15)
                }
               
                
            }.ignoresSafeArea(.keyboard)
        }
        
    }
}
    //struct MagazineContentAddView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        NavigationStack {
    //            MagazineContentAddView()
    //        }
    //    }
    //}
