////
////  ImageTesting.swift
////  CT
////
//  Created by Nate Owen on 2/11/24.
////
//
//import SwiftUI
//import Firebase
//import FirebaseStorage
//import SDWebImageSwiftUI
//
//struct  ImageTesting: View {
//    @State private var imageURL: URL?
//
//    var body: some View {
//        if let imageURL = imageURL {
//            // Display the downloaded image
//            WebImage(url: imageURL)
//                .resizable()
//                .scaledToFit()
//        } else {
//            // Loading state
//            Text("Loading...")
//                .onAppear {
//                    // Download the image when the view appears
//                    downloadImage()
//                }
//        }
//    }
//
//    func downloadImage() {
//        let storageRef = Storage.storage().reference().child("Schools/UVA/comemay.jpeg")
//
//        storageRef.downloadURL { (url, error) in
//            if let error = error {
//                print("Error downloading image: \(error.localizedDescription)")
//            } else if let url = url {
//                // Update the imageURL state variable
//                imageURL = url
//            }
//        }
//    }
//}
//
//
//#Preview {
//    ImageTesting()
//}
