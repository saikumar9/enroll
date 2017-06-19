$(document).on('click', '#search_for_plan_shopping_help', function() {
  $.ajax({
    type: 'GET', 
    data: {firstname: $('#help_first_name').val(), lastname: $('#help_last_name').val(), type: $('#help_type').html(),
           person: $('#help_requestor').html(), email: $('#help_requestor_email').html(),
           first_name: $('#person_first_name').val(), last_name: $('#person_last_name').val(),
           ssn: $('#person_ssn').val(), dob: $('#jq_datepicker_ignore_person_dob').val()
         },
    url: '/exchanges/hbx_profiles/request_help?',
  }).done(function(response) {
    $('#help_status').html(JSON.parse(response)['status'])
  });
})

$(document).on('click', '.help_button', function(){
$.ajax({
    type: 'GET', 
    data: {assister: this.getAttribute('data-assister'), broker: this.getAttribute('data-broker'),
           person: $('#help_requestor').html(), email: $('#help_requestor_email').html(),
           first_name: $('#person_first_name').val(), last_name: $('#person_last_name').val(),
           ssn: $('#person_ssn').val(), dob: $('#jq_datepicker_ignore_person_dob').val()
         },
    url: '/exchanges/hbx_profiles/request_help?',
  }).done(function(response) {
    broker_status = JSON.parse(response)
    var status = broker_status['status']
    var broker = broker_status['broker']
    $('#help_index_status').html(status).removeClass('hide')
    $('#consumer_brokers_widget').html(broker)
  });
})

SignUpHelp.setupNameSearchClick(".name_search_only");
SignUpHelp.setupHelpPlanShoppingClick('[data-target="#help_with_plan_shopping"]');

$(document).on('click', '#back_to_help', function(){
  $('.help_reset').addClass("hide");
  $("#back_to_help").addClass('hide');
  $('#help_list').removeClass("hide");
  $('#help_status').html('')
})
