//= require jquery3
//= require popper
//= require bootstrap-sprockets

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

function success(pos) {
  var crd = pos.coords;
  document.cookie = `lat_long=${crd.latitude + "|" + crd.longitude}`;
}

function error(err) {
  console.warn(`ERROR(${err.code}): ${err.message}`);
}

function writeCookie() {
   cookievalue = escape(document.location_form.location.value) + ";"
   document.cookie = "manual_location=" + cookievalue;
}

async function updatePage(){
    var repeater;
    var survey_id = $('.temp_information').data('survey-id')
    var api_url = $('.temp_information').data('api-url')
    const response = await fetch(`${api_url}/api/v1/surveys/${survey_id}`, {});
    const json = await response.json();
    var total_votes = json.data.attributes.total_votes;
    var restaurant_1_votes = json.data.attributes.restaurant_1_votes;
    var restaurant_2_votes = json.data.attributes.restaurant_2_votes;
    var restaurant_3_votes = json.data.attributes.restaurant_3_votes;
    var survey_status = json.data.attributes.survey_status

    document.getElementById("total-votes").innerHTML=total_votes;
    document.getElementById("sr1-votes").innerHTML=restaurant_1_votes;
    document.getElementById("sr2-votes").innerHTML=restaurant_2_votes;
    document.getElementById("sr3-votes").innerHTML=restaurant_3_votes;
    repeater = setTimeout(updatePage, 3000);
    if (survey_status == 'inactive') {
      location.reload()
    }
  };
