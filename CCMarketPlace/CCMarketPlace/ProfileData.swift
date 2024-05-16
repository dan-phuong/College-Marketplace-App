/*
import SwiftUI

struct ServerTester2View: View {
    @State private var data: [Post] = []

    var body: some View {
        List(data, id: \.id) { post in
            VStack(alignment: .leading) {
                Text(post.name)
                Text(post.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(post.password)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(post.classYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        guard let url = URL(string: "http://10.13.44.30:8080/api/student/getAllStudents") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self.data = posts
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
*/

struct Post: Codable {
    let id: Int64
    let name: String
    let email: String
    let password: String
    let classYear: String
    let userRating: Double
    let numReviews: Int
    let productList: [String]
}


import SwiftUI

struct ProfileData: View {
    @State private var data: [Post] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            if let selectedPost = data.first {  // Assuming you want to display the details of the first post
                Text(selectedPost.name)
                    .font(.title)
                    .foregroundColor(Color.black)
                Text(selectedPost.classYear)
                    .foregroundColor(Color.black)
                    .padding(.top, 8)
                Text(selectedPost.email.split(separator: "@").first ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    + Text("@CC.edu")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                
            } else {
                Text("No post selected")
            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        guard let url = URL(string: "http://10.13.44.30:8080/api/student/getAllStudents") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self.data = posts
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}



