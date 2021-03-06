#!/usr/bin/env osascript

property untaggedTagName: "Untagged"

on run()
  -- make the tag if it doesn't exist and get a reference to it, free to move it around later
  tell application "Things3"
    make new tag with properties { name:untaggedTagName }
  end tell

  -- faster than querying for open status on all todos because of "logged"
  tagUntagged("Anytime")
  tagUntagged("Someday")
  tagUntagged("Upcoming")
end run

on idle()
	run()
	return 60 * 15
end idle

to joinList(aList, delimiter)
 set retVal to ""
 set prevDelimiter to AppleScript's text item delimiters
 set AppleScript's text item delimiters to delimiter
 set retVal to aList as string
 set AppleScript's text item delimiters to prevDelimiter
 return retVal
end joinList

to splitString(aString, delimiter)
 set retVal to {}
 set prevDelimiter to AppleScript's text item delimiters
 set AppleScript's text item delimiters to {delimiter}
 set retVal to every text item of aString
 set AppleScript's text item delimiters to prevDelimiter
 return retVal
end splitString

on tagUntagged(listName)
  tell application "Things3"
    log "Checking " & listName
    repeat with task in to dos of list listName
      if class of task is not project then
        set taskTags to tags of task
        set taskName to name of task
        set taskTagCount to count of taskTags

        -- inherit project tags, if any
        -- if task's project is not missing value then
        --   set taskTags to taskTags & tags of task's project
        -- end if

        -- no tags on either the project or task, so we tag as untagged
        if taskTagCount is 0 then
          log "Adding Untagged: " & taskName & ", " & taskTagCount & " tags [" & tag names of task & "]"
          set newTagNames to tag names of task & "," & untaggedTagName
          set tag names of task to newTagNames

        -- remove untagged tag if present
        else if taskTagCount is greater than 1 then
          set otherTagNames to name of task's tags whose name is not untaggedTagName
          if count of otherTagNames is less than taskTagCount then
            set newTagNames to my joinList(otherTagNames, ",")
            log "Removing Untagged: " & taskName & ", " & taskTagCount & " tags [" & tag names of task & "]"
            set task's tag names to newTagNames
          end if
        end if

      end if
    end repeat
  end tell
end tagUntagged
