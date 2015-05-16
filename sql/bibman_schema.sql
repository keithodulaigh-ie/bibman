BEGIN;

DROP DATABASE IF EXISTS bibman;

CREATE DATABASE bibman;

USE bibman;

CREATE TABLE user (
   email VARCHAR(255) PRIMARY KEY,
   password VARCHAR(40),
   display_name VARCHAR(255) NOT NULL
);

CREATE TABLE library (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    display_name VARCHAR(255) NOT NULL,
    owner_email VARCHAR(255),
    CONSTRAINT valid_owner_email FOREIGN KEY(owner_email) REFERENCES user(email) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE shared_library (
    library_id INTEGER,
    user_email VARCHAR(255),
    CONSTRAINT valid_library_id FOREIGN KEY(library_id) REFERENCES library(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT valid_user_email FOREIGN KEY(user_email) REFERENCES user(email) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (library_id, user_email)
);

CREATE TABLE reference (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    author VARCHAR(300),
    abstract VARCHAR(3000),
    pdf MEDIUMBLOB,
    address VARCHAR(300),
    annote VARCHAR(300),
    booktitle VARCHAR(255),
    chapter VARCHAR(10),
    crossref INTEGER,
    edition VARCHAR(10),
    eprint VARCHAR(10),
    howpublished VARCHAR(100),
    institution VARCHAR(50),
    journal VARCHAR(50),
    bibtexkey VARCHAR(20),
    publish_month VARCHAR(10),
    note VARCHAR(1500),
    issue_number VARCHAR(10),
    organization VARCHAR(50),
    pages VARCHAR(10),
    publisher VARCHAR(50),
    school VARCHAR(50),
    series VARCHAR(50),
    title VARCHAR(100),
    publish_type VARCHAR(50),
    url VARCHAR(300),
    volume VARCHAR(50),
    publish_year VARCHAR(4),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    library INTEGER REFERENCES library(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT valid_crossref FOREIGN KEY(crossref) REFERENCES reference(id) ON UPDATE CASCADE
);

DELIMITER $$

CREATE PROCEDURE search_library(author_in VARCHAR(255), title_in VARCHAR(255), year_in VARCHAR(4), library_in INTEGER)
COMMENT 'Searches all of the libraries available to a user.'
BEGIN
    SELECT *
    FROM reference
    WHERE 
      (author LIKE CONCAT('%', author_in, '%')
      OR title LIKE CONCAT('%', title_in, '%')
      OR publish_year = year_in)
      AND library = library_in;
END;

$$

CREATE PROCEDURE create_user (email_in VARCHAR(255), display_name_in VARCHAR(255), password_in VARCHAR(40))
COMMENT 'Procedure for registering a new user.'
BEGIN
    INSERT INTO user (email, display_name, password)
    VALUES (email_in, display_name_in, sha1(password_in));

    INSERT INTO library (display_name, owner_email)
    VALUES ('Trash', email_in);

    INSERT INTO library (display_name, owner_email)
    VALUES ('Unfiled', email_in);
END;

$$

CREATE PROCEDURE update_user (old_email_in VARCHAR(255), email_in VARCHAR(255), display_name_in VARCHAR(255), password_in VARCHAR(40)) 
COMMENT 'Updates the account details for a user.'
BEGIN
    UPDATE user
    SET email = email_in,
        password = sha1(password_in),
        display_name = display_name_in
    WHERE email = old_email_in;
END;

$$

CREATE PROCEDURE create_library (display_name_in VARCHAR(255), owner_email_in VARCHAR(255))
COMMENT 'Procedure for inserting a new library into the database.'
BEGIN
    DECLARE libsWithSameName INTEGER DEFAULT (SELECT count(*) 
                                              FROM library
                                              WHERE display_name = display_name_in 
                                                 AND owner_email = owner_email_in);

    IF libsWithSameName > 0 THEN
        INSERT INTO library (display_name, owner_email)
        VALUES (CONCAT(display_name_in, ' (', libsWithSameName + 1, ')'), owner_email_in);
    ELSE
        INSERT INTO library (display_name, owner_email)
        VALUES (display_name_in, owner_email_in);
    END IF;

    SELECT id 
    FROM library
    WHERE display_name = display_name_in;
END

$$

CREATE PROCEDURE validate_login (email_in VARCHAR(255), password_in VARCHAR(255))
COMMENT 'Can be used to check if login details are correct.'
BEGIN
    DECLARE known_password VARCHAR(40) DEFAULT (SELECT password
                                                FROM user
						WHERE email = email_in);

    IF known_password IS NULL then
        SELECT FALSE;
    ELSE
        SELECT (known_password = sha1(password_in));
    END IF;
END

$$

CREATE PROCEDURE share_library (requesting_user_email VARCHAR(255), share_with_user_email VARCHAR(255), library_to_share INTEGER)
COMMENT 'Allows the owner of a library to share a library with another user.'
BEGIN
    DECLARE authorised BOOLEAN DEFAULT (SELECT owner_email 
                                        FROM library 
					WHERE id = library_to_share) = requesting_user_email;

    IF NOT authorised THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This user is not authorised to share this library.';
    ELSE
        INSERT INTO shared_library (library_id, user_email)
        VALUES (library_to_share, share_with_user_email);
    END IF;
END

$$

CREATE PROCEDURE unshare_library (requesting_user_email VARCHAR(255), unshare_with_user_email VARCHAR(255), library_to_unshare INTEGER)
COMMENT 'Allows the owner of a library to unshare a library with another user.'
BEGIN
    DECLARE authorised BOOLEAN DEFAULT (SELECT owner_email 
                                        FROM library
                                        WHERE id = library_to_unshare) = requesting_user_email;

    IF NOT authorised THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This user is not authorised to unshare this library.';
    ELSE
        DELETE 
        FROM shared_library
	WHERE library_id = library_to_unshare 
           AND user_email = unshare_with_user_email;
    END IF;
END

$$

CREATE PROCEDURE owns_library (user_email VARCHAR(255), library_id INTEGER) 
COMMENT 'Checks if the user owns the library.'
BEGIN
    SELECT (SELECT owner_email FROM library WHERE id = library_id) = user_email;
END;

$$

CREATE PROCEDURE get_shared_with (requesting_user_email VARCHAR(255), library_id_in INTEGER)
COMMENT 'Allows the owner of a library to view who the library is shared with.'
BEGIN
    DECLARE authorised BOOLEAN DEFAULT (SELECT owner_email 
                                        FROM library 
					WHERE id = library_id_in) = requesting_user_email;

    IF NOT authorised THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only the owner can view who this library is shared with.';
    ELSE
        SELECT user.*
        FROM user
        JOIN shared_library ON user.email = shared_library.user_email
        WHERE library_id = library_id_in;
    END IF;
END

$$

CREATE PROCEDURE add_reference (author_in VARCHAR(300),
				abstract_in VARCHAR(3000),  
                                pdf_in MEDIUMBLOB,                            
				address_in VARCHAR(300),
				annote_in VARCHAR(300),
				booktitle_in VARCHAR(255),
				chapter_in VARCHAR(10),
				crossref_in INTEGER,
				edition_in VARCHAR(10),
				eprint_in VARCHAR(10),
				howpublished_in VARCHAR(100),
				institution_in VARCHAR(50),
				journal_in VARCHAR(50),
				bibtexkey_in VARCHAR(20),
				publish_month_in VARCHAR(10),
				note_in VARCHAR(1500),
				issue_number_in VARCHAR(10),
				organization_in VARCHAR(50),
				pages_in VARCHAR(10),
				publisher_in VARCHAR(50),
				school_in VARCHAR(50),
				series_in VARCHAR(50),
				title_in VARCHAR(100),
				publish_type_in VARCHAR(50),
				url_in VARCHAR(300),
				volume_in VARCHAR(50),
				publish_year_in VARCHAR(4),
				library_in INTEGER)
COMMENT 'Procedure for adding a new reference to a library.'
BEGIN
    INSERT INTO reference(  author,
                            abstract,
                            pdf,
                            address,
                            annote,
                            booktitle,
                            chapter,
                            crossref,
                            edition,
                            eprint,
                            howpublished,
                            institution,
                            journal,
                            bibtexkey,
                            publish_month,
                            note,
                            issue_number,
                            organization,
                            pages,
                            publisher,
                            school,
                            series,
                            title,
                            publish_type,
                            url,
                            volume,
                            publish_year,
                            library   )
    VALUES (    author_in,
                abstract_in,
                pdf_in,
                address_in,
		annote_in,
		booktitle_in,
		chapter_in,
		crossref_in,
		edition_in,
		eprint_in,
		howpublished_in,
		institution_in,
		journal_in,
		bibtexkey_in,
		publish_month_in,
		note_in,
		issue_number_in,
		organization_in,
		pages_in,
		publisher_in,
		school_in,
		series_in,
		title_in,
		publish_type_in,
		url_in,
		volume_in,
		publish_year_in,
		library_in );
END

$$

CREATE PROCEDURE get_references_summary (user_email VARCHAR(255), library_id INTEGER)
COMMENT 'Returns all of the references available to a user within some library. This can be pagintaed with values for initial and final.'
BEGIN
    DECLARE is_owner BOOLEAN DEFAULT (SELECT owner_email 
                                      FROM library 
                                      WHERE id = library_id) = user_email;
    DECLARE is_shared_with BOOLEAN DEFAULT (SELECT user_email 
                                            IN (SELECT DISTINCT user_email 
                                                FROM shared_library sl 
						WHERE sl.library_id = library_id)
                                            );

    IF (is_owner OR is_shared_with) THEN
        SELECT reference.*
	FROM library
        JOIN reference ON reference.library = library.id
	WHERE library.id = library_id
	ORDER BY title;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'This user is not authorised to view the content of this library.';
    END IF;
END

$$

CREATE PROCEDURE get_references_summary_author (user_email VARCHAR(255), library_id INTEGER)
COMMENT 'Returns all of the references available to a user within some library. This can be pagintaed with values for initial and final.'
BEGIN
    DECLARE is_owner BOOLEAN DEFAULT (SELECT owner_email 
                                      FROM library 
                                      WHERE id = library_id) = user_email;
    DECLARE is_shared_with BOOLEAN DEFAULT (SELECT user_email 
                                            IN (SELECT DISTINCT user_email 
                                                FROM shared_library sl 
						WHERE sl.library_id = library_id)
                                            );

    IF (is_owner OR is_shared_with) THEN
        SELECT reference.*
	FROM library
        JOIN reference ON reference.library = library.id
	WHERE library.id = library_id
	ORDER BY author;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'This user is not authorised to view the content of this library.';
    END IF;
END

$$

CREATE PROCEDURE get_references_summary_year (user_email VARCHAR(255), library_id INTEGER)
COMMENT 'Returns all of the references available to a user within some library. This can be pagintaed with values for initial and final.'
BEGIN
    DECLARE is_owner BOOLEAN DEFAULT (SELECT owner_email 
                                      FROM library 
                                      WHERE id = library_id) = user_email;
    DECLARE is_shared_with BOOLEAN DEFAULT (SELECT user_email 
                                            IN (SELECT DISTINCT user_email 
                                                FROM shared_library sl 
						WHERE sl.library_id = library_id)
                                            );

    IF (is_owner OR is_shared_with) THEN
        SELECT reference.*
	FROM library
        JOIN reference ON reference.library = library.id
	WHERE library.id = library_id
	ORDER BY publish_year;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'This user is not authorised to view the content of this library.';
    END IF;
END

$$

CREATE PROCEDURE get_references_summary_key (user_email VARCHAR(255), library_id INTEGER)
COMMENT 'Returns all of the references available to a user within some library. This can be pagintaed with values for initial and final.'
BEGIN
    DECLARE is_owner BOOLEAN DEFAULT (SELECT owner_email 
                                      FROM library 
                                      WHERE id = library_id) = user_email;
    DECLARE is_shared_with BOOLEAN DEFAULT (SELECT user_email 
                                            IN (SELECT DISTINCT user_email 
                                                FROM shared_library sl 
						WHERE sl.library_id = library_id)
                                            );

    IF (is_owner OR is_shared_with) THEN
        SELECT reference.*
	FROM library
        JOIN reference ON reference.library = library.id
	WHERE library.id = library_id
	ORDER BY bibtexkey;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'This user is not authorised to view the content of this library.';
    END IF;
END

$$

CREATE PROCEDURE get_all_references_summary (user_email VARCHAR(255))
COMMENT 'Returns all of the references available to a user.'
BEGIN
    SELECT *
    FROM reference
    WHERE library IN (  SELECT id 
			FROM library
			WHERE owner_email = user_email
			UNION
			SELECT library_id
			FROM shared_library sl
			WHERE sl.user_email = user_email);
END

$$

CREATE PROCEDURE get_available_libraries (user_email VARCHAR(255))
COMMENT 'Returns all of the details for the libraries available to the specified user.'
BEGIN
	SELECT DISTINCT *
	FROM library
	WHERE id IN (   SELECT id 
                        FROM library
			WHERE owner_email = user_email
			UNION
			SELECT library_id
			FROM shared_library sl
			WHERE sl.user_email = user_email)
	ORDER BY display_name;
END

$$

CREATE PROCEDURE delete_library (user_email VARCHAR(255), id_in INTEGER, target INTEGER)
COMMENT 'Deletes a library if the requesting user has permission and moves the associated references.'
BEGIN
    DECLARE owns_library BOOLEAN DEFAULT (SELECT owner_email
                                          FROM library
                                          WHERE id = id_in) = user_email;

    DECLARE shared_library BOOLEAN DEFAULT (SELECT user_email IN (SELECT user_email FROM shared_library WHERE library_id = id_in));

    DECLARE owns_target_library BOOLEAN DEFAULT (   SELECT owner_email
                                                    FROM library
                                                    WHERE id = target) = user_email;

    DECLARE shared_target_library BOOLEAN DEFAULT (SELECT user_email IN (SELECT user_email FROM shared_library WHERE library_id = target));

    DECLARE library_name VARCHAR(255) DEFAULT (SELECT display_name FROM library WHERE id = id_in);
	
    IF (owns_library OR shared_library) AND (owns_target_library OR shared_target_library) AND NOT (library_name = 'Trash' OR library_name = 'Unfiled') THEN
        UPDATE reference
        SET library = target
        WHERE library = id_in;

        DELETE
	FROM library
	WHERE id = id_in;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'You cannot delete a library that you do not own/share.';
    END IF;
END

$$

CREATE PROCEDURE empty_trash (user_email VARCHAR(255))
COMMENT 'Empties the trash library for a user.'
BEGIN
    DECLARE trashId INTEGER DEFAULT (SELECT id
                                     FROM   library
                                     WHERE display_name = 'Trash'
                                        AND owner_email = user_email);

    DELETE
    FROM reference
    WHERE library = trashId;
END

$$

CREATE PROCEDURE delete_reference (user_email VARCHAR(255), reference_id INTEGER)
COMMENT 'Deletes a reference if the requesting user has permission.'
BEGIN
    DECLARE reference_library_id INTEGER DEFAULT (SELECT library FROM reference WHERE id = reference_id);
    DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                            FROM library
                                            WHERE id = reference_library_id) = user_email;
	
    IF owns_library THEN
        DELETE
	FROM reference
	WHERE id = reference_id;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'You cannot delete a reference that you do not own.';
    END IF;	
END;

$$

CREATE PROCEDURE update_library (user_email VARCHAR(255), library_id INTEGER, new_display_name VARCHAR(255))
COMMENT 'If the requesting user has the appropriate permissions then they can rename the library.'
BEGIN
    DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                            FROM library
                                            WHERE id = library_id) = user_email;
	
	IF owns_library THEN
            UPDATE library
            SET display_name = new_display_name
            WHERE library_id = id;
	ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot modify the name of a library that you do not own.';
	END IF;	
END;

$$

CREATE PROCEDURE get_record_details(user_email_in VARCHAR(300), reference_id INTEGER)
COMMENT 'Gets all of the details for a record.'
BEGIN
	DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                                FROM library
                                                WHERE id = (SELECT library 
                                                            FROM reference 
                                                            WHERE reference_id = id)) = user_email_in;
	DECLARE is_shared_with BOOLEAN DEFAULT (SELECT user_email_in IN (   SELECT user_email 
                                                                            FROM shared_library
                                                                            WHERE library_id = (SELECT library 
                                                                                                FROM reference 
                                                                                                WHERE id = reference_id)));

	IF owns_library OR is_shared_with THEN
            SELECT *
            FROM reference
            WHERE id = reference_id; 
	ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot view a reference in a library that you do not own.';
	END IF;	
