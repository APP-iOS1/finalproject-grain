//
//  MapCategoryCellView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI


struct MapCategoryCellView: View {
    
    // MARK: 카테고리 종류 리스트
    // category -> 0: 포토스팟 / 1: 현상소 / 2: 수리점
    let categoryList : [String] = ["전체","포토스팟", "현상소", "수리점"]
    @Binding var categoryString : String
    
    @State var allButtonClickedBool : Bool = false
    @State var photoButtonClickedBool : Bool = false
    @State var StationButtonClickedBool : Bool = false
    @State var repairButtonClickedBool : Bool = false
   
    // MARK: 오버레이
    let style = StrokeStyle(lineWidth: 2,
                            lineCap: .round)
    
    func buttonSwitch(index: String){
        switch index{
        case "전체":
            photoButtonClickedBool = false
            StationButtonClickedBool = false
            repairButtonClickedBool = false
        case "포토스팟":
            allButtonClickedBool = false
            StationButtonClickedBool = false
            repairButtonClickedBool = false
        case "현상소":
            allButtonClickedBool = false
            photoButtonClickedBool = false
            repairButtonClickedBool = false
        case "수리점":
            allButtonClickedBool = false
            photoButtonClickedBool = false
            StationButtonClickedBool = false
        default:
            StationButtonClickedBool = false
           
        }
    }
    
    var body: some View {
        // MARK: 카테고리 버튼
        HStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(allButtonClickedBool ? .blue : .white)
                .frame(width: 69, height: 40)
                .overlay{
                    Button {
                        allButtonClickedBool.toggle()
                        categoryString = "전체"
                        buttonSwitch(index: categoryString)
                    } label: {
                        
                        Text("전체")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                }
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(photoButtonClickedBool ? .blue : .white)
                .frame(width: 69, height: 40)
                .overlay{
                    Button {
                        photoButtonClickedBool.toggle()
                        categoryString = "포토스팟"
                        buttonSwitch(index: categoryString)
                    } label: {
                        
                        Text("포토스팟")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                }
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(StationButtonClickedBool ? .blue : .white)
                .frame(width: 69, height: 40)
                .overlay{
                    Button {
                        StationButtonClickedBool.toggle()
                        categoryString = "현상소"
                        buttonSwitch(index: categoryString)
                    } label: {
                        
                        Text("현상소")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                }
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(repairButtonClickedBool ? .blue : .white)
                .frame(width: 69, height: 40)
                .overlay{
                    Button {
                        repairButtonClickedBool.toggle()
                        categoryString = "수리점"
                        buttonSwitch(index: categoryString)
                    } label: {
                        
                        Text("수리점")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                }
        }
    }
}
