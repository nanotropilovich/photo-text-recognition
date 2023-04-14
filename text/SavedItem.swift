//
//  SavedItem.swift
//  text
//
//  Created by Ilya on 12.04.2023.
//

import Foundation
import SwiftUI
import UIKit
import Vision
import CoreML
struct SavedItem: Identifiable {
    let id = UUID()
    let text: String
    let image: UIImage
}

struct SavedItemsView: View {
    @State private var savedItems: [SavedItem] = []
    
    var body: some View {
        NavigationView {
            List(savedItems) { item in
                HStack {
                    Image(uiImage: item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text(item.text)
                        .padding(.leading)
                }
            }
            .navigationBarTitle("Saved Items")
        }
        .onAppear(perform: loadSavedItems)
    }

    func loadSavedItems() {
        let savedItemsData = UserDefaults.standard.array(forKey: "savedItems") as? [[String: String]] ?? []
        var items: [SavedItem] = []

        for itemData in savedItemsData {
            if let imagePath = itemData["imagePath"],
               let text = itemData["text"],
               let image = loadImageFromPath(imagePath) {
                items.append(SavedItem(text: text, image: image))
            }
        }

        savedItems = items
    }

    func loadImageFromPath(_ imagePath: String) -> UIImage? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(imagePath)
        
        if let imageData = try? Data(contentsOf: fileURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

