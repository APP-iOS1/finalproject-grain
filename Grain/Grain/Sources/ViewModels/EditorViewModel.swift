//
//  EditorViewModel.swift
//  Grain
//
//  Created by 지정훈 on 2023/03/21.
//

import Foundation
import Combine


final class EditorViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var editorData = [EditorDocument]()
    
    var fetchEditorSuccess = PassthroughSubject<(), Never>()
    
    func fetchEditor() {
        EditorService.getEditor()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (data: EditorResponse) in
                self.editorData = data.documents
                self.fetchEditorSuccess.send()
            }.store(in: &subscription)
        
    }
    
}
