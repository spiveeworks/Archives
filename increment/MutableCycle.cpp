
void MutableCycle::Push(unsigned thing) // thing <= Read()
{
	auto X = std::lower_bound(seq.begin(), seq.begin() + edge, thing);
	if (X == seq.begin())
		X = std::upper_bound(seq.begin() + edge, seq.end(), thing);
	else
		++edge;
	seq.insert(X, thing);
}

unsigned MutableCycle::ReadUntil(unsigned comp)
{
	unigned ret = (comp - seq[(edge - 1)%seq.size()]) / change;
	comp += ret * change;
	ret *= seq.size();
	
	auto X = std::upper_bound(seq.begin() + edge, seq.end(), thing);
	if (X == seq.end())
		X = std::lower_bound(seq.begin(), seq.begin() + edge, thing)
		  + seq.size(); // + size is to hack the return expression to be the same as the upper case

	ret += X - (seq.begin() + edge);
	return ret;
}

unsigned MutableCycle::PushPopUntil(unsigned comp)
{
	unsigned ret = 0;
	edge %= seq.size();
	while (seq[edge] < comp)
	{
		seq[edge]+= change;
		++edge;
		edge %= seq.size();
		++ret;
	}
	return ret;
}

