
namespace spiv 
	{

class contextstack;

std::string gettoken (std::string&, const std::string&);

bool trycommand (std::string& input, const std::string& comp, const std::string& delim);

struct fluidcommand {
	std::string invokes;
	unsigned (*script) (std::string);
	bool attempt (std::string delim, std::string input);
	fluidcommand (std::string invoker, unsigned (*func)(std::string));
};

class command {
	std::string invokes, delim, prevarg;
	unsigned (*script) (std::string);
public:
	std::string getdelim () {return delim;}
	std::string getstring () {return invokes;}
	bool compare (std::string input);
	bool compare (std::string input, std::string odelim);
	unsigned operator() (std::string args) {return (*script)(args);prevarg = args;}
	unsigned operator() () {return (*script)(prevarg);}
//constructors + destructors
	command (std::string invoker, unsigned (*func)(std::string), std::string delimiter);
	command (fluidcommand base, std::string delimiter);
};



class context {
	unsigned size;
	command** available;
	unsigned (*defact)(std::string);
public:
	unsigned operator() (std::string input, std::string delim);
	unsigned operator() (std::string input);
	context (std::string* invokes, unsigned (**scripts)(std::string), std::string delim, unsigned number);
/*	
	context (fluidcommand** things, std::string delim, unsigned number) {
		size = number;
		available = new command* [number];
		for (unsigned i = 0; i < number; i++)
		{
			available [i] = command (*things[i], delim);
		}
	}
*/	
	context () {size = 0; available = 0; defact = 0;}
	void append (command* toadd);
	void append (context toadd);
	void setDefault (unsigned (*defaultC)(std::string)) {defact = defaultC;}
};

class contextstack {//not yet at all tested
	context** stack;
	unsigned length;
public:
	//void (*onunderflow)(unsigned, contextstack*); //removed because instead I'll pass the overpop back to the caller// void funcname (unsigned amount_under_by, context* failer = this)
	void push (context& level);
	signed pop (unsigned n);
	void operator() (std::string input/*, std::string delim*/);
	
};


	}
/*
spiv::context operator+ (spiv::context base, spiv::command* append) {
	base.append (append);
	return base;
}
spiv::context operator+ (spiv::context base, spiv::context append) {
	base.append (append);
	return base;
}

spiv::context operator+= (spiv::context& base, spiv::command* append) {
	base.append (append);
	return base;
}
spiv::context operator+= (spiv::context& base, spiv::context append) {
	base.append (append);
	return base;
}
 */