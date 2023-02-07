import SwiftUI
import FirebaseAuth

struct MagazineDetailView: View {
    var data : MagazineDocument
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                            VStack(alignment: .leading) {
                                Text(data.fields.nickName.stringValue)
                                    .bold()
                                HStack {
                                    Text("1분전")
                                    Spacer()
                                    Text(data.fields.customPlaceName.stringValue)
                                }
                                .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        .padding(.top, -15)
                        Divider()
                            .frame(maxWidth: Screen.maxWidth * 0.9)
                            .background(Color.black)
                            .padding(.top, -5)
                            .padding(.bottom, -10)
                        
                        //            Image("line")
                        //                .resizable()
                        //                .frame(width: Screen.maxWidth, height: 0.3)
                        TabView{
                            ForEach(1..<4, id: \.self) { i in
                                Image("\(i)")
                                    .resizable()
                                    .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(maxHeight: Screen.maxHeight * 0.27)
                        .padding()
                    }
                    .frame(minHeight: 350)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: MagazineDetailHeader(data: data) ){
                            VStack {
                                Text(data.fields.content.stringValue)
                                    .lineSpacing(4.0)
                                    .padding(.vertical, -9)
                                    .padding()
                                    .foregroundColor(Color.textGray)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 1)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    // MARK: 현재 유저 Uid 값과 magazineDB userId가 같으면 수정 삭제 보여주기
                    if data.fields.userID.stringValue == Auth.auth().currentUser?.uid{
                        NavigationLink {
                            MagazineEditView(data: data)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            //삭제
                        } label: {
                            Image(systemName: "trash")
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}
struct MagazineDetailHeader: View {
    var data : MagazineDocument
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(data.fields.title.stringValue)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        .background(Rectangle().foregroundColor(.white))
    }
}

//struct MagazineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MagazineDetailView()
//        }
//
//    }
//}
