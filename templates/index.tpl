<html>
    <head>
        <title>{$website_name} | {$page_title}</title>
        <link rel="stylesheet" type="text/css" href="css/login.css" />
    </head>
    <body>
        <div id="main">
            <span style="font-size: 150px; text-shadow: 5px 5px grey;">BibMan</span>
            <br/>
            <span style="text-shadow: 2px 2px grey; text-align: center; font-family: script; font-size: 32px;">Cloud powered bibliography management.<br><br>(Beta: Not all features working!)</span>
            <form action="index.php" method="post">
                <input name="email" type="text" value="Email Address" style="color: grey;" onfocus="this.value = ''"/>
                <br/><br/>
                <input name="password" type="text" value="Password" style="color: grey;" onfocus="this.value = '';
                        this.type = 'password';"/>
                <br/>
                <br/>
                <input type="submit" value="Log In" style="width: 250px; color: white; background-color: gray"/>&nbsp;<input type="button" onclick="window.location='register.php'" value="Register" style="width: 250px; color: white; background-color: gray"/>
            </form>
        </div>
    </body>
</html>
