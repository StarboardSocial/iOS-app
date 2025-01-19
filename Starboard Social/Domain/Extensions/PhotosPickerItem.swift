//
//  PhotosPickerItem.swift
//  Starboard Social
//
//  Created by Josian van Efferen on 24/12/2024.
//

import Foundation
import SwiftUI
import PhotosUI

extension PhotosPickerItem {
    func getFileExtension() async -> String? {
        guard let data: Data = try? await self.loadTransferable(type: Data.self) else {
            return nil
        }
        
        if let contentType = self.supportedContentTypes.first {
            // Step 2: make the URL file name and a get a file extention.
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = path.appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
            do {
                // Step 3: write to temp App file directory and return in completionHandler
                try data.write(to: url)
                return url.absoluteString.split(separator: ".").last?.lowercased()
            } catch {
                return nil
            }
        }
        return nil
    }
}
