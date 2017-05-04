-- Tested with Outlook 15.33, i.e. Outlook 2016 for Mac

-- get the posix paths of the currently selected records in DEVONthink
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
		set thePath to the path of theRecord as POSIX file
		copy thePath to end of thePaths
	end repeat
end tell

tell application "Microsoft Outlook"
	
	-- loop through the open Outlook windows looking for
	-- draft message windows. If there is only one draft window open
	-- this finds it. Experimentation indicates that when multiple
	-- draft windows are open this finds the topmost one first
	set theWindow to false as boolean
	repeat with x from 1 to (count windows)
		if class of window x is draft window then
			set theWindow to window x
			exit repeat
		end if
	end repeat
	
	if theWindow is false then
		display notification "No draft messages are currently open."
		return
	end if
	
	--display notification "have draft window"
	get the id of the object of theWindow
	set myObjectID to id of (object of theWindow)
	set theMessage to message id myObjectID
	
	-- loop through the paths from the records and add them
	-- as attachments to the message
	repeat with thePath in thePaths
		tell theMessage
			make new attachment with properties {file:thePath}
		end tell
	end repeat
end tell

