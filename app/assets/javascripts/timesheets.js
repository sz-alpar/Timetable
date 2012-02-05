function update_form(evt, data, status, xhr) {
	var $form_container = $('#form_container');
	$form_container.html(xhr.responseText)
	
	bind_form();
}

function bind_form() {
	$('#timesheet_table_form')
	.bind("ajax:success", update_form)
    .bind("ajax:error", function(evt, xhr, status, error){
      alert("An error occured!");
    });
}

$(document).ready(function() {
	bind_form();
});

function submit_form(cell_id) {
	var modified_cell_id = $("<input>").attr("type", "hidden").attr("name", "modified_cell_id").val(cell_id);
	$('#timesheet_table_form').append($(modified_cell_id));

	$("#save_timesheet_submit_button").click();
}
