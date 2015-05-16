<?php

require_once 'config.inc.php';

function validLogin($emailAddress, $password) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL validate_login(?, ?)");
        $statement->execute(array($emailAddress, $password));

        return $statement->fetch()[0] == 1;
    } catch (PDOException $error) {
        die($error->getMessage());

        return FALSE;
    }

    return FALSE;
}

function ownsLibrary($emailAddress, $libraryId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL owns_library(?, ?)");
        $statement->execute(array($emailAddress, $libraryId));

        return $statement->fetch()[0];
    } catch (PDOException $error) {
        die($error->getMessage());

        return FALSE;
    }

    return FALSE;
}

function getAvailableLibraries($emailAddress) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL get_available_libraries(?)");
        $statement->execute(array($emailAddress));

        return $statement->fetchAll();
    } catch (PDOException $error) {
        die($error->getMessage());

        return array();
    }

    return array();
}

function deleteReference($email, $referenceId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL delete_reference(?, ?)");
        $statement->execute(array($email, $referenceId));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function getReferences($email, $libraryId, $sort = "title") {
    try {
        switch ($sort) {
            case "title":
                $procName = "get_references_summary";
                break;
            case "author":
                $procName = "get_references_summary_author";
                break;
            case "year":
                $procName = "get_references_summary_year";
                break;
            case "key":
                $procName = "get_references_summary_key";
                break;
        }

        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL $procName(?, ?)");
        $statement->execute(array($email, $libraryId));

        return $statement->fetchAll();
    } catch (PDOException $error) {
        die($error->getMessage());

        return array();
    }

    return array();
}

function addNewLibrary($displayName, $ownerEmail) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL create_library(?, ?)");
        $statement->execute(array($displayName, $ownerEmail));

        return $statement->fetch()[0];
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function shareLibrary($userEmail, $shareWithEmail, $libraryId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL share_library(?, ?, ?)");
        $statement->execute(array($userEmail, $shareWithEmail, $libraryId));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function unshareLibrary($userEmail, $unshareWithEmail, $libraryId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL unshare_library(?, ?, ?)");
        $statement->execute(array($userEmail, $unshareWithEmail, $libraryId));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function getSharedWith($userEmail, $libraryId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL get_shared_with(?, ?)");
        $statement->execute(array($userEmail, $libraryId));

        return $statement->fetchAll();
    } catch (PDOException $error) {
        die($error->getMessage());

        return array();
    }

    return array();
}

function getRecordDetails($userEmail, $referenceId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL get_record_details (?, ?)");
        $statement->execute(array($userEmail, $referenceId));

        return $statement->fetch();
    } catch (PDOException $error) {
        die($error->getMessage());

        return array();
    }

    return array();
}

function getPdf($userEmail, $referenceId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL get_pdf (?, ?)");
        $statement->execute(array($userEmail, $referenceId));

        return $statement->fetch();
    } catch (PDOException $error) {
        die($error->getMessage());

        return array();
    }

    return array();
}

function updateReference($author_in, $abstract_in, $pdf_in, $address_in, $annote_in, $booktitle_in, $chapter_in, $crossref_in, $edition_in, $eprint_in, $howpublished_in, $institution_in, $journal_in, $bibtexkey_in, $publish_month_in, $note_in, $issue_number_in, $organization_in, $pages_in, $publisher_in, $school_in, $series_in, $title_in, $publish_type_in, $url_in, $volume_in, $publish_year_in, $library_in, $user_email, $reference) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL update_reference(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $statement->execute(array($author_in, $abstract_in, $pdf_in, $address_in, $annote_in, $booktitle_in, $chapter_in, $crossref_in, $edition_in, $eprint_in, $howpublished_in, $institution_in, $journal_in, $bibtexkey_in, $publish_month_in, $note_in, $issue_number_in, $organization_in, $pages_in, $publisher_in, $school_in, $series_in, $title_in, $publish_type_in, $url_in, $volume_in, $publish_year_in, $library_in, $user_email, $reference));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function updateLibrary($userEmail, $libraryId, $displayName) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL update_library(?, ?, ?)");
        $statement->execute(array($userEmail, $libraryId, $displayName));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function deleteLibrary($userEmail, $sourceLibraryToDelete, $targetForOrphanedReferences) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL delete_library(?, ?, ?)");
        $statement->execute(array($userEmail, $sourceLibraryToDelete, $targetForOrphanedReferences));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function createUser($newEmail, $displayName, $password) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL create_user(?, ?, ?)");
        $statement->execute(array($newEmail, $displayName, $password));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function updateUser($oldEmail, $newEmail, $displayName, $password) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL update_user(?, ?, ?, ?)");
        $statement->execute(array($oldEmail, $newEmail, $displayName, $password));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function moveReference($userEmail, $referenceId, $newLibraryId) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL move_reference(?, ?, ?)");
        $statement->execute(array($userEmail, $referenceId, $newLibraryId));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function emptyTrashLibrary($userEmail) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL empty_trash(?)");
        $statement->execute(array($userEmail));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function addReference($author, $abstract, $pdf, $address, $annote, $booktitle, $chapter, $crossref, $edition, $eprint, $howpublished, $institution, $journal, $bibtexkey, $publish_month, $note, $issue_number, $organization, $pages, $publisher, $school, $series, $title, $publish, $url, $volume, $publish_year, $library) {
    try {
        $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
        $statement = $dbh->prepare("CALL add_reference(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $statement->execute(array($author, $abstract, $pdf, $address, $annote, $booktitle, $chapter, $crossref, $edition, $eprint, $howpublished, $institution, $journal, $bibtexkey, $publish_month, $note, $issue_number, $organization, $pages, $publisher, $school, $series, $title, $publish, $url, $volume, $publish_year, $library));
    } catch (PDOException $error) {
        die($error->getMessage());
    }
}

function searchLibraries($author, $title, $year, $library) {
    $result = array();

    try {
        foreach ($library as $lib) {
            $dbh = new PDO(DB_CONNECTION_STRING, DB_USER, DB_PASSWORD);
            $statement = $dbh->prepare("CALL search_library(?, ?, ?, ?)");
            $statement->execute(array($author, $title, $year, $lib));

            $result = array_merge($result, $statement->fetchAll());
        }
    } catch (PDOException $error) {
        die($error->getMessage());
    }

    return $result;
}
