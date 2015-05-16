<html>
    <head>
        <title>Register</title>
        <link rel="stylesheet" type="text/css" href="css/login.css" />
    </head>
    <body>
        <div id="main">
            <span style="font-size: 64px; text-shadow: 5px 5px grey;">BibMan</span>
            <br/>
            <form method="post" action="register.php" style="width: 60%; margin-left: auto; margin-right: auto; padding: 10px;">
                <input type="hidden" name="action" value="register"/>
                <fieldset style="padding: 10px;">
                    <legend><strong>Register New Account</strong></legend>
                    <label>Email Address</label>
                    <br/><br/>
                    <input type="email" name="email_address"/>
                    <br/><br/>
                    <label>Display Name</label>
                    <br/><br/>
                    <input type="text" name="display_name_input"/>
                    <br/><br/>
                    <label>Password</label>
                    <br/><br/>
                    <input type="password" name="password"/>
                    <br/><br/>
                    <input type="submit" value="Register Now" />
                </fieldset>
            </form>
        </div>
    </body>
</html>
