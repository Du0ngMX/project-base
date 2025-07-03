void ThemPhanTu(int a[], int &n, int val, int pos){
    // Mang da day, khong the them.
    if(n >= MAX){
        return;
    }
    // Neu pos <= 0 => Them vao dau
    if(pos < 0){
        pos = 0;
    }
    // Neu pos >= n => Them vao cuoi
    else if(pos > n){
        pos = n;
    }
    // Dich chuyen mang de tao o trong truoc khi them.
    for(int i = n; i > pos; i--){
        a[i] = a[i-1];
    }
    // Chen val tai pos
    a[pos] = val;
    // Tang so luong phan tu sau khi chen.
    ++n;
}
 
void XoaPhanTu(int a[], int &n, int pos){
    // Mang rong, khong the xoa.
    if(n <= 0){
        return;
    }
    // Neu pos <= 0 => Xoa dau
    if(pos < 0){
        pos = 0;
    }
    // Neu pos >= n => Xoa cuoi
    else if(pos >= n){
        pos = n-1;
    }
    // Dich chuyen mang
    for(int i = pos; i < n - 1; i++){
        a[i] = a[i+1];
    }
    // Giam so luong phan tu sau khi xoa.
    --n;
}
