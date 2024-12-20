-- Tạo database
CREATE DATABASE QUANLYSACH;
GO

USE QUANLYSACH;
GO

-- Tạo bảng LOAISACH
CREATE TABLE LOAISACH (
    MaLoai INT PRIMARY KEY,
    TenLoai NVARCHAR(50) NOT NULL
);

-- Tạo bảng NHAXUATBAN
CREATE TABLE NHAXUATBAN (
    MaNXB INT PRIMARY KEY,
    TenNXB NVARCHAR(100) NOT NULL
);

-- Tạo bảng SACH
CREATE TABLE SACH (
    MaSach INT PRIMARY KEY,
    MaLoai INT NOT NULL FOREIGN KEY REFERENCES LOAISACH(MaLoai),
    MaNXB INT NOT NULL FOREIGN KEY REFERENCES NHAXUATBAN(MaNXB),
    TenSach NVARCHAR(100) NOT NULL,
    TacGia NVARCHAR(50),
    NamXB INT
);

-- Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH INT PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    DienThoai NVARCHAR(15) UNIQUE NOT NULL,
    DiaChi NVARCHAR(200)
);

-- Tạo bảng DATHANG
CREATE TABLE DATHANG (
    Id INT PRIMARY KEY,
    NgayDatHang DATE NOT NULL,
    MaKH INT NOT NULL FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    TongSL INT,
    TongTien MONEY,
    GhiChu NVARCHAR(200)
);

-- Tạo bảng CTDATHANG
CREATE TABLE CTDATHANG (
    DatHangId INT NOT NULL FOREIGN KEY REFERENCES DATHANG(Id),
    MaSach INT NOT NULL FOREIGN KEY REFERENCES SACH(MaSach),
    SoLuong INT NOT NULL,
    DonGia MONEY NOT NULL,
    ThanhTien AS (SoLuong * DonGia) PERSISTED
);

-- Tạo view vw_DanhSachSach
CREATE VIEW vw_DanhSachSach AS
SELECT 
    SACH.MaSach,
    SACH.TenSach,
    SACH.TacGia,
    SACH.NamXB,
    LOAISACH.TenLoai,
    NHAXUATBAN.TenNXB
FROM SACH
INNER JOIN LOAISACH ON SACH.MaLoai = LOAISACH.MaLoai
INNER JOIN NHAXUATBAN ON SACH.MaNXB = NHAXUATBAN.MaNXB;

-- Tạo view vw_DanhSachDatHang
CREATE VIEW vw_DanhSachDatHang AS
SELECT 
    DATHANG.Id AS DatHangId,
    DATHANG.NgayDatHang,
    DATHANG.MaKH,
    KHACHHANG.TenKH,
    CTDATHANG.MaSach,
    SACH.TenSach,
    CTDATHANG.SoLuong,
    CTDATHANG.DonGia,
    CTDATHANG.ThanhTien
FROM DATHANG
INNER JOIN KHACHHANG ON DATHANG.MaKH = KHACHHANG.MaKH
INNER JOIN CTDATHANG ON DATHANG.Id = CTDATHANG.DatHangId
INNER JOIN SACH ON CTDATHANG.MaSach = SACH.MaSach;

-- Tạo stored procedure sp_DanhSachSachTheoLoai
CREATE PROCEDURE sp_DanhSachSachTheoLoai
    @MaLoai INT
AS
BEGIN
    SELECT 
        MaSach,
        TenSach,
        TacGia,
        NamXB
    FROM SACH
    WHERE MaLoai = @MaLoai;
END;

-- Tạo stored procedure sp_DSDatHang
CREATE PROCEDURE sp_DSDatHang
    @DienThoai NVARCHAR(15)
AS
BEGIN
    SELECT 
        DATHANG.Id AS DatHangId,
        DATHANG.NgayDatHang,
        KHACHHANG.TenKH,
        CTDATHANG.MaSach,
        SACH.TenSach,
        CTDATHANG.SoLuong,
        CTDATHANG.DonGia,
        CTDATHANG.ThanhTien
    FROM DATHANG
    INNER JOIN KHACHHANG ON DATHANG.MaKH = KHACHHANG.MaKH
    INNER JOIN CTDATHANG ON DATHANG.Id = CTDATHANG.DatHangId
    INNER JOIN SACH ON CTDATHANG.MaSach = SACH.MaSach
    WHERE KHACHHANG.DienThoai = @DienThoai;
END;
