
#include "spivee"
#include <cmath>

namespace SGeo {

const double HALFTAU 		= spiv::shiftright (3373259426.0, 30);
const double QUARTERTAU		= spiv::shiftright (3373259426.0, 31);
const double TAU 			= spiv::shiftright (3373259426.0, 29);

const double DOUBLEPI 	= TAU;
const double PI 		= HALFTAU;
const double HALFPI 	= QUARTERTAU;



struct basic_vector;
struct vector;
struct radial_vector;
typedef const basic_vector& CBVR; //i.e. Constant Basic-Vector Reference

struct basic_vector {
	virtual double direction () const =0;
	virtual double magnitude () const =0;
	virtual double square () const =0;
	
	virtual double gradient () const =0;
	virtual double xComp () const =0; //X component
	virtual double yComp () const =0; //Y component
	
	virtual basic_vector& simplify () =0;
	virtual CBVR simplified () const =0;
	
	virtual bool issimilar (CBVR test) const =0;//will tell if vector is pointing in the same direction as another (or in the opposite direction)
	virtual bool isperpendicular (CBVR test) const =0;//both of these comparatives work with either vector containing zeros as well (unlike gradient tests)
	virtual spiv::comparative location (CBVR comp) const =0;//'greater' if in the counterclockwise direction, 'less' in clockwise, and 'equal' if comp 'issimilar ()' to &this
	
	
/*cast*/
	vector castcoord () const;
	radial_vector castrad () const;
		
//	virtual basic_vector& operator= (CBVR B) =0;
	
/*operators*/
	virtual CBVR operator* (double B) const =0;
	virtual CBVR operator/ (double B) const =0;
	
	virtual basic_vector& operator*= (double B) =0;
	virtual basic_vector& operator/= (double B) =0;
	
	virtual bool operator== (CBVR B) const =0;
	virtual bool operator!= (CBVR B) const =0;
	
/*special*/
	virtual CBVR left () const =0;
	virtual CBVR right () const =0;
	
};


const basic_vector& operator* (double B, const basic_vector& base) {return (base * B);}
const basic_vector& operator/ (double B, const basic_vector& base) {return (base / B);}

struct vector: basic_vector {
	double x, y;
	
	double direction () const {
		return (atan2 (y, x));
	}
	double magnitude () const {
		return (sqrt (x*x + y*y));
	}
	double square () const {
		return (x*x + y*y);
	}
	
	double xComp () const {return x;}
	double yComp () const {return y;}
	double gradient () const {return (y/x);}
	
	basic_vector& simplify () {
		double mag = magnitude ();
		x /= mag;
		y /= mag;
		return *this;
	}
	CBVR simplified () const {
		double mag = magnitude ();
		return ( vector (x / mag, y / mag) );
	}
	
	
	bool issimilar (CBVR test) const {return (test.yComp() * x == test.xComp() * y);}//will tell if vector is pointing in the same direction as another (or in the opposite direction)
	bool isperpendicular (CBVR test) const {return (test.yComp() * y == test.xComp() * x * -1);}//both of these comparatives work with either vector containing zeros as well
	spiv::comparative location (CBVR comp) const {return spiv::relation (y * comp.xComp(), x * comp.yComp());}//'greater' if in the counterclockwise direction, 'less' in clockwise, and 'equal' if comp 'issimilar ()' to &this; also note that most of the term 'comp' refer to 
	
//constructors and assignment
	vector (double X = 0.0, double Y = 0.0) {x = X; y = Y;}
	vector (CBVR base) {x = base.xComp(); y = base.yComp();}
	
	basic_vector& operator= (CBVR base) {x = base.xComp(); y = base.yComp(); return *this;}
	
//operators
	CBVR operator* (double B) const {return vector (x * B, y * B);}
	CBVR operator/ (double B) const {return vector (x / B, y / B);}
	basic_vector& operator*= (double B) {x *= B; y *= B; return *this;}
	basic_vector& operator/= (double B) {x /= B; y /= B; return *this;}
	
	bool operator== (CBVR B) const {return (x == B.xComp() && y == B.yComp());}
	bool operator!= (CBVR B) const {return (x != B.xComp() | y != B.yComp());}
	
	
//special
	CBVR left () const {return vector (-y, x);}
	CBVR right () const {return vector (y, -x);}
};

vector operator+ (vector A, vector B) {return vector (A.x + B.x, A.y + B.y);}//if radial vector is needed, casting is necessary.
vector operator- (vector A, vector B) {return vector (A.x - B.x, B.y - B.y);}

basic_vector& operator+= (basic_vector& A, CBVR B) {return (A = A + B);}
basic_vector& operator-= (basic_vector& A, CBVR B) {return (A = A - B);}

struct radial_vector: basic_vector {
	double argument, modulus;
	
