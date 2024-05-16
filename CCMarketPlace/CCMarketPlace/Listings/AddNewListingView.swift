//
//  AddNewListingView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/31/24.
//

import SwiftUI
import PhotosUI

struct AddNewListingView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    let boundary: String = "Boundary-\(UUID().uuidString)"
    
    func uploadImage(){
        let studentId = currentUser.id.uuidString
        let boundary = boundary
        
        let url = URL(string: "10.13.44.30:8080/api/image/uploadProduct/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       
    }
    
    var body: some View {
        VStack {
            PhotosPicker("Select Image for Listing", selection: $avatarItem, matching: .images)
            
            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    AddNewListingView()
        .environmentObject(CurrentUserManager())
}
