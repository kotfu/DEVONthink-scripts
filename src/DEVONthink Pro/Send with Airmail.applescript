-- Using Airmail, compose a new message and attach the selected items
-- Tested with Airmail 3

-- get the paths of the currently selected records in DEVONthink
tell application id "DNtp"
	-- go find the first viewer window
	-- this doesn't seem to select the topmost viewer window
	-- if you have multiple viewer windows open, but it works great
	-- if you only have one
	set theWindow to false as boolean
	repeat with x from 1 to (count windows)
		if class of window x is viewer window then
			set theWindow to window x
			exit repeat
		end if
	end repeat
	
	if theWindow is false then
		display notification "No DEVONthink viewer window found."
		return
	end if
	
	set theRecords to selection of theWindow
	set thePaths to {}
	repeat with theRecord in theRecords
		set thePath to the path of theRecord
		copy thePath to end of thePaths
	end repeat
end tell

set theSubject to "Files From DEVONthink"

tell application "Airmail 3"
	
	-- we give the message a subject so we can find the window later
	set theMessage to make new outgoing message with properties {subject:theSubject}
	
	-- loop through the paths from the records and add them
	-- as attachments to the message
	repeat with thePath in thePaths
		tell theMessage
			make new mail attachment with properties {filename:thePath}
		end tell
	end repeat
	
	activate
	compose theMessage
end tell

tell application "System Events"
	tell process "Airmail 3"
		-- go find the window that just got created, using the subject we created
		-- it with
		repeat with x from 1 to (count windows)
			if name of window x starts with theSubject then
				exit repeat
			end if
		end repeat
		-- set focus to the "To:" field
		set focused of text field 1 of scroll area 1 of window x to true
		-- set the subject field to empty
		set value of text field 1 of window x to ""
	end tell
end tell
