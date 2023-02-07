//
//  ListTestView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/01.
//

import SwiftUI

struct ListTestView: View {
    //    @State var items: [String] = ["Item 1", "Item 2"]
    //
    //       var body: some View {
    //           List {
    //               ForEach(items, id: \.self) { item in
    //                   Text(item)
    //               }
    //           }
    //           .navigationBarTitle("List")
    //           .navigationBarItems(trailing: Button(action: {
    //               self.items.append("Item \(self.items.count + 1)")
    //           }, label: {
    //               Text("Add Item")
    //           }))
    //       }
    @State private var items: [String] = ["Item 1", "Item 2"]
    @State private var showAddItem = false
    @State private var newItem = ""
    
//    var body: some View {
//        Form {
//            ForEach(0 ..< items.count, id: \.self) { index in
//                TextField("Enter item", text: self.$items[index])
//            }
//            .onDelete(perform: removeItems)
//
//            Button(action: addItem) {
//                Text("Add Item")
//            }
//        }
//    }
//
//    func addItem() {
//        items.append("Item \(items.count + 1)")
//    }
//
//    func removeItems(at offsets: IndexSet) {
//        items.remove(atOffsets: offsets)
//    }
    var body: some View {
           NavigationView {
               List {
                   ForEach(items, id: \.self) { item in
                       Text(item)
                   }
                   .onDelete(perform: removeItems)

                  
                   if showAddItem {
                       HStack {
                           TextField("Enter item", text: $newItem)
                           Button(action: addItem) {
                               Image(systemName: "plus.circle")
//                               Text("등록")
                           }
                       }
                   }
                   
                   HStack{
                       Spacer()
                       Button{
                           showAddItem.toggle()
                           
                       } label: {
//                           Image(systemName: "plus")
                           if showAddItem{
                               Text("완료")
                                   .foregroundColor(Color(UIColor.systemGray2))
                           } else {
                               HStack{
                                   Image(systemName: "plus.circle")
                                   Text("기기 추가하기")
                               }
                               .foregroundColor(Color(UIColor.systemGray))
                           }
                       }
                       Spacer()
                   }
               }
               .navigationBarTitle("Items")
               .navigationBarItems(
                   leading: EditButton(),
                   trailing: Button(action: {
                       showAddItem.toggle()
                   }) {
                       Image(systemName: "plus")
                   }
               )
           }
       }

       func addItem() {
           items.append(newItem)
           newItem = ""
       }

       func removeItems(at offsets: IndexSet) {
           items.remove(atOffsets: offsets)
       }
}

struct ListTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ListTestView()
        }
    }
}
