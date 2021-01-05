let playerIdentifier = ""

window.addEventListener('message', function(event) {
    if (event.data.civilianresults){
        $('.tbody-result-users').remove();
        $('.all-found-users').append($('<tbody class="tbody-result-users">'));

        event.data.civilianresults.forEach(function(user){
            $('.tbody-result-users').append($('<tr>').on('click', function(){
                showExtraUserData(user);
            })
                .append($('<td>').text(user['firstname']))
                .append($('<td>').text(user['lastname']))
                .append($('<td>').text(user['sex']))
                .append($('<td>').text(user['dateofbirth'])));
        })
    } else if (event.data.crresults){
        $('.sabika-icerik-cezalar').html('');
        event.data.crresults.forEach(function(cr){
            if (cr['id'] != "-1" ) {
            $('.sabika-icerik-cezalar').append($('<div class="sabika-icerik-cezalar-js">')
                .append($('<div class="sabika-icerik-kutu">').text(cr['reason']))
                .append($('<div class="sabika-icerik-kutuceza">').text(cr['fine']))
                .append($('<div class="sabika-icerik-kutux">').append($('<span style="text-aligin: center;"class="delete_cr" data-id="'+ cr['id'] +'">').text('X'))));
            } else {
            $('.sabika-icerik-cezalar').append($('<div class="sabika-icerik-cezalar-js">')
                .append($('<div class="sabika-icerik-kutu">').text(cr['reason']))
                .append($('<div class="sabika-icerik-kutuceza">').text(cr['fine']))
                .append($('<div class="sabika-icerik-kutux">').text()))
            }
        })
    } else if (event.data.houseNo) {
        $('.ev').text(event.data.houseNo);
    } else if(event.data.note_deleted){
        $.post('https://tgiann-mdt/get-note', JSON.stringify({ playerid: playerIdentifier }) );
        $('.note-message').empty();
    } else if(event.data.note_not_deleted){
        $('.note-message').empty();
    } else if(event.data.cr_deleted){
        $.post('https://tgiann-mdt/get-cr', JSON.stringify({ playerid: playerIdentifier }) );
        $('.cr-message').empty();
    } else if(event.data.bolo_not_deleted){
        $('.error-bolo').empty();
    } else if(event.data.bolo_deleted){
        $.post('https://tgiann-mdt/get-bolos' );
        $('.bolo-message').empty();
    } else if(event.data.cr_not_deleted){
        $('.cr-message').empty();
    } else if (event.data.noteResults){
        $('.not-icerik-cezalar').html('');
        event.data.noteResults.forEach(function(notes){
            if (notes['id'] != "-1" ) {
                $('.not-icerik-cezalar').append($('<div class="not-icerik-cezalar-js">')
                .append($('<div class="not-icerik-kutu">').text(notes['title']))
                .append($('<div class="not-icerik-kutux">').append($('<span style="text-aligin: center;"class="delete_note" data-id="'+ notes['id'] +'">').text('X'))));
            } else {
                $('.not-icerik-cezalar').append($('<div class="not-icerik-cezalar-js">')
                .append($('<div class="not-icerik-kutu">').text(notes['title']))
                .append($('<div class="not-icerik-kutux">').text()))
            }
        })
    } else if (event.data.licenseResults){
        $('.lisanslar-kutu').html('');
        if (event.data.licenseResults.length == 0) {
            $('.lisanslar-kutu').append($('<div class="lisanslar-js">').append($('<div class="lisans-turu">').text("Herhangi Bir Lisansı Yok")));
        } else {
            for (let i = 0; i < event.data.licenseResults.length; i++) {
                const type = event.data.licenseResults[i].type;
                if ( type == 'boating') {
                    licanseName = 'Boat Driving License';
                } else if ( type == 'dmv' ) {
                    licanseName = 'Intern License';
                } else if ( type == 'drive' ) {
                    licanseName = 'Driving license';
                } else if ( type == 'drive_bike' ) {
                    licanseName = ' Motorcycle license';
                } else if ( type == 'drive_truck' ) {
                    licanseName = 'Truck License';
                } else if ( type == 'aircraft' ) {
                    licanseName = 'Pilot License';
                }
                $('.lisanslar-kutu').append($('<div class="lisanslar-js">').append($('<div class="lisans-turu">').text(licanseName)));
            }
        }
    } else if (event.data.showBolos){
        $('.tgiann-mdt-bolos tbody').html('');
        event.data.showBolos.forEach(function(bolo){
            if (bolo['id'] == -1 ) {
                $('.tgiann-mdt-bolos tbody').append($('<tr>')
                    .append($('<td>').text(bolo['name']))
                    .append($('<td>').text(""))
                    .append($('<td>').text(""))
                    .append($('<td>').text(""))
                    .append($('<td>').text(""))
                    .append($('<td>').text(""))
                );
            } else {
                $('.tgiann-mdt-bolos tbody').append($('<tr>')
                    .append($('<td>').text(bolo['name']))
                    .append($('<td>').text(bolo['lastname']))
                    .append($('<td>').text(bolo['gender']))
                    .append($('<td>').text(bolo['reason']))
                    .append($('<td>').text(bolo['created_at']))
                    .append($('<td>').append($('<span class="delete_bolo" data-id="'+ bolo['id'] +'">').text('X')))
                );
            }
        })
    } else if (event.data.playerCars){
        $('.player-cars').html('');
        event.data.playerCars.forEach(function(bolo){
            $('.player-cars').append(`
                <div class="player-cars-kutu">
                    <div class="player-cars-model">${bolo.model}</div>
                    <div class="player-cars-plate">${bolo.plate}</div>
                </div> 
            `);
        })
    } else if (event.data.plate){
        $('#plate').empty().append(event.data.plate);
        $('#model').empty().append(event.data.model);
        $('#firstname').empty().append(event.data.firstname);
        $('#lastname').empty().append(event.data.lastname);
    } else if (event.data.foto) {
        document.getElementById("cr-resmi").value = event.data.foto;
    } else if (event.data.showCadSystem === true){
        $('#tgiann-mdt').show();
        $('#input-plate').focus();
        $("html").show();
    } else if (event.data.showCadSystem === false){
        $('#tgiann-mdt').hide();
        $("html").hide();
    }
});

