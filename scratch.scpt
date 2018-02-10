# set projectActions to to dos of aProject whose activation date is missing value
# log projectActions
# set nextAction to first to do of projectActions
# log nextAction
# if exists nextAction then
# 	log "moving first item to anytime"
# 	move the nextAction to list "Anytime"
# end
#
# -- if we have
#
# -- we can't manipulate the list while we iterate, so grab a copy
# set somedayItems to to dos 2 thru -1 of aProject
# repeat with aTodo in somedayItems
# 	set itemProps to properties of the first to do of aProject
# 	log itemProps
# 	-- set theId to id of aProject
# 	--log theId
# 	--set alreadyInSomeday to to dos of list "Someday" whose id = theId
# 	--log to dos in alreadyInSomeday
# 	-- this moves it to the bottom of the list
# 	--if exists item in alreadyInSomeday whose id equals theId
# 		--log itemProps
# 	move aTodo to list "Anytime" -- this will clear activation dates
# 	move aTodo to list "Someday"
# 	--end if
# end repeat
