-- Install in ~/Library/Scripts/Applications/Microsoft Outlook
-- Import selected Microsoft Outlook messages & attachments to DEVONthink Pro.
-- Created by Christian Grunenberg on Mon Mar 05 2012.
-- Copyright (c) 2012-2015. All rights reserved.

-- this string is used when the message subject is empty
property pNoSubjectString : "(no subject)"

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
			my importMessage(theMessage, theFolder, theGroup)
		end repeat
	on error error_message number error_number
		if error_number is not -128 then display alert "Microsoft Outlook" message error_message as warning
	end try
end tell

on importMessage(theMessage, theFolder, theGroup)
	tell application "Microsoft Outlook"
		try
			tell theMessage
				set {theDateReceived, theDateSent, theSender, theSubject, theSource, theReadFlag} to {the time received, the time sent, the sender, subject, the source, the is read}
			end tell
			if theSubject is equal to "" then set theSubject to pNoSubjectString
			set theAttachmentCount to count of attachments of theMessage
			tell application id "DNtp"
				if theAttachmentCount is greater than 0 then set theGroup to create record with {name:theSubject, type:group} in theGroup
				create record with {name:theSubject & ".eml", type:unknown, creation date:theDateSent, modification date:theDateReceived, URL:theSender, source:(theSource as string), unread:(not theReadFlag)} in theGroup
			end tell
			repeat with theAttachment in attachments of theMessage
				set theFile to theFolder & (name of theAttachment)
				tell theAttachment to save in theFile
				tell application id "DNtp"
					set theAttachmentRecord to import theFile to theGroup
					set unread of theAttachmentRecord to (not theReadFlag)
					set URL of theAttachmentRecord to theSender
				end tell
			end repeat
			display notification "Saved '" & theSubject & "' to DEVONthink."
		on error error_message number error_number
			if error_number is not -128 then display alert "Microsoft Outlook" message error_message as warning
		end try
	end tell
end importMessage
