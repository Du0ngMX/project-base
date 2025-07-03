#include <iostream>

using namespace std;

// chất liệu
enum MaterialType {
	FLASTIC = 0,
	WOOD
};

// Sản Phẩm
enum SP {
	CHAIR_SP = 0,
	TABLE_SP
};

class BaseProduct {
public:
	virtual void create(SP sp) = 0;
};

class FurnitureAbstractFactory {
public:
	virtual BaseProduct *createProduct() = 0;
};

class PlasticProduct : public BaseProduct {
public:
	void create(SP sp) {
		if (sp == SP::CHAIR_SP) {
			cout << "Create plastic chair" << endl;
		} else if (sp == SP::TABLE_SP) {
			cout << "Create plastic table" << endl;
		}
	}
};


class WoodProduct : public BaseProduct {
public:
	void create(SP sp) {
		if (sp == SP::CHAIR_SP) {
			cout << "Create wood chair" << endl;
		} else if (sp == SP::TABLE_SP) {
			cout << "Create wood table" << endl;
		}
	}
};

class FlasticFactory : public FurnitureAbstractFactory {
public:
	FlasticFactory() {}

	BaseProduct *createProduct() {
		return new PlasticProduct();
	}

};

class WoodFactory : public FurnitureAbstractFactory {
public:
	WoodFactory() {}
	BaseProduct *createProduct() {
		return new PlasticProduct();
	}
};

class FurnitureFactory {
public:
	FurnitureFactory() {}
	FurnitureAbstractFactory* getFactory(MaterialType type) {
		if (type == MaterialType::FLASTIC) {
			return new FlasticFactory();
		} else if (type == MaterialType::WOOD) {
			return new WoodFactory();
		} else {
			cout << "This furniture is unsupported " << endl;
		}
	}
};

int main() {

	cout << "start ==========================>" << endl;

	FurnitureFactory *fac = new FurnitureFactory();
	FurnitureAbstractFactory *factory = fac->getFactory(MaterialType::FLASTIC);

	auto res = factory->createProduct();
	res->create(SP::CHAIR_SP);
	res->create(SP::TABLE_SP);

	cout << "end ==========================>" << endl;
	return 0;
}
