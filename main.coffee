image_url = ""
free_cell = 
	row: 4
	col: 4

get_random_list = (t) ->
	r_list = []
	while r_list.length < t
		n = Math.round(Math.random() * 100)
		r_list.push n if n not in r_list and n in [1..t]
	return r_list

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

set_cursor = ->
	$(".col").removeClass('hand_pointer')
	$("div[data-col=#{free_cell.col}]").addClass('hand_pointer')
	$("div[data-row=#{free_cell.row}] .col").addClass('hand_pointer')
	$("div[data-row=#{free_cell.row}] div[data-col=#{free_cell.col}]").removeClass('hand_pointer')

check_completion = ->
	correct = incorrect = 0
	for i in [1..15]
		if $("div[data-pos=#{i}]>div").attr('data-seq') == "#{i}"
			correct++
		else
			incorrect++
	complition = Math.round(correct * 100 / 15, 1)
	$("#score").text "Complition: #{complition}% (correct: #{correct}; incorrect: #{incorrect})"
	alert "you won" if Complition == 100

$(document).ready ->

	$("#chnage_image").click ->
		image_url = if $('#image_url').val() then "url(#{$('#image_url').val()})" else ''
		start_puzzle()
		$("#preview_div").css("backgroundImage", image_url)
		$('.tile-ssimg').css("backgroundImage", image_url)
	$("#chnage_image").click()

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



