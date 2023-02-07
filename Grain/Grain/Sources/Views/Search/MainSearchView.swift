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
    @State private var searchStatus: SearchState = .magazine
    @State private var selectedIndex: Int = 0
    
    @FocusState private var focus: FocusableField?
    
    
    
    private let searchTitles: [String] = ["메거진", "커뮤니티", "계정"]
    
    private func ignoreSpaces(in string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
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
                                if selectedIndex == 0 {
                                    self.isMagazineSearchResultShown.toggle()
                                }else if selectedIndex == 1 {
                                    self.isCommunitySearchResultShown.toggle()
                                }else {
                                    self.isUserSearchResultShown.toggle()
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
                    VStack{
                        switch selectedIndex {
                        case 0:
                            List{
                                ForEach(magazineViewModel.magazines.filter {
                                    ignoreSpaces(in: $0.fields.title.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                    ignoreSpaces(in: $0.fields.content.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                },id: \.self) { item in
                                    NavigationLink {
                                        MagazineDetailView(data: item)
                                    } label: {
                                        
                                        VStack(alignment: .leading){
                                            Text(item.fields.title.stringValue)
                                                .bold()
                                                .padding(.bottom, 5)
                                            Text(item.fields.content.stringValue)
                                                .lineLimit(2)
                                                .foregroundColor(.textGray)
                                                .font(.caption)
                                            
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)
                            
                        case 1:
                            List{
                                ForEach(communtyViewModel.communities.filter {
                                    ignoreSpaces(in: $0.fields.title.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord)) ||
                                    ignoreSpaces(in: $0.fields.content.stringValue)
                                        .localizedCaseInsensitiveContains(ignoreSpaces(in: self.searchWord))
                                },id: \.self) { item in
                                    NavigationLink {
                                        CommunitySearchDetailView(community: item)
                                    } label: {
                                        VStack(alignment: .leading){
                                            Text(item.fields.title.stringValue)
                                                .bold()
                                                .padding(.bottom, 5)
                                            Text(item.fields.content.stringValue)
                                                .lineLimit(2)
                                                .foregroundColor(.textGray)
                                                .font(.caption)
                                        }
                                    }
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
                                },id: \.self) { item in
                                    NavigationLink {
                                        UserSearchDetailView(user: item)
                                    } label: {
                                        VStack(alignment: .leading){
                                            HStack{
                                                Circle()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.brightGray)
                                                    .overlay(
                                                        Image(systemName: "person.fill")
                                                    )
                                                VStack{
                                                    Text(item.fields.nickName.stringValue)
                                                        .bold()
                                                        .padding([.bottom, .leading], 5)
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)
                        default:
                           Text("다시 시도해주세요")
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
