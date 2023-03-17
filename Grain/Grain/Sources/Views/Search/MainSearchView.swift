//
//  CommunitySearchView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

private enum FocusableField: Hashable {
    case search
}
enum SearchState: Hashable {
    case magazine
    case community
    case user
}

struct MainSearchView: View {
    @StateObject var searchViewModel: SearchViewModel = SearchViewModel()
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
    @ObservedObject var magazineViewModel: MagazineViewModel = MagazineViewModel()
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    
    @State private var searchWord: String = ""
    @State private var searchList: [String] =  ["카메라", "명소", "출사"]
    @State private var isMagazineSearchResultShown: Bool = false
    @State private var isCommunitySearchResultShown: Bool = false
    @State private var isUserSearchResultShown: Bool = false
    @State private var isShownProgress: Bool = true
    @State private var isShownPickerProgress: Bool = false
    @State private var searchStatus: SearchState = .magazine
    @State private var selectedIndex: Int = 0
    @State private var progress: Double = 0.5
    @FocusState private var focus: FocusableField?
   
    var searchedUser: [UserDocument] {
        let arr = userViewModel.users.filter {
            ignoreSpaces(in: $0.fields.nickName.stringValue)
                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
            ignoreSpaces(in: $0.fields.name.stringValue)
                .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
        }
        return Array(arr)
    }
    
    private let searchTitles: [String] = ["매거진", "커뮤니티", "계정"]
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    init(){
//        if searchWord.isEmpty{
//            isShownProgress = true
//        }
    }
    
    @State var updateNum : String = ""

