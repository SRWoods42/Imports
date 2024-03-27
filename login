def login(): # used for login which runs when the user clicks the login button 
    UsernameorEmail = LoginWindow_InputField1.value
    Password = LoginWindow_InputField2.value
    if not all([UsernameorEmail,Password]):
        LoginWindow.error("Error", "Please fill in all fields.")
    else:
        if '@' in UsernameorEmail:
            LoginForm_Field1Type = "usrEmail"
        else:
            LoginForm_Field1Type = "usrUsername"
        Password = hashPassword(Password)
        # creates an sql query which will search the database for the either the username or email and password
        result = searchDB(f"select * from user where {LoginForm_Field1Type} = ? AND usrPassword = ?", UsernameorEmail, Password) # this mitigates sql injection with this query statment as it complies with legal requirements
        if len(result) > 0: # check to see if there is a result from the database by checking if its greater than 1
            global userLoggedinID # sets up the global variables of the users details to be used elsewhere in the program
            userLoggedinID = result[0][0]

            global usrIsTeacher # sets up the global variables of the users details to be used elsewhere in the program
            usrIsTeacher = result[0][0]
            global usrLoggedinEmail
            usrLoggedinEmail = result[0][1]
            global usrLoggedinUsername
            usrLoggedinUsername = result[0][2]
            global usrLoggedinFirstName
            usrLoggedinFirstName = result[0][4]
            global usrLoggedinLastName
            usrLoggedinLastName = result[0][5]
            global usrPassword
            usrPassword = result[0][3]
            usrPassword = "*" * len(usrPassword) #convert users password into stars
            usrPassword = usrPassword[:-110] # as the password is hashed we removed most of the length to make it look like their password

            DashboardWindow_WelcomeUsername.value = f"{usrLoggedinFirstName} {usrLoggedinLastName}"

            #LoadSettings() #Load load users settings
            loadDueTests(userLoggedinID) # load users due tests
            #print("Check ", userLoggedinID) # SW
            print(f"Successfully logged in as {userLoggedinID} - {usrLoggedinUsername} - {usrLoggedinEmail}")
            hidex(LoginWindow)
            showx(DashboardWindow)
            changeWindow("MainPage")
            clearx(LoginWindow_InputField1,LoginWindow_InputField2)
            
        else:
            LoginWindow.error("Error", "Username/Email or Password is invalid")
