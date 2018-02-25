#!/usr/bin/env osascript

on run()
  tagUntagged()
end run

on idle()
	tagUntagged()
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

on tagUntagged()
  tell application "Things3"
    -- make the tag if it doesn't exist and get a reference to it, free to move it around later
    set untaggedTag to make new tag with properties { name:"Untagged" }
    set untaggedTagName to name of untaggedTag

    repeat with task in to dos of list "Anytime"
      if class of task is not project then
        set taskTags to tags of task

        -- inherit project tags, if any
        -- if task's project is not missing value then
        --   set taskTags to taskTags & tags of task's project
        -- end if

        -- no tags on either the project or task, so we tag as untagged
        if count of taskTags is 0 then
          log "Marking as Untagged: " & name of task & ", " & count of tags of task & " tags [" & tag names of task & "]"
          set newTagNames to tag names of task & "," & name of untaggedTag
          set tag names of task to newTagNames

        -- remove untagged tag if present
        else if count of taskTags is greater than 1 then
          set tagNameList to my splitString(tag names of task, ", ")
          set newTagNameList to {}

          if tagNameList contains untaggedTagName
          -- make a new list, removing the untagged tag
            repeat with i from 1 to length of tagNameList
              set tagName to item i of tagNameList
              if tagName does not equal untaggedTagName
                set newTagNameList's end to tagName
              end if
            end repeat

            set tagNameList to my joinList(newTagNameList, ",")
            set task's tag names to tagNameList
            log "Removing Untagged: " & name of task & ", " & count of tags of task & " tags [" & tag names of task & "]"
          end if
        end if

      end if
    end repeat
  end tell
end tagUntagged
