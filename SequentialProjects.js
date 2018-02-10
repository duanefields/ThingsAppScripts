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

const somedayList = Things.lists['Someday']
console.log(JSON.stringify(somedayList.properties()))
// TODO move can act on a list, probably faster to batch per project, once I get it working
// TODO use a filter to get all but the first project
projects.forEach(p => {
  console.log(p.name())
  for (let [index, todo] of p.toDos().entries()) {
    // TODO this approach doesn't seem to return someday items, so only works the first time
    if (todo.status() === 'open') {
      console.log(index, todo.name())
      if (index !== 0) {
        //todo.move({to:somedayList})
        //todo.move({to:"Someday"})
        //Things.move(todo, {to:somedayList})
        //Things.move(todo, {to: {name:"Someday"}})
        //Things.move(todo, {to:"Someday"})
        //Things.move({todo:todo, to:somedayList})
        todo.move({to:somedayList})
      }
    }
  }
})
