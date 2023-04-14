//
//  ImagePicker.swift
//  text
//
//  Created by Ilya on 12.04.2023.
//

import SwiftUI
import Vision
import UIKit
import Vision
import CoreML

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var recognizedText: String
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.image = image
                
                // Perform handwriting recognition on the image
                recognizeText(image)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func recognizeText(_ image: UIImage) {
            // Изменение размера изображения перед распознаванием текста
            let newSize = CGSize(width: 800, height: image.size.height * (800 / image.size.width))
            let resizedImage = resizeImage(image, newSize: newSize)
            
            guard let cgImage = resizedImage.cgImage else { return }

            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

                var recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: " ")

                DispatchQueue.main.async {
                    self.parent.recognizedText = recognizedText
                }
            }

            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US", "ru-RU"] // Добавлена поддержка русского языка
            request.customWords = ["@", "#", "$", "%", "&", "*", "(", ")", "-", "_", "=", "+"]

            let requests = [request]

            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? imageRequestHandler.perform(requests)
        }
    }
}

func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
    let rect = CGRect(origin: .zero, size: newSize)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage ?? image
}
