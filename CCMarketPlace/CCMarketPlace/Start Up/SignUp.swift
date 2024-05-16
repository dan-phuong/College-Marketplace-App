////
////  SignUp.swift
////  CCMarketPlace
////
////  Created by JTT on 1/30/24.
////

//
//  ContentView.swift
//  LoginScreenTutorial
//
//  Created by Duy Bui on 11/9/19.
//  Copyright © 2019 iosAppTemplates. All rights reserved.
//
import SwiftUI

struct SignUpView: View {
    // MARK: - Propertiers
    @EnvironmentObject var currentUser: CurrentUserManager
    @State private var createdAccount = false
    @State private var invalidCreatedAccount = false
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var classYear = ""
    @State private var code: String = ""
    @State private var EmailAuthenticating = false
    @State private var sentEmail = false
    @State private var name = ""
    @State private var phone = ""
    var dropDownItem: [String]  = ["Freshman", "Sophmore", "Junior", "Senior", "Super-Senior"]
    
    // MARK: - View
    var body: some View {
        NavigationView{
            VStack() {
                Image("LogInLogo")
                //.resizable()
                    .frame(width: 330, height: 90)
                    .padding(.top, 150)
                    .padding(.bottom, 50)
                
                
                VStack(alignment: .center, spacing: 15) {
                    if(createdAccount){
                        TextField("name", text: self.$name)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 10, y: 7)
                        
                        TextField("phone number (optional)", text: self.$phone)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 10, y: 7)
                    }
                    else{
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
                        
                        
                        HStack{
                            TextField("classYear", text: self.$classYear)
                                .padding()
                                .background(Color.themeTextField)
                                .cornerRadius(20.0)
                                .shadow(radius: 10.0, x: 10, y: 7)
                            
                            
                            Menu {
                                ForEach(dropDownItem, id: \.self){ item in
                                    Button(item) {
                                        self.classYear = item
                                    }
                                }
                            } label: {
                                VStack(spacing: 5){
                                    Image(systemName: "chevron.down")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                    if(EmailAuthenticating) {
                        TextField("Enter Email Verification Code", text: self.$code)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 10, y: 7)
                    }
                    
                    
                }.padding([.leading, .trailing], 27.5)
                
                //sign up button
                Button {
                    Task {
                        // Sending email
                        if(!EmailAuthenticating && !sentEmail){
                            EmailAuthenticating = true
                            emailAuthenticate(email: email)
                        }
                        
                        // Verify Email
                        if(EmailAuthenticating && sentEmail){
                            emailVerification(code: code)
                        }
                        
                        if createdAccount{
                            currentUser.setName(name: self.name)
                            currentUser.setPhone(phone: self.phone)
                            globals.loggedIn=true
                        }
                        //signUp(email: email, password: password, classYear: classYear)
                    }
                } label: {
                    HStack {
                        if createdAccount{
                            Text("Welcome!")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color("kYellow"))
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 10, y: 7)
                        }else if(sentEmail && EmailAuthenticating){
                            Text("Verify Email")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color("kYellow"))
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 10, y: 7)
                        }else{
                            Text("SIGN UP!")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color("kYellow"))
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 10, y: 7)
                        }
                    }
                    .padding(.top, 50)
                }
                
                if invalidCreatedAccount {
                    Text("Account already exists")
                        .foregroundColor(.red)
                        .padding(.top, 12)
                        .padding(.horizontal)
                }
                
                if EmailAuthenticating && sentEmail{
                    Text("Sending email verification")
                        .foregroundColor(Color("kGreen"))
                        .padding(.top, 12)
                        .padding(.horizontal)
                }
                
                
                //                NavigationLink(destination: SwipeView()) {
                //                    Text("Sign Up!")
                //                        .font(.headline)
                //                        .foregroundColor(.black)
                //                        .frame(width: 300, height: 50)
                //                        .background(Color.yellow)
                //                        .cornerRadius(15.0)
                //                        .shadow(radius: 10.0, x: 20, y: 10)
                //                }
                //                .padding(.top, 20)
                Spacer()
            }
            .background( LinearGradient(gradient: Gradient(colors: [Color("kBlueVar2"), Color("kDGrey")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            
        }
    }
    
    func emailAuthenticate(email: String){
        let endpoint = URL(string: "http://10.13.44.30:8080/api/email/authenticate/retrieve/"+email)
        var request = URLRequest(url: endpoint!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                sentEmail = true
                print("EMAIL SENT")
            } else {
                print("NO EMAIL")
            }
        }.resume()
    }
    
    func emailVerification(code: String){
        let endpoint = URL(string: "http://10.13.44.30:8080/api/email/authenticate/send/"+code)
        var request = URLRequest(url: endpoint!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                signUp(email: email, password: password, classYear: classYear)
                print("VERIFIED")
            } else {
                print("NOT VERIFIED")
            }
        }.resume()
    }
    
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
    
    func signUp(email: String, password: String, classYear: String) {
        let endpoint = URL(string: "http://10.13.44.30:8080/api/student/addNewStudent")
        var request = URLRequest(url: endpoint!)
        
        let parameters: [String: Any] = [
            "email": email.lowercased(),
            "password": password.lowercased(),
            "classYear": classYear.lowercased()
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print("~~~~~~~~DATA~~~~~~~~")
                let str = String(decoding: data, as: UTF8.self)
                if str == "true" {
                    //DispatchQueue.main.async {
                    createdAccount = true
                    invalidCreatedAccount = false
                    activateUser(email: email, password: password)
                    
                    //globals.loggedIn = true
                    //}
                } else if str == "false" {
                    //DispatchQueue.main.async {
                    invalidCreatedAccount = true
                    createdAccount = false
                    //}
                }
            }
        }.resume()
    }
    
}

#Preview {
    SignUpView()//SignUpView
        .environmentObject(CurrentUserManager())
}
