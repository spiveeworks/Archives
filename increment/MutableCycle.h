
class MutableCycle
{
	std::vector<unsigned> seq;
	unsigned edge = 0;
	unsigned change;
	
public:
	void Push(unsigned thing); // thing <= Read()
	
	inline unsigned PushPop()
	{
		edge %= seq.size();
		return seq[edge++] += change;
	}
	inline unsigned Read()
	    {return seq[edge%seq.size()]}
		
	unsigned ReadUntil(unsigned comp);
	unsigned PushPopUntil(unsigned comp);
};
