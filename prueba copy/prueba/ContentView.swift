import SwiftUI
import FirebaseAuth
// Main content view that manages user account creation and navigation
struct ContentView: View {
    // User's name
    @State private var nombre: String = ""
    // User's email
    @State private var email: String = ""
    // User's password
    @State private var password: String = ""
    // Flag to check if account was created
    @State private var isAccountCreated: Bool = false
    // Flag to show login view
    @State private var showLoginView: Bool = false
    // Flag to show main content view
    @State private var showMainView: Bool = false
    // Error message for account creation
    @State private var accountError: String?

    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Background image
            Image("exoplanet")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.bottom, -500)
            
            // If the main view should be shown
            if showMainView {
                MainView(showMainView: $showMainView)
            } else {
                VStack(spacing: 30) {
                    // User icon
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 70.0, height: 70.0)
                        .foregroundColor(.white)
                
                    // Title
                    Text("Create User")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Name text field
                    TextField("Name", text: $nombre)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .frame(width: 290.0, height: 50.043)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 3).fill(Color.gray.opacity(0.2)))
                    
                    // Email text field with icon
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .frame(width: 212.0, height: 50)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal)
                            .foregroundColor(.white)
                    }
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 3).fill(Color.gray.opacity(0.2)))
                    
                    HStack {
                        // Password secure field with icon
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .padding(.leading, -8)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.leading, 8)
                            .foregroundColor(.white)
                            .frame(height: 50)
                    }
                    .padding()
                    .frame(width: 285.0, height: 50.0)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 3).fill(Color.gray.opacity(0.2)))
                    
                    // Create and design an account button
                    Button(action: crearCuenta) {
                        Text("Create account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .frame(width: 285.0, height: 50.0)
                            .background(Color(red: 0.0, green: 0.9, blue: 1.0))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    // Navigate to login view button
                    Button(action: { showLoginView = true }) {
                        Text("Do you already have an account?")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .frame(width: 285.0, height: 50.0)
                            .background(Color(.white))
                            .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Display account creation error if any
                    if let error = accountError {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Spacer()
                }
                .fullScreenCover(isPresented: $showLoginView) {
                    // Present login view
                    LoginView(showMainView: $showMainView)
                }
            }
        }
    }
    
    // Function to create an account
    private func crearCuenta() {
        guard !nombre.isEmpty, !email.isEmpty, !password.isEmpty else {
            accountError = "Please, complete all fields."
            return
        }
        
        guard isValidEmail(email) else {
            accountError = "Please, enter a valid email."
            return
        }

        // Call firebase to create a user
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                accountError = "Error creating account: \(error.localizedDescription)"
                return
            }
            
            isAccountCreated = true
            showMainView = true
            print("Account created successfully: \(result?.user.uid ?? "")")
        }
    }
    
    // Validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

// Login view struct for user login functionality
struct LoginView: View {
    @Binding var showMainView: Bool
    @Environment(\.dismiss) var dismiss
    // User email for login
    @State private var email: String = ""
    // User password for login
    @State private var password: String = ""
    // Flag for successful login
    @State private var isLoginSuccessful: Bool = false
    // Error message for login
    @State private var loginError: String?

    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Background image for login
            Image("exoplanet")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(180))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y:-370)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                
                // Title
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Email text field for login
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(width: 290.0, height: 50.043)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 3).fill(Color.gray.opacity(0.2)))
                
                // Password secure field for login
                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(width: 290.0, height: 50.043)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 3).fill(Color.gray.opacity(0.2)))

                // Display login error if any
                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Login button
                Button(action: iniciarSesion) {
                    Text("Login")
                        .frame(width: 252.0, height: 20.0)
                        .padding()
                        .background(Color(red: 0.0, green: 0.9, blue: 1.0))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Show successful login message
                if isLoginSuccessful {
                    Text("Successful login!")
                        .foregroundColor(.green)
                }
                
                // Back button to return to previous view
                Button(action: { dismiss() }) {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(width: 285.0, height: 50.0)
                        .background(Color(.white))
                        .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // Function to handle user login
    private func iniciarSesion() {
        // Check if email and password fields are not empty
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Please, complete all fields."
            return
        }

        // Attempt to sign in with Firebase using the provided email and password
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // Capture and display any error that occurs during login
                loginError = "Login error: \(error.localizedDescription)"
                return
            }
            
            // Set login success flag and navigate to main view
            isLoginSuccessful = true
            showMainView = true
            print("Successful login: \(result?.user.uid ?? "")")
        }
    }
}

// Main view struct that displays after successful login
struct MainView: View {
    // Binding to control visibility of main view
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Set background color to black
                Color.black.ignoresSafeArea()
                // Custom view for background image
                OverlayImageView(backgroundImageName: "Image 1")
                    .ignoresSafeArea()
                
                // Image positioned at the top right
                Image("Image 2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 250)
                    .padding()
                    .position(x: 320, y: 100)
                
                VStack(spacing: 20) {
                    ZStack {
                        // Semi-transparent rectangle background for title
                        Rectangle()
                            .fill(Color(red: 0.0, green: 0.9, blue: 1.0).opacity(0.3))
                            .frame(width: 300, height: 250)
                            .cornerRadius(40)
                            .position(x: 188, y: 380)
                        
                        // Title text
                        Text("EXOEXPLORER")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .position(x: 188, y: 330)
                        
                        // Subtitle text
                        Text("Explore exoplanets \n and stars")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .position(x: 188, y: 400)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    ZStack {
                        // Rectangle background for "ExoGame" section

                        Rectangle()
                            .fill(Color.gray.opacity(0.7))
                            .frame(width: 180, height: 250)
                            .cornerRadius(40)
                            .position(x: 100, y: 380)

                        // "ExoGame" title text
                        Text("ExoGame")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .lineLimit(0)
                            .frame(width: nil)
                            .position(x: 100, y: 380)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 150, height: 250)
                            .cornerRadius(40)
                            .position(x: 280, y: 103)

                        // VR title text
                        Text("VR")
                            .foregroundColor(.white)
                            .font(.system(size: 40, weight: .heavy))
                            .multilineTextAlignment(.center)
                            .position(x: 280, y: 30)

                        // Description text for VR section
                        Text("Watch in\n virtual reality \n some \n exoplanets")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .position(x: 280, y: 120)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Spacer()
                }
                .padding()
                .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                showMainView = false
            }) {
                Text("Back")
                    .foregroundColor(.blue)
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Custom view for overlaying a background image
struct OverlayImageView: View {
    var backgroundImageName: String

    var body: some View {
        Image(backgroundImageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

// Preview provider for SwiftUI preview functionality
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview of the ContentView
        ContentView()
    }
}
