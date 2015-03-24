
 unsigned prevobjident = 0;

struct object {
private:
	unsigned ident;
	bool existstate;
public:
	unsigned getident() {if (ident == 0) ident = ++prevobjident; return ident;}
	bool exists () {return existstate;}
	void destroy () {existstate = false;}
	SGeo::point centre;
	double radius;
	virtual int classnum() =0;
	object () {ident = 0; existstate = true;}
};
#define ClassNum(ARG) virtual int classnum() {return (ARG);}


struct objectsense {
	SGeo::vector locator;
	bool stillvisible;
	unsigned ident;
	struct nonchanging {
		unit_P radius;
		int appearance;
	}stats;
};

struct food: public object {
	unit_S value;
	ClassNum(1);
};
