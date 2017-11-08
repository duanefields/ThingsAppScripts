#!/usr/bin/env osascript -l JavaScript

// instead, trying javascript, not oascript, and bridge out as needed to make changes
// grab all the data, make the changes, and put them back

UNTAGGED_TAG = 'Untagged'
TAGS_TO_IGNORE = ['Stale', 'Untagged'] // empty string split leavas an empty tag

Things = Application('Things3')

// create the tag, if it doesn't already exist
untaggedTag = Things.Tag({name: UNTAGGED_TAG})
Things.tags.push(untaggedTag)

console.log(`There are ${untaggedTag.toDos.length} tasks tagged as ${UNTAGGED_TAG}`)

// if there are no real (unignored) tags
hasNoMeaningfulTags = (tags) => {
	nonIgnoredTags = tags.filter(tag => TAGS_TO_IGNORE.indexOf(tag) === -1)
	return nonIgnoredTags.length === 0
}
date = new Date()
// tasks = Things.toDos().filter(task => task.status() === 'open') // all open tasks
tasks = Things.lists.byName('Inbox').toDos // just inbox

console.log(`Examining ${tasks.length} open tasks...`)
for (var i=0; i < tasks.length; i++) {
	task = tasks[i]
	tags = task.tagNames().split(',').filter(tag => tag.length > 0)
	markedUntagged = tags.indexOf(UNTAGGED_TAG) !== -1

	console.log(`Examining task '${task.name()}' (${task.status()}) with tags ${JSON.stringify(tags)}`)

	if (hasNoMeaningfulTags(tags)) {
		if (! markedUntagged) {
			console.log(`  Tagging '${task.name()}' with ${UNTAGGED_TAG}`)
			// todo: should push tags into task.tags, or the task into tags.todDos, but it doesn't work...
	    tags.push(UNTAGGED_TAG)
	    task.tagNames = tags.join(',')
		}
	} else {
		if (markedUntagged) {
			console.log(`  Removing ${UNTAGGED_TAG} tag from ${task.name()}`)
			tags.splice(tags.indexOf(UNTAGGED_TAG), 1)
			task.tagNames = tags.join(',')
		}
	}
}

console.log(`There are now ${untaggedTag.toDos.length} tasks tagged as ${UNTAGGED_TAG}`)
