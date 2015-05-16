$(function() {
    var librarySettingsPopup = function() {
        $('#screen').css({'display': 'block', opacity: 0.7, 'width': $(document).width(), 'height': $(document).height()});
        $('body').css({'overflow': 'hidden'});
        $('#library-settings-popup').css({'display': 'block'});

        $('#library-settings-popup-close').click(function() {
            $('body').css({'overflow': 'auto'});

            $('#library-settings-popup').css('display', 'none');
            $('#screen').css('display', 'none')
        });
    }

    $('#library-settings').click(librarySettingsPopup);

    var moveRecordsPopup = function() {
        $('#screen').css({'display': 'block', opacity: 0.7, 'width': $(document).width(), 'height': $(document).height()});
        $('body').css({'overflow': 'hidden'});
        $('#move-items-popup').css({'display': 'block'});

        $('#move-items-popup-close').click(function() {
            $('body').css({'overflow': 'auto'});

            $('#move-items-popup').css('display', 'none');
            $('#screen').css('display', 'none')
        });
    };

    $('#move-items-popup-button').click(moveRecordsPopup);

    $("#select-all-records").click(function() {
        var allRecordsSelected = !$(this).data("allRecordsSelected");

        if (allRecordsSelected) {
            $("#references-summary input[type='checkbox']").prop('checked', true);
        } else {
            $("#references-summary input[type='checkbox']").prop('checked', false);
        }
        $(this).data("allRecordsSelected", allRecordsSelected);
    });

    $("#select-all-libraries").click(function() {
        var allSearchLibrariesSelected = !$(this).data("allSearchLibrariesSelected");
        if (allSearchLibrariesSelected) {
            $("#library-search-id option").prop('selected', true);
        } else {
            $("#library-search-id option").prop('selected', false);
        }
        $(this).data("allSearchLibrariesSelected", allSearchLibrariesSelected);
    });

    $("#move-items-to-trash").click(function() {
        $("#move-items-target").prop("value", $("#move-items-to-trash").attr("value"));
        $("#metadata-summary-form").submit();
    });

    $("#move-now").click(function() {
        $("#move-items-target").prop("value", $("#target_library_id").val());
        $("#metadata-summary-form").submit();
    });
});

function displayNewRecordControls() {
    $("#record-controls-1").css('display', 'none');
    $("#record-controls-2").css('display', 'block');
    $("#update-metadata-form").find(':input').each(function() {
        switch (this.type) {
            case 'password':
            case 'select-multiple':
            case 'select-one':
            case 'text':
            case 'textarea':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });
    
    return false;
}

function saveRecord() {
    $('#update-metadata-form-action').prop("value", "create_record");
    $('#update-metadata-form').submit();
}

function displayActiveRecordControls() {
    $("#record-controls-2").css('display', 'none');
    $("#record-controls-1").css('display', 'block');
    location.reload();
}