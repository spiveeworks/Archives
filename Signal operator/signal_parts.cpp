
namespace Signal 
	{

typedef bool ConduitState;

class UnexpectedSignalError {};
class InvalidTerminalError {};



class OutputGiver {
protected:
	virtual void SendSignal (unsigned using_terminal) = 0;
	virtual void onResponse (unsigned using_terminal) = 0;
public:
	
	virtual void TriggerResponse (unsigned using_terminal) {onResponse(using_terminal);}
	virtual ConduitState getPartnerState (unsigned using_terminal) = 0;
};

class InputTaker {
protected:
	virtual void onSignal (unsigned using_terminal) = 0;
	virtual void SendResponse (unsigned using_terminal) = 0;
	virtual void SetState (unsigned using_terminal) = 0;
public:
	virtual ConduitState getState(unsigned using_terminal) = 0;
    virtual void TriggerSignal (unsigned using_terminal) 
	{
		if (!getState(using_terminal)) //only accept signals once per response
		{
			SetState(using_terminal); //prevent future signals until response
			onSignal(using_terminal); //trigger interface functionality associated with input
		}
	}
};

struct OutputTerminal {
private:
    InputTaker &partner;
	unsigned partner_terminal;
public:
    void SendSignal() {partner.TriggerSignal(partner_terminal);}
	
};

struct InputTerminal {
private:
    OutputGiver &partner;
	unsigned partner_terminal;
	ConduitState state;
public:
    void SendResponse() 
	{
		if (!state) 
		    throw UnexpectedSignalError(); 
		state = false;
		partner.TriggerResponse(partner_terminal);
	}
	void setState()
	{
	    state = true;
	}
	ConduitState getState()
	{
	    return state;
	}
};

class SimpleOutputGiver: public OutputGiver {
	OutputTerminal terminal;
protected:
//Activation
    void SendSignal () {terminal.SendSignal();}
	void SendSignal (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    terminal.SendSignal();
		else
		    throw InvalidTerminalError ();
	}
	
//Deactivation
	virtual void onResponse () = 0;
	void onResponse (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    onResponse();
		else
		    throw InvalidTerminalError ();
	}
public:
	
};

class SimpleInputTaker: public InputTaker {
	InputTerminal terminal;
	
protected:
//Activation
	virtual void onSignal () = 0;
	void onSignal (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    onSignal();
		else
		    throw InvalidTerminalError ();
	}
	
	void SetState (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    terminal.setState();
		else
		    throw InvalidTerminalError ();
	}
	
//Deactivation
	void SendResponse () {terminal.SendResponse();}
	void SendResponse (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    terminal.SendResponse();
		else
		    throw InvalidTerminalError ();
	}
	
public:
    ConduitState getState () {terminal.getState();}
	ConduitState getState (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    return terminal.getState();
		else
		    throw InvalidTerminalError ();
	}
};


class DualOutputGiver: public OutputGiver {
	OutputTerminal primary, secondary;
protected:
//Activation
    void SendPrimarySignal () {primary.SendSignal();}
    void SendSecondarySignal () {secondary.SendSignal();}
	void SendSignal (unsigned using_terminal = 0)
	{
	    if (using_terminal == 0)
		    primary.SendSignal();
		else if (using_terminal == 1)
		    secondary.SendSignal();
		else
		    throw InvalidTerminalError ();
	}
	
//Deactivation
	virtual void onPrimaryResponse () = 0;
	virtual void onSecondaryResponse () = 0;
	void onResponse (unsigned using_terminal = 0)
	{
	    if (using_terminal == 0)
		    onPrimaryResponse();
	    else if (using_terminal == 1)
		    onSecondaryResponse();
		else
		    throw InvalidTerminalError ();
	}
public:
	
};

class DualInputTaker: public InputTaker {
	InputTerminal primary, secondary;
	
//Activation Initialization
	void SetState (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    primary.setState();
		else if (using_terminal == 1)
		    secondary.setState();
		else
		    throw InvalidTerminalError ();
	}
protected:
//Activation
	virtual void onPrimarySignal () = 0;
	virtual void onSecondarySignal () = 0;
	void onSignal (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    onPrimarySignal();
		else if (using_terminal == 1)
		    onSecondarySignal();
		else
		    throw InvalidTerminalError ();
	}
	
//Deactivation
    void SendPrimaryResponse () {primary.SendResponse();}
    void SendSecondaryResponse () {secondary.SendResponse();}
	void SendResponse (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    primary.SendResponse();
		else if (using_terminal == 1)
		    secondary.SendResponse();
		else
		    throw InvalidTerminalError ();
	}
	
public:
    ConduitState getPrimaryState () {primary.getState();}
    ConduitState getSecondaryState () {secondary.getState();}
	ConduitState getState (unsigned using_terminal)
	{
	    if (using_terminal == 0)
		    return primary.getState();
		else if (using_terminal == 1)
		    return secondary.getState();
		else
		    throw InvalidTerminalError ();
	}
	


};

	}