    var body: some View {
        NavigationStack{
            VStack{
                VStack(spacing: 0){
                    HStack{
                        TextField("\( Image(systemName: "magnifyingglass")) 검색어를 입력하세요", text: $searchWord)
                            .textContentType(.oneTimeCode)
                            .tint(Color.black)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focus, equals: .search)
                            .submitLabel(.search)
                            .onSubmit {
                                if searchWord.isEmpty {
                                    self.focus = nil
                                } else{
                                    if selectedIndex == 0 {
                                        self.isMagazineSearchResultShown.toggle()
                                    }else if selectedIndex == 1 {
                                        self.isCommunitySearchResultShown.toggle()
                                    }else {
                                        self.isUserSearchResultShown.toggle()
                                    }
                                    
                                    if let user = userViewModel.currentUsers {
                                        if userViewModel.recentSearch.contains(where: { $0 == self.searchWord }) {
                                            // 이미 검색한 검색어이면 배열에서 먼저 이미 있는 값 삭제
                                            if let index = userViewModel.recentSearch.firstIndex(of: self.searchWord) {
                                                userViewModel.recentSearch.remove(at: index)
                                            }
                                        }

                                        // 배열의 첫번째 인덱스에 넣어준다.
                                        // 1 index 에 넣는 이유는 0번째 인덱스가 "" 로 초기화 되어있기 때문.
                                        userViewModel.recentSearch.insert(self.searchWord, at: 1)
                                        userViewModel.updateCurrentUserArray(type: "recentSearch", arr: userViewModel.recentSearch, docID: user.id.stringValue)
                                    }
                                }
                            }
                            .onChange(of: searchWord) { value in
                                self.isShownProgress = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.isShownProgress = false
                                }
                            }
                            .padding(.leading)
                        
                        if focus == .search{
                            HStack {
                                Button {
                                    self.searchWord = ""
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                }
                                .tint(.gray)
                                .padding(.trailing, 7)
                                .animation(.easeInOut, value: focus)
                                
                                Button {
                                    self.focus = nil
                                    self.searchWord = ""
                                } label: {
                                    Text("취소")
                                }
                                .tint(.black)
                            }
                            
                        }
                    }
                    .padding()
                    
                    HStack {
                        Spacer()
                        SegmentedPicker(
                            searchTitles,
                            selectedIndex: Binding(
                                get: { selectedIndex },
                                set: { selectedIndex = $0 ?? 0 }),
                            content: { item, isSelected in
                                Text(item)
                                    .foregroundColor(isSelected ? Color.black : Color.gray )
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .bold()
                                    .frame(width: Screen.maxWidth * 0.28)
                            },
                            selection: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: Screen.maxWidth * 0.2, height: 1)
                                        .transition(.slide)
                                        .animation(.easeInOut, value: selectedIndex)
                                }
                                
                            })
                        .onChange(of: selectedIndex) { value in
                            self.isShownPickerProgress = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.isShownPickerProgress = false
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                
                if searchWord.isEmpty {
                    MainRecentSearchView(searchList: $searchList, userVM: userViewModel)
                    
                } else if !searchWord.isEmpty {
                    ZStack {
                        VStack{
                            switch selectedIndex {
                            case 0:
                                ScrollView {
                                    HStack{
                                        Text(Image(systemName: "magnifyingglass"))
                                            .padding(.leading)
                                        
                                        Text("\(searchWord)")
                                    }
                                    .padding(.top)
                                    .frame(width: Screen.maxWidth, alignment: .leading)
                                    .padding(.bottom, 3)
                                    ForEach(magazineViewModel.magazines.filter {
                                        ignoreSpaces(in: $0.fields.title.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                        ignoreSpaces(in: $0.fields.content.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                    }.prefix(3),id: \.self) { item in
                                        NavigationLink {
                                            MagazineDetailView(magazineVM: magazineViewModel, userVM: userViewModel, currentUsers: userViewModel.currentUsers, data: item, updateNum: $updateNum)
                                        } label: {
                                            VStack(alignment: .leading){
                                                Text(item.fields.title.stringValue)
                                                    .font(.body)
                                                    .bold()
                                                    .padding(.top, 6)
                                                    .padding(.bottom, 4)
                                                    .lineLimit(1)
                                                Text(item.fields.content.stringValue)
                                                    .lineLimit(1)
                                                    .foregroundColor(.textGray)
                                                    .font(.caption)
                                                    .padding(.bottom,3)
                                                Divider()
                                                    .padding(.bottom, 5)
                                            }
                                            .padding(.horizontal)
                                        }.onTapGesture {
                                        
                                        }
                                        
                                    }
                                    
                                    Button {
                                        self.isMagazineSearchResultShown.toggle()
                                    } label: {
                                        Text("결과 모두 보기")
                                            .foregroundColor(.blue)
                                            .font(.body)
                                            .padding(.vertical, 9)
                                    }
                                    
                                }
                                .emptyPlaceholder(magazineViewModel.magazines.filter {
                                    ignoreSpaces(in: $0.fields.title.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) || ignoreSpaces(in: $0.fields.content.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                }) {
                                    VStack{
                                        Spacer()
                                        MainSearchPlaceHolder(searchWord: $searchWord)
                                        Spacer()
                                    }
                                    
                                }
                                
                            case 1:
                                ScrollView {
                                    HStack{
                                        Text(Image(systemName: "magnifyingglass"))
                                            .padding(.leading)
                                        
                                        Text("\(searchWord)")
                                    }
                                    .padding(.top)
                                    .frame(width: Screen.maxWidth, alignment: .leading)
                                    .padding(.bottom, 3)
                                    ForEach(communtyViewModel.communities.filter {
                                        ignoreSpaces(in: $0.fields.title.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                        ignoreSpaces(in: $0.fields.content.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                    }.prefix(3),id: \.self) { item in
                                        NavigationLink {
                                            CommunitySearchDetailView(community: item)
                                            
                                        } label: {
                                            VStack(alignment: .leading){
                                                Text(item.fields.title.stringValue)
                                                    .font(.body)
                                                    .bold()
                                                    .padding(.top, 6)
                                                    .padding(.bottom, 4)
                                                    .lineLimit(1)
                                                Text(item.fields.content.stringValue)
                                                    .lineLimit(1)
                                                    .foregroundColor(.textGray)
                                                    .font(.caption)
                                                    .padding(.bottom,3)
                                                Divider()
                                                    .padding(.bottom, 5)
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    
                                    Button {
                                        self.isCommunitySearchResultShown.toggle()
                                    } label: {
                                        Text("결과 모두 보기")
                                            .foregroundColor(.blue)
                                            .font(.body)
                                            .padding(.vertical, 9)
                                    }
                                }
                                .emptyPlaceholder(communtyViewModel.communities.filter {
                                    ignoreSpaces(in: $0.fields.title.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                    ignoreSpaces(in: $0.fields.content.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                }) {
                                    VStack{
                                        Spacer()
                                        MainSearchPlaceHolder(searchWord: $searchWord)
                                        Spacer()
                                    }
                                    
                                }
                                
                            case 2:
                                ScrollView {
                                    HStack{
                                        Text(Image(systemName: "magnifyingglass"))
                                            .padding(.leading)
                                        
                                        Text("\(searchWord)")
                                    }
                                    .padding(.top)
                                    .frame(width: Screen.maxWidth, alignment: .leading)
                                    .padding(.bottom, 7)
//                                    userViewModel.users.prefix()
                                    
                                    if searchedUser.count >= 4 {
                                        ForEach(0..<4) { i in
                                            NavigationLink {
    //                                            UserSearchDetailView(user: item)
                                                UserDetailView(user: searchedUser[i], userVM: userViewModel)
                                            } label: {
                                                VStack{
                                                    HStack{
                                                        KFImage(URL(string: searchedUser[i].fields.profileImage.stringValue ) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                                            .resizable()
                                                            .frame(width: 47, height: 47)
                                                            .cornerRadius(30)
                                                            .overlay {
                                                                Circle()
                                                                    .stroke(lineWidth: 0.5)
                                                            }
                                                            .padding(.trailing, -10)
                                                        VStack(alignment: .leading){
                                                            Text(searchedUser[i].fields.nickName.stringValue)
                                                                .font(.body)
                                                                .bold()
                                                                .padding(.bottom, 1)
                                                                .lineLimit(1)
                                                            Text(searchedUser[i].fields.name.stringValue)
                                                                .font(.caption)
                                                                .foregroundColor(.textGray)
                                                                .frame(alignment: .leading)
                                                        }
                                                        .padding(.leading)
                                                        Spacer()
                                                    }
                                                    Divider()
                                                        .padding(.bottom, 5)
                                                }
                                                .padding(.horizontal)
                                                .padding(.top, 5)
                                            }
                                        }
                                    }
                                    else if searchedUser.count > 0 && searchedUser.count < 4  {
                                        ForEach(0..<searchedUser.count) { i in
                                            NavigationLink {
    //                                            UserSearchDetailView(user: item)
                                                UserDetailView(user: searchedUser[i], userVM: userViewModel)
                                            } label: {
                                                VStack{
                                                    HStack{
                                                        KFImage(URL(string: searchedUser[i].fields.profileImage.stringValue ) ?? URL(string:"https://cdn.travie.com/news/photo/202108/21951_11971_5847.jpg"))
                                                            .resizable()
                                                            .frame(width: 47, height: 47)
                                                            .cornerRadius(30)
                                                            .overlay {
                                                                Circle()
                                                                    .stroke(lineWidth: 0.5)
                                                            }
                                                            .padding(.trailing, -10)
                                                        VStack(alignment: .leading){
                                                            Text(searchedUser[i].fields.nickName.stringValue)
                                                                .font(.body)
                                                                .bold()
                                                                .padding(.bottom, 1)
                                                                .lineLimit(1)
                                                            Text(searchedUser[i].fields.name.stringValue)
                                                                .font(.caption)
                                                                .foregroundColor(.textGray)
                                                                .frame(alignment: .leading)
                                                        }
                                                        .padding(.leading)
                                                        Spacer()
                                                    }
                                                    Divider()
                                                        .padding(.bottom, 5)
                                                }
                                                .padding(.horizontal)
                                                .padding(.top, 5)
                                            }
                                        }
                                    }
                                 
                                    Button {
                                        self.isCommunitySearchResultShown.toggle()
                                    } label: {
                                        Text("결과 모두 보기")
                                            .foregroundColor(.blue)
                                            .font(.body)
                                            .padding(.vertical, 9)
                                    }
                                }
                                .emptyPlaceholder(userViewModel.users.filter {
                                    ignoreSpaces(in: $0.fields.nickName.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                    ignoreSpaces(in: $0.fields.name.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                }) {
                                    VStack{
                                        Spacer()
                                        MainSearchPlaceHolder(searchWord: $searchWord)
                                        Spacer()
                                    }
                                    
                                }
                                
                            default:
                                Text("다시 시도해주세요")
                            }
                            
                        }
                        
                        if isShownProgress == true {
                            SearchProgress()
                        }
                        
                        if isShownPickerProgress == true {
                            SearchProgress()
                        }
                        
                    }
                }
                Spacer()
            }
            
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    Spacer()
                    Button {
                        self.focus = nil
                    } label: {
                        Text("취소")
                            .foregroundColor(.blue)
                    }
                    
                }
            }
        }
        .navigationDestination(isPresented: $isMagazineSearchResultShown){
            MagazineSearchResultView(searchWord: $searchWord, magazine: magazineViewModel, userViewModel: userViewModel)
        }
        .navigationDestination(isPresented: $isCommunitySearchResultShown){
            CommunitySearchResultView(searchWord: $searchWord, community: communtyViewModel)
        }
        
        .navigationDestination(isPresented: $isUserSearchResultShown){
            UserSearchResultView(searchWord: $searchWord, user: userViewModel)
        }
        .onAppear{
            if searchWord.isEmpty{
                        isShownProgress = true
                    }
            self.focus = .search
            userViewModel.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            communtyViewModel.fetchCommunity()
            magazineViewModel.fetchMagazine()
            userViewModel.fetchUser()
        }
    }
}

//struct MainSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MainSearchView()
//        }
//    }
//}
