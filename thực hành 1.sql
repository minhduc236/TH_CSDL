CREATE DATABASE Sales
GO
USE Sales

-- 1. Kiểu dữ liệu tự định nghĩa
EXEC sp_addtype 'Mota', 'NVARCHAR(40)'
EXEC sp_addtype 'IDKH', 'CHAR(10)', 'NOT NULL'
EXEC sp_addtype 'DT', 'CHAR(12)'

-- 2. Tạo table
CREATE TABLE SanPham (
    MaSP CHAR(6) NOT NULL,
    TenSP VARCHAR(20),
    NgayNhap Date,
    DVT CHAR(10),
    SoLuongTon INT,
    DonGiaNhap money,
)

CREATE TABLE HoaDon (
    MaHD CHAR(10) NOT NULL,
    NgayLap Date,
    NgayGiao Date,
    MaKH IDKH,
    DienGiai Mota,
)

CREATE TABLE KhachHang (
    MaKH IDKH,
    TenKH NVARCHAR(30),
    DiaCHi NVARCHAR(40),
    DienThoai DT,
)

CREATE TABLE ChiTietHD (
    MaHD CHAR(10) NOT NULL,
    MaSP CHAR(6) NOT NULL,
    SoLuong INT
)

-- 3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HoaDon
    ALTER COLUMN DienGiai NVARCHAR(100)

-- 4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
    ADD TyLeHoaHong float

-- 5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
    DROP COLUMN NgayNhap

-- 6. Tạo các ràng buộc khóa chính và khóa ngoại cho các bảng trên
ALTER TABLE SanPham
ADD
CONSTRAINT pk_sp primary key(MASP)

ALTER TABLE HoaDon
ADD
CONSTRAINT pk_hd primary key(MaHD)

ALTER TABLE KhachHang
ADD
CONSTRAINT pk_khanghang primary key(MaKH)

ALTER TABLE HoaDon
ADD
CONSTRAINT fk_khachhang_hoadon FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_hoadon_chitiethd FOREIGN KEY(MaHD) REFERENCES HoaDon(MaHD)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_sanpham_chitiethd FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)

-- 7.Thêm vào bảng HoaDon các ràng buộc
ALTER TABLE HoaDon
ADD CHECK (NgayGiao > NgayLap)

ALTER TABLE HoaDon
ADD CHECK (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')

ALTER TABLE HoaDon
ADD CONSTRAINT df_ngaylap DEFAULT GETDATE() FOR NgayLap

--8.Thêm vào bảng Sản phẩm các ràng buộc sau
ALTER TABLE SanPham
ADD CHECK (SoLuongTon > 0 and SoLuongTon < 50)

ALTER TABLE SanPham
ADD CHECK (DonGiaNhap > 0)

ALTER TABLE SanPham
ADD CONSTRAINT df_ngaynhap DEFAULT GETDATE() FOR NgayNhap

ALTER TABLE SanPham
ADD CHECK (DVT='KG' or DVT='Thùng' or DVT='Hộp''Cái')

--9.Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi Table
INSERT INTO SanPham(Masp, Tensp, NgayNhap, DVT, SoluongTon, DonGiaNhap)
VALUES 
	('SP01', 'LENOVO', '2023/4/15', 'VNĐ', '20', '9000000'),
	('SP02', 'DELL', '2023/2/20', 'VNĐ', '1', '500000000'),
	('SP03', 'HP', '2023/6/30', 'VNĐ', '100', '19000000'),
	('SP04', 'APPLE', '2023/12/24', 'VNĐ', '50', '40000000');

INSERT INTO KhachHang(Makh, TenKH, DiaCHi, DienThoai)
VALUES 
	('KH01', 'Nguyễn Thanh Hơn', '622, Cộng Hòa, Tân phú', '099827319'),
	('KH02', 'Vũ Minh Đức', 'Hóc Môn', '0327237767'),
	('KH03', 'Tạ Quang Thắng', '622, Cộng Hòa, Tân phú', '082918923'),

INSERT INTO HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
VALUES 
	('HD01', '2023/5/5','2023/7/30','KH01','xinh đẹp'),
	('HD02', '2023/3/19','2023/3/30','KH02','mắc géc'),
	('HD03', '2023/8/28','2023/9/30','KH03','dễ thương'),
	('HD04', '2023/5/30','2023/6/30','KH04','cũng xinh');

INSERT INTO ChiTietHD(MaHD, MaSP, SoLuong)
VALUES ('HD01','SP01', 20),
		('HD02','SP02', 30),
		('HD03','SP03', 40),
		('HD04','SP04', 50);

--12.Đổi tên CSDL Sales thành BanHang
ALTER DATABASE Sales MODIFY NAME = BanHang

--14.Tạo bản BackUp cho CSDL BanHang
Backup database BanHang disk = 'C:\backup'

