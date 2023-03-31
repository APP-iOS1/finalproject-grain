//
//  AddMagazineView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct AddCommunityView: View {
    @ObservedObject var communityVM : CommunityViewModel
    @ObservedObject var userVM : UserViewModel
    
    @State private var inputTitle: String = ""
    @State private var inputContent: String = ""
    @State private var selectedCamera = 0
    @State private var isShowingModal = false
    @State private var textFieldFocused: Bool = true
    @State private var selectedTab: CommunityTabs = .매칭
    // 이미지 앨범에서 가져오기
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingAlert = false
    
    @Binding var presented: Bool
    
    enum CommunityTabs: String, CaseIterable, Identifiable {
        case 매칭, 마켓, 클래스, 정보
        var id: Self { self }
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        
    var body: some View {
        GeometryReader{ geo in
            VStack {
                Divider()
                HStack {
                    if selectedImages.count < 5 {
                        PhotosPicker(
                            selection: $selectedItems, maxSelectionCount: 5,selectionBehavior: .ordered ,
                            matching: .images) {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.middlebrightGray, lineWidth: 1)
                                    )
                                    .overlay {
                                        VStack {
                                            Spacer()
                                            Image(systemName: "camera.fill")
                                                .font(.title3)
                                                .foregroundColor(.black)
                                            Text("\(selectedItems.count)/5")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                                .padding(.top, 5)
                                                .monospacedDigit()
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading)
                            }
                            .onChange(of: selectedItems) { newItem in
                                Task {
                                    selectedImages = []
                                 
                                    for value in newItem {
                                        if let imageData = try? await value.loadTransferable(type: Data.self),
                                            let image = UIImage(data: imageData) {
                                            selectedImages.append(image)
                                        }
                                    }
                                }
                            }
                    }
                    // MARK: 선택한 이미지를 보여주는 부분
                    ScrollView(.horizontal) {
                        HStack {
                            // MARK: 이미지 선택 버튼 우측으로 이미지 정렬
                            ForEach(Array(selectedImages.enumerated()), id: \.1.self) { (index, item) in
                                GeometryReader { geometry in
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 100, height: 100)
                                        .overlay {
                                            if index == 0 {
                                                Image(uiImage: item)
                                                    .resizable()
                                                    .cornerRadius(15)
                                                    
                                                Rectangle()
                                                    .overlay {
                                                        Text("대표 사진")
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.white)
                                                    }
                                                    .frame(height: geometry.size.width/4)
                                                    .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height-13))
                                                    .cornerRadius(15)
                                                Image(systemName: "x.circle.fill")
                                                    .position(CGPoint(x: geometry.size.width-2, y: 8))
                                                    .onTapGesture {
                                                        if selectedItems.count == selectedImages.count{
                                                            selectedItems.remove(at: index)
                                                            selectedImages.remove(at: index)
                                                        }else{
                                                            print("삭제 실패")
                                                        }
                                                    }
                                            }
                                            else{
                                                Image(uiImage: item)
                                                    .resizable()
                                                    .cornerRadius(15)
                                                   
                                                Image(systemName: "x.circle.fill")
                                                    .position(CGPoint(x: geometry.size.width-2, y: 8))
                                                    .onTapGesture {
                                                        if selectedItems.count == selectedImages.count{
                                                            selectedItems.remove(at: index)
                                                            selectedImages.remove(at: index)
                                                        }else{
                                                            print("삭제 실패")
                                                        }
                                                    }
                                            }

                                        }
                                }.frame(width: 100, height: 100)
                               
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                Divider()
                
//                //MARK: 카테고리 피커 -> 버튼으로 변경
//                HStack {
//                    Picker("Tab", selection: $selectedTab){
//                        ForEach(CommunityTabs.allCases){ tab in
//                            Text(tab.rawValue)
//                        }
//                    }
//                    .font(.title)
//                    .colorMultiply(.black)
//                    Spacer()
//                }.padding(.vertical, 6)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("카테고리")
                            .foregroundColor(.black)
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }.padding(.leading)
                    HStack {
                        ForEach(CommunityTabs.allCases) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab.rawValue)
                                    .font(.footnote)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.vertical, 7)
                                        .foregroundColor(selectedTab == tab ? Color.white : Color.black)
                                        .background(selectedTab == tab ? Color.black : Color.white)
                                        .cornerRadius(14)
                                        .overlay(RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.brightGray, lineWidth: 0.5))
                            }
                            .padding(.horizontal, 6)
                        }
                        
                        Spacer()
                    }.padding(.leading)
                }.padding(.vertical, 8)
                
                Divider()
                
                VStack {
                    //MARK: 게시물 제목 작성 란
                    TextField("제목을 입력해주세요.", text: $inputTitle)
                        .font(.body)
                        .bold()
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 15)
                        .onSubmit {
                            hideKeyboard()
                        }
                        .submitLabel(.done)
                }
                .padding(.vertical, 8)
                
                //MARK: 게시물 제목 작성 란
//                TextField("제목을 입력해주세요.", text: $inputTitle)
//                    .font(.body)
//                    .bold()
//                    .keyboardType(.default)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .padding(.horizontal, 15)
//                    .onSubmit {
//                        hideKeyboard()
//                    }
//                    .submitLabel(.done)
//                    .padding(.vertical, 8)
               
                Divider()
                
                // MARK: 게시물 내용 작성 란
                TextField("내용을 자세하게 입력해주세요 :)", text: $inputContent, axis: .vertical)
                    .font(.body)
                    .bold()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    .disableAutocorrection(true)
                    .lineLimit(7)
                    .padding(.horizontal, 15)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                hideKeyboard()
                            } label: {
                                Text("Done")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .frame(height: Screen.maxHeight * 0.4, alignment: .top)
                    .padding(.vertical, 8)
                
                Spacer()
                
                //MARK: 다음 버튼
                if inputTitle.count == 0 || inputContent.count == 0 {
                    Button {
                        isShowingAlert = true
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("작성 완료")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("알림"), message: Text("제목, 내용은 필수 입력 항목입니다."), dismissButton: .default(Text("확인")))
                        
                    }
                } else {
                    Button {
                        let docId = UUID().uuidString
                        let data = CommunityFields(title: CommunityCategory(stringValue: inputTitle), category: CommunityCategory(stringValue: selectedTab.rawValue), content: CommunityCategory(stringValue: inputContent), profileImage: CommunityCategory(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""), introduce: CommunityCategory(stringValue: userVM.currentUsers?.introduce.stringValue ?? ""), state: CommunityCategory(stringValue: ""), nickName: CommunityCategory(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "")])), userID: CommunityCategory(stringValue: userVM.currentUsers?.id.stringValue ?? ""), id: CommunityCategory(stringValue: docId))
                        communityVM.insertCommunity(data: data, images: selectedImages)
                        var postCommunityArr : [String]  = userVM.postedCommunityID
                        postCommunityArr.append(docId)
                        userVM.updateCurrentUserArray(type: "postedCommunityID", arr: postCommunityArr, docID: Auth.auth().currentUser?.uid ?? "")
                        communityVM.fetchCommunity()     //  presented.toggle() 순서 바뀌면 게시글이 바로 적용이 안됨!
                        presented.toggle()
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                            .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                            .overlay {
                                Text("작성 완료")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
            .navigationTitle("커뮤니티 작성하기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            .onAppear {
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            }
        }
    }
}
//struct AddCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCommunityView(presented: .constant(false))
//    }
//}
