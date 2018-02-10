#!/usr/bin/env osascript

-- for any project that is tagged as sequential,
-- if the first action is an unscheduled someday action, it will be moved to anytime
on run()
	promoteNextActions()
end run

on promoteNextActions()
	log "promoting next actions..."
	tell application "Things3"
		-- make the tag if it doesn't exist and get a reference to it
		set sequentialTag to make new tag with properties { name:"sequential" }

		-- for every project (class selector doesn't work for some reason)
	  repeat with aProject in to dos of sequentialTag
			-- ignore non projects marked as sequential
			if aProject's class is project then
				set nextActions to to dos of aProject
				-- make the first item active, unless it is scheduled, this either does nothing if the item is already
				-- active, or promotes the first unscheduled someday item to active
				-- I would not move it if it was already in Anytime, but I can't figure out how to determine that
				repeat with nextAction in nextActions
					if activation date of nextAction is missing value then
						log "moving first item to anytime..."
						move the nextAction to list "Anytime"
						exit repeat
					end if
				end repeat

			end if
	  end repeat
	end tell
end promoteNextActions
