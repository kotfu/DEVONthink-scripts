-- Install in ~/Library/Scripts/Applications/Microsoft Outlook
-- Import attachments of selected Microsoft Outlook messages to DEVONthink Pro.
-- Created by Christian Grunenberg on Fri May 18 2012.
-- Copyright (c) 2012-2015. All rights reserved.

tell application "Microsoft Outlook"
	try
		tell application id "DNtp"
			if not (exists current database) then error "No database is in use."
			set theGroup to preferred import destination
		end tell
		set theSelection to the selection
		set theFolder to (POSIX path of (path to temporary items))
		if the theSelection is {} then error "One or more messages must be selected."
		repeat with theMessage in theSelection
			set theSender to the sender of theMessage
			repeat with theAttachment in attachments of theMessage
				set theSubject to subject of theMessage
				set theFile to theFolder & (name of theAttachment)
				tell theAttachment to save in theFile
				tell application id "DNtp"
					set theAttachmentRecord to import theFile to theGroup
					set URL of theAttachmentRecord to theSender
				end tell
			end repeat
			display notification "Saved " & ((count of attachments of theMessage) as string) & " attachments from '" & theSubject & "' to DEVONthink."
		end repeat
	on error error_message number error_number
		if error_number is not -128 then display alert "Microsoft Outlook" message error_message as warning
	end try
end tell
