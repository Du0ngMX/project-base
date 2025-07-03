#include <iostream>
using namespace std;

bool IsPalindrome(int x) {
	if (x < 0) return false;
	if (x <= 9) return true;
	if (x % 10 == 0) return false;

	int rev = 0;
	while (x > rev) {
		rev = rev * 10 + x % 10;
		x /= 10;
	}
	return x == rev || x == rev / 10;
}


bool IsArmstrong(int num) {
	int originalNum, remainder, result = 0;
	originalNum = num;
	while (originalNum != 0) {
		// remainder contains the last digit
		remainder = originalNum % 10;

		result += remainder * remainder * remainder;

		// removing last digit from the orignal number
		originalNum /= 10;
	}

	return result == num;
}


int main() {
	cout << "Hello World" << endl;

	int x = 123454321;

	auto abc = IsPalindrome(x);

	cout << abc  << endl;

	return 0;
}