END;

$$

CREATE PROCEDURE get_pdf (user_email_in VARCHAR(300), reference_id INTEGER)
COMMENT 'Gets all of the details for a record.'
BEGIN
	DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                                FROM library
                                                WHERE id = (SELECT library 
                                                            FROM reference 
                                                            WHERE reference_id = id)) = user_email_in;
	
	IF owns_library THEN
            SELECT pdf
            FROM reference
            WHERE id = reference_id; 
	ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot view a PDF in a library that you do not own.';
	END IF;	
END;

$$

CREATE PROCEDURE move_reference (user_email_in VARCHAR(255), reference_id INTEGER, new_library_id INTEGER) 
COMMENT 'Moves a reference from one library into another.'
BEGIN
    DECLARE reference_library_id INTEGER DEFAULT (SELECT library 
                                                  FROM reference 
                                                  WHERE id = reference_id);
    DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                            FROM library
                                            WHERE id = reference_library_id) = user_email_in;
    DECLARE shares_library BOOLEAN DEFAULT (SELECT user_email_in IN (   SELECT user_email 
                                                                        FROM shared_library
                                                                        WHERE library_id = reference_library_id));    

    IF owns_library OR shares_library THEN
        UPDATE reference
        SET library = new_library_id
        WHERE id = reference_id;
    END IF;
