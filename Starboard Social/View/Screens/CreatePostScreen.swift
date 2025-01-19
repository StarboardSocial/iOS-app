//
//  CreatePostScreen.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 24/12/2024.
//

import SwiftUI
import PhotosUI

struct CreatePostScreen: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var imageUrl: String = ""
    
    @State private var photoItem: PhotosPickerItem?
    @State private var preview: Image?
    
    
    private func createPostHandler() {
        if (title.isEmpty || photoItem == nil) { return }
        
        Task.detached {
            let post = await PostCreateModel(
                title: title,
                description: description,
                imageBase64: (try? await photoItem?.loadTransferable(type: Data.self)?.base64EncodedString())!,
                imageExtension: (await photoItem?.getFileExtension())!
            )
            _ = await PostRepository.shared.createPost(post)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField(text: $title, label: { Text("Title*") })
                    .textFieldStyle(.roundedBorder)
                TextField(text: $description, label: { Text("Description") })
                    .textFieldStyle(.roundedBorder)
                PhotosPicker("Select Image", selection: $photoItem, matching: .images)

                preview?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Button(action: createPostHandler, label: { Text("Create Post").padding(.horizontal, 100) })
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                Spacer()
            }
            .padding(20)
            .navigationTitle(Text("Create Post"))
            .onChange(of: photoItem) {
                Task {
                    if let loaded = try? await photoItem?.loadTransferable(type: Image.self) {
                        preview = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
        }
    }
}

#Preview {
    CreatePostScreen()
}
