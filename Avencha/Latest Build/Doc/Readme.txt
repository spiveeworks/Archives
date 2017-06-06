Yay! We have a readme!

~To update
When Avencha is on a usb, which is plugged into Jarvis's computer run
	"sync.bat" and it will sync all unowned versions and any ideas
	/reports in their respective folders

 - I have worked out an idea for an emulator that would allow you to 
       locally store the items required for updates, so you can transfer
       update info to a computer cleanly.

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
	Reports are for bugs, notes and tweaks necesary to Avencha, but
	making the cmd environment cleaner won't be a priority for a while.

Note, you should check the todo list before you submit an idea.
Also keeping half finished documents in the folders are still sent whenever
	you update avencha (don't be afraid to double send if that happens)

~Revising/Rebooting versions
If you screw anything up, just delete or rename the version's folder and
	update Avencha again, it will be replaced and revised, (read on for
	more on revising)

~Demo environments
These aren't yet an existing part of Avencha, but eventually if you delete
	and replace older versions of Avencha, they may contain some
	demo environments contributed by other people via the ideas system
	when you get a revision.

#Playing the game#
So far there are two commands, and anywhere up to a billion verbs,
the commands are:
LOOK - lists objects in the environment, for now it is run automatically 
	on startup, for this version it doesn't work
DEBUG - Lists all of the relevant environment variables used by Avencha,
	Kinda useless unless you made Avencha, but it might have some uses
	for debugging your environments
	Note, this will be made more useful later, but for now it is for
	Jarvis :D

(That's right, neither of the commands are useful at the moment.)
	(really they are just an unwanted trace of the indynamic 
	system that 1.4 used					)

Using verbs:
VERB [the|a|any] [adjective 1 [adjective 2 [etc]]] <object> [[with|using] 
	[adjective 1 [adjective 2 [etc]]] <instrument>]
EG:
unlock the door using the key
unlock a locked door using any fragile key
unlock the door using a stable key
enter the door
eat the key

#Do it Yourself#

Programming your own environment is fairly easy, 
	also there are no default environments, so you have to :D
So make a txt file, and open it, or open an existing environment, if you 
	want a learning example.

~the type map
This is a nested ball of types of object that can exist in your environment.
Each type is defined by:
type <name>
and following it you can start a number of lines with a space to define 
	your new type.
The three forms of data that can exist in an object are the property
	(C++ calls them a unity (codeception!) )
	The value (a normal number variable, yay!
	and the State, a boolean, which is actually just a spy property
	There are also pointers, which are more complicated.


A type can also be defined from inside another type, which just makes it a 
	subtype, giving it all of the existing properties by default
So this is done something like this:

type space
type object
 pointer location space
 property colour red, green, blue, yellow, magenta, cyan
 state visible invisible visible
 type living
  value health
  value drating
  type player
  type zombie
 type weapon
  value sharpness
  value length

~event mapping

The event programming is kind of new, so you might want to look at the old
	adhoc language that I used in 0.2

event <name> <subject> <object> [instrument]
 [line]
 [line]
 [line]
 [etc]

so line can be any of the following:

###

if <object> is <adjective>
 [line]
else
 [line]

notes, else is optional, just very useful
object is format is used for properties and states
the other formats are
object.data mirrors object.data
more specific, and can use all four forms of data
it compares the specified data within the given objects, and so you cannot
specify an exact value.

Finally there is
object.value equals number
which is your direct number comparison

The term 'not' can follow any comparison, which negates it, exactly what it 
sounds like

###

define <object> [as] <adjective>

changes the relevant property or state of object to "adjective"

###

align <object>.<data> [with] <object>.<data>

Yeah that sets the left one to the content of the right one

###

set <object>.<value> [to] #value#
increase <object>.<value> [by] #value#
decrease <object>.<value> [by] #value#

affects the number value in the described way

###

destroy <object>

kills it

###

print <string>

Prints string to the screen, it also replaces strings under as such:

$ob becomes the type name of object
$in becomes the type name of instrument
$sb becomes the type name of the player/initiator of the event

###

create <type> [called] <name>

this instantiates an object of the designated type,
until the end of the layer it was created in you can access your object
just as if it was 'subject', 'object' or 'instrument' using <name>

###

loop <name> [using] <type> [with] <pointer name> [as] <target object>
 [line]

right here, is a very useful function.
take your time to understand this one, it is currently the most complicated
command around, and is what gives pointers most of their value.

after this command you put an indented layer of lines, which will be run
once for each object that fits the specified requirements.

The requirements are:
the object must specifically fit the specified type, or a subtype.
the data slot (the pointer) named "pointer name" of the object must be
	pointing to the target object

For each object it finds, it will run through the [line] set once,
	using "name" as an object name for the current object.

###

Note

you can't use the type name of an object in the event, you have to either
	write subject object or instrument. However pointer and data names
	are used normally, this is so that an event can involve more than 
	one of the same type of object.
Indenting can be stacked, so nested if else statements are fine
Any object can be followed by any number of pointers to refer to the pointed 
	object, eg: if instrument.handle.hilt is metalic
		    if object.location mirrors subject.location
		    if instrument.colour mirrors object.lock.colour


The syntax things are read like this
<query> a custom name for whatever is being asked for
#query# a pure number value
[string] an optional inclusion
[option|option] a choice, one or the other must be used
 [line] an additional nested command, this can in fact be any number of
	commands, of any kind, as long as you maintain the indentation.

If a term isn't enclosed then it must be directly copied.

if you over indent it is read as a comment
if you under indent it is interpreted as a set of closed braces ( a '}')
each layer of indentation must be exactly one space character
	(" ", ASCII value 30 (decimal) 20 (hexadecimal) or 40 (octal) )

~the reality map

this is opened with:
reality <name>
name is just a string, the avencha game is opened with 
You are in a <name>.
so this is useful for flavour text... I guess

Then you open objects.

<type> <debugname>
 [data]

where the data stuff is...
 <pointer name> <debug name of a defined object>
 <value name> #value#
 <adjective>

The last line in the file should be:
controlhook <debug name of an object>
so the object should be of the same type as all of the subject types of the
	events.
I'm not sure what will happen if you don't do that bit right.
 On that note I don't think that the event handler checks to see if
 the right type of object is initiating the event, so that could be a
 problem.
after the controlhook are a whole lot of lines as such:
<verb> <eventname>
this then handles itself magically, so the verbs are what the player uses
	to do everything, and will directly trigger the event when used 
	right

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
	trade similar.