END;

$$

CREATE PROCEDURE update_reference ( author_in VARCHAR(300),
                                    abstract_in VARCHAR(3000),
                                    pdf_in MEDIUMBLOB,
                                    address_in VARCHAR(300),
                                    annote_in VARCHAR(300),
                                    booktitle_in VARCHAR(255),
                                    chapter_in VARCHAR(10),
                                    crossref_in INTEGER,
                                    edition_in VARCHAR(10),
                                    eprint_in VARCHAR(10),
                                    howpublished_in VARCHAR(100),
                                    institution_in VARCHAR(50),
                                    journal_in VARCHAR(50),
                                    bibtexkey_in VARCHAR(20),
                                    publish_month_in VARCHAR(10),
                                    note_in VARCHAR(1500),
                                    issue_number_in VARCHAR(10),
                                    organization_in VARCHAR(50),
                                    pages_in VARCHAR(10),
                                    publisher_in VARCHAR(50),
                                    school_in VARCHAR(50),
                                    series_in VARCHAR(50),
                                    title_in VARCHAR(100),
                                    publish_type_in VARCHAR(50),
                                    url_in VARCHAR(300),
                                    volume_in VARCHAR(50),
                                    publish_year_in VARCHAR(4),
                                    library_in INTEGER,
                                    user_email VARCHAR(255),
                                    reference_id INTEGER)
