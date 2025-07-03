#include <iostream>

using namespace std;

// chất liệu
enum MaterialType {
	FLASTIC = 0,
	WOOD
};

class Chair {
public:
	virtual void create() = 0;
};

class Table {
public:
	virtual void create() = 0;
};

class FurnitureAbstractFactory {
public:
	virtual Chair *createChair() = 0;
	virtual Table *createTable() = 0;
};

class PlasticChair : public Chair {
public:
	void create() {
		cout << "Create plastic chair" << endl;
	}
};

class WoodChair : public Chair {
public:
	void create() {
		cout << "Create wood chair" << endl;
	}
};

class PlasticTable : public Table {
public:
	PlasticTable() {}
	void create() {
		cout << "Create plastic table" << endl;
	}
};

class WoodTable : public Table {
public:
	void create() {
		cout << "Create wood table" << endl;
	}
};

class FlasticFactory : public FurnitureAbstractFactory {
public:
	FlasticFactory() {}
	Chair *createChair() {
		return new PlasticChair();
	}

	Table *createTable() {
		return new PlasticTable();
	}
};

class WoodFactory : public FurnitureAbstractFactory {
public:
	WoodFactory() {}
	Chair *createChair() {
		return new WoodChair();
	}

	Table *createTable() {
		return new PlasticTable();
	}
};

class FurnitureFactory {
public:
	FurnitureFactory() {}
	FurnitureAbstractFactory* getFactory(MaterialType type) {
		if (type == MaterialType::FLASTIC) {
			return new FlasticFactory();
		}
		else if (type == MaterialType::WOOD) {
			return new WoodFactory();
		}
		else {
			cout << "This furniture is unsupported " << endl;
		}
	}
};

int main() {

	cout << "start ==========================>" << endl;

	FurnitureFactory *fac = new FurnitureFactory();
	FurnitureAbstractFactory *factory = fac->getFactory(MaterialType::FLASTIC);

	Chair *chair = factory->createChair();
	chair->create(); // Create plastic chair

	Table *table = factory->createTable();
	table->create(); // Create plastic table

	cout << "end ==========================>" << endl;
	return 0;
}
