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
                                {if $smarty.session.search_results}
                                    <option selected="selected">Search Results</option>
                                {/if}
                                {foreach from=$smarty.session.libraries item=library}
                                    <option {if not isset($smarty.session.search_results) and $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
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
                    <form action="bibliography.php" method="post">
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
                            <select name="library_id[]" id="library-search-id" class="small" multiple="multiple">
                                {foreach from=$smarty.session.libraries item=library}
                                    <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
                                {/foreach}
                            </select>
                            <span class="float-right">
                                <a href="#" id="select-all-libraries">Toggle All Libraries</a>
                            </span>
                            <br/><br/>
                            <br/>
                            <input type="submit" value="Search Now"/>
                        </fieldset>
                    </form>                    
                </div>
                <div id="content">
                    <div id="references-summary">
                        <div>
                            <form action='bibliography.php' method='post' id='metadata-summary-form'>
                                <input type="hidden" name="action" value="move_references"/>
                                <input type="hidden" name="target" id="move-items-target"/>
                                <table>
                                    <thead>
                                        <tr>
                                            <th style="width: 10%;"><input type="button" id="select-all-records" value="All"/></th>
                                            <th style="width: 20%;"><a href="bibliography.php?sort=author&action=sort_key_change">Author</a></th>
                                            <th style="width: 50%;"><a href="bibliography.php?sort=title&action=sort_key_change">Title</a></th>
                                            <th style="width: 8%;"><a href="bibliography.php?sort=year&action=sort_key_change">Year</a></th>
                                            <th style="width: 12%;"><a href="bibliography.php?sort=key&action=sort_key_change">Key</a></th>
                                            <th style="width: 5%;">PDF</th>
                                            <th style="width: 5%;">URL</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$smarty.session.references item=reference}
                                            <tr {if $record.id == $reference.id}class="selected"{else}class="{cycle values="even, odd"}"{/if}>
                                                <td><input type="checkbox" name="reference_id[]" value="{$reference.id}"/></td>
                                                <td><a class="ref-link" href="bibliography.php?action=switch_active_record&active_record={$reference.id}">{$reference.author|truncate:20:"...":true}</a></td>
                                                <td><a class="ref-link" href="bibliography.php?action=switch_active_record&active_record={$reference.id}">{$reference.title|truncate:50:"...":true}</a></td>
                                                <td><a class="ref-link" href="bibliography.php?action=switch_active_record&active_record={$reference.id}">{$reference.publish_year}</a></td>
                                                <td><a class="ref-link" href="bibliography.php?action=switch_active_record&active_record={$reference.id}">{$reference.bibtexkey|truncate:10:"...":true}</a></td>
                                                <td>{if $reference.pdf}<a href="downloadpdf.php?record={$reference.id}" target="_blank"><img src="images/pdf_icon.gif" alt="PDF file attached." width="16" height="16"/></a>{/if}</td>
                                                <td>{if $reference.url}<a href="{$reference.url}" target="_blank"><img src="images/url.png" width="16" height="16"/></a>{/if}</td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>
                    <div id="references-controls">
                        <div style="float: left; height: 15px; color: brown;">
                            <form action="bibliography.php" method="post" id="sort-order">
                                <input type="hidden" name="action" value="sort_order_change" />
                                Sort by:
                                <select style="width: 60px;" name="order" onchange="this.parentNode.submit();">
                                    <option value="Asc" {if $smarty.session.sort_order eq "Asc"}selected="selected"{/if}>Asc</option>
                                    <option value="Desc" {if $smarty.session.sort_order eq "Desc"}selected="selected"{/if}>Desc</option>
                                </select>
                            </form>
                        </div>
                        <button value="move_selected" id="move-items-popup-button">Move Selected</button>&nbsp;
                        {foreach from=$smarty.session.libraries item=library}
                            {if $library.display_name eq 'Trash'}
                                <button id="move-items-to-trash" value='{$library.id}'>Move to Trash</button>                       
                            {/if}
                        {/foreach}
                    </div>
                    <div id="references-metadata">
                        <div id="view">
                            <form enctype='multipart/form-data' method="post" action="bibliography.php" id="update-metadata-form">
                                <input type="hidden" id="update-metadata-form-action" name="action" value="update"/>
                                <table>
                                    <tr>
                                        <th>Title</th>
                                        <td><input type="text" name="title" value="{$record.title}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Author</th>
                                        <td><input type="text" name="author" value="{$record.author}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Year</th>
                                        <td><input type="text" name="publish_year" value="{$record.publish_year}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Abstract</th>
                                        <td><textarea cols="100" name="abstract" rows="10">{$record.abstract}</textarea></td>
                                    </tr>
                                    <tr>
                                        <th>Attached PDF</th>
                                        <td><input type="file" name="pdf" accept="application/pdf"/></td>
                                    </tr>
                                    <tr>
                                        <th>Address</th>
                                        <td><input type="text" name="address" value="{$record.address}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Annote</th>
                                        <td><input type="text" name="annote" value="{$record.annote}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Book Title</th>
                                        <td><input type="text" name="booktitle" value="{$record.booktitle}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Chapter</th>
                                        <td><input type="text" name="chapter" value="{$record.chapter}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Edition</th>
                                        <td><input type="text" name="edition" value="{$record.edition}" /></td>
                                    </tr>
                                    <tr>
                                        <th>E-Print</th>
                                        <td><input type="text" name="eprint" value="{$record.eprint}" /></td>
                                    </tr>
                                    <tr>
                                        <th>How Published</th>
                                        <td><input type="text" name="howpublished" value="{$record.howpublished}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Institution</th>
                                        <td><input type="text" name="institution" value="{$record.institution}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Journal</th>
                                        <td><input type="text" name="journal" value="{$record.journal}" /></td>
                                    </tr>
                                    <tr>
                                        <th>BibTeX Key</th>
                                        <td><input type="text" name="bibtexkey" value="{$record.bibtexkey}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Month</th>
                                        <td><input type="text" name="month" value="{$record.publish_month}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Note</th>
                                        <td><input type="text" name="note" value="{$record.note}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Issue Number</th>
                                        <td><input type="text" name="issuenumber" value="{$record.issue_number}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Organization</th>
                                        <td><input type="text" name="organization" value="{$record.organization}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Pages</th>
                                        <td><input type="text" name="pages" value="{$record.publish_year}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Publisher</th>
                                        <td><input type="text" name="publisher" value="{$record.publisher}" /></td>
                                    </tr>
                                    <tr>
                                        <th>School</th>
                                        <td><input type="text" name="school" value="{$record.school}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Series</th>
                                        <td><input type="text" name="series" value="{$record.series}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Type</th>
                                        <td>
                                            <select name="type">
                                                <option value="article" {if "article" eq $record.publish_type}selected='selected'{/if}>Article</option>
                                                <option value="book" {if "book" eq $record.publish_type}selected='selected'{/if}>Book</option>
                                                <option value="booklet" {if "booklet" eq $record.publish_type}selected='selected'{/if}>Booklet</option>
                                                <option value="conference" {if "conference" eq $record.publish_type}selected='selected'{/if}>Conference</option>
                                                <option value="inbook" {if "inbook" eq $record.publish_type}selected='selected'{/if}>In Book</option>
                                                <option value="incollection" {if "incollection" eq $record.publish_type}selected='selected'{/if}>In Collection</option>
                                                <option value="inproceedings" {if "inproceedings" eq $record.publish_type}selected='selected'{/if}>In Proceedings</option>
                                                <option value="manual" {if "manual" eq $record.publish_type}selected='selected'{/if}>Manual</option>
                                                <option value="mastersthesis" {if "mastersthesis" eq $record.publish_type}selected='selected'{/if}>Masters Thesis</option>
                                                <option value="misc" {if "misc" eq $record.publish_type}selected='selected'{/if}>Miscellaneous</option>
                                                <option value="phdthesis" {if "phdthesis" eq $record.publish_type}selected='selected'{/if}>PhD Thesis</option>
                                                <option value="techreport" {if "techreport" eq $record.publish_type}selected='selected'{/if}>Tech Report</option>
                                                <option value="unpublished" {if "unpublished" eq $record.publish_type}selected='selected'{/if}>Unpublished</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>URL</th>
                                        <td><input name="url" type="text" value="{$record.url}" /></td>
                                    </tr>
                                    <tr>
                                        <th>Volume</th>
                                        <td><input name="volume" type="text" value="{$record.volume}" /></td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                        <div id="save-changes">
                            <div id="record-controls-1">
                                <button form="update-metadata-form" onclick="document.getElementById('update-metadata-form').submit();" class="medium">Update</button>
                                <br/><br/>
                                <hr/>
                                <br/>
                                <button onclick="displayNewRecordControls();" class="medium">New</button>
                            </div>
                            <div id="record-controls-2">
                                <button onclick="saveRecord();" class="medium">Save</button>
                                <br/><br/>
                                <button form="update-metadata-form" onclick="displayActiveRecordControls();" class="medium">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="footer" class="clear">
                &copy; 2014 Mr. J. Bloggs
            </div>
            <div id="screen"></div>
            <div id="library-settings-popup">
                <div id="rename-library">
                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Rename Library</legend>
                            <input type="hidden" name="action" value="rename_library" />
                            <label for='library_chooser'>Choose the library that you want to rename:</label>
                            <br/><br/>
                            <select name='library_id' name="library_id">
                                {foreach from=$smarty.session.libraries item=library}
                                    {if not ($library.display_name eq 'Trash' or $library.display_name eq 'Unfiled')}
                                        <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
                                    {/if}
                                {/foreach}
                            </select>
                            <br/><br/>
                            <label for="library_name">Provide a new name for the library:</label>
                            <br/><br/>
                            <input type="text" id="library_name" name="library_name" />
                            <br/><br/>
                            <input type="submit" value="Save Changes" />
                        </fieldset>
                    </form>

                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Delete Library</legend>
                            <input type="hidden" name="action" value="delete_library" />
                            <label for='library_chooser'>Choose the library to delete:</label>
                            <br/><br/>
                            <select name='library_delete_source'>
                                {foreach from=$smarty.session.libraries item=library}
                                    {if not ($library.display_name eq 'Trash' or $library.display_name eq 'Unfiled')}
                                        <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
                                    {/if}
                                {/foreach}
                            </select>
                            <br/><br/>
                            <label for="library_name">Move records in this library but not filed in other libraries to:</label>
                            <br/><br/>
                            <select name='library_delete_target'>
                                {foreach from=$smarty.session.libraries item=library}
                                    {if ($library.display_name eq 'Trash' or $library.display_name eq 'Unfiled')}
                                        <option {if $smarty.session.active_library eq $library.id}selected="selected"{/if} value="{$library.id}">{$library.display_name}</option>
                                    {/if}
                                {/foreach}
                            </select>
                            <br/><br/>
                            <input type="submit" value="Move Records and Delete Library" />
                        </fieldset>
                    </form>

                    <form action="bibliography.php" method="post">
                        <fieldset>
                            <legend>Empty Trash</legend>
                            <input type="hidden" name="action" value="empty_trash" />
                            <input type="submit" value="Empty Trash Library" />
                        </fieldset>
                    </form>
                    <button id='library-settings-popup-close'>Close and return to library</button>
                </div>
            </div>
            <div id="move-items-popup">
                <form>
                    <fieldset>
                        <legend>Move Items</legend>
                        <input type="hidden" name="action" />
                        <label for='target_library_id'>Choose the library that you want to move these items to:</label>
                        <br/><br/>
                        <select name='library_id' id="target_library_id">
                            {foreach from=$smarty.session.libraries item=library}
                                <option value='{$library.id}'>{$library.display_name}</option> 
                            {/foreach}
                        </select>
                        <input id="move-now" value="Move Now" />
                    </fieldset>
                </form> 
                <button id='move-items-popup-close'>Close and return to library</button>
            </div>
        </div>
        <script src="javascript/jquery-1.11.0.js" type="text/javascript"></script>
        <script src="javascript/script.js" type="text/javascript"></script>
    </body>
</html>
