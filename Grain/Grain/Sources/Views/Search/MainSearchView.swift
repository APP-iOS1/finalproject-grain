//
//  CommunitySearchView.swift
//  Grain
//
//  Created by 박희경 on 2023/01/18.
//

import SwiftUI

private enum FocusableField: Hashable {
    case search
}
enum SearchState: Hashable {
    case magazine
    case community
    case user
}

struct MainSearchView: View {
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
    @ObservedObject var magazineViewModel: MagazineViewModel = MagazineViewModel()
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    
    @State private var searchWord: String = ""
    @State private var searchList: [String] =  ["카메라", "명소", " 출사"]
    @State private var isMagazineSearchResultShown: Bool = false
    @State private var isCommunitySearchResultShown: Bool = false
    @State private var isUserSearchResultShown: Bool = false
    @State private var isShownProgress: Bool = true
    @State private var isShownPickerProgress: Bool = false
    @State private var searchStatus: SearchState = .magazine
    @State private var selectedIndex: Int = 0
    @State private var progress: Double = 0.5
    
    @FocusState private var focus: FocusableField?
    
    
    
    private let searchTitles: [String] = ["메거진", "커뮤니티", "계정"]
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    init(){
        if searchWord.isEmpty{
            isShownProgress = true
        }
    }
    var body: some View {
        NavigationStack {
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
                                    .frame(width: Screen.maxWidth * 0.27)
                            },
                            selection: {
                                VStack(spacing: 0) {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(height: 1)
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
                    VStack{
                        HStack {
                            Text("최근 검색어")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Button(action: {
                                searchList.removeAll()
                            }) {
                                Text("전체삭제")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 0)
                        ForEach(0..<searchList.count, id: \.self) { index in
                            HStack {
                                NavigationLink(destination: {
                                    
                                }) {
                                    Text(searchList[index])
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                }
                                Spacer()
                                
                                Button(action: {
                                    searchList.remove(at: index)
                                }) {
                                    Image(systemName: "multiply")
                                        .foregroundColor(.gray)
                                    
                                }
                                .frame(alignment: .trailing )
                                
                            }
                            .padding()
                        }
                        
                    }
                    .padding()
                    
                } else if !searchWord.isEmpty {
                    ZStack {
                        VStack{
                            switch selectedIndex {
                            case 0:
                                List{
                                    HStack{
                                        Text(Image(systemName: "magnifyingglass"))
                                            .padding(.leading)
                                            
                                        Text("\(searchWord)")
                                    }
                                    .padding(.top)
                                    .frame(width: Screen.maxWidth, alignment: .leading)
                                    ForEach(magazineViewModel.magazines.filter {
                                        ignoreSpaces(in: $0.fields.title.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                        ignoreSpaces(in: $0.fields.content.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                    }.prefix(3),id: \.self) { item in
                                        NavigationLink {
                                            MagazineDetailView(data: item)
                                        } label: {
                                            VStack(alignment: .leading){
                                                Text(item.fields.title.stringValue)
                                                    .font(.body)
                                                    .bold()
                                                    .padding(.vertical, 5)
                                                Text(item.fields.content.stringValue)
                                                    .lineLimit(1)
                                                    .foregroundColor(.textGray)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    Button {
                                        self.isMagazineSearchResultShown.toggle()
                                    } label: {
                                     Text("결과 모두 보기")
                                            .foregroundColor(.blue)
                                            .font(.body)
                                            .offset(x: Screen.maxWidth * 0.32)
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
                                .listStyle(.plain)
                                
                            case 1:
                                List{
                                    HStack{
                                        Text(Image(systemName: "magnifyingglass"))
                                            .padding(.leading)
                                            
                                        Text("\(searchWord)")
                                    }
                                    .frame(width: Screen.maxWidth, alignment: .leading)
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
                                                    .padding(.vertical, 5)
                                                Text(item.fields.content.stringValue)
                                                    .lineLimit(1)
                                                    .foregroundColor(.textGray)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                 
                                        Button {
                                            self.isCommunitySearchResultShown.toggle()
                                        } label: {
                                         Text("결과 모두 보기")
                                                .foregroundColor(.blue)
                                                .font(.body)
                                                .offset(x: Screen.maxWidth * 0.32)
                                                .padding(.vertical, 8)
                                        }
                                  
    
                                    .buttonStyle(.plain)
                                     

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
                                .listStyle(.plain)
                               
                            case 2:
                                List{
                                    ForEach(userViewModel.users.filter {
                                        ignoreSpaces(in: $0.fields.nickName.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                        ignoreSpaces(in: $0.fields.name.stringValue)
                                            .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                    }.prefix(4),id: \.self) { item in
                                        NavigationLink {
                                            UserSearchDetailView(user: item)
                                        } label: {
                                            HStack{
                                                Circle()
                                                    .stroke(lineWidth: 1)
                                                    .frame(width: 47, height: 47)
                                                    .foregroundColor(.black)
                                                    .overlay(
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .foregroundColor(.brightGray)
                                                            .aspectRatio(contentMode: .fit)
                                                            .padding(9)
                                                    )
                                                VStack(alignment: .leading){
                                                    Text(item.fields.nickName.stringValue)
                                                        .bold()
                                                        .padding(.bottom, 5)
                                                    Text(item.fields.name.stringValue)
                                                        .font(.caption)
                                                        .foregroundColor(.textGray)
                                                        .frame(alignment: .leading)
                                                }
                                                .padding(.leading)
                                                Spacer()
                                            }
                                        }
                                    }
                                    Button {
                                        self.isCommunitySearchResultShown.toggle()
                                    } label: {
                                     Text("결과 모두 보기")
                                            .foregroundColor(.blue)
                                            .font(.body)
                                            .offset(x: Screen.maxWidth * 0.32)
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
                                .listStyle(.plain)
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
            .onAppear{
                self.focus = .search
                self.searchWord = ""
                communtyViewModel.fetchCommunity()
                magazineViewModel.fetchMagazine()
                userViewModel.fetchUser()
            }
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isMagazineSearchResultShown, destination: {
                MagazineSearchResultView(searchWord: $searchWord)
            })
            .navigationDestination(isPresented: $isCommunitySearchResultShown, destination: {
                CommunitySearchResultView(searchWord: $searchWord)
            })
            .navigationDestination(isPresented: $isUserSearchResultShown, destination: {
                UserSearchResultView(searchWord: $searchWord)
            })
        }
    }
}

struct MainSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainSearchView()
        }
    }
}