$(document).on('click','.karakter-geri-git', function (ev) {
    $('.civilian-details .inputfield').empty();
    $('.civilian-details').hide(300);
    $('.resultinner').show(300);
});

$(document).on('click','#search-for-plate',function(){
    $.post('https://tgiann-mdt/search-plate', JSON.stringify({ plate: $('#input-plate').val() }));
});

$(document).on('click','.tgiann-mdt-close',function(){
    $.post('https://tgiann-mdt/escape');
});

$(document).on('click','.civ-back', function () {
    $('.resultinner').show(300);
});

$(document).on('click','.add-cr', function () {
    $('.modal-add-record').show(300);
    $(".modal-add-note").hide(400);
});

$(document).on('click','.add-bolo', function () {
    $('.modal-add-bolos').show(300);
});

$(document).on('click','#save-criminal-record', function () {
    if ($('#cr-reason').val().length > 0 && $('#cr-fine').val().length > 0 ) {
        $.post('https://tgiann-mdt/add-cr', JSON.stringify({ reason: $('#cr-reason').val(), fine: $('#cr-fine').val(), resmi: $('#cr-resmi').val(), time: $('#cr-time').val(), playerid: playerIdentifier }) );
    } else if ($('#cr-resmi').val().length > 0) {
        $.post('https://tgiann-mdt/save-photo', JSON.stringify({resmi: $('#cr-resmi').val(), playerid: playerIdentifier }));
        $("#save-criminal-record").notify(
            "Suçlunun Resmi Kaydedildi",  "success", 
            { position: "bottom" }
        );
    } else {
        $("#save-criminal-record").notify(
            "Kişinin Suçlarını ve Cezasının Bedelini Yazman Lazım", "error", 
            { position: "bottom" }
        );
    }
});

$(document).on('click','#takePhoto', function () {
    $.post('https://tgiann-mdt/takePhoto');
});

$(document).on('click','.add-note', function () {
    $('#note-title').val('');
    $('#note-content').val('');
});

$(document).on('click','.delete_note' ,function () {
    $.post('https://tgiann-mdt/delete_note', JSON.stringify({ id:  $(this).data('id') }));
});

