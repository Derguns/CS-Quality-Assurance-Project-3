# app.rb
require 'sinatra'

class HelloWorldApp < Sinatra::Base
  # Upon accessing the main page ("/", i.e., http://localhost:4567),
  get '/' do
    erb :index
  end
  # If the "Show truth table" button is pressed and the data is invalid, then an error page containing the text "ERROR" in an H1 tag, and "Invalid parameters."
  # shall be displayed, along with a description explaining the rules for valid data (see below).
  post '/table' do
	# Data Default Values
    true_input = params[:true]
    false_input = params[:false]
    size_input = params[:size]
	# If no data is entered on the main page in a particular textbox, the default value shall be used. 
	# The default value for the true symbol is "T",
	if true_input.length <= 0
	  true_input = "T"
	end
	# the default value for the false symbol is "F",
 	if false_input.length <= 0
	  false_input = "F"
	end
	# and the default value for the size is "3".
 	if size_input.length <= 0
	  size_input = "3"
	end
	
	# Data Validation
	# Data shall be considered valid if both the true and false symbols are single characters
    if !true_input.is_a? String or true_input.length != 1
	  erb :inputerror
    elsif !false_input.is_a? String or false_input.length != 1
	  erb :inputerror
	# and are distinct from each other (i.e., they shall not be the same character)
    elsif false_input.eql? true_input
	  erb :inputerror
	# and that the size is an integer with a value of 2 or greater.
	elsif size_input.to_i < 2 
	  erb :inputerror  
	else
		# Data Display Page
		to_print = "<table style='width:100%'>"
		to_print = to_print + "<tr>"
		i = size_input.to_i-1
		while i >= 0
			to_print = to_print + "<th>#{i}</th>"
			i = i-1;
		end
		to_print = to_print + "<th>AND</th><th>OR</th><th>NAND</th><th>NOR</th></tr>"

		# We need to generate an array that finds the split points for each column.
		split_points = Array.new
		i = size_input.to_i 
		half_point = 2**(size_input.to_i) /2
		while i >= 0
			split_points.push(half_point)
			half_point = half_point / 2
			i = i-1;
		end
		# We will then have 2 ^ size rows to fill into the table. 
		row_size = 2**(size_input.to_i)
		i = 0
		while i < row_size
			to_print = to_print + "<tr>"
			# Each row will then have # <td> columns that is the size + 1, and, or, nand, and nor.
			x = 0
			current_index = i;
			current_and = true;
			current_or = false;
			while x < size_input.to_i	
				# Adjust for indexes as the split point gets smaller
				while(current_index >= (split_points[x]*2))
					current_index = current_index - split_points[x]*2
				end
				if(current_index < split_points[x])
					to_print = to_print + "<td align='center'>#{false_input}</td>"
					current_and = current_and && false;
					current_or = current_or || false;
				else
					to_print = to_print + "<td align='center'>#{true_input}</td>"
					current_and = current_and && true;
					current_or = current_or || true;
				end
				x = x+1;
			end
			# AND
			if(current_and == true)
				to_print = to_print + "<td align='center'>#{true_input}</td>"
			else
				to_print = to_print + "<td align='center'>#{false_input}</td>"
			end
			# OR
			if(current_or == true)
				to_print = to_print + "<td align='center'>#{true_input}</td>"
			else
				to_print = to_print + "<td align='center'>#{false_input}</td>"
			end
			# NAND
			if(current_and == true)
				to_print = to_print + "<td align='center'>#{false_input}</td>"
			else
				to_print = to_print + "<td align='center'>#{true_input}</td>"
			end
			# NOR
			if(current_or == true)
				to_print = to_print + "<td align='center'>#{false_input}</td>"
			else
				to_print = to_print + "<td align='center'>#{true_input}</td>"
			end
			
			# Close our row.
			to_print = to_print + "</tr>"
			i = i+1;
		end
		# Add our return link
		to_print = to_print + "</table><br><a href='/' name='return'>Back Home</a>"
		# Print our Dynamic HTML
		"#{to_print}"
	end
end
 # If a user goes to a URL other than one specified (e.g., "http://localhost:4567/hotdog"), the system shall display a page stating "ERROR" (in an h1 tag),
 # as well as the text, "Invalid address.", along with a 404 error code.
  not_found do
    status 404
    erb :error
  end
end