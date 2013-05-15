-- InDDBTool for InDesign-- version 1.0-- created by medul6, Michael Heck, 2013-- open sourced on May 15th, 2013 on Github > check the LICENSE.txt and README.md in the repository for detailed information-- https://github.com/medul6/indesign-InDDB-tool-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••-- global variablesglobal activeDocumentglobal openDocumentsglobal otherDocumentsglobal deduplicatedLayerNamesglobal layerNameListActiveDocglobal myUUIDglobal theSelectionglobal myGeometryglobal myLayer--test variablen-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••tell application id "com.adobe.InDesign"		-- set up some informations from the current state as variables	set activeDocument to active document	set openDocuments to every document	set otherDocuments to every document whose id is not activeDocument's id	set layerListActiveDoc to every layer of activeDocument		-- initialize some lists (to be filled in the next two repeat loops)	set layerList to {}	set layerNameList to {}	set layerNameListActiveDoc to {}		-- fills the layerList with every layer from every document (but there might be duplicates in it)	repeat with i from 1 to count openDocuments		set layerList to layerList & every layer of item i of openDocuments	end repeat		-- creates a new list but with readable names instead of IDs (to present them later to the user)	repeat with i from 1 to count layerList		set layerNameList to layerNameList & name of item i of layerList	end repeat	repeat with i from 1 to count layerListActiveDoc		set layerNameListActiveDoc to layerNameListActiveDoc & name of item i of layerListActiveDoc	end repeat		-- the deduplicting function removes the duplicates from the readable names list	deduplicator(reverse of layerNameList) of me		-- this will display a dialog in which the user can select the desired function of this tool	my functionChooser()	end tell-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on UUIDGenerator()	set myUUID to do shell script "uuidgen"	--display dialog myUUID	--return myUUID	--log myUUIDend UUIDGenerator-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on giveAllPageItemsAnUUID()	tell application id "com.adobe.InDesign"		set allPageItems to all page items of activeDocument --ich glaube das hier sind ALLE Objekte!				repeat with i from 1 to count allPageItems			my UUIDGenerator()			set label of item i of allPageItems to myUUID		end repeat	end tellend giveAllPageItemsAnUUID-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on deleteTheSelectedObjects()	tell application id "com.adobe.InDesign"				set theSelection to selection of activeDocument		if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte ein oder mehrere Objekte auswählen." buttons "OK" default button "OK"		else			set theSelection to every item of selection of activeDocument			repeat with x from 1 to count theSelection				set myUUID to label of item x of theSelection				repeat with y from 1 to count openDocuments					delete (every page item of openDocuments's item y whose label contains myUUID)				end repeat			end repeat		end if	end tellend deleteTheSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on transferUUIDsFromATaggedSourceDocumentToATargetDocument()	tell application id "com.adobe.InDesign"		set allPageItemsSource to all page items of activeDocument		set allPageItemsTarget to all page items of otherDocuments's item 1				set itemCount to count allPageItemsSource				repeat with i from 1 to count allPageItemsSource			set loopINDID to id of allPageItemsSource's item i			set loopUUID to label of allPageItemsSource's item i			try				set targetObject to (first item of all page items of otherDocuments's item 1 whose id is loopINDID)				set label of targetObject to loopUUID			end try		end repeat	end tellend transferUUIDsFromATaggedSourceDocumentToATargetDocument-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on deleteAllUUIDs()	tell application id "com.adobe.InDesign"		set allPageItems to all page items of activeDocument --ich glaube das hier sind ALLE Objekte!				repeat with i from 1 to count allPageItems			set label of item i of allPageItems to ""		end repeat	end tellend deleteAllUUIDs-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on tagSelectedObjects()	tell application id "com.adobe.InDesign"		set theSelection to selection of activeDocument				if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte EIN Objekt auswählen." buttons "OK" default button "OK"					else			repeat with x from 1 to count theSelection				if class of item x of theSelection = group then					repeat with y from 1 to count (every page item of item x of theSelection)						my UUIDGenerator()						set label of page item y of item x of theSelection to myUUID					end repeat				end if				my UUIDGenerator()				set label of item x of theSelection to myUUID			end repeat					end if			end tellend tagSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on untagSelectedObjects()	tell application id "com.adobe.InDesign"		set theSelection to selection of activeDocument				if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte EIN Objekt auswählen." buttons "OK" default button "OK"					else			repeat with x from 1 to count theSelection				if class of item x of theSelection = group then					repeat with y from 1 to count (every page item of item x of theSelection)						set label of page item y of item x of theSelection to ""					end repeat				end if				set label of item x of theSelection to ""			end repeat					end if			end tellend untagSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on transformTheSelectedObjects()	tell application id "com.adobe.InDesign"				set theSelection to selection of activeDocument		if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte ein oder mehrere Objekte auswählen." buttons "OK" default button "OK"		else			set theSelection to every item of selection of activeDocument						--repeat with x from 1 to count theSelection			repeat with x from (count theSelection) to 1 by -1				set myUUID to label of item x of theSelection				set myGeometry to geometric bounds of item x of theSelection				repeat with y from 1 to count otherDocuments										set geometric bounds of (every page item of otherDocuments's item y whose label contains myUUID) to myGeometry				end repeat			end repeat		end if			end tellend transformTheSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on copyTheSelectedObjects()	tell application id "com.adobe.InDesign"				set theSelection to selection of activeDocument		if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte ein oder mehrere Objekte auswählen." buttons "OK" default button "OK"		else			set theSelection to every item of selection of activeDocument						repeat with x from 1 to count theSelection				--repeat with x from (count theSelection) to 1 by -1				set myUUID to label of item x of theSelection				--myLayer				set myLayer to item layer of item x of theSelection				repeat with y from 1 to count otherDocuments					--delete (every page item of openDocuments's item y whose label contains myUUID)					duplicate item x of theSelection to layer (name of myLayer) of otherDocuments's item y				end repeat			end repeat		end if			end tellend copyTheSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on moveTheSelectedObjects()	tell application id "com.adobe.InDesign"				set theSelection to selection of activeDocument		if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte ein oder mehrere Objekte auswählen." buttons "OK" default button "OK"		else			set theSelection to every item of selection of activeDocument						display dialog "Um wieviel X sollen die Objekte verschoben werden?" default answer "0"			set xMoveInteger to (text returned of result)			if xMoveInteger contains "," then				set o to (offset of "," in xMoveInteger)				if ((o > 0) and (0.0 as string is "0,0")) then set xMoveInteger to (text 1 thru (o - 1) of xMoveInteger & "," & text (o + 1) thru -1 of xMoveInteger)				set xMoveInteger to xMoveInteger as number			end if						display dialog "Um wieviel Y sollen die Objekte verschoben werden?" default answer "0"			set yMoveInteger to (text returned of result)			if yMoveInteger contains "," then				set o to (offset of "," in yMoveInteger)				if ((o > 0) and (0.0 as string is "0,0")) then set yMoveInteger to (text 1 thru (o - 1) of yMoveInteger & "," & text (o + 1) thru -1 of yMoveInteger)				set yMoveInteger to yMoveInteger as number			end if						--repeat with x from 1 to count theSelection			repeat with x from (count theSelection) to 1 by -1				set myUUID to label of item x of theSelection				--set myGeometry to geometric bounds of item x of theSelection				repeat with y from 1 to count openDocuments					--set geometric bounds of (every page item of otherDocuments's item y whose label contains myUUID) to myGeometry					move (every page item of openDocuments's item y whose label contains myUUID) by {xMoveInteger, yMoveInteger}				end repeat			end repeat		end if			end tellend moveTheSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on moveLayerTheSelectedObjects()	tell application id "com.adobe.InDesign"				set theSelection to selection of activeDocument		if (count of theSelection) < 1 then			display dialog "Es ist nichts ausgewählt!" & return & "Bitte ein oder mehrere Objekte auswählen." buttons "OK" default button "OK"		else			set theSelection to every item of selection of activeDocument						set chosenLayer to choose from list (reverse of deduplicatedLayerNames) with prompt "Ziel-Ebene wählen:" OK button name "Verschieben"						set chosenLayerColor to layer color of layer (chosenLayer as string) of activeDocument						--repeat with x from 1 to count theSelection			repeat with x from (count theSelection) to 1 by -1				set myUUID to label of item x of theSelection				--set myGeometry to geometric bounds of item x of theSelection				repeat with y from 1 to count openDocuments					--set geometric bounds of (every page item of otherDocuments's item y whose label contains myUUID) to myGeometry					--move (every page item of openDocuments's item y whose label contains myUUID) by {xMoveInteger, yMoveInteger}					if not (layer (chosenLayer as string) of openDocuments's item y exists) then make new layer of openDocuments's item y with properties {name:(chosenLayer as string), layer color:chosenLayerColor}					set item layer of (every page item of openDocuments's item y whose label contains myUUID) to layer (chosenLayer as string) of openDocuments's item y				end repeat			end repeat					end if			end tellend moveLayerTheSelectedObjects-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••-- the functionChooser shows the user a list dialog with the functions of the script. after choosing the desired function gets called (together with one or more arguments)on functionChooser()	set functionChoice to choose from list {"Alle Objekte im Dokument taggen!", "Alle Objekte im Dokument enttaggen!", "Alle UUIDs aus Quelldokument übertragen", "Ausgewählte Objekte taggen", "Ausgewählte Objekte enttaggen", "Ausgewählte Objekte löschen", "Ausgewählte Objekte kopieren", "Ausgewählte Objekte bewegen (x,y)", "Ausgewählte Objekte verschieben (Ebene)", "Ausgewählte Objekte transformieren (beta)"} with prompt "Funktion wählen:" OK button name "Weiter!"		if the functionChoice = {"Alle Objekte im Dokument taggen!"} then		my giveAllPageItemsAnUUID()	else if the functionChoice = {"Alle Objekte im Dokument enttaggen!"} then		my deleteAllUUIDs()	else if the functionChoice = {"Alle UUIDs aus Quelldokument übertragen"} then		my transferUUIDsFromATaggedSourceDocumentToATargetDocument()	else if the functionChoice = {"Ausgewählte Objekte taggen"} then		my tagSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte enttaggen"} then		my untagSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte löschen"} then		my deleteTheSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte kopieren"} then		my copyTheSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte bewegen (x,y)"} then		my moveTheSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte verschieben (Ebene)"} then		my moveLayerTheSelectedObjects()	else if the functionChoice = {"Ausgewählte Objekte transformieren (beta)"} then		my transformTheSelectedObjects()	end if	end functionChooser-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••on displayTheEnd()	display dialog "Fertig!" buttons "OK" default button "OK"end displayTheEnd-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••-- the duplicator take a list as an argument and returns a new deduplicated listto deduplicator(l)	set deduplicatedLayerNames to {}	repeat with i from 1 to count l		set x to (l's item i)		if x is not in deduplicatedLayerNames then set end of deduplicatedLayerNames to x	end repeat	deduplicatedLayerNamesend deduplicator-- •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••-- Here starts the garbage, the left-overs, whatever you want call it ... or if I cleaned it up, this is the end!