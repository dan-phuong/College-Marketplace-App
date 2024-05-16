
import SwiftUI

// Login view that calls backend validation
struct LogInView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    
    
    // MARK: - Propertiers
    @State private var attemptedEntry = false
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - View
    var body: some View {
        //@StateObject var logInGlobals = globals
        NavigationStack{
            VStack() {
                
                Image("LogInLogo")
                //.resizable()
                    .frame(width: 330, height: 90)
                    .padding(.top, 150)
                    .padding(.bottom, 50)
                
                
                Text("Welcome!")
                    .font(.title)
                    .foregroundColor(Color("kYellowVar2"))
                    .padding(.vertical, 10)
                    .fontWeight(.bold)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    TextField("email" + "@" + "coloradocollege.edu", text: self.$email)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 10, y: 7)
                    
                    SecureField("password", text: self.$password)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 10, y: 7)
                    
                }.padding([.leading, .trailing], 27.5)
                
                
                //sign in button
                Button {
                    Task {
                        signIn(email: email, password: password)
                        activateUser(email: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color("kYellow"))
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    .padding(.top, 50)
                }
                
                if attemptedEntry {
                    Text("Incorrect username or password")
                        .foregroundColor(.red)
                        .padding(.top, 12)
                        .padding(.horizontal)
                }
                
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                        .foregroundColor(.white)
                    NavigationLink(destination: SignUpView()) {
                        //globals.createAccount = true
                        Text("Sign Up")
                            .foregroundColor(.white)
                    }
                }
            }
            .background( LinearGradient(gradient: Gradient(colors: [Color("kBlueVar2"), Color("kDGrey")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
    
    // Sets global current user
    func activateUser(email: String, password: String) {
        
        let endpoint = URL(string: "http://10.13.44.30:8080/api/student/findStudent")
        var request = URLRequest(url: endpoint!)
        let parameters: [String: Any] = [
            "email": email.lowercased(),
            "password": password.lowercased()
        ]
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let posts = try JSONDecoder().decode(Student.self, from: data)
                DispatchQueue.main.async {
                    currentUser.setUserFromStudent(user: posts)
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    // Signs in user and takes user to SwipeView
    func signIn(email: String, password: String) {
        
        let endpoint = URL(string: "http://10.13.44.30:8080/api/student/loginStudent")
        var request = URLRequest(url: endpoint!)
        
        let parameters: [String: Any] = [
            "email": email.lowercased(),
            "password": password.lowercased()
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("~~~~~~RESPONSE~~~~~~")
                print(response)
            }
            if let data = data {
                print("~~~~~~~~DATA~~~~~~~~")
                let str = String(decoding: data, as:UTF8.self)
                print(str)
                if str == "true" {
                    
                    globals.loggedIn = true
                    
                    
                    
                }
                else if str == "false" {
                    
                    globals.loggedIn = false
                    // Update the local attemptedEntry variable
                    attemptedEntry = true
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print("~~~~~~~~JSON~~~~~~~~")
                    for (k, v) in responseJSON {
                        print("Email:", k, "|", "Password:", v)
                    }
                } else {
                    print("~~~~~~~~????~~~~~~~~")
                    print(data)
                }
            }
        }.resume()
    }

}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

#Preview {
    LogInView()
        .environmentObject(CurrentUserManager())
}
