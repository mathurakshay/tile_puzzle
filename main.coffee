image_url = ""
free_cell = 
	row: 4
	col: 4

###
# returns a shuffeled list of numbers from 1 to the given number
###
get_random_list = (t) ->
	r_list = []
	while r_list.length < t
		n = Math.round(Math.random() * 100)
		r_list.push n if n not in r_list and n in [1..t]
	return r_list

###
# arreanges the tiles for the first time (shuffeled) 
# either with an image or with numbers
###
start_puzzle = ->
	items = get_random_list(15)
	for i in [1..15]
		if image_url
			$("div[data-pos=#{i}]").html "<div class='tile-ssimg tile_#{items[i-1]}' data-seq='#{items[i-1]}'></div>"
		else
			$("div[data-pos=#{i}]").html "<div class='tile-num' data-seq='#{items[i-1]}'>#{items[i-1]}</div>"
	free_cell.row = free_cell.col = 4
	$("div[data-pos=16]").html ''
	set_cursor()
	check_completion()

###
# Takes care that hand cursor shows up on the movable tiles
###
set_cursor = ->
	$(".col").removeClass('hand_pointer')
	$("div[data-col=#{free_cell.col}]").addClass('hand_pointer')
	$("div[data-row=#{free_cell.row}] .col").addClass('hand_pointer')
	$("div[data-row=#{free_cell.row}] div[data-col=#{free_cell.col}]").removeClass('hand_pointer')

###
# Lets user know current completion status
# Greets the user on complition and re-starts new game
###
check_completion = ->
	correct = incorrect = 0
	for i in [1..15]
		if $("div[data-pos=#{i}]>div").attr('data-seq') == "#{i}"
			correct++
		else
			incorrect++
	complition = Math.round(correct * 100 / 15, 1)
	$("#score").text "Complition: #{complition}% (correct: #{correct}; incorrect: #{incorrect})"
	if complition == 100
		alert "Congratulations! You won" 
		start_puzzle()

$(document).ready ->

	###
	# Gets invoked when user clicks the button in front of text box for changing the image
	# Allows user to play with any image 
	# sets user provided image in tiles and the preview area
	# Restarts the puzzle with the new image
	###
	$("#chnage_image").click ->
		image_url = if $('#image_url').val() then "url(#{$('#image_url').val()})" else ''
		start_puzzle()
		$("#preview_div").css("backgroundImage", image_url)
		$('.tile-ssimg').css("backgroundImage", image_url)
	$("#chnage_image").click()

	###
	# gets invoked when user clicks on a tile
	# Moves tiles as intended by use
	###
	$(".col").click (ev)->
		target = $(this)
		target_row = parseInt target.closest('.row-fluid').attr('data-row')
		target_col = parseInt target.attr('data-col')
		if target_row == free_cell.row
			#move columns
			move_order = [free_cell.col..target_col]
			for x in [0..move_order.length - 1]
				content_to_move = $("div[data-row=#{free_cell.row}]").find("div[data-col=#{move_order[x + 1]}]").html()
				$("div[data-row=#{free_cell.row}]").find("div[data-col=#{move_order[x + 1]}]").html('')
				$("div[data-row=#{free_cell.row}]").find("div[data-col=#{move_order[x]}]").html content_to_move
				free_cell.col = move_order[x]

		else if target_col == free_cell.col
			#move rows
			move_order = [free_cell.row..target_row]
			for x in [0..move_order.length - 1]
				content_to_move = $("div[data-row=#{move_order[x + 1]}]").find("div[data-col=#{free_cell.col}]").html()
				$("div[data-row=#{move_order[x + 1]}]").find("div[data-col=#{free_cell.col}]").html('')
				$("div[data-row=#{move_order[x]}]").find("div[data-col=#{free_cell.col}]").html content_to_move
				free_cell.row = move_order[x]
			#move rows
		set_cursor()
		check_completion()
		return
	return