	double direction () const {return (argument);}
	double magnitude () const {return (modulus);}
	double square () const {return (modulus * modulus);}
	
	double xComp () const {return modulus * cos (argument);}
	double yComp () const {return modulus * sin (argument);}
	double gradient () const {return (tan(argument));}
	
	basic_vector& simplify () {
		modulus = 1.0;
		return *this;
	}
	CBVR simplified () const {
		return radial_vector (argument);
	}
	
	bool issimilar (CBVR test) const {return ( fmod(argument - test.direction() + 1.0, PI) == 1.0);}//not recomended... issimilar() is only designed to work on integer-coordinate based vectors.
	bool isperpendicular (CBVR test) const {return ( fmod(argument - test.direction(), PI) == HALFPI);}//ditto.
	spiv::comparative location (CBVR comp) const {
		double num = argument - comp.direction(); 	//find the angle between the vectors
		num += PI;									//add a half revolution for the modulo process
		num = fmod(num, TAU);									//find the angle within plus or minus half of a revolution
		num -= PI;									//subtract the half revolution again to get a usable value
		return spiv::relation (num, 0.0); 			//compare the angle between them with zero to find out which is greater and which is smaller.
	}
	
//constructors and assignment
	radial_vector (double arg = 0.0, double mod = 1.0) {argument = arg; modulus = mod;}
	radial_vector (CBVR base) {argument = base.direction(); modulus = base.magnitude();}
	
	basic_vector& operator= (CBVR base) {argument = base.direction(); modulus = base.magnitude(); return *this;}
	
//operators
	CBVR operator* (double B) const {return radial_vector (argument, modulus * B);}
	CBVR operator/ (double B) const {return radial_vector (argument, modulus / B);}
	basic_vector& operator*= (double B) {modulus *= B; return *this;}
	basic_vector& operator/= (double B) {modulus /= B; return *this;}
	
	bool operator== (CBVR B) const {return (modulus == B.magnitude() && argument == B.direction());}//I could probably make these work a bit better, by using a squared magnitude or something
	bool operator!= (CBVR B) const {return (modulus != B.magnitude() || argument != B.direction());}
	
//special
	CBVR left () const {return radial_vector (argument + HALFPI, modulus);}
	CBVR right () const {return radial_vector (argument - HALFPI, modulus);}
	
};

vector basic_vector::castcoord () const {
	return vector (xComp(), yComp());
}

radial_vector basic_vector::castrad () const {
	return radial_vector (magnitude(), direction());
}


double operator* (const vector& A, CBVR B) {return (A.x * B.xComp() + A.y * B.yComp());}
double operator* (const radial_vector& A, CBVR B) {return (A.modulus * B.magnitude() * sin (A.argument - B.direction()));}
 
 /*
vector outer (basic_vector& within, basic_vector axis) {return vector (within * axis, within * axis.left());}
vector operator/ (vector within, vector axis) {return (outer (within, axis)/(axis*axis));}
//If you rotate both vectors such that "axis" lies along the x axis, then the result of this operation is the new vector "within" divided by the magnitude of axis; /**/

class point {
	vector fromorigin;
	
public:
	
	double x () {return fromorigin.x;}
	double y () {return fromorigin.y;}
	vector coords () {return fromorigin;}
	
	//function members
	
	double gradient (point p) {return ( (p.fromorigin - fromorigin).gradient () );}
	point midpoint (point p) {return ( point ( (p.fromorigin.x - fromorigin.x)/2, (p.fromorigin.y - fromorigin.y)/2 ) );}
	double distance (point p) {return ( (p.fromorigin - fromorigin).magnitude () );}
	
	//structifiers
	
	point (double x = 0.0, double y = 0.0) {
		fromorigin.x = x;
		fromorigin.y = y;
	}
	point (vector location) {
		fromorigin = location;
	}
	
	//operators
	
	point operator+ (vector B) {return point (fromorigin + B);}
	point operator- (vector B) {return point (fromorigin - B);}
	vector operator- (point B) {return (fromorigin - B.fromorigin);}
	
	point operator+= (vector B) {return point (fromorigin += B);}
	point operator-= (vector B) {return point (fromorigin -= B);}
	vector operator-= (point B) {return (fromorigin -= B.fromorigin);}
	
	point displace (double U, double D) {return point (fromorigin += vector (U, D));}
	point counterplace (double U, double D) {return point (fromorigin -= vector (U, D));}
	//same as += and -= respectively, just with both coords as arguments
	
	bool operator== (point B) {return (fromorigin == B.fromorigin);}
	bool operator!= (point B) {return (fromorigin != B.fromorigin);}
	
};


}