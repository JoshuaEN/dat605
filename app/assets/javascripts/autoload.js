$(document).ready(function(){

	// This is terrible for performance I'm sure.
	$('.modal-trigger').leanModal({in_duration: 100, out_duration: 100});
	$(".button-collapse").sideNav();
	$('.collapsible').collapsible();
	$('select').material_select();

	$('li.collection-item.dismissable i[data-dismiss]').on('click', function(e) {
		var $collection_item = $(this).closest('li.collection-item.dismissable');

		// Delete the entire container if there's only one item left.
		if($collection_item.parent().children().length == 1)
			$collection_item.parent().remove();
		else
			$collection_item.remove();

	});

	$('[data-href]').on('click', function(e) {
		window.location.href = $(this).attr('data-href');
	});
});