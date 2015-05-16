<!DOCTYPE html>
<html>
    <head>
        <title>BibMan | Online Bibliography</title>
        <link rel="stylesheet" href="css/stylesheet.css" />
    </head>
    <body>
        <div id="container">
            <div id="logo-bar">
                <span class="logo">BibMan</span>
                <span class="float-right"><a href="bibliography.php">Home</a>&nbsp;|&nbsp;<a href="my_account.php">My Account</a>&nbsp;|&nbsp;<a href="logout.php">Logout</a></span>
            </div>
            <div class="clear">
                <div id="sidebar">
                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Change Active Library</legend>
                            <input type="hidden" name="action" value="switch_active_library" />
                            <select name="library_id" class="small">
                                {foreach from=$smarty.session.libraries item=library}
                                    <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
                                {/foreach}
                            </select>
                            <br/><br/>
                            <input type="submit" value="Change Active Library"/>&nbsp;
                            <a href="#" id="library-settings"><img src="images/cog.png" width="16" height="16" alt="Click to open library settings menu."/></a>
                        </fieldset>
                    </form>                    
                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Create New Library</legend>
                            <input type="hidden" name="action" value="add_library" />
                            <input type="text" maxlength="10" name="display_name" class="plain small" />
                            <br/><br/>
                            <input type="submit" value="Add New Library" />
                        </fieldset>
                    </form>
                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Library Sharing</legend>
                            <input type="hidden" name="action" value="unshare_library" />
                            <select name="stop_sharing_addresses[]" class="small" multiple="multiple" {if not $smarty.session.owns_library}disabled="disabled"{/if}>
                                {foreach from=$smarty.session.active_library_shared_with item=collaborator}
                                    <option value="{$collaborator.email}">{$collaborator.display_name}&nbsp;&lt;{$collaborator.email}&gt;</option>
                                {/foreach}
                            </select>
                            <br/><br/>
                            <input type="submit" {if not $smarty.session.owns_library}disabled="disabled"{/if} value="{if $smarty.session.owns_library}Stop Sharing with Selected{else}Sharing Library is Disabled{/if}"/>
                        </fieldset>
                    </form>
                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Share With</legend>
                            <input type="hidden" name="action" value="share_library" />
                            <input type="email" name="email" class="small plain" {if not $smarty.session.owns_library}disabled="disabled"{/if}/>  
                            <br/><br/>
                            <input type="submit" value="{if $smarty.session.owns_library}Add{else}Sharing Library is Disabled{/if}" {if not $smarty.session.owns_library}disabled="disabled"{/if}/>
                        </fieldset>
                    </form>
                    <form action="bibliography.php" method="post" class="validatedForm">
                        <fieldset>
                            <legend>Search Libraries</legend>
                            <input type="hidden" name="action" value="search_library" />
                            <label for="author_name">Author Name</label>
                            <input type="text" name="author_name" id="author_name" value="" class="plain small"/>
                            <br/><br/>
                            <label for="title">Title</label>
                            <input type="text" name="title" id="title" value="" class="plain small"/>
                            <br/><br/>
                            <label for="year">Year</label>
                            <input type="text" name="year" maxlength="4" id="year" value="" class="plain small"/>
                            <br/><br/>
                            <label for="library-search-id">Libraries to Search</label>
                            <select name="library_id" id="library-search-id" class="small" multiple="multiple">
                                {foreach from=$smarty.session.libraries item=library}
                                    <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if}>{$library.display_name}</option>
                                {/foreach}
                            </select>
                            <span class="float-right">
                                <a href="#" id="select-all-libraries">Toggle All Libraries</a>
                            </span>
                            <br/><br/>
                            <br/>
                            <input type="submit" value="Search and Save Results"/>
                        </fieldset>
                    </form>                    
                </div>
                <div id="content">
                    <form action="my_account.php" method="post" id="my-account-form" class="validatedForm">
                        <input type="hidden" name="action" value="update" />
                        <fieldset>
                            <legend>Update Account</legend>
                            <label for="email_input">Email Address</label>
                            <br/>
                            <input type="email" name="email_address" id="email_input" class="plain"/>
                            <br/><br/>
                            <label for="display_name_input">Display Name</label>
                            <br/>
                            <input type="text" name="display_name_input" class="plain"/>
                            <br/><br/>
                            <label for="password_input">New Password</label>  
                            <br/>
                            <input type="password" name="password" id="password" class="plain"/>
                            <br/><br/>
                            <label for="confirm_password_input">Confirm Password</label>    
                            <br/>
                            <input type="password" name="password_confirm" class="plain"/>
                            <br/><br/>
                            <input type="submit" value="Update Account" />
                            <input type="button" value="Cancel and Return" onclick="window.location = 'bibliography.php';"/>
                        </fieldset>
                    </form>
                </div>
            </div>
            <div id="footer" class="clear">
                &copy; 2014 Mr. J. Bloggs
            </div>
        </div>
        <script src="javascript/jquery-1.11.0.js" type="text/javascript"></script>
        <script src="javascript/jquery.validate.min" type="text/javascript"></script>
        <script src="javascript/script.js" type="text/javascript"></script>
        <script type="text/javascript">
            {literal}
                $('.validatedForm').validate({
                    rules: {
                        password: {
                            minlength: 5
                        },
                        password_confirm: {
                            minlength: 5,
                            equalTo: "#password"
                        }
                    }
                });
            {/literal}
        </script>
    </body>
</html>