COMMENT 'Procedure for adding a new reference to a library.'
BEGIN
	DECLARE reference_library_id INTEGER DEFAULT (  SELECT library 
                                                        FROM reference 
                                                        WHERE id = reference_id);
	DECLARE owns_library BOOLEAN DEFAULT (  SELECT owner_email
                                                FROM library
                                                WHERE id = reference_library_id) = user_email;
	DECLARE shares_library BOOLEAN DEFAULT (SELECT user_email IN (  SELECT user_email 
									FROM shared_library
									WHERE library_id = library_in));

	IF owns_library OR shares_library THEN
            UPDATE reference
            SET author = author_in,
                abstract = abstract_in,
		pdf = pdf_in,
		address = address_in,
		annote = annote_in,
		booktitle = booktitle_in,
		chapter = chapter_in,
		crossref = crossref_in,
		edition = edition_in,
		eprint = eprint_in,
		howpublished = howpublished_in,
		institution = institution_in,
		journal = journal_in,
		bibtexkey = bibtexkey_in,
		publish_month = publish_month_in,
		note = note_in,
		issue_number = issue_number_in,
		organization = organization_in,
		pages = pages_in,
		publisher = publisher_in,
		school = school_in,
		series = series_in,
		title = title_in,
		publish_type = publish_type_in,
		url = url_in,
		volume = volume_in,
		publish_year = publish_year_in,
		library = library_in
        WHERE id = reference_id;
    ELSE
        SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'You cannot modify a reference stored in a library that you do not own.';
    END IF;
