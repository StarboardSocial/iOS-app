//
//  PostWidget.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 23/12/2024.
//

import SwiftUI

struct PostWidget: View {
    
    init(_ post: Post) {
        _post = post
    }
    
    @State var imageSize: CGSize = .init(width: 1000, height: 500)
    
    let _post: Post
    
    var profileBanner: some View {
        HStack {
            Circle()
                .fill((Color.accentColor))
                .frame(width: 40)
                .aspectRatio(1, contentMode: .fit)
                .overlay(content: {
                    Image(systemName: "person")
                        .foregroundStyle(Color.white)
                })
            
            VStack(alignment: .leading) {
                Text(_post.userName)
                    .font(.headline)
                Text(_post.postedAt.timeAgoDisplay())
                    .font(.footnote)
                    .fontWeight(.light)
            }
            Spacer()
        }
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            profileBanner
            
            let imageUrl: URL? = URL(string: _post.image?.url ?? "")
            
            if (imageUrl == nil) {
                Text("No image available")
            } else {
                HStack {
                    Spacer()
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .tint(.accentColor)
                    }
                    .frame(height: 250)
                    Spacer()
                }
                

            }
            Text(_post.title)
                .font(.title3)
                .bold()
            Text(_post.description)
                .font(.callout)
                .fontWeight(.light)
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    let post = Post(
        id: "dwuhjhd83ud98qh3hd8h3qhd",
        userId: "j9d32fhw9fh3fh",
        title: "Test Post",
        description: "This is an amazing test post to make sure everything works",
        image: PostImage(
            id: "test", url: "https://dummyimage.com/500x300/000/fff"),
        postedAt: Date.now
    )
    PostWidget(post)
}
