// Command Pattern cho phép tất cả những Request gửi đến object được lưu trữ trong chính object đó dưới dạng một object Command.
// Khái niệm Command Object giống như một class trung gian được tạo ra để lưu trữ các câu lệnh và trạng thái của object tại một thời điểm nào đó.

#include <iostream>
#include <string>
using namespace std;

// là một request class.
class Account {
private:
	string name;
public:
	Account () {}
	Account(const string &name) : name{name} {}
	void open() {
		cout << "Account [ " << name << " ] Opened" << endl;
	}

	void close() {
		cout << "Account [ " << name << " ] Closed" << endl;
	}
};

// là một interface của Command Pattern, cung cấp phương thức execute().
class Command {
public:
	virtual void execute() = 0;
};

class OpenAccount : public Command {
private:
	Account account;
public:
	OpenAccount(const Account &account) : Command {}, account {account} {}
	void execute(){
		this->account.open();
	}
};

class CloseAccount : public Command {
private:
	Account account;
public:
	CloseAccount(const Account &account) : Command{}, account{ account } {}

	void execute() {
		this->account.close();
	}
};

// là một class, hoạt động như Invoker, gọi execute() của ConcreteCommand để thực thi request.
class BankApp {
private:
	Command *openAccount;
	Command *closeAccount;

public:
	BankApp(Command *openAccount, Command *closeAccount) : openAccount{openAccount}, closeAccount {closeAccount} {}

	void clickOpenAccount() {
		cout << "User click open an account" << endl;
		openAccount->execute();
	}

	void clickCloseAccount() {
		cout << "User click close an account" << endl;
		closeAccount->execute();
	}
};

int main() {

	Account *account = new Account("duongmx");

	Command *open = new OpenAccount(*account);
	Command *close = new CloseAccount(*account);
	BankApp *bankApp = new BankApp(open, close);

	bankApp->clickOpenAccount();
	bankApp->clickCloseAccount();


	delete account;
	delete open;
	delete close;
	delete bankApp;
	return 0;
}