END;

$$

DELIMITER ;

-- Inserting test dummy data begins here.
CALL create_user ('paddy.oflynn@eeng.nuim.ie', 'Paddy O''Flynn', 'paddy');
CALL create_library ('Paddy''s Library', 'paddy.oflynn@eeng.nuim.ie');
CALL add_reference ('Paddy O''Flynn', 'Just one of my many papers.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ICMTS', 'paddy14', 'March', NULL, NULL, 'NUI Maynooth', NULL, 'IEEE', NULL, NULL, 'A Verified Pacemaker', 'inproceedings', NULL, NULL, 2014, 1);

CALL create_user ('gerry.martin@eeng.nuim.ie', 'Gerry Martin', 'gerry');
CALL create_library ('All My References', 'gerry.martin@eeng.nuim.ie');
CALL add_reference ( 'Gerry Martin', 'I''ve done it again...a masterpiece!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ICCPCT', 'martin03', 'December', NULL, NULL, 'NUI Maynooth', NULL, 'IEEE', NULL, NULL, 'Testing Embedded Systems', 'inproceedings', NULL, NULL, 2003, 3);
CALL add_reference ( 'Gerry Martin', 'I''ve done it again...a masterpiece!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ICCPCT', 'martin03', 'December', NULL, NULL, 'NUI Maynooth', NULL, 'IEEE', NULL, NULL, 'Testing Embedded Systems', 'inproceedings', NULL, NULL, 2003, 4);

CALL create_user ('sophiem@cs.nuim.ie', 'Sophie Martin', 'sophie');
CALL create_library ('Sophie References', 'sophiem@cs.nuim.ie');
CALL create_library ('Paper with Gerry', 'sophiem@cs.nuim.ie');
CALL share_library ('sophiem@cs.nuim.ie', 'gerry.martin@eeng.nuim.ie', (SELECT id 
                                                                        FROM library 
																		WHERE display_name = 'Paper with Gerry' 
                                                                           AND owner_email = 'sophiem@cs.nuim.ie'));
CALL add_reference ('Gerry Martin, Sophie Martin', 'Abstract enough.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ICCPCT', 'martins10', 'November', NULL, NULL, 'NUI Maynooth', NULL, 'Springer Verlag', NULL, NULL, 'A Comparision of Hardware and Software Testing', 'inproceedings', NULL, NULL, 2010, 10);
COMMIT;