$(document).on('click','.delete_cr' ,function () {
    $.post('https://tgiann-mdt/delete_cr', JSON.stringify({ id:  $(this).data('id') }));
});

$(document).on('click','#save-note', function () {
    if ($('#note-title').val().length > 1 ) {
        $.post('https://tgiann-mdt/add-note', JSON.stringify({ content: $('#note-content').val(), title: $('#note-title').val(), playerid: playerIdentifier}));
    } else {
        $("#save-note").notify(
            "Boş Not Kaydedemezsin",  "error", 
            { position: "bottom" }
        );
    }
});

$(document).on('click','#save-bolos', function () {
    $.post('https://tgiann-mdt/add-bolo', JSON.stringify({
        name: $('#input-bolos-gender').val(),
        lastname: $('#input-bolos-height').val(),
        gender: $('#input-bolos-age').val(),
        reason: $('#input-bolos-type-of-crime').val(),
    }));
    $('.modal-add-bolos').hide(300);
});

$(document).on('click','.delete_bolo' ,function () {
    $.post('https://tgiann-mdt/delete-bolo', JSON.stringify({ id:  $(this).data('id') }));
});

$(document).on('click','#search-for-civilian',function() {
    $.post('https://tgiann-mdt/search-players', JSON.stringify({ search: $('#search').val() }));
});

$(document).on('click', '.tgiann-mdt-menu li', function () {
    let id = $(this).data('id');
    $('.active').removeClass('active');
    $(this).addClass('active');

    $('#plate-checker').hide();

    if($(this).data('id') == 'plate-checker'){
        $('#plate-checker').show();
    }
    
    if ( id == 'bolos'){
        $.post('https://tgiann-mdt/get-bolos');
    }

    $('.page').hide();
    $('#'+id).show();
    $('input').focus();
});

function showExtraUserData(user){
    playerIdentifier = user.identifier
    $('#criminal-records tbody').html('');
    $('#licenses tbody').html('');
    $('.resultinner').hide(300);
    $('.civilian-details').show(300);
    $('#playerIdentifier').html(playerIdentifier);
    $('.isimsoyisim').html(user.firstname + ' ' + user.lastname);
    $('#dob').html(user.dateofbirth);
    $('#job').html(user.job);
    $('#bank').html('$' + JSON.parse(user.accounts).bank);
    $('#number').html(user.phone_number);

    if ( user.sex == "M" ) {
        $('#gender').html('Male');
        if ( user.userimage != undefined ) {
            $('img').attr('src', user.userimage);
        } else {
            $('img').attr('src', 'images/male.png');  
        }
    } else {
        $('#gender').html('Female');
        if ( user.userimage != undefined ) {
            $('img').attr('src', user.userimage);   
        } else {
            $('img').attr('src', 'images/female.png');   
        }
    }

    $.post('https://tgiann-mdt/get-cr', JSON.stringify({identifier: playerIdentifier} ));
    $.post('https://tgiann-mdt/get-note', JSON.stringify({identifier: playerIdentifier} ));
    $.post('https://tgiann-mdt/get-license', JSON.stringify({identifier: playerIdentifier} ));
    $.post('https://tgiann-mdt/get-player-car', JSON.stringify({identifier: playerIdentifier} ));
}

function openNav() {
    document.getElementById("mySidebar").style.display = "inline-block";
    document.getElementById("openbtn").style.display = "none";
}
  
function closeNav() {
    document.getElementById("mySidebar").style.display = "none";
    document.getElementById("openbtn").style.display = "block";
}

document.addEventListener("DOMContentLoaded", () => {
    let coll = document.getElementsByClassName("cezabaslikicerik");

    for (i = 0; i < coll.length; i++) {
        coll[i].addEventListener("click", function() {
            let cezaicerik = this.nextElementSibling;
            this.classList.toggle("cezabaslikicerik-aktif");
            if (cezaicerik.style.display === "block") {
                cezaicerik.style.display = "none";
            } else {
                cezaicerik.style.display = "block";
            }
        });
    }
});

document.onkeydown = function (data) {
    if (data.which == 120 || data.which == 27) {
        $.post('https://tgiann-mdt/escape');
    }
};