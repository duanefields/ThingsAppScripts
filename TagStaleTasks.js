#!/usr/bin/env osascript -l JavaScript
//
// Sets or clears the "Stale" tag on any Active task or project not modified in the last 60 days.
// To reset the clock, simply remove the "Stale" tag from the project or task.
// Currently only looks at Anytime tasks, not Inbox, Upcoming, or Someday tasks.

MAX_DAYS = 60
STALE_TAG = 'Stale'
targetDate = new Date(new Date().setDate(new Date().getDate() - MAX_DAYS))

Things = Application('Things3')

// create the tag, if it doesn't already exist
staleTag = Things.Tag({name: STALE_TAG})
Things.tags.push(staleTag)
console.log("There are currently " + staleTag.toDos.length + " tasks tagged as " + STALE_TAG)

// tag tasks not modified since the cut off date
// todo: can we make a compound filter to not include existing stale tags?
tasks = Things.lists.byName('Anytime').toDos.whose({creationDate: {'<': targetDate}})
console.log("Adding stale tags on " + tasks.length + " tasks")
for (i=0; i < tasks.length; i++) {
	task = tasks[i]
  tags = task.tagNames().split(',')
  // todo: you'd think you can push tags into task.tags, but it doesn't work...
  if (tags.indexOf(STALE_TAG) == -1) {
    console.log("Updating tags for '" + task.name() + "' to ", tags.join(','))
    tags.push(STALE_TAG)
    task.tagNames = tags.join(',')
  }
}

// untag tasks modified since the cut off date previously marked as stale
// tasks = Things.tags.byName("Stale").toDos.whose({modificationDate: {'>=': targetDate}})
// console.log("Removing stale tags on " + tasks.length + " tasks")
// for (i=0; i < tasks.length; i++) {
// 	task = tasks[i]
//   tags = task.tagNames().split(',')
//   indexOfStaleTag = tags.indexOf(STALE_TAG)
//   if (indexOfStaleTag != -1) {
//     tags.splice(indexOfStaleTag, 1)
//     console.log("Updating tags for '" + task.name() + "': ", tags)
//     task.tagNames = tags.join(',')
//   }
// }
