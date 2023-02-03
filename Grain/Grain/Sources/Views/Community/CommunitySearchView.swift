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

struct CommunitySearchView: View {
    @ObservedObject var communtyViewModel: CommunityViewModel = CommunityViewModel()
    
    @State private var searchWord: String = ""
    @State private var searchList: [String] =  ["카메라", "명소", " 출사"]
    @State private var isSearchResultShown: Bool = false
    
    @FocusState private var focus: FocusableField?
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack(spacing: 0){
                    HStack{
                        TextField("검색어를 입력하세요", text: $searchWord)
                            .tint(Color.black)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focus, equals: .search)
                            .submitLabel(.search)
                            .onSubmit {
                                self.isSearchResultShown.toggle()
                            }
                        Button {
                            self.isSearchResultShown.toggle()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                        }
                        
                        if focus == .search{
                            Button {
                                self.focus = nil
                                self.searchWord = ""
                            } label: {
                                Text("취소")
                            }
                            
                        }
                    }
                    .padding()
                    
                    Rectangle()
                        .frame(width: Screen.maxWidth, height: 1, alignment: .bottom)
                        .foregroundColor(.black)
                    
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
                        List(communtyViewModel.communities.filter {
                            $0.fields.title.stringValue
                                .localizedCaseInsensitiveContains(self.searchWord) || $0.fields.content.stringValue
                                .localizedCaseInsensitiveContains(self.searchWord)
                        },id: \.self) { item in
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
                        .listStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $isSearchResultShown, destination: {
                CommunitySearchResultView(searchWord: $searchWord)
            })
            .onAppear{
                self.searchWord = ""
                communtyViewModel.fetchCommunity()
            }
        }
    }
}

struct CommunitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CommunitySearchView()
        }
    }
}



