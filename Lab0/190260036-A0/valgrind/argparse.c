#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "argparse.h"

#define ARGCAP 3

struct argParser argParser;

void initArgs()
{
	argParser.capacity = ARGCAP;
	argParser.argList = malloc(sizeof(struct arg) * argParser.capacity);
	argParser.len = 0;
}

void addArg(char *name)
{
	if (argParser.len < argParser.capacity)
	{
		argParser.argList[argParser.len].name = strdup(name);
		argParser.argList[argParser.len++].result = NULL;
		return;
	}

	argParser.capacity += ARGCAP;
	struct arg *tempArgs = malloc(sizeof(struct arg) * argParser.capacity);



	for (int i = 0; i < argParser.len; i++)
	{
		tempArgs[i] = argParser.argList[i];
	}
	free(argParser.argList);
	argParser.argList = tempArgs;
	argParser.argList[argParser.len].name = strdup(name);
	argParser.argList[argParser.len++].result = NULL;
}

void parseArgs(int argc, char **argv)
{
	// fprintf(stdout, "%d", argc);
	// fprintf(stdout, "%s", *argv);
	// fflush(stdout);
	for (int i = 0; i < argc; i++)
	{
		for (int j = 0; j < argParser.len; j++)
		{
			if (strcmp(argv[i], argParser.argList[j].name) == 0)
			{
				if (i + 1 < argc)
				{
					argParser.argList[j].result = strdup(argv[i + 1]);
				}
				else
				{
					fprintf(stderr, "Argument %s not found\n", argv[i]);
				}
			}
		}
	}
}

char *getArg(char *name)
{
	char *retr;
	retr = NULL;

	for (int i = 0; i < argParser.len; i++)
	{
		if (strcmp(name, argParser.argList[i].name) == 0)
		{
			if (argParser.argList[i].result)
				retr = strdup(argParser.argList[i].result);
		}
	}

	for (int i = 0; i < argParser.len; i++)
	{
		if (argParser.argList[i].name)
			free(argParser.argList[i].name);
		if (argParser.argList[i].result)
			free(argParser.argList[i].result);
	}
	free(argParser.argList);

	return retr;
}
