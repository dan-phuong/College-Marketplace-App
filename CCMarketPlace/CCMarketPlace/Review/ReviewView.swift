//
//  ReviewView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/28/24.
//

import SwiftUI

struct ReviewView: View {
    @State var user: Student
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ReviewView(user: Student(id: UUID(),
                             name: "Jane Doe",
                             email: "J_Doe@ColoradoCollege.edu",
                             classYear: "Senior",
                             userRating: 2.5,
                             reviews: [],
                             productSet: [],
                             purchases: [],
                             likedSet: [])
    )
}
