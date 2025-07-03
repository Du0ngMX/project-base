#include <iostream>
using namespace std;

int demSo(int n) {
	int dem = 0;
	while (n != 0) {
		if ((n % 10) % 2 != 0) {
			dem++;
		}
		n /= 10;
	}
	return dem;
}

int demDequy(int n, int dem = 0) {
	if (n == 0) return 0;
	if ((n % 10) % 2 != 0) {
		return 1 + demDequy(n / 10);
	}
	return demDequy(n / 10);
}

int demdequy1(int n, int dem = 0) {
	if (n == 0) return dem;
	if ((n % 10) % 2 != 0) {
		return demdequy1(n / 10, dem + 1);
	}
	return demdequy1(n / 10, dem);
}

int main() {
	cout << "Hello World" << endl;
	int x = 1234567;
	int abc = demdequy1(x);
	return 0;
}
