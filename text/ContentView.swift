//
//  ContentView.swift
//  text
//
//  Created by Ilya on 12.04.2023.
//

import SwiftUI
import UIKit
import Vision
import CoreML

struct ContentView: View {
    @State public var image: UIImage?
    @State private var recognizedText: String = ""
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Text("No image selected")
                        .font(.title)
                        .padding()
                }
                Spacer()
                Button("Select Image") {
                    showingImagePicker = true
                }
                Spacer()
                NavigationLink(destination: ResultsView(recognizedText: recognizedText), isActive: Binding<Bool>(get: { recognizedText.isEmpty }, set: { _ in })) {

                    Text("Recognize")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
            }
           
            .navigationBarTitle("Handwriting Recognition")
                .navigationBarItems(trailing: NavigationLink(destination: SavedItemsView()) {
                    Image(systemName: "tray.full")
                })
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $image, recognizedText: $recognizedText)
                }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
