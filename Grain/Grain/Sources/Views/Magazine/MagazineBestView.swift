//
//  MagazineBestView.swift
//  Grain
//
//  Created by 윤소희 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth

struct MagazineBestView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    @ObservedObject var  userVM: UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    @ObservedObject var editorVM : EditorViewModel
    
    @State var ObservingChangeValueLikeNum: String = ""
    @State private var isMagazineEditorViewShown: Bool = false
    @State private var selectIndexNum: Int = 0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    
    @Binding var scrollToTop: Bool
    
    @AppStorage("authenticationState") var authenticationState: AuthenticationState = .unauthenticated
    
    var body: some View {
        VStack{
            ScrollViewReader { proxyReader in
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        EditorViewCell(editorVM: editorVM)
                            .onTapGesture {
                                isMagazineEditorViewShown.toggle()
                            }
                        
                        HStack{
                            Text("인기 피드")
                                .font(.title)
                                .fontWeight(.bold)
                                .fixedSize()
                            Spacer()
                            Image("line")
                                .resizable()
                                .frame(width: Screen.maxWidth * 0.66, height: 2)
                        }
                        .padding([.leading, .top])
                        
                        HStack{
                            Text("\(Image(systemName: "info.circle")) 좋아요 수 기준으로 인기 피드를 보여드립니다.")
                                .font(.footnote)
                                .foregroundColor(.middlebrightGray)
                            Spacer()
                            
                        }
                        .padding(.horizontal,21)
                        .padding(.top, 7)
                        .padding(.bottom, 2)
                       
                        ForEach(Array(magazineVM.sortedTopLikedMagazineData.prefix(10).enumerated()), id: \.1.self ){ (index, data) in  // 좋아요 순으로 최대 10개까지만 뷰에 보여짐
                            NavigationLink {
                                MagazineDetailView(magazineVM: magazineVM, userVM: userVM, data: data, ObservingChangeValueLikeNum: $ObservingChangeValueLikeNum)
                                
                            } label: {
                                LazyVStack{
                                    Top10View(data: data, userVM: userVM)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                    
                                }
                            }
                            
                        }
                        .emptyPlaceholder(Array(magazineVM.sortedTopLikedMagazineData.prefix(10).enumerated())) {
                            MagazinePlaceHolderView()
                        }
                        
                    }
                    .id("SCROLL_TO_TOP")
                    .overlay(
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                if startOffset == 0 {
                                    self.startOffset = proxy.frame(in: .global).minY
                                }
                                let offset = proxy.frame(in: .global).minY
                                self.scrollViewOffset = offset - startOffset
                                
                            }
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
                    .onChange(of: ObservingChangeValueLikeNum
                              , perform: { newValue in
                        magazineVM.fetchMagazine(nextPageToken: "")
                    })
                }
                .refreshable {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(1.6) * 1_000_000_000)
                      } catch {}
                    magazineVM.fetchMagazine(nextPageToken: "")
                }
                .onReceive(magazineVM.fetchMagazineSuccess, perform: { _ in
                    magazineVM.filteringBlockUserCommunity(blockingUsers: userVM.blockingList, blockedUsers: userVM.blockedList)
                })
                .onChange(of: scrollToTop, perform: { newValue in
                    withAnimation(.default) {
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                })
                .navigationDestination(isPresented: $isMagazineEditorViewShown){
                    EditorView(editorVM : editorVM, userVM: userVM, magazineVM: magazineVM)
                }
                .onAppear{
                    editorVM.fetchEditor()
                    UITableView.appearance().separatorStyle = .none
                    
                    if authenticationState == .authenticated{
                        authenticationStore.addToken()
                    }

                }
            }
            Spacer()
        }
    }
}
//
//struct MagazineBestView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
//                .previewDevice("iPhone 14 Pro")
//            
//            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
//                .previewDevice("iPhone SE (3rd generation)")
//            
//            MagazineBestView(userVM: UserViewModel(), magazineVM: MagazineViewModel(), editorVM: EditorViewModel())
//                .previewDevice("iPhone 12 mini")
//        }
//    }
//}
