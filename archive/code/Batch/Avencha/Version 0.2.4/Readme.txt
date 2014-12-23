Yay! We have a readme!

~To update
When Avencha is on a usb, which is plugged into Jarvis's computer run
	"sync.bat" and it will sync all unowned versions and any ideas
	/reports in their respective folders

~Ideas and Reports
There are two empty folders. ideas and reports, as well as the same two in
	the folder called sent, write anything you like in the first two
	folders in a txt file and when you next update it will log them on
	Jarvis's computer and archive them in your "sent" folder.
The idea is that ideas and suggestions for future updates go in the ideas
	folder, as well as any ideas you'd like to share or demonstrate
	involving the uses of Avencha (so that they can be kept in mind in
	future updates, and also in case they are kept as demo's in 
	revisions of updates)
	Reports are for bugs, notes and tweaks necisary to Avencha, but
	making the cmd environment cleaner won't be a priority for a while.

~Revising/Rebooting versions
If you screw anything up, just delete or rename the version's folder and
	update Avencha again, it will be replaced and revised, (read on for
	more on revising)

~Demo environments
These aren't yet an existing part of Avencha, but eventually if you delete
	and replace older versions of Avencha, they may contain some
	demo environments contributed by other people via the ideas system


#Playing the game#
So far there are two commands, and anywhere up to a billion verbs,
the commands are:
LOOK - lists objects in the environment, for now it is run automatically 
	on startup
DEBUG - Lists all of the relevant environment variables used by Avencha,
	Kinda useless unless you made Avencha, but it might have some uses
	for debugging your environments
	Note, this will be made more useful later, but for now it is for
	Jarvis :D

Using verbs:
VERB [the|a|any] [adjective 1 [adjective 2 [etc]]] <object> [with|using] 
	[adjective 1 [adjective 2 [etc]]] <instrument>
At the moment all verbs must involve an instrument, so you can't walk 
	through a door, even if it's open
EG:
unlock the door using the key
unlock a locked door using any fragile key
unlock the door using a stable key

#Do it Yourself#

Programming your own environment is fairly easy, 
first off right click "avencha starta.bat" and select edit, scroll to the
	bottom, and there are a whole lot of lines starting with "call"
You can add your own lines like this, and these lines will be interpreted
	(via cmd.exe magic) and fed into "avencha.bat" to make it go

~stencil
This is the basis for all objects, syntax:
call :stencil <name>;[<propertyname>{[adjective1 [;adjective2 
	etc]]}[<next property>{[]} etc]]

~object
The most friendly of commands, instantiates an object of a given stencil:
call :object <stencil> [Flavour text][;applied adjective[;next 
	adjective etc]]
the stencil must be created on an earlier line first

~output
These are the prases that :event will use later on in "print;"
call :output <phrase name> <phrase>

~event
Have fun.
call :event <verb> <object stencil> <instrument stencil> <script>
This one is pretty self explanatory as long as you 
	a: understand basic imperative coding
	b: read the example in avencha starta.bat

noteable stuff:
if <lhs> [==|!=] <rhs> {script} [else {script}]
print <output name>;
destroy [object|instrument];
set [object|instrument] [=|+=|-=] [adjective];

Remember, semicolon's are imperative!
Also it all needs to be on one line, and it will take some trial and error 
to nut it all out

~other stuff
Check the changelog for detailed notes on things
The changelog also has a percentage which represents the amount of lines 
	you'll have to rewrite to make an environment for previous versions 
	compatible to the current version
Submit Ideas that you think would be useful for your environment,
Submit reports on anything severely painful, or severely awesome that you
	felt the need to comment on.
Ask questions if you are otherwise in doubt.
Check out demos (when they exist) and the todo list and changelog if you
	need inspiration 
(This stuff takes a lot of creativity to make it interesting)


Copyright 2013 Jarvis Carroll, open source and free under all circumstances, 
	trade fair and trade similar.