struct choice;
class cellsoul;
struct cell;
struct cellsense;

struct choice {
	SGeo::vector move;
	int nature;
	int argument;
};

struct note {
	objectsense target;
	int watchers;
	note (objectsense const& targ) {target = targ; watchers = 0;}
};

class cellsoul {
public:
	struct action {
		note* watch;
		int techniquenum;
		int nature;
		int argument;//DOES NOT YET SERVE ANY PURPOSE
		action(int techniquenum2 = 0, int nature2 = 0, int argument2 = 0) {
			techniquenum = techniquenum2; 
			nature = nature2; 
			argument = argument2; 
			watch = 0;
		}
		action(note* watching, action base) {
			watch = watching; 
			watching -> watchers += 1; 
			nature = base.nature; 
			argument = base.argument; 
			techniquenum = base.techniquenum;
		}
	} techassoc[2];//this member is a list of default actions to take, a very primitive behaviour system... there is one for each type of object that can be visible.
	std::list<note> notes;
	std::list<action> queue;
	note* getnote (unsigned ident);

	choice committurn ();
	void smell (objectsense const& target);
};

struct cell: public object {
public:
	ClassNum(0);
	
	cellsoul soul;
	struct cellstats {
		unit_S maxhealth;
		unit_S attackDmg; //damage to enemy upon collision
		unit_P smelldistance;
		unit_S birthcost;
		unit_SpT metabolism;
		
	}stat;
	unit_S LP;
	unit_S HP;
	void eat (food& target);
	cell createchild ();
	void damage (unit_S dmg);
	bool cansmellfrom (unit_P distance) {
		return (stat.smelldistance >= distance);
	}
	objectsense appearance (object& target);
	void smell (object& target) {soul.smell(appearance(target));}
	
	cell (): object() {}
};

void cell::eat (food& target) {
	LP += target.value;
	target.destroy();
}

cell cell::createchild () {
	LP -= stat.birthcost;
	LP /= 2;
	HP /= 2;
	cell ret;
	ret.stat = stat;
	ret.LP = LP;
	ret.HP = HP;
	return ret;
}

void cell::damage (unit_S dmg) {
	if (dmg >= HP) 
		destroy();
	else
		HP -= dmg;
}

objectsense cell::appearance (object& target, bool visibility) {
	objectsense ret;
	ret.stats.radius = target.radius;
	ret.stats.appearance = target.classnum();
	if (ret.stillvisible = visibility)
		ret.locator = target.centre - centre;
	else
		ret.locator = SGeo::vector (0,0);
	return ret;
}























choice cellsoul::committurn ()  {
	
	choice ret;
	action close = queue.front();
	ret.nature = close.nature;
	ret.argument = close.argument;
	switch (close.nature) {
	case 0:
		ret.move = (close.watch -> target.locator)*(-1); //move hella away
		break;
	case 1:
		ret.move = (close.watch -> target.locator); //move hella towards
		break;
	default:
		ret.move = SGeo::vector (0,0);
	}
	return ret;
}

note* cellsoul::getnote (unsigned ident) {
	for (std::list<note>::iterator trynote = notes.begin(); trynote != notes.end(); trynote++)
		if (trynote -> target.ident == ident)
			return &*trynote;
	return 0;
}

void cellsoul::smell (objectsense const& target) {
	note* dep = getnote (target.ident);
	if (!dep)
	{
		notes.push_back (note(target));
		dep = &notes.back();
	}
	else
		dep -> target = target;//simply replace with new information for now, don't worry about anything else like informing about any changes.
	queue.push_back (action(dep, techassoc[target.stats.appearance]));
}


