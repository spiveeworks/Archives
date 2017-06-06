#error \
This file is not meant to be compiled!!!

#undef XXX
#ifdef XXX



struct trigger {
	id_trigevent cause;
	int param1, param2;
	
};


struct action {
	enum actiontype {
		special,
		behaviour, form, simple
	};
	union {
		id_behavestate newbehaviour;
		id_morphform newform;
		id_cellaction cellaction;
		id_function functype;
	};
	
};




#endif
