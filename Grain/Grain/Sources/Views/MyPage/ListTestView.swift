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
    
    var body: some View {
        Form {
            ForEach(0 ..< items.count, id: \.self) { index in
                TextField("Enter item", text: self.$items[index])
            }
            .onDelete(perform: removeItems)
            
            Button(action: addItem) {
                Text("Add Item")
            }
        }
    }
    
    func addItem() {
        items.append("Item \(items.count + 1)")
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
