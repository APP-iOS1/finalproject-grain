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
    
    @State var allButtonClickedBool : Bool = true
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
            Button {
                allButtonClickedBool.toggle()
                categoryString = "전체"
                buttonSwitch(index: categoryString)
            } label: {
                
                Rectangle()
                    .foregroundColor(allButtonClickedBool ? Color(hex: "1A4645") : .white)
                    .overlay{
                        HStack{
                            if !allButtonClickedBool{
                                Image("allMarker")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                            }
                            Text("전체")
                                .fontWeight(.bold)
                                .font(.caption) //살짝 키우기
                                .foregroundColor(allButtonClickedBool ? .white : .gray)
                        }
                       
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(allButtonClickedBool ? Color(hex: "1A4645") : .white , lineWidth: 5)
                    }.cornerRadius(10)
                    .frame(width:89, height:40)
                    
            }
            
            Button {
                photoButtonClickedBool.toggle()
                categoryString = "포토스팟"
                buttonSwitch(index: categoryString)
            } label: {
                Rectangle()
                    .foregroundColor(photoButtonClickedBool ? Color(hex: "F8BC24") : .white)
                    .overlay{
                        HStack{
                            if !photoButtonClickedBool{
                                Image("photoSpotMarker")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                            }
                            Text("포토스팟")
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundColor(photoButtonClickedBool ? .white : .gray)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(photoButtonClickedBool ? Color(hex: "F8BC24") : .white , lineWidth: 5)
                    }.cornerRadius(10)
                    .frame(width:89, height:40)
                    
            }
            
            Button {
                StationButtonClickedBool.toggle()
                categoryString = "현상소"
                buttonSwitch(index: categoryString)
            } label: {
                Rectangle()
                    .foregroundColor(StationButtonClickedBool ? Color(hex: "F58800") : .white)
                    .overlay{
                        HStack{
                            if !StationButtonClickedBool{
                                Image("stationMarker")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                            }
                            Text("현상소")
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundColor(StationButtonClickedBool ? .white : .gray)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(StationButtonClickedBool ? Color(hex: "F58800") : .white , lineWidth: 5)
                    }.cornerRadius(10)
                    .frame(width:89, height:40)
                    
            }
            
            Button {
                repairButtonClickedBool.toggle()
                categoryString = "수리점"
                buttonSwitch(index: categoryString)
            } label: {
                Rectangle()
                    .foregroundColor(repairButtonClickedBool ? Color(hex: "266867") : .white)
                    .overlay{
                        HStack{
                            if !repairButtonClickedBool{
                                Image("repairShopMarker")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                            }
                            Text("수리점")
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundColor(repairButtonClickedBool ? .white : .gray)
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(repairButtonClickedBool ? Color(hex: "266867") : .white , lineWidth: 5)
                    }.cornerRadius(10)
                    .frame(width:89, height:40)
                    
            }
        }
    }
}
