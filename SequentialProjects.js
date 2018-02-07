#!/usr/bin/env osascript -l JavaScript

// the tag for sequential projects
const SEQ_TAG = "sequential"

// get a reference to Things
const Things = Application('Things3')

// create the tag if it doesn't exist
const sequentialTag = Things.Tag({name: SEQ_TAG})
Things.tags.push(sequentialTag)

const projects = sequentialTag.toDos().filter(task => task.properties()["pcls"] === 'project')
console.log(`There are ${projects.length} projects tagged as ${SEQ_TAG}`)

const somedayList = Things.lists.byName('Someday')
console.log(JSON.stringify(somedayList.properties()))
projects.forEach(p => {
  console.log(p.name())
  for (let [index, todo] of p.toDos().entries()) {
    if (todo.status() === 'open') {
      console.log(index, todo.name())
      if (index !== 0) {
        todo.move({to: 'Someday'})
      }
    }
  }
})
