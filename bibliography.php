<?php

require_once 'config.inc.php';


if (!isset($_SESSION['email_address'])) {
    header("Location: index.php");
}

doActionTask();

/* Set the active library. */
$_SESSION['libraries'] = getAvailableLibraries($_SESSION['email_address']);

if (empty($_SESSION['active_library'])) {
    $_SESSION['active_library'] = $_SESSION['libraries'][0]['id'];
}

/* Set the active record. */
$_SESSION['active_library_shared_with'] = getSharedWith($_SESSION['email_address'], $_SESSION['active_library']);

/* Checks if the user owns the active library. */
$_SESSION['owns_library'] = ownsLibrary($_SESSION['email_address'], $_SESSION['active_library']);

/* Set sort key. */
if (empty($_SESSION['sort_key'])) {
    $_SESSION['sort_key'] = "title";
}

/* Get all records. */
if (isset($_SESSION['search_results'])) {
    $_SESSION['references'] = $_SESSION['search_results'];
} else {
    $_SESSION['references'] = getReferences($_SESSION['email_address'], $_SESSION['active_library'], $_SESSION['sort_key']);
}
/* Sort order. */
if (empty($_SESSION['sort_order'])) {
    $_SESSION['sort_order'] = "Asc";
}

/* Sort if needed. */
if ($_SESSION["sort_order"] == "Desc") {
    $_SESSION['references'] = array_reverse($_SESSION['references']);
}

$template->assign("record", getRecordDetails($_SESSION['email_address'], $_SESSION['active_record']));
$template->display('bibliography.tpl');

function doActionTask() {
    switch (getAction()) {
        case "add_library":
            newLibraryTask();
            break;
        case "switch_active_library":
            switchActiveLibraryTask();
            break;
        case "switch_active_record":
            switchActiveRecordTask();
            break;
        case "share_library":
            shareLibraryTask();
            break;
        case "unshare_library":
            stopSharingTask();
            break;
        case "update":
            updateRecordTask();
            break;
        case "delete_library":
            deleteLibraryTask();
            break;
        case "empty_trash":
            emptyTrashTask();
            break;
        case "rename_library":
            renameLibraryTask();
            break;
        case "move_references":
            moveReferencesTask();
            break;
        case "sort_order_change":
            sortOrderChangeTask();
            break;
        case "sort_key_change":
            sortKeyChangeTask();
            break;
        case "create_record":
            createRecordTask();
            break;
        case "search_library":
            searchLibraryTask();
            break;
    }
}

function getAction() {
    $action = filter_input(INPUT_GET, "action", FILTER_SANITIZE_STRING);

    if (empty($action)) {
        $action = filter_input(INPUT_POST, "action", FILTER_SANITIZE_STRING);
    }

    return $action;
}

function searchLibraryTask() {
    $author = filter_input(INPUT_POST, "author_name");
    $title = filter_input(INPUT_POST, "title");
    $year = filter_input(INPUT_POST, "year");
    $library = $_POST['library_id'];

    $_SESSION['search_results'] = searchLibraries($author, $title, $year, $library);
}

function createRecordTask() {
    addReference($_POST['author'], $_POST['abstract'], NULL, $_POST['address'], $_POST['annote'], $_POST['booktitle'], $_POST['chapter'], NULL, $_POST['edition'], $_POST['eprint'], $_POST['howpublished'], $_POST['institution'], $_POST['journal'], $_POST['bibtexkey'], $_POST['month'], $_POST['note'], $_POST['issuenumber'], $_POST['organization'], $_POST['pages'], $_POST['publisher'], $_POST['school'], $_POST['series'], $_POST['title'], $_POST['publisher'], $_POST['url'], $_POST['volume'], $_POST['publish_year'], $_SESSION['active_library']);
}

function sortOrderChangeTask() {
    $_SESSION['sort_order'] = filter_input(INPUT_POST, "order");
}

function sortKeyChangeTask() {
    $_SESSION['sort_key'] = filter_input(INPUT_GET, "sort");
}

function moveReferencesTask() {
    $referenceId = $_POST['reference_id'];
    $target = filter_input(INPUT_POST, "target");

    foreach ($referenceId as $ref) {
        moveReference($_SESSION['email_address'], $ref, $target);
    }
}

function deleteLibraryTask() {
    $source = filter_input(INPUT_POST, 'library_delete_source');
    $target = filter_input(INPUT_POST, 'library_delete_target');

    deleteLibrary($_SESSION['email_address'], $source, $target);
}

function emptyTrashTask() {
    emptyTrashLibrary($_SESSION['email_address']);
}

function renameLibraryTask() {
    $libraryId = filter_input(INPUT_POST, 'library_id');
    $displayName = filter_input(INPUT_POST, 'library_name');

    updateLibrary($_SESSION['email_address'], $libraryId, $displayName);
}

function newLibraryTask() {
    $displayName = filter_input(INPUT_POST, "display_name");
    $_SESSION['active_library'] = addNewLibrary($displayName, $_SESSION['email_address']);
}

function switchActiveLibraryTask() {
    unset($_SESSION['search_results']);
    $newActiveLibrary = filter_input(INPUT_POST, "library_id");
    $_SESSION['active_library'] = $newActiveLibrary;
    $_SESSION['active_record'] = -1;
}

function switchActiveRecordTask() {
    $_SESSION['active_record'] = filter_input(INPUT_GET, "active_record");
}

function shareLibraryTask() {
    $shareWithEmail = filter_input(INPUT_POST, "email", FILTER_SANITIZE_EMAIL);
    shareLibrary($_SESSION['email_address'], $shareWithEmail, $_SESSION['active_library']);
}

function stopSharingTask() {
    $stopSharingWith = $_POST['stop_sharing_addresses'];

    foreach ($stopSharingWith as $email) {
        unshareLibrary($_SESSION['email_address'], $email, $_SESSION['active_library']);
    }
}

function updateRecordTask() {
    updateReference($_POST['author'], $_POST['abstract'], NULL, #PDF
            $_POST['address'], $_POST['annote'], $_POST['booktitle'], $_POST['chapter'], NULL, #crossref 
            $_POST['edition'], $_POST['eprint'], $_POST['howpublished'], $_POST['institution'], $_POST['journal'], $_POST['bibtexkey'], $_POST['month'], $_POST['note'], $_POST['issuenumber'], $_POST['organization'], $_POST['pages'], $_POST['publisher'], $_POST['school'], $_POST['series'], $_POST['title'], $_POST['type'], $_POST['url'], $_POST['volume'], $_POST['publish_year'], $_SESSION['active_library'], $_SESSION['email_address'], $_SESSION['active_record']);
}

?>