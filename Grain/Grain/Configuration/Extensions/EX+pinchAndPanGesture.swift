//
//  EX+pinchAndPanGesture.swift
//  Grain
//
//  Created by 조형구 on 2023/03/01.
//

import SwiftUI

extension View {
    /// Add Pinch to Zoom With DragGesture Modifier
    func addPinchZoom(backgroundColor: Color = .black) -> some View {
        return PinchZoomContext(content: {self}, backgroundColor: backgroundColor)
    }
}

/// Helper 구조체
struct PinchZoomContext<Content: View>: View {
    @ViewBuilder let content:()-> Content
    
    @State var offset: CGPoint = .zero
    @State var scale: CGFloat = 0
    
    @State var scalePosition: CGPoint = .zero
    @State var opacity: Double = 0
    
    // SecneStorage 을 통해 줌이 작동하는지 안하는지 파악하려고 하는데 잘 안되는듯
    @SceneStorage("isZooming") var isZooming: Bool = false
    @SceneStorage("index") var selectedIndex: Int = 0
    
    let backgroundColor: Color
    
    var body: some View{
        ZStack{
            if scale > 0 {
                backgroundColor
                    .opacity(Double(max(min(scale, 0.7), 0.3)))
                    .frame(width: Screen.maxWidth, height: Screen.maxHeight * 3)
            }
            
            TabView(selection: $selectedIndex){
                content()
                // offset을 지정
                    .offset(x: offset.x, y: offset.y)
                // UIKit Gesture Reconizer 를 이용해서 제스처가 벌어지고 있는 상태에 대한 조건과 두개의 제스처가 동시에 이뤄질 수있도록 만들어줌
                    .overlay(
                        GeometryReader{ proxy in
                            let size = proxy.size
                            ZoomGesture(size: size, scale: $scale , offset: $offset, scalePosition: $scalePosition)
                            
                        }
                    )
                // Content를 확대하는 scaleEffect부분
                    .scaleEffect(1 + (scale < 0 ? 0 : scale), anchor: .init(x: scalePosition.x, y: scalePosition.y))
                // 줌이 시작되면 zIndex 를 올려주는 부분 지금 우리 상황에서는 필요 없을지도? 그리고 offset은 줌이 시작되어야 바꿀 수 있어서 큰 의미 없는 조건
                    .zIndex((scale != 0 || offset != .zero) ? 1000: 0)
                    .onChange(of: scale) { newValue in
                        
                        isZooming = (scale != 0 || offset != .zero)
                        if scale == -1 {
                            // 애니메이션을 자연스럽게 적용하기 위한 부분
                           g
                                scale = 0
                            }
                        }
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: isZooming ? .never : .automatic))
            
        }
    }
}

struct ZoomGesture: UIViewRepresentable {
   
    // Scale을 계산해서 사이즈를 받는 부분
    var size: CGSize
    
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    
    @Binding var scalePosition: CGPoint
    
    /// Coordinator 연결 메소드
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        // 핀치 줌 제스처 추가
        let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        
        view.addGestureRecognizer(Pinchgesture)
        
        // 드레그 제스처 추가
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        
        Pangesture.delegate = context.coordinator
        
        view.addGestureRecognizer(Pinchgesture)
        view.addGestureRecognizer(Pangesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    /// 제스처에 조건을 부여하는 핸들러
    class Coordinator: NSObject,UIGestureRecognizerDelegate{
        
        var parent: ZoomGesture
        
        init(parent: ZoomGesture) {
            self.parent = parent
        }
        
        // 두개의 제스처가 동시에 인식되도록 하는 부분
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        @objc
        func handlePan(sender: UIPanGestureRecognizer){
            
            // 최대 터치 수 정한 부분
            sender.maximumNumberOfTouches = 2
            
            // 최소 scale 은 1
            if (sender.state == .began || sender.state == .changed) && parent.scale > 0 {
               
                if let view = sender.view{
                    
                    // 드레그 제스처에 따른 offset 변화값
                    let translation = sender.translation(in: view)
                    
                    parent.offset = translation
                }
            }
            else if sender.cancelsTouchesInView {
                // 제스처 끝난 후에 원래 상태로 돌리는 부분
                withAnimation{
                    parent.offset = .zero
                    parent.scalePosition = .zero
                }
            }
            
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            
            // Scale을 계산하는 부분
            if sender.state == .began || sender.state == .changed {
                
                // 스케일을 세팅하는 부분
                // 기본 값이 1이기 때문에 1을 제거
                parent.scale = (sender.scale - 1)
                
                // 중앙만 핀치하는것이 아니라 원하는 부분을 골라서 핀치 줌 하도록 위치를 잡는 부분
                let scalePoint = CGPoint(x: sender.location(in: sender.view).x / sender.view!.frame.size.width, y: sender.location(in: sender.view).y / sender.view!.frame.size.height)
                
                // 결과는 이런식으로 나옴((0...1), (0...1))
                // 스케일 포인트는 한번 지정된 후에 바뀌지 않게 함
                parent.scalePosition = (parent.scalePosition == .zero ? scalePoint : parent.scalePosition)
            }
            else {
                // 제스처가 끝났을 때 크기를 원래로 돌려 놓는 부분
                withAnimation(.easeInOut(duration: 0.35)){
                    parent.scale = -1
                    parent.scalePosition = .zero
                }
            }
        }
    }
}
