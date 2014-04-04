$(document).ready(function(){

	// $('#hit_form button').click(function(){
	$(document).on("click","#hit_form button",function() {
		$.ajax({
			type: 'POST',
			url: '/game/hit' 
		}).done(function(msg){
			// alert(msg)
			$('#game').replaceWith(msg);
		});
		return false;
	});

	// $('#stay_form button').click(function(){
	$(document).on("click","#stay_form button",function() {
		$.ajax({
			type: 'POST',
			url: '/game/stay' 
		}).done(function(msg){
			// alert(msg)
			$('#game').replaceWith(msg);
		});
		return false;
	});

	// $('#dealer_hit_form button').click(function(){
	$(document).on("click","#dealer_hit_form button",function() {
		$.ajax({
			type: 'POST',
			url: '/game/dealer_hit' 
		}).done(function(msg){
			// alert(msg)
			$('#game').replaceWith(msg);
		});
		return false;
	});
});