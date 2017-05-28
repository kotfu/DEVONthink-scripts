-- Attach the selected files from DEVONthink to the current Airmail composer
-- Tested with Airmail 3

-- get the paths of the currently selected records in DEVONthink
tell application id "DNtp"
	-- select the topmost viewer window, i.e. one with a list of documents
	-- this skips over windows like PDF reader windows
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

-- now tell Airmail to attach each one of the selected files
repeat with thePath in thePaths
	tell application "System Events" to tell process "Airmail 3"
		-- make sure Airmail is frontmost so we can click the menu
		set frontmost to true
		click menu item "Attach..." of menu 1 of menu bar item "Composer" of menu bar 1
		
		-- wait for the file dialog to appear
		repeat until exists sheet 1 of window 1
			delay 0.1
		end repeat
		
		tell sheet 1 of window 1
			-- open the "Go To Folder" sheet
			keystroke "g" using {command down, shift down}
			-- wait for it to appear
			repeat until exists sheet 1
				delay 0.1
			end repeat
			-- put in the path and click Go
			keystroke thePath
			tell sheet 1 to click button "Go"
			-- our file is now selected, attach it
			click button "Attach File"
		end tell
	end tell
end repeat

