import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var loginUsername = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var username = ""
    @State private var confirmPassword = ""
    @State private var isCreatingAccount = false
    @State private var showPassword = false
    @State private var isLoggedIn = false
    
    @ViewBuilder
    var body: some View {
        if isLoggedIn {
            ContentView()
        } else {
            NavigationStack {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Text("Sidequester")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Sign in to continue")
                        .foregroundStyle(.secondary)
                    
                    if isCreatingAccount {
                        TextField("Username", text: $username)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    if !isCreatingAccount {
                        TextField("Username", text: $loginUsername)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                        }
                    }
                    
                    if isCreatingAccount {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                    
                    if !isCreatingAccount {
                        Button("Log In") {
                            let cleanLoginUsername = loginUsername.lowercased().filter { $0.isLetter || $0.isNumber }
                            let loginEmail = "\(cleanLoginUsername)@sidequester.app"
                            
                            Auth.auth().signIn(withEmail: loginEmail, password: password) { _, error in
                                if let error {
                                    errorMessage = error.localizedDescription
                                } else {
                                    errorMessage = ""
                                    isLoggedIn = true
                                    print("Logged in successfully")
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .disabled(loginUsername.isEmpty || password.isEmpty)
                    }
                    
                    Button(isCreatingAccount ? "Finish Creating Account" : "Create Account") {
                        if !isCreatingAccount {
                            isCreatingAccount = true
                            return
                        }
                        
                        guard password == confirmPassword else {
                            errorMessage = "Passwords do not match."
                            return
                        }
                        
                        let cleanUsername = username.lowercased().filter { $0.isLetter || $0.isNumber }
                        let generatedEmail = "\(cleanUsername)@sidequester.app"
                        
                        Auth.auth().createUser(withEmail: generatedEmail, password: password) { result, error in
                            if let error {
                                errorMessage = error.localizedDescription
                                return
                            }
                            
                            guard let user = result?.user else { return }
                            
                            let db = Firestore.firestore()
                            db.collection("users").document(user.uid).setData([
                                "username": cleanUsername,
                                "points": 0,
                                "streak": 0,
                                "longestStreak": 0,
                                "createdAt": Timestamp(),
                                "lifetimeCompletedActivities": 0,
                                "activitiesCreated": 0,
                                "completedActivities": [],
                                "createdActivities": []
                            ]) { error in
                                if let error {
                                    errorMessage = error.localizedDescription
                                } else {
                                    errorMessage = "Account created successfully!"
                                    isCreatingAccount = false
                                    username = ""
                                    password = ""
                                    confirmPassword = ""
                                    print("Account created and saved to users database: \(user.uid)")
                                }
                            }
                        }
                    }
                    
                    if isCreatingAccount {
                        Button("Back to Log In") {
                            isCreatingAccount = false
                            errorMessage = ""
                            username = ""
                            password = ""
                            confirmPassword = ""
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    

}
