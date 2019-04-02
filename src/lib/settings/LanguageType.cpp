#include "LanguageType.h"

std::string languageTypeToString(LanguageType t)
{
	switch (t)
	{
	case LANGUAGE_C:
		return "C";
	case LANGUAGE_CPP:
		return "C++";
	case LANGUAGE_JAVA:
		return "Java";
	case LANGUAGE_PYTHON:
		return "Python";
	case LANGUAGE_CUSTOM:
		return "Custom";
	case LANGUAGE_UNKNOWN:
		break;
	}
	return "unknown";
}

LanguageType stringToLanguageType(std::string s)
{
	if (s == languageTypeToString(LANGUAGE_C))
	{
		return LANGUAGE_C;
	}
	else if (s == languageTypeToString(LANGUAGE_CPP))
	{
		return LANGUAGE_CPP;
	}
	else if (s == languageTypeToString(LANGUAGE_JAVA))
	{
		return LANGUAGE_JAVA;
	}
	else if (s == languageTypeToString(LANGUAGE_PYTHON))
	{
		return LANGUAGE_PYTHON;
	}
	else if (s == languageTypeToString(LANGUAGE_CUSTOM))
	{
		return LANGUAGE_CUSTOM;
	}
	return LANGUAGE_UNKNOWN;
}

LanguageType getLanguageTypeForSourceGroupType(SourceGroupType t)
{
	switch (t)
	{
	case SOURCE_GROUP_C_EMPTY:
		return LANGUAGE_C;
	case SOURCE_GROUP_CPP_EMPTY:
		return LANGUAGE_CPP;
	case SOURCE_GROUP_CXX_CDB:
		return LANGUAGE_CPP;
	case SOURCE_GROUP_CXX_CODEBLOCKS:
		return LANGUAGE_CPP;
	case SOURCE_GROUP_CXX_SONARGRAPH:
		return LANGUAGE_CPP;
	case SOURCE_GROUP_CXX_VS:
		return LANGUAGE_CPP;
	case SOURCE_GROUP_JAVA_EMPTY:
		return LANGUAGE_JAVA;
	case SOURCE_GROUP_JAVA_MAVEN:
		return LANGUAGE_JAVA;
	case SOURCE_GROUP_JAVA_GRADLE:
		return LANGUAGE_JAVA;
	case SOURCE_GROUP_JAVA_SONARGRAPH:
		return LANGUAGE_JAVA;
	case SOURCE_GROUP_PYTHON_EMPTY:
		return LANGUAGE_PYTHON;
	case SOURCE_GROUP_CUSTOM_COMMAND:
		return LANGUAGE_CUSTOM;
	default:
		break;
	}

	return LANGUAGE_UNKNOWN;
}

