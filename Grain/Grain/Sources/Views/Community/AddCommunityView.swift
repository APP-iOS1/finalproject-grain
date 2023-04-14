//
//  AddMagazineView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/20.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

private enum FocusableField: Hashable {
    case write
}

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
    
    @State private var isUpdateCommunitySuccess: Bool = false
    @State private var isClickedSubmitButton: Bool = false
    
    enum CommunityTabs: String, CaseIterable, Identifiable {
        case 매칭, 마켓, 클래스, 정보
        var id: Self { self }
    }
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @FocusState private var focus: FocusableField?

    var body: some View {
        GeometryReader{ geo in
            ZStack {
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
                    
                    HStack{
                        Text("\(Image(systemName: "info.circle")) 그레인 운영 정책을 위반하는 경우에는 삭제 처리 될 수 있습니다.")
                            .foregroundColor(.middlebrightGray)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    Divider()
                    
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
                                        .foregroundColor(selectedTab == tab ? Color.white : Color.gray)
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
                        TextField("제목을 입력해주세요", text: $inputTitle)
                            .font(.body)
                            .bold()
                            .keyboardType(.default)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(.horizontal)
                            .onSubmit {
                                hideKeyboard()
                            }
                            .submitLabel(.done)
                            .focused($focus, equals: .write )

                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    
                    TextEditor(text: $inputContent)
                        .frame(height: Screen.maxHeight * 0.35)
                        .lineSpacing(4.0)
                        .padding(.horizontal, 12)
                        .overlay(
                            // Placeholder를 Text로 구현하고, text가 비어있을 때만 표시되도록 조건문 추가
                            Group {
                                if inputContent.isEmpty {
                                    Text("내용을 자세하게 입력해주세요 😊")
                                        .foregroundColor(Color(.placeholderText))
                                        .font(.body)
                                        .bold()
                                }
                            }
                        )
                        .font(.body)
                        .bold()
                        .focused($focus, equals: .write)
                        .onTapGesture {
                            // TextEditor를 탭하면 키보드를 닫습니다.
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
                        .padding(.bottom, 20)
                    
//                    Spacer()    .padding(.bottom, 20)
                    
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
                        
                        if isClickedSubmitButton {
                            Button {
                                
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.black)
                                    .frame(width: Screen.maxWidth * 0.85, height: Screen.maxHeight * 0.07)
                                    .overlay {
                                        Text("작성 완료")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                            }.onAppear {
                                
                            }

                        }
                        else {
                            Button {
                              
                                Task{
                                    isClickedSubmitButton = true
                                    isUpdateCommunitySuccess = true

                                    // 완료 버튼 1번 누르면 더이상 누르지 못하게 막기
                                    
                                    if isClickedSubmitButton{
                                        
                                        let docId = UUID().uuidString
                                        let data = CommunityFields(title: CommunityCategory(stringValue: inputTitle), category: CommunityCategory(stringValue: selectedTab.rawValue), content: CommunityCategory(stringValue: inputContent), profileImage: CommunityCategory(stringValue: userVM.currentUsers?.profileImage.stringValue ?? ""), introduce: CommunityCategory(stringValue: userVM.currentUsers?.introduce.stringValue ?? ""), state: CommunityCategory(stringValue: ""), nickName: CommunityCategory(stringValue: userVM.currentUsers?.nickName.stringValue ?? ""), image: CommunityImage(arrayValue: CommunityArrayValue(values: [CommunityCategory(stringValue: "")])), userID: CommunityCategory(stringValue: userVM.currentUsers?.id.stringValue ?? ""), id: CommunityCategory(stringValue: docId))
                                        
                                        if selectedImages.count == 0 {
                                            // 이미지를 선택을 안했을 경우 default 이미지가 들어가게 함.
                                            if let image = UIImage(named: "defaultCommunityImage") {
                                                selectedImages.append(image)
                                            }
                                        }
                                        
                                        communityVM.insertCommunity(data: data, images: selectedImages)
                                        
                                        var postCommunityArr : [String]  = userVM.postedCommunityID
                                        postCommunityArr.append(docId)
                                        userVM.updateCurrentUserArray(type: "postedCommunityID", arr: postCommunityArr, docID: Auth.auth().currentUser?.uid ?? "")
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            communityVM.fetchCommunity(nextPageToken: "")
                                        }
                                        self.presented = false
                                    }

                                }
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
                            .padding()
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
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        self.focus = nil
                    } label: {
                        Text("완료")
                            .foregroundColor(.blue)
                    }
                    
                }
            }
            .onAppear {
                userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            }
        }
    }
}
