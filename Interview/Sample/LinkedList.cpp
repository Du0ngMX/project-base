#include<iostream>

using namespace std;

typedef struct Node {
	int data;
	Node *pNext;
}NODE;

typedef struct list {
	NODE *pHead;
	NODE *pTail;
}LIST;

void Init(LIST &l) {
	l.pHead = l.pTail = nullptr;
}

NODE *getNode(int data) {
	NODE *node = new NODE;
	node->data = data;
	node->pNext = nullptr;
	return node;
}

void AddNodeHead(LIST *l, NODE *p) {
	if (l->pHead == nullptr) {
		l->pHead = l->pTail = p;
	} else {
		p->pNext = l->pHead;
		l->pHead = p;
	}
}

void AddNodeTail(LIST *l, NODE *p) {
	if (l->pHead == nullptr) {
		l->pHead = l->pTail = p;
	}
	else {
		l->pTail->pNext = p;;
		l->pTail = p;
	}
}

void getList(LIST *l, int n) {

	for (int i = 1; i < n; i++) {
		NODE *node = getNode(i);
		AddNodeTail(l, node);
	}
}

int getMax(LIST l) {
	int maxx = l.pHead->data;
	for (NODE *p = l.pHead->pNext; p != nullptr; p = p->pNext) {
		if (p->data > maxx) {
			maxx = p->data;
		}
	}
	return maxx;
}

void Insert(LIST *l, NODE *q, NODE *p) {
	for (NODE *k = l->pHead; k != nullptr; k = k->pNext) {
		if (k->data == q->data) {
			//Node *temp = k->pNext;
			//k->pNext = p;
			//p->pNext = temp;
			p->pNext = k->pNext;
			k->pNext = p;
			return;
		}
	}
}


void output(LIST l) {
	cout << "end============================>1" << endl;
	for (NODE *k = l.pHead; k != nullptr; k = k->pNext) {
		cout << k->data << "	";
	}
	cout << "\nend============================>2" << endl;
}
 
int main() {

	LIST l;
	Init(l);
	getList(&l, 6);
	output(l);

	cout << "maxxxxxxxxxxxxxxx = " << getMax(l) << endl;
	cout << "insert" << endl;

	Node *q = getNode(4);
	Node *p = getNode(6969);
	Insert(&l, q, p);
	output(l);
	return 0;
}
