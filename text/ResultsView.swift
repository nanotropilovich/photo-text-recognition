//
//  ResultsView.swift
//  text
//
//  Created by Ilya on 12.04.2023.
//
import UIKit
import Vision
import CoreML
import Foundation
import SwiftUI
struct ResultsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var recognizedText: String
    @State private var showCopiedMessage = false
    
    var body: some View {
        VStack {
            Text(recognizedText)
                .padding()
            Spacer()
            Button("Save") {
                if let currentImage = UIApplication.shared.windows.first?.rootViewController?.presentedViewController as? ContentView {
                    if let unwrappedImage = currentImage.image {
                        saveText(recognizedText, image: unwrappedImage)
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
            Button("Copy to Clipboard") {
                UIPasteboard.general.string = recognizedText
                showCopiedMessage = true
            }
            .alert(isPresented: $showCopiedMessage) {
                Alert(title: Text("Copied"), message: Text("Text has been copied to clipboard"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .navigationBarTitle("Results")
    }
    
    func saveText(_ text: String, image: UIImage) {
        // Сохранение изображения в файловой системе
        let imagePath = UUID().uuidString
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(imagePath)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL)
        }
        
        // Сохранение текста и пути к изображению в UserDefaults
        
        // Сохранение текста и пути к изображению в UserDefaults
        var savedItems = UserDefaults.standard.array(forKey: "savedItems") as? [[String: String]] ?? []
        savedItems.append(["text": text, "imagePath": imagePath])
        UserDefaults.standard.set(savedItems, forKey: "savedItems")
    }
}
