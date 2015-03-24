
#include "point.cpp"
#include <vector>
#include <list>





//unit declaration

//elementary
typedef double unit_S; //Scores
typedef int unit_T; //Turns (time)
typedef double unit_P; //Paces (distance)
typedef int unit_C; //Count (quantity of objects)
typedef int unit_R; //Repeats (quantity of events)

//derived
typedef double unit_SpT; //Scores per Turn (rate of change of score)
typedef double unit_PpT; //Paces per Turn (velocity)
typedef double unit_PpTpT; //Paces per Turn per Turn (acceleration)
typedef unit_PpTpT unit_PpsT; //Paces per square turn
typedef double unit_sP; //square pace (unit of area/volume)

//external
typedef double unit_Sec; //seconds
typedef double unit_Pxl; //pixel / lixel

//translational
typedef double unit_TpSec; //Turns per second (framerate)
typedef double PxlpP; //Pixels per pace (visual scale)




//CLASSNUM numbers
#define CLASS_CELL	0
#define CLASS_FOOD	1




//id type classes
typedef unsigned id_trigevent;
typedef unsigned id_behavestate;
typedef unsigned id_morphform;
typedef unsigned id_cellaction;
typedef unsigned id_function;





//macro definitions

#define P2O(OBJ,TYPE) (*((TYPE*)OBJ))
#define O2O(OBJ,TYPE) (*((TYPE*)(&OBJ)))
#define O2P(OBJ,TYPE) ((TYPE*)(&OBJ))
#define P2P(OBJ,TYPE) ((TYPE*)OBJ)

