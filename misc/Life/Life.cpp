
#include "header.h"

#include "object.cpp"
#include "cell.cpp"

std::list<cell> ES;


// * * * * * * * * * * * * ** //
// * collision and physical * //
// ** * * * * * * * * * * * * //


void push (object& A, object& B) {
	SGeo::vector diff = A.centre - B.centre;
	double mag = diff.magnitude();//because it is used multiple times...
	unit_P tomo = (A.radius + B.radius - mag); //tomo means "To Move"
	diff *= (tomo / mag / 2); //this should set the vector's new length to be half of the distance needed to move
	A.centre += diff;
	B.centre -= diff;
}

void collidecells (cell& A, cell& B) {
	A.damage (B.stat.attackDmg);
	B.damage (A.stat.attackDmg);
	return;
}

void collideobjects (object& A, object& B) {
	object *minor, *major;
	if (A.classnum() < B.classnum()) 
	{
		minor = &A;
		major = &B;
	}
	else
	{
		minor = &B;
		major = &A;
	}
	
	switch (major -> classnum())
	{
	case CLASS_CELL:
		collidecells ( P2O(minor,cell) , P2O(major,cell) );
		break;
	case CLASS_FOOD:
		switch (minor -> classnum())
		{
		case CLASS_CELL:
			P2O(minor,cell).eat (P2O(major,food));
			break;
		case CLASS_FOOD:
			push(A, B);
			break;
		}
		break;
	}
};

















// * * * * * * * * * * * * * //
// * central and iterative * //
// * * * * * * * * * * * * * //

void run_turn () {
//collect turn commitments and execute them.
	for (std::list<cell>::iterator curr = ES.begin(); curr != ES.end(); curr++)
	{
		choice data = curr -> soul.committurn();
		switch (data.nature)
		{
		case 1://mitosis!
			ES.push_back( curr -> createchild() );
		break;
		default:
			curr -> centre += data.move;
		}
	}

	for (std::list<cell>::iterator curr = ES.begin(); curr != ES.end(); curr++)
	{
		
		for (std::list<cell>::iterator com = curr; com != ES.end(); com++)
		{
			unit_P distance = (curr -> centre - com -> centre).magnitude() - (curr -> radius + com -> radius);//the distance between their closest edges, being the distances of their centres minus their respective radii
//handle cells' senses
			curr -> smell (*com, curr -> cansmellfrom (distance));
			com -> smell (*curr, com -> cansmellfrom (distance));
//handle collision
			if (distance <= 0) 
				collidecells (*curr, *com);
		}
	}
	
	//then go through again and delete any elements that have become dead
	for (std::list<cell>::iterator curr = ES.begin(); curr != ES.end(); curr++)
	{
		if 
	}
};












int main () {
	
	return 0;
}