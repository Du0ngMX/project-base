// Composite là một mẫu thiết kế thuộc nhóm cấu trúc (Structural Pattern).
// Composite Pattern là một sự tổng hợp những thành phần có quan hệ với nhau để tạo ra thành phần lớn hơn.
// Nó cho phép thực hiện các tương tác với tất cả đối tượng trong mẫu tương tự nhau.

#include <iostream>
#include <vector>
#include <string>
using namespace std;

// Một hệ thống tập tin là một cấu trúc cây có chứa các nhánh là các thư mục (folder – composite),
// cũng như các nút lá là các tệp (file – leaf). Một folder có thể chứa một hoặc nhiều file hoặc folder.
// Do đó, folder là một đối tượng phức tạp và file là một đối tượng đơn giản. 

class FileComponent {
public:
	virtual void showProperty() const = 0;
	virtual long totalSize() const = 0;
};

class FileLeaf : public FileComponent {
private:
	string name;
	long size;
public:
	FileLeaf(string name, long size) : FileComponent{}, name{name}, size{size} {}

	void showProperty() const {
		cout << "FileLeaf { name = " << this->name << ", size = " << this->size << " }" << endl;
	}

	long totalSize() const {
		return size;
	}
};

class FolderComposite : public FileComponent {
private:
	vector<FileComponent*> files;
public:
	FolderComposite(const vector<FileComponent*> &files) : FileComponent{}, files{files} {}

	void showProperty() const {
		for (auto file : files) {
			file->showProperty();
		}
	}

	long totalSize() const {
		long total = 0;
		for (auto file : files) {
			total += file->totalSize();
		}
		return total;
	}
};

int main() {
	FileComponent *file1 = new FileLeaf("file 1", 10);
	FileComponent *file2 = new FileLeaf("file 2", 5);
	FileComponent *file3 = new FileLeaf("file 3", 12);

	vector<FileComponent*> files = { file1 , file2 , file3 };
	FileComponent *folder = new FolderComposite(files);
	folder->showProperty();
	cout << "Total Size: " << folder->totalSize() << endl;

	delete file1;
	delete file2;
	delete file3;
	delete folder;
	return 0;
}
