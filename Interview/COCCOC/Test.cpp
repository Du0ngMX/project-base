#include <iostream>
#include "CalculateDistance.h"

using namespace task;

int main(int argc, char **argv) {
	if (argc != 3) {
		std::cout << "Usage: ccdist path_to_first_doc path_to_second_doc" << std::endl;
		return 1;
	}

	std::string path_to_first_doc = argv[1];
	std::string path_to_second_doc = argv[2];

	std::ifstream fin_first_doc, fin_second_doc;
	fin_first_doc.open(path_to_first_doc);
	fin_second_doc.open(path_to_second_doc);

	if (!fin_first_doc || !fin_second_doc) {
		std::cout << "Error opening or reading input file" << std::endl;
		return 1;
	}

	document d1 = CountWords(fin_first_doc);
	document d2 = CountWords(fin_second_doc);

	if (0 == d1.size() || 0 == d2.size()) {
		std::cout << "Error document empty" << std::endl;
		return 1;
	}
	auto distance = VectorAngle(d1, d2);
	std::cout << "The distance between the documents is = " << distance << " radians" << std::endl;

	return 0;
}