#include "signal_parts.cpp"

namespace Signal
    {


class Parallel_Merge: DualInputTaker, SimpleOutputGiver
{
protected:
	void onPrimarySignal ()
	{
	    if (getSecondaryState())
		    SendSignal();
	}
	void onSecondarySignal ()
	{
	    if (getPrimaryState())
		    SendSignal();
	}
	
	void onResponse ()
	{
	    SendPrimaryResponse();
		SendSecondaryResponse();
	}
	
};

//This should end up being one of the hardest gates to use in series; just a warning
class Stream_Merge: DualInputTaker, SimpleOutputGiver
{
    bool occupied;
	unsigned to_close;
	
	void StreamPrimary()
	{
		occupied = true;
		to_close = 0;
		SendSignal();
	}
	void StreamSecondary()
	{
		occupied = true;
		to_close = 1;
		SendSignal();
	}
	
protected:
	void onPrimarySignal ()
	{
	    if (!occupied)
			StreamPrimary();
	}
	void onSecondarySignal ()
	{
	    if (!occupied)
			StreamSecondary();
	}
	
	void onResponse ()
	{
	    SendResponse(to_close);
		if (to_close == 0)
		    if (getSecondaryState())
			    StreamSecondary();
		else if (to_close == 1)
		    if (getPrimaryState())
			    StreamPrimary();
		else
		    occupied = false;
	}
};

class Bias_Merge: DualInputTaker, SimpleOutputGiver
{
    bool ready_to_close = false;
	void try_close () {//every second call to this will close both inputs
	    if (ready_to_close)
		{
		    SendPrimaryResponse();
			SendSecondaryResponse();
			ready_to_close = false;
		}
		else
		    ready_to_close = true;
	}
protected:
	void onPrimarySignal ()
	{
	    SendSignal();
	}
	void onSecondarySignal ()
	{
	    try_close(); //Either this or the next one will succeed,
	}
	void onResponse ()
	{
	    try_close(); //Cycle continues once both attempts have been made
	}
};

//uses same mechanism as "Bias_Merge", but on two outputs instead of an out and an in
class Parallel_Branch: SimpleInputTaker, DualOutputGiver
{
    bool ready_to_close = false;
	void try_close () {//every second call to this will close both inputs
	    if (ready_to_close)
		{
		    SendResponse();
			ready_to_close = false;
		}
		else
		    ready_to_close = true;
	}
protected:
    void onSignal ()
	{
	    SendPrimarySignal();
	    SendSecondarySignal();
	}
	void onPrimaryResponse ()
	{
	    try_close(); 
	}
	void onSecondaryResponse ()
	{
	    try_close(); 
	}
};

class Sequence_Branch: SimpleInputTaker, DualOutputGiver
{
protected:
    void onSignal()
	{
	    SendPrimarySignal();
	}
	void onPrimaryResponse()
	{
	    SendSecondarySignal();
	}
	void onSecondaryResponse()
	{
	    SendResponse ();
	}
};

class Buffer_Branch: SimpleInputTaker, DualOutputGiver
{
    bool first_is_full = false, second_is_full = false;
protected:
    void onSignal()
	{
	    if (!first_is_full)
		{
		    SendPrimarySignal();
			first_is_full = true;
			if (!second_is_full)
			    SendResponse();
		}
		else // We know here that second is not full, as no response is sent when both are full
		{
		    SendSecondarySignal();
			second_is_full = true;
		}
	}
	void onPrimaryResponse ()
	{
	    first_is_full = false;
	    if (getState())
		    SendResponse();
	}
	void onSecondaryResponse ()
	{
	    second_is_full = false;
	    if (getState())
		    SendResponse();
	}
};


class Buffer_Mech: SimpleInputTaker, SimpleOutputGiver
{
    bool actual_state;
protected:
    void onSignal()
	{
	    if (!actual_state)
		{
			SendResponse();
		    SendSignal();
		    actual_state = true;
		}
	}
	void onResponse()
	{
	    actual_state = false;
	    if (getState())
		    onSignal();
	}
};

    }