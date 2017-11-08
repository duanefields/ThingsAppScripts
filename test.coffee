# coffee --compile --transpile --inline-map --print "$0" | osascript -l JavaScript
Things = Application 'Things3'
tasks = Things.lists.byName('Anytime').toDos
for task in tasks
  console.log task.name()
