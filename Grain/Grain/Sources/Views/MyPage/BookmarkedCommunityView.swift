////
////  BookmarkedCommunityView.swift
////  Grain
////
////  Created by 홍수만 on 2023/02/06.
////
//
//import SwiftUI
//
//struct BookmarkedCommunityView: View {
//    @Environment(\.presentationMode) var presentationMode
//    
//    var community: [CommunityDocument]
//
//    var body: some View {
//        VStack{
//            //MARK: 상단바
//            HStack{
//                Button{
//                    presentationMode.wrappedValue.dismiss()
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("설정")
//                    }
//                    .padding(.horizontal)
//                }
//                
//                Spacer()
//                
//                Text("저장된 커뮤니티 글")
//                    .font(.title3)
//                    .bold()
//                    .padding(.trailing, 80)
//                
//                Spacer()
//            }
//            .accentColor(.black)
//            
//            ScrollView{
//                ForEach(community, id: \.self) { data in
//                    NavigationLink {
//                        CommunityDetailView(community: data)
//                    } label: {
//                        CommunityRowView(community: data)
//
//                    }
//                }
//            }
//        }
//        
//    }
//}
//
//struct BookmarkedCommunityView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            BookmarkedCommunityView(communityVM: <#CommunityViewModel#>)
//        }
//    }
//}
