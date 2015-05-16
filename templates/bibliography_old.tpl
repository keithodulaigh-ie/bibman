<html>
    <head>
        <title>BibMan: Cloud Bibliography Management Software</title>
        <link rel="stylesheet" type="text/css" href="css/default.css" />
    </head>
    <body>
        <div id="main">
            <div id="header">
                <span style="text-shadow: 2px 2px grey;">BibMan</span>
                <span style="text-shadow: 1px 1px grey; float:right; font-family: script;">Cloud powered bibliography management.</span>
            </div>
            <div id="menubar">
            </div>
            <div id="library_pane">
                <h3>My Libraries</h3>
                <div id="button">
                    <ul>
                        {foreach from=$smarty.session.libraries item=library}
                            <li><a {if $smarty.session.active_library eq $library.id}class="selected-library"{/if} href="bibliography.php?action=switch_active_library&active_library={$library.id}">{$library.display_name}</a></li>
                        {/foreach}
                    </ul>
                </div>
                <div id="library_controls" style="padding: 10px;">
                    <form action="bibliography.php?action=new_library" method="post">
                        <input type="text" name="display_name" value="New library name..." style="color: grey; width: 100%" onfocus="this.value = '';"/>
                        <br/><br/>
                        <input type="submit" value="Create" />
                    </form>
                </div>
                <div id="share_tools">
                    <h3>Currently Shared With</h3>
                    <form action="bibliography.php" method="post" style="padding: 10px;">
                        <input type="hidden" name="action" value="stop_sharing"/>
                        <select multiple="multiple" name="stop_sharing_addresses" style="width: 100%;">
                            {foreach from=$smarty.session.active_library_shared_with item=collaborator}
                                <option value="{$collaborator.email}">{$collaborator.display_name}&nbsp;&lt;{$collaborator.email}&gt;</option>
                            {/foreach}
                        </select>
                        <br/><br/>
                        <input type="submit" value="Stop Sharing" />
                    </form>
                </div>
                <div id="share_with">
                    <h3>Share Active Library With</h3>
                    <form action="bibliography.php" method="get" style="padding: 10px;">
                        <input type="hidden" name="action" value="share_library"/>
                        <input type="text" name="share_with_email" onfocus="this.value = '';" style="width: 100%; color: grey;" value="Email address of collaborator..."/>
                        <br/>
                        <br/>
                        <input type="submit" value="Share"/> 
                    </form>
                </div>
            </div>
            <div id="references_view">
                <table>
                    <tr>
                        <th>Author</th>
                        <th>Title</th>
                        <th>Year</th>
                        <th>Key</th>
                        <th>PDF</th>
                        <th>URL</th>
                    </tr>
                    {foreach from=$smarty.session.references item=reference}
                        <tr class="{cycle values="even, odd"}">
                            <td><a href="bibliography.php?action=switch_active_record&active_record={$reference.id}" class="plain">{$reference.author}</a></td>
                            <td><a href="bibliography.php?action=switch_active_record&active_record={$reference.id}" class="plain">{$reference.title}</a></td>
                            <td><a href="bibliography.php?action=switch_active_record&active_record={$reference.id}" class="plain">{$reference.publish_year}</a></td>
                            <td><a href="bibliography.php?action=switch_active_record&active_record={$reference.id}" class="plain">{$reference.bibtexkey}</a></td>
                            <td>{if $reference.pdf}<a href="downloadpdf.php?record={$reference.id}" target="_blank"><img src="images/pdf_icon.gif" alt="PDF file attached." width="16" height="16"/></a>{/if}</td>
                            <td>{if $reference.url}<a href="{$reference.url}" target="_blank"><img src="images/url.png" width="16" height="16"/></a>{/if}</td>
                        </tr>
                    {/foreach}
                </table>
            </div>
            {* Pagination is another day's work!
            <div style="padding-above: 10px; float: right; margin-right: 30px; font-size: small">
            <form>
            <label>Page</label>
            <select>
            <option value="1">1</option>
            </select>
            </form>

            </div>
            *}
            <div id="metadata_pane">
                <form enctype='multipart/form-data' method="post" action="bibliography.php">
                    <input type="hidden" name="action" value="update"/>
                    <table>
                        <tr>
                            <th>Title</th>
                            <td><input type="text" name="title" value="{$record.title}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Author</th>
                            <td><input type="text" name="author" value="{$record.author}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Year</th>
                            <td><input type="text" name="publish_year" value="{$record.publish_year}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Abstract</th>
                            <td><textarea cols="120" name="abstract" rows="10">{$record.abstract}</textarea></td>
                        </tr>
                        <tr>
                            <th>Attached PDF</th>
                            <td><input type="file" name="pdf" accept="application/pdf"/></td>
                        </tr>
                        <tr>
                            <th>Address</th>
                            <td><input type="text" name="address" value="{$record.address}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Annote</th>
                            <td><input type="text" name="annote" value="{$record.annote}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Book Title</th>
                            <td><input type="text" name="booktitle" value="{$record.booktitle}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Chapter</th>
                            <td><input type="text" name="chapter" value="{$record.chapter}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Edition</th>
                            <td><input type="text" name="edition" value="{$record.edition}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>E-Print</th>
                            <td><input type="text" name="eprint" value="{$record.eprint}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>How Published</th>
                            <td><input type="text" name="howpublished" value="{$record.howpublished}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Institution</th>
                            <td><input type="text" name="institution" value="{$record.institution}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Journal</th>
                            <td><input type="text" name="journal" value="{$record.journal}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>BibTeX Key</th>
                            <td><input type="text" name="bibtexkey" value="{$record.bibtexkey}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Month</th>
                            <td><input type="text" name="month" value="{$record.publish_month}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Note</th>
                            <td><input type="text" name="note" value="{$record.note}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Issue Number</th>
                            <td><input type="text" name="issuenumber" value="{$record.issue_number}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Organization</th>
                            <td><input type="text" name="organization" value="{$record.organization}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Pages</th>
                            <td><input type="text" name="pages" value="{$record.publish_year}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Publisher</th>
                            <td><input type="text" name="publisher" value="{$record.publisher}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>School</th>
                            <td><input type="text" name="school" value="{$record.school}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Series</th>
                            <td><input type="text" name="series" value="{$record.series}" size="120"/></td>
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
                            <td><input name="url" type="text" value="{$record.url}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Volume</th>
                            <td><input name="volume" type="text" value="{$record.volume}" size="120"/></td>
                        </tr>
                        <tr>
                            <th>Added At</th>
                            <td><input name="addedat" type="text" value="{$record.added_at}" readonly="readonly" size="120"/></td>
                        </tr>
                    </table>
                    <input type="submit" value="Update" />
                    <input type="button" value="Delete" />
                </form>
            </div>
            <div id="footer">
                CS615 Windows Azure Sample Assignment - Keith &Oacute; D&uacute;laigh
            </div>
        </div>
    </body>
</html>