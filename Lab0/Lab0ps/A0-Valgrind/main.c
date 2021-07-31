#include "argparse.h"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv)
{
	initArgs();

	addArg("-M");
	addArg("-N");
	addArg("-K");
	addArg("-L");
	addArg("-J");

	parseArgs(argc, argv);

	char* result = getArg("-J");

	if(result)
		printf("Found J: %s\n", result);

	free(result);
	return 0;
}