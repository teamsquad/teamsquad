// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showPreview() {
	params = Form.serialize( 'edit-form' )
	new Ajax.Updater(
		'in-content-preview',
		'/ajax/textile_preview',
		{asynchronous:true, method:'post', parameters:params}
	);
	$('in-content').style.display = 'none';
	$('in-content-preview').style.display = 'block'
	$('in-content-tab').className = 'inactive';
	$('in-content-preview-tab').className = 'active'
}

function showInput() {
	$('in-content').style.display = 'block';
	$('in-content-preview').style.display = 'none'
	$('in-content-tab').className = 'active';
	$('in-content-preview-tab').className = 'inactive'
}