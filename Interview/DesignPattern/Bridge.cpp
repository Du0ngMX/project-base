// Bridge Pattern là một trong những Pattern thuộc nhóm cấu trúc (Structural Pattern).
// Ý tưởng của nó là tách tính trừu tượng (abstraction) ra khỏi tính hiện thực (implementation) của nó.
// Từ đó có thể dễ dàng chỉnh sửa hoặc thay thế mà không làm ảnh hưởng đến những nơi có sử dụng lớp ban đầu.

#include <iostream>
using namespace std;

class Account {
public:
	virtual void openAccount() const = 0;
};

class CheckingAccount : public Account {
public:
	void openAccount() const override {
		cout << "Checking Account" << endl;
	}
};

class SavingAccount : public Account {
public:
	void openAccount() const override{
		cout << "Saving Account" << endl;
	}
};

class Bank {
protected:
	Account *account;
public:
	Bank(Account *account) : account{account} {}
	virtual void openAccount() const = 0;
};

class VietcomBank : public Bank {
public:
	VietcomBank(Account *account) : Bank {account} {}
	void openAccount() const {
		cout << "Open your account at VietcomBank is a ";
		account->openAccount();
	}
};

class TPBank : public Bank {
public:
	TPBank(Account *account) : Bank{ account } {}
	void openAccount() const {
		cout << "Open your account at TPBank is a ";
		account->openAccount();
	}
};

int main() {

	Bank *vietcomBank = new VietcomBank(new CheckingAccount());
	vietcomBank->openAccount();

	Bank *tpBank = new TPBank(new CheckingAccount());
	tpBank->openAccount();

	delete vietcomBank;
	delete tpBank;
	return 0;
}
