/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES latin1 */;

SET FOREIGN_KEY_CHECKS=0;

USE `lj`;

CREATE TABLE `merk` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `merk` (`merk`)
)ENGINE=InnoDB
AUTO_INCREMENT=2148 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `promo` (
  `IDpromo` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(200) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tglefektif` DATE NOT NULL,
  `tglnonefektif` DATE NOT NULL,
  PRIMARY KEY (`IDpromo`),
  UNIQUE KEY `kode` (`kode`),
  UNIQUE KEY `nama` (`nama`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `product` (
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglnoneffective` DATE DEFAULT NULL,
  `diskon` FLOAT(9,3) NOT NULL DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `barcode` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `UT` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `RS` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `reorderqty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `barcode128` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`kode`),
  UNIQUE KEY `IDproduct` (`IDproduct`),
  UNIQUE KEY `kode` (`kode`, `nama`, `merk`, `seri`, `satuan`, `hargabeli`, `hargajual`, `keterangan`, `barcode`),
  KEY `kodepromo` (`kodepromo`),
  KEY `merk` (`merk`),
  CONSTRAINT `product_fk` FOREIGN KEY (`kodepromo`) REFERENCES `promo` (`kode`),
  CONSTRAINT `product_fk1` FOREIGN KEY (`merk`) REFERENCES `merk` (`merk`)
)ENGINE=InnoDB
AUTO_INCREMENT=56409 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB; (`kodepromo`) REFER `sparepart/promo`(`kode`) ON UPDATE ';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `product_before_ins_tr` BEFORE INSERT ON `product`
  FOR EACH ROW
BEGIN
 set new.barcode128 = `TextTo128C`(new.barcode);
END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `product_after_ins_tr` AFTER INSERT ON `product`
  FOR EACH ROW
BEGIN
 insert ignore into productgudang (IDproduct,IDgudang) select new.IDproduct,IDgudang from gudang order by IDgudang;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `product_before_upd_tr` BEFORE UPDATE ON `product`
  FOR EACH ROW
BEGIN
 if (old.barcode<>new.barcode) then set new.barcode128 = `TextTo128C`(new.barcode);
 end if;
END;

CREATE TABLE `adjustdetail` (
  `idAdjust` INTEGER(11) NOT NULL DEFAULT '0',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `qtybefore` DOUBLE(15,3) DEFAULT '0.000',
  `qtyafter` DOUBLE(15,3) DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  KEY `kode` (`kode`),
  CONSTRAINT `adjustdetail_fk` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `adjustmaster` (
  `idAdjust` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `operator` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `totaladjust` DOUBLE(15,3) DEFAULT '0.000',
  `isposted` INTEGER(11) DEFAULT '0' COMMENT '-1 = batal posting\r\n0 = belum posting\r\n1 = sudah posting',
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci NOT NULL DEFAULT 'TK',
  PRIMARY KEY (`idAdjust`),
  UNIQUE KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=4 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `buydetail` (
  `idBeli` INTEGER(11) NOT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `harganondiskon` DOUBLE(15,3) DEFAULT '0.000',
  `isposted` TINYINT(1) NOT NULL DEFAULT '1',
  `subtotal` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `barcode` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `hpp` DOUBLE(15,3) DEFAULT '0.000',
  `stock` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  KEY `faktur` (`faktur`),
  KEY `kode` (`kode`),
  CONSTRAINT `buydetail_fk` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `buymaster` (
  `idBeli` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `noinvoice` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodesupplier` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `supplier` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `pembayaran` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nogiro` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tgljatuhtempo` DATE DEFAULT NULL,
  `tempohari` TINYINT(4) DEFAULT '0',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `ppn` DOUBLE(15,3) DEFAULT '0.000',
  `total` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `grandtotal` DOUBLE(15,3) DEFAULT '0.000',
  `DP` DOUBLE(15,3) DEFAULT '0.000',
  `kurang` DOUBLE(15,3) DEFAULT '0.000',
  `isposted` TINYINT(1) DEFAULT '0',
  `lunas` TINYINT(1) DEFAULT '0',
  `totalpayment` DOUBLE(15,3) DEFAULT '0.000',
  `bayarskrg` DOUBLE(15,3) DEFAULT '0.000',
  `checked` TINYINT(1) DEFAULT '0',
  `IDuserposted` INTEGER(11) NOT NULL,
  PRIMARY KEY (`idBeli`),
  KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=7 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 11264 kB; InnoDB free: 731136 kB';

CREATE TABLE `buypayment` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kodesupplier` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `supplier` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tanggal` DATE NOT NULL,
  `waktu` TIME NOT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `transfer` DOUBLE(15,3) DEFAULT '0.000',
  `tunai` DOUBLE(15,3) DEFAULT '0.000',
  `bg` DOUBLE(15,3) DEFAULT '0.000',
  `totalhutangfaktur` DOUBLE(15,3) DEFAULT '0.000',
  `totalretur` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `tanggalinput` DATE NOT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `isposted` TINYINT(1) DEFAULT '0',
  `saldo_hutang` DOUBLE(15,3) DEFAULT '0.000',
  PRIMARY KEY (`faktur`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `buypaymentbg` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tgl` DATE DEFAULT NULL,
  `transfer` DOUBLE(15,3) DEFAULT '0.000',
  `bg` DOUBLE(15,3) DEFAULT '0.000',
  `bgno` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgbank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgtempo` DATE DEFAULT NULL,
  `tobank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `sales` (
  `idsales` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `alamat` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tgllahir` DATE DEFAULT NULL,
  `tempatlahir` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglmasuk` DATE DEFAULT NULL,
  `noktp` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglnoneffective` DATE DEFAULT NULL,
  PRIMARY KEY (`idsales`),
  UNIQUE KEY `kode` (`kode`),
  UNIQUE KEY `nama` (`nama`)
)ENGINE=InnoDB
AUTO_INCREMENT=61 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `customer` (
  `IDcustomer` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat2` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota2` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepos` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT NULL,
  `telephone` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `telephone2` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fax` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `email` VARCHAR(150) COLLATE latin1_swedish_ci DEFAULT NULL,
  `website` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL,
  `cp` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hp` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hp2` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hobby` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglreg` DATE DEFAULT NULL,
  `tgllahir` DATE DEFAULT NULL,
  `tglnoneffective` DATE DEFAULT NULL,
  `npwp` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodesales` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`kode`),
  UNIQUE KEY `IDcustomer` (`IDcustomer`),
  KEY `kodesales` (`kodesales`),
  CONSTRAINT `customer_fk` FOREIGN KEY (`kodesales`) REFERENCES `sales` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
AUTO_INCREMENT=11219 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `customerdiskon` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `IDcustomer` INTEGER(11) NOT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `disc` FLOAT(9,3) DEFAULT '0.000',
  PRIMARY KEY (`id`),
  KEY `IDcustomer` (`IDcustomer`),
  KEY `merk` (`merk`),
  CONSTRAINT `customerdiskon_fk` FOREIGN KEY (`IDcustomer`) REFERENCES `customer` (`IDcustomer`),
  CONSTRAINT `customerdiskon_fk1` FOREIGN KEY (`merk`) REFERENCES `merk` (`merk`)
)ENGINE=InnoDB
AUTO_INCREMENT=19178 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `customerpromo` (
  `kodecustomer` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  KEY `kodecustomer` (`kodecustomer`),
  KEY `kodepromo` (`kodepromo`),
  CONSTRAINT `customerpromo_fk` FOREIGN KEY (`kodecustomer`) REFERENCES `customer` (`kode`),
  CONSTRAINT `customerpromo_fk1` FOREIGN KEY (`kodepromo`) REFERENCES `promo` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `formadjust` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `quantityadjust` DOUBLE(15,3) DEFAULT '0.000',
  `keterangan` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harga` DOUBLE(15,3) DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `formbg` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tgl` DATE DEFAULT NULL,
  `transfer` DOUBLE(15,3) DEFAULT '0.000',
  `bg` DOUBLE(15,3) DEFAULT '0.000',
  `bgno` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgbank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgtempo` DATE DEFAULT NULL,
  `tobank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nourut` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `formbuy` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harga` DOUBLE(15,3) DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harganondiskon` DOUBLE(15,3) DEFAULT '0.000',
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `barcode` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `barcode128` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hpp` DOUBLE(15,3) DEFAULT '0.000',
  `stock` DOUBLE(15,3) DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `formkeuangan` (
  `idoperasional` BIGINT(20) DEFAULT NULL,
  `idTrans` INTEGER(11) DEFAULT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `debet` DOUBLE(15,3) DEFAULT '0.000',
  `kredit` DOUBLE(15,3) DEFAULT '0.000',
  `fakturpay` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `saldoawaltagihan` DOUBLE(15,3) DEFAULT '0.000',
  `signcolor` TINYINT(1) NOT NULL DEFAULT '0',
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `formkeuangan_before_ins_tr` BEFORE INSERT ON `formkeuangan`
  FOR EACH ROW
BEGIN
 declare vtgl date;
 declare vsign TINYINT(1);
 set vtgl=null;
 set vsign=0;
 select tanggal,signcolor into vtgl,vsign from `formkeuangan` order by tanggal desc limit 1;
 if (vtgl is not null) then
 begin
  if vtgl=new.tanggal then set new.signcolor=vsign; else set new.signcolor= not vsign; end if;
 end;
 end if;
END;

CREATE TABLE `formretur` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `quantityretur` DOUBLE(15,3) DEFAULT '0.000',
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harga` DOUBLE(15,3) DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fakturjual` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `formsell` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harga` DOUBLE(15,3) DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `totalharga` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `idstts` TINYINT(4) DEFAULT '0' COMMENT '0 = Value\r\n1 = Free\r\n2 = Tukar',
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `stock` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `vsubtotal` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT '0',
  `nomordet` TINYINT(4) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=1732 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `formsellorder` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `harga` DOUBLE(15,3) DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `totalharga` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `idstts` TINYINT(4) DEFAULT '0' COMMENT '0 = Value\r\n1 = Free\r\n2 = Tukar',
  `nourut` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `stock` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `vsubtotal` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT '0',
  `nomordet` TINYINT(4) UNSIGNED DEFAULT '1',
  PRIMARY KEY (`nourut`)
)ENGINE=InnoDB
AUTO_INCREMENT=181 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `gudang` (
  `IDgudang` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `namagudang` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat1` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat2` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `telp` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fax` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `wilayah` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `type` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `isbadstock` TINYINT(1) NOT NULL DEFAULT '0',
  `lokasi` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`IDgudang`),
  UNIQUE KEY `kodegudang` (`kodegudang`)
)ENGINE=InnoDB
AUTO_INCREMENT=3 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `gudang_after_ins_tr` AFTER INSERT ON `gudang`
  FOR EACH ROW
BEGIN
 insert into productgudang (IDproduct,IDgudang) select IDproduct,new.IDgudang from product order by IDproduct;
END;

CREATE TABLE `historybuysell` (
  `tanggal` DATE DEFAULT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `quantity` INTEGER(11) DEFAULT '0',
  `hargajual` DOUBLE(50,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `netto` DOUBLE(50,3) DEFAULT '0.000',
  `hargabeli` DOUBLE(50,3) DEFAULT '0.000',
  `kodesales` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `namasales` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodebrg` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodecust` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDhist` INTEGER(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDhist`)
)ENGINE=InnoDB
AUTO_INCREMENT=2087 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `inventory` (
  `IDinventory` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tgltrans` DATE NOT NULL,
  `kodebrg` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci NOT NULL DEFAULT 'TK',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `typetrans` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `idtrans` INTEGER(11) NOT NULL DEFAULT '0',
  `IDuser` INTEGER(11) DEFAULT NULL,
  `username` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `waktu` TIME NOT NULL,
  `keterangan` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT '',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  UNIQUE KEY `IDinventory` (`IDinventory`),
  KEY `kodebrg` (`kodebrg`),
  CONSTRAINT `inventory_fk` FOREIGN KEY (`kodebrg`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
AUTO_INCREMENT=10229 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `inventory_before_ins_tr` BEFORE INSERT ON `inventory`
  FOR EACH ROW
BEGIN
 if upper(new.kodegudang)='UT' THEN
  update product set UT = UT + new.qty where kode = new.kodebrg; 
 elseif upper(new.kodegudang)='RS' THEN
  update product set RS = RS + new.qty where kode = new.kodebrg; 
 end if; 
 
 update productgudang p,gudang g,product r set p.`qty`=p.`qty`+new.qty 
 where r.kode=new.kodebrg and g.kodegudang=new.kodegudang and p.IDproduct=r.IDproduct and p.`IDgudang`=g.IDgudang;
 
END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `inventory_before_upd_tr` BEFORE UPDATE ON `inventory`
  FOR EACH ROW
BEGIN
 if upper(new.kodegudang)='UT' THEN
  update product set UT = UT + new.qty - old.qty where kode = new.kodebrg; 
 elseif upper(new.kodegudang)='RS' THEN
  update product set RS = RS + new.qty - old.qty where kode = new.kodebrg; 
 end if; 


 update productgudang p,gudang g,product r set p.`qty`=p.`qty`+new.qty-old.qty 
 where r.kode=new.kodebrg and g.kodegudang=new.kodegudang and p.IDproduct=r.IDproduct and p.`IDgudang`=g.IDgudang;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `inventory_before_del_tr` BEFORE DELETE ON `inventory`
  FOR EACH ROW
BEGIN
 if upper(old.kodegudang)='UT' THEN
  update product set UT = UT - old.qty where kode = old.kodebrg; 
 elseif upper(old.kodegudang)='RS' THEN
  update product set RS = RS - old.qty where kode = old.kodebrg; 
 end if; 

 update productgudang p,gudang g,product r set p.`qty`=p.`qty`-old.qty 
 where r.kode=old.kodebrg and g.kodegudang=old.kodegudang and p.IDproduct=r.IDproduct and p.`IDgudang`=g.IDgudang;

END;

CREATE TABLE `inventoryimp` (
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDproduct` INTEGER(11) DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `qty` DOUBLE(15,3) DEFAULT '0.000',
  `hargabelip` DOUBLE(15,3) DEFAULT '0.000',
  `hargajualp` DOUBLE(15,3) DEFAULT '0.000',
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDgolongan` INTEGER(11) DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglnoneffective` DATE DEFAULT NULL,
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `barcode` VARCHAR(80) COLLATE latin1_swedish_ci DEFAULT NULL,
  `reorderqty` DOUBLE(15,3) DEFAULT '0.000',
  `expdate` DATE DEFAULT NULL
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `inventoryimp_before_ins_tr` BEFORE INSERT ON `inventoryimp`
  FOR EACH ROW
BEGIN
 insert ignore into product (kode,nama,merk,seri,satuan,IDgolongan,hargabeli,hargajual,keterangan,tglnoneffective,diskon,diskonrp,barcode,reorderqty,expdate) 
 values (new.kode,new.nama,new.merk,new.seri,new.satuan,new.IDgolongan,new.hargabeli,new.hargajual,new.keterangan,new.tglnoneffective,new.diskon,new.diskonrp,new.barcode,new.reorderqty,new.expdate);
END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `inventoryimp_after_ins_tr` AFTER INSERT ON `inventoryimp`
  FOR EACH ROW
BEGIN
 insert into terimagudangdetform (ipv,IDproduct,kode,nama,satuan,qty,hargabeli,hargajual) 
 values (new.ipv,(select IDproduct from product where kode=new.kode),new.kode,new.nama,new.satuan,new.qty,new.hargabelip,new.hargajualp);
END;

CREATE TABLE `inventorytemp` (
  `IDinventory` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tgltrans` DATE NOT NULL,
  `kodebrg` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci NOT NULL DEFAULT 'TK',
  `qty` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `typetrans` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `idtrans` INTEGER(11) NOT NULL DEFAULT '0',
  `IDuser` INTEGER(11) DEFAULT NULL,
  `username` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `waktu` TIME NOT NULL,
  `keterangan` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`IDinventory`, `tgltrans`, `kodebrg`, `kodegudang`, `typetrans`, `faktur`, `idtrans`, `username`, `waktu`),
  UNIQUE KEY `IDinventory` (`IDinventory`)
)ENGINE=InnoDB
AUTO_INCREMENT=10617 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `jasa` (
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `komisi` DOUBLE(15,3) DEFAULT '0.000',
  `tglnoneffective` DATE DEFAULT '2100-01-01',
  PRIMARY KEY (`kode`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `loginfo` (
  `no` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `username` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `computername` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`no`)
)ENGINE=InnoDB
AUTO_INCREMENT=521 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `menu` (
  `IDmenu` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(200) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`IDmenu`)
)ENGINE=InnoDB
AUTO_INCREMENT=36 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `operasional` (
  `idoperasional` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `idTrans` INTEGER(11) DEFAULT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `debet` DOUBLE(15,3) DEFAULT '0.000',
  `kredit` DOUBLE(15,3) DEFAULT '0.000',
  `fakturpay` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `saldoawaltagihan` DOUBLE(15,3) DEFAULT '0.000',
  PRIMARY KEY (`idoperasional`)
)ENGINE=InnoDB
AUTO_INCREMENT=3 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `pindahgudang` (
  `IDpindahgudang` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `docno` VARCHAR(30) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `doctgl` DATE NOT NULL,
  `IDgudang` INTEGER(11) NOT NULL,
  `IDgudangto` INTEGER(11) NOT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `usernameposted` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT '',
  `posted` DATETIME DEFAULT NULL,
  PRIMARY KEY (`IDpindahgudang`),
  UNIQUE KEY `docno` (`docno`)
)ENGINE=InnoDB
AUTO_INCREMENT=1070 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `pindahgudang_before_upd_tr` BEFORE UPDATE ON `pindahgudang`
  FOR EACH ROW
BEGIN
 declare vkodegudang VARCHAR(10);
 declare vkodegudangto VARCHAR(10);

 select kodegudang into vkodegudang from gudang where IDgudang=new.IDgudang;
 select kodegudang into vkodegudangto from gudang where IDgudang=new.IDgudangto;

 if (old.posted is null) and (new.posted is not null) THEN
 begin
  insert into inventory (tgltrans,kodebrg,kodegudang,qty,satuan,hargabeli,hargajual,typetrans,faktur,IDtrans,IDuser,username,waktu,keterangan) 
  select new.doctgl,b.kode,vkodegudang,-1*b.qty,b.satuan,b.hargabeli,b.hargajual,'pindah gudang',new.docno,new.IDpindahgudang,new.IDuserposted,new.usernameposted,time(now()),new.notes from pindahgudangdet b where b.IDpindahgudang=new.IDpindahgudang;

  insert into inventory (tgltrans,kodebrg,kodegudang,qty,satuan,hargabeli,hargajual,typetrans,faktur,IDtrans,IDuser,username,waktu,keterangan) 
  select new.doctgl,b.kode,vkodegudangto,b.qty,b.satuan,b.hargabeli,b.hargajual,'pindah gudang',new.docno,new.IDpindahgudang,new.IDuserposted,new.usernameposted,time(now()),new.notes from pindahgudangdet b where b.IDpindahgudang=new.IDpindahgudang;
 
 end;
 elseif (old.posted is not null) and (new.posted is null) THEN
 begin
  delete from inventory where IDtrans=old.IDpindahgudang and typetrans='pindah gudang';
 end;
 end if;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `pindahgudang_before_del_tr` BEFORE DELETE ON `pindahgudang`
  FOR EACH ROW
BEGIN
 delete from inventory where IDtrans=old.IDpindahgudang and typetrans='pindah gudang';
END;

CREATE TABLE `pindahgudangdet` (
  `IDpindahgudang` INTEGER(11) NOT NULL,
  `IDproduct` INTEGER(11) NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  KEY `IDpindahgudang` (`IDpindahgudang`),
  KEY `kode` (`kode`),
  CONSTRAINT `pindahgudangdet_fk` FOREIGN KEY (`IDpindahgudang`) REFERENCES `pindahgudang` (`IDpindahgudang`) ON DELETE CASCADE,
  CONSTRAINT `pindahgudangdet_fk1` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `pindahgudangdetform` (
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000'
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `productgudang` (
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `IDgudang` INTEGER(11) NOT NULL,
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`IDproduct`, `IDgudang`),
  KEY `IDgudang` (`IDgudang`),
  KEY `IDproduct` (`IDproduct`),
  CONSTRAINT `productgudang_fk` FOREIGN KEY (`IDproduct`) REFERENCES `product` (`IDproduct`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `productgudang_fk1` FOREIGN KEY (`IDgudang`) REFERENCES `gudang` (`IDgudang`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `purchaseorder` (
  `IDpurchaseorder` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `IDsupplier` INTEGER(11) NOT NULL,
  `pono` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tgl` DATE NOT NULL,
  `totalprice` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `usernameposted` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `posted` DATETIME DEFAULT NULL,
  PRIMARY KEY (`IDpurchaseorder`),
  UNIQUE KEY `pono` (`pono`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `reportrugilaba` (
  `idrugilaba` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `tanggal` DATE DEFAULT NULL,
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `labakotor` DOUBLE(15,3) DEFAULT '0.000',
  `operasional` DOUBLE(15,3) DEFAULT '0.000',
  `pajak` DOUBLE(15,3) DEFAULT '0.000',
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`idrugilaba`)
)ENGINE=InnoDB
AUTO_INCREMENT=11 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `returbelidetail` (
  `idReturBeli` INTEGER(11) NOT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `qtybeli` DOUBLE(15,3) DEFAULT '0.000',
  `qtyretur` DOUBLE(15,3) DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT NULL,
  `diskon2` FLOAT(9,3) NOT NULL DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT NULL,
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `fakturbeli` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  KEY `kode` (`kode`),
  CONSTRAINT `returbelidetail_fk` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `returbelimaster` (
  `idReturBeli` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `operator` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fakturbeli` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `noinvoice` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodesupplier` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `supplier` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `totaltrans` DOUBLE(15,3) DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `ppn` DOUBLE(15,3) DEFAULT '0.000',
  `totalretur` DOUBLE(15,3) DEFAULT '0.000',
  `lunas` TINYINT(1) DEFAULT '0',
  `isposted` TINYINT(1) DEFAULT '0' COMMENT '-1 = batal posting\r\n0 = belum posting\r\n1 = sudah posting',
  `pembayaran` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `checked` TINYINT(1) DEFAULT '0',
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT 'UT',
  PRIMARY KEY (`idReturBeli`),
  UNIQUE KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=3 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `returjualdetail` (
  `idReturJual` INTEGER(11) NOT NULL,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `keterangan` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `qtyjual` DOUBLE(15,3) DEFAULT '0.000',
  `qtyretur` DOUBLE(15,3) DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fakturjual` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `fakturjualold` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fakturjualnew` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  KEY `kode` (`kode`),
  CONSTRAINT `returjualdetail_fk` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `returjualmaster` (
  `idReturJual` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `operator` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodecustomer` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `customer` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `totaltrans` DOUBLE(15,3) DEFAULT '0.000',
  `subtotal` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `ppn` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `totalretur` DOUBLE(15,3) DEFAULT '0.000',
  `lunas` TINYINT(1) DEFAULT '0',
  `isposted` TINYINT(1) DEFAULT '0' COMMENT '-1 = batal posting\r\n0 = belum posting\r\n1 = sudah posting',
  `pembayaran` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `checked` TINYINT(1) DEFAULT '0',
  `kodegudang` VARCHAR(10) COLLATE latin1_swedish_ci NOT NULL DEFAULT 'UT',
  `returpajakno` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`idReturJual`),
  UNIQUE KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=3 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `rusakdetail` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `idrusak` INTEGER(11) NOT NULL,
  KEY `faktur` (`faktur`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `rusakmaster` (
  `idrusak` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `isposted` TINYINT(1) DEFAULT '0' COMMENT '-1 = batal posting\r\n0 = belum posting\r\n1 = sudah posting',
  PRIMARY KEY (`idrusak`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `sellmaster` (
  `idsell` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDcustomer` INTEGER(11) DEFAULT NULL,
  `kodecustomer` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `customer` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `pembayaran` CHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nogiro` CHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tgljatuhtempo` DATE DEFAULT NULL,
  `subtotal` DOUBLE(50,3) DEFAULT '0.000',
  `ppn` DOUBLE(50,3) DEFAULT '0.000',
  `total` DOUBLE(50,3) DEFAULT '0.000',
  `diskon` DOUBLE(50,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(50,3) DEFAULT '0.000',
  `grandtotal` DOUBLE(50,3) DEFAULT '0.000',
  `bayar` DOUBLE(50,3) DEFAULT '0.000',
  `kembali` DOUBLE(50,3) DEFAULT '0.000',
  `isposted` TINYINT(1) DEFAULT '0',
  `lunas` TINYINT(1) DEFAULT '0',
  `totalpayment` DOUBLE(50,3) DEFAULT '0.000',
  `kodesales` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `namasales` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bayarskrg` DOUBLE(50,3) DEFAULT '0.000',
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `checked` TINYINT(1) DEFAULT '0',
  `idsellorder` INTEGER(11) DEFAULT NULL,
  `totalretur` DOUBLE(15,3) DEFAULT '0.000',
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `fakturpajakno` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `totdet` TINYINT(4) NOT NULL DEFAULT '0',
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`idsell`),
  UNIQUE KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=257 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `sellmaster_before_ins_tr` BEFORE INSERT ON `sellmaster`
  FOR EACH ROW
BEGIN
 declare nourut int(11);
 declare vnourut VARCHAR(5);
 declare vnama VARCHAR(191);
 
 select coalesce(MAX(cast(right(faktur,4) as unsigned)),0)+1 into nourut from sellmaster  
 where left(faktur,1)=left(new.faktur,1) and month(tanggal)=month(new.tanggal) and year(tanggal)=year(new.tanggal);
 
 set vnourut = cast(nourut as char);
 if (nourut<10) then set vnourut = concat('000',vnourut);
 elseif (nourut<100) then set vnourut = concat('00',vnourut);
 elseif (nourut<1000) then set vnourut = concat('0',vnourut); 
 end if;
 
 if (new.faktur is not null) then 
  set new.faktur = concat(new.faktur,DATE_FORMAT(new.tanggal,'%Y%m%d'),vnourut);
 end if;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `sellmaster_before_upd_tr` BEFORE UPDATE ON `sellmaster`
  FOR EACH ROW
BEGIN
 declare vquantity,viduser,ctnomordet int(11);
 declare vhargajual,vdiskon,vnetto,vhargabeli double(50,3);
 declare vkode VARCHAR(50); 
 
 declare ttlharga Double;
 
 if (new.isposted=0) then set new.totdet = 0; end if;
 
 if ((new.grandtotal=1)OR((old.isposted=0)and(new.isposted=1))) then 
 begin
  select coalesce(sum(subtotal),0),COUNT(*) into ttlharga, ctnomordet from selldetail  
  where faktur = NEW.faktur;
  
  set new.subtotal     = ttlharga;
  set new.total        = ttlharga + new.ppn;
  set new.grandtotal   = ttlharga + new.ppn - new.diskonrp;
  
  set new.totdet   =  ctnomordet;
 end;
 end if;
 
 
 if (old.isposted=0)and(new.isposted=1) then
 begin
  select IDuser into viduser from user where username=new.kasir;
  
  set new.IDuserposted = viduser;
  
  set new.idsellorder = null;
 
  insert into inventory (kodebrg,qty,satuan,faktur,typetrans,idTrans,tglTrans,kodeGudang,IDuser,username,waktu,keterangan) 
  select kode,quantity*-1,satuan,faktur,'penjualan',idsell,new.tanggal,'UT',viduser,new.kasir,new.waktu,concat('Invoice No.',faktur,' ',new.customer) from selldetail where faktur=new.faktur;
  
  insert into historybuysell (Tanggal,faktur,quantity,hargajual,diskon,diskon2,netto,hargabeli,kodesales,namasales,kodebrg,kodecust)  
  select new.Tanggal,new.faktur,quantity,hargajual,diskon,diskon2,hargajual-round(hargajual*diskon*0.01*diskon2*0.01),hargabeli,new.kodesales,new.namasales,kode,new.kodecustomer from selldetail where faktur=new.faktur;
 end;
 elseif (old.isposted<>-1)and(new.isposted=-1) then
 BEGIN
  delete from historybuysell where faktur = new.faktur;
 end;
 end if;
END;

CREATE TABLE `selldetail` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `isposted` TINYINT(1) DEFAULT '1',
  `idstts` TINYINT(4) DEFAULT '0' COMMENT '0 = Value\r\n1 = Free\r\n2 = Tukar',
  `idsell` INTEGER(11) NOT NULL,
  `komisisales` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nomordet` TINYINT(4) NOT NULL DEFAULT '1',
  `vsubtotal` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT '0',
  KEY `faktur` (`faktur`),
  KEY `idsell` (`idsell`),
  KEY `kode` (`kode`),
  KEY `kodepromo` (`kodepromo`),
  CONSTRAINT `selldetail_fk` FOREIGN KEY (`faktur`) REFERENCES `sellmaster` (`faktur`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `selldetail_fk1` FOREIGN KEY (`idsell`) REFERENCES `sellmaster` (`idsell`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `selldetail_fk2` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE,
  CONSTRAINT `selldetail_fk3` FOREIGN KEY (`kodepromo`) REFERENCES `promo` (`kode`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB; (`faktur`) REFER `sparepart/sellmaster`(`faktur`); (`ids';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `selldetail_before_ins_tr` BEFORE INSERT ON `selldetail`
  FOR EACH ROW
BEGIN
 declare vnomordet TINYINT(4);
 select count(*) into vnomordet from selldetail where faktur=new.faktur;
 set vnomordet = vnomordet + 1;
 set NEW.nomordet = vnomordet;
END;

CREATE TABLE `sellorder` (
  `idsell` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tanggal` DATE DEFAULT NULL,
  `waktu` TIME DEFAULT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDcustomer` INTEGER(11) DEFAULT NULL,
  `kodecustomer` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `customer` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `pembayaran` CHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nogiro` CHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tgljatuhtempo` DATE DEFAULT NULL,
  `subtotal` DOUBLE(50,3) DEFAULT '0.000',
  `ppn` DOUBLE(50,3) DEFAULT '0.000',
  `total` DOUBLE(50,3) DEFAULT '0.000',
  `diskon` DOUBLE(50,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(50,3) DEFAULT '0.000',
  `grandtotal` DOUBLE(50,3) DEFAULT '0.000',
  `bayar` DOUBLE(50,3) DEFAULT '0.000',
  `kembali` DOUBLE(50,3) DEFAULT '0.000',
  `isposted` INTEGER(11) DEFAULT '0',
  `lunas` INTEGER(11) DEFAULT '0',
  `totalpayment` DOUBLE(50,3) DEFAULT '0.000',
  `kodesales` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `namasales` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bayarskrg` DOUBLE(50,3) DEFAULT '0.000',
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `checked` TINYINT(1) DEFAULT '0',
  `fakturpajakno` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`idsell`),
  UNIQUE KEY `faktur` (`faktur`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `sellorder_before_del_tr` BEFORE DELETE ON `sellorder`
  FOR EACH ROW
BEGIN
  declare vmaxjumdet tinyint(4);
  
  set vmaxjumdet = 30;

  insert into sellmaster (faktur,idsellorder,tanggal,waktu,kasir,IDcustomer,kodecustomer,customer,alamat,kota,pembayaran,nogiro,tgljatuhtempo,subtotal,ppn,total,diskon,diskonrp,grandtotal,bayar,kembali,isposted,lunas,totalpayment,kodesales,namasales,bayarskrg,kodepromo,checked,notes) 
  select DISTINCT(d.kategori),old.idsell,old.tanggal,old.waktu,old.kasir,old.IDcustomer,old.kodecustomer,old.customer,old.alamat,old.kota,old.pembayaran,old.nogiro,old.tgljatuhtempo,old.subtotal,old.ppn,old.total,old.diskon,old.diskonrp,old.grandtotal,old.bayar,old.kembali,0,old.lunas,old.totalpayment,old.kodesales,old.namasales,old.bayarskrg,old.kodepromo,old.checked,old.notes from sellorderdetail d 
  where d.idsell=old.idsell;
 
  insert into selldetail (faktur,kode,nama,kategori,merk,tipe,seri,hargajual,diskon,diskon2,diskonrp,diskon_rp,quantity,hargabeli,satuan,subtotal,isposted,idstts,idsell,komisisales,kodepromo,vsubtotal) 
  select j.faktur,d.kode,d.nama,d.kategori,d.merk,d.tipe,d.seri,d.hargajual,d.diskon,d.diskon2,d.diskonrp,d.diskon_rp,d.quantity,d.hargabeli,d.satuan,d.subtotal,d.isposted,d.idstts,j.idsell,d.komisisales,d.kodepromo,d.vsubtotal from `sellorderdetail` d 
  left join sellmaster j on d.idsell=j.idsellorder and left(j.faktur,1)=d.kategori  
  where d.`idsell`=old.idsell;

  update sellmaster set grandtotal=1 where idsellorder=old.idsell; 
  
  insert into sellmaster (faktur,idsellorder,tanggal,waktu,kasir,IDcustomer,kodecustomer,customer,alamat,kota,pembayaran,nogiro,tgljatuhtempo,subtotal,ppn,total,diskon,diskonrp,grandtotal,bayar,kembali,isposted,lunas,totalpayment,kodesales,namasales,bayarskrg,kodepromo,checked,notes) 
  select left(s.faktur,1),old.idsell,old.tanggal,old.waktu,old.kasir,old.IDcustomer,old.kodecustomer,old.customer,old.alamat,old.kota,old.pembayaran,old.nogiro,old.tgljatuhtempo,old.subtotal,old.ppn,old.total,old.diskon,old.diskonrp,old.grandtotal,old.bayar,old.kembali,0,old.lunas,old.totalpayment,old.kodesales,old.namasales,old.bayarskrg,old.kodepromo,old.checked,old.notes from sellmaster s 
  where s.totdet>vmaxjumdet and s.idsellorder=old.idsell;
  
  insert into selldetail (faktur,kode,nama,kategori,merk,tipe,seri,hargajual,diskon,diskon2,diskonrp,diskon_rp,quantity,hargabeli,satuan,subtotal,isposted,idstts,idsell,komisisales,kodepromo,vsubtotal) 
  select j.faktur,d.kode,d.nama,d.kategori,d.merk,d.tipe,d.seri,d.hargajual,d.diskon,d.diskon2,d.diskonrp,d.diskon_rp,d.quantity,d.hargabeli,d.satuan,d.subtotal,d.isposted,d.idstts,j.idsell,d.komisisales,d.kodepromo,d.vsubtotal from `selldetail` d 
  left join sellmaster s on d.idsell=s.idsell 
  left join sellmaster j on s.idsellorder=j.idsellorder and left(j.faktur,1)=d.kategori
  where s.totdet>vmaxjumdet and s.idsellorder=old.idsell and d.`nomordet`>vmaxjumdet and j.`totdet`=0 ;

  delete from selldetail where nomordet>vmaxjumdet and idsell in (select idsell from sellmaster where totdet>vmaxjumdet and idsellorder=old.idsell);


  update sellmaster set grandtotal=1 where idsellorder=old.idsell;
  
  insert into sellmaster (faktur,idsellorder,tanggal,waktu,kasir,IDcustomer,kodecustomer,customer,alamat,kota,pembayaran,nogiro,tgljatuhtempo,subtotal,ppn,total,diskon,diskonrp,grandtotal,bayar,kembali,isposted,lunas,totalpayment,kodesales,namasales,bayarskrg,kodepromo,checked,notes) 
  select left(s.faktur,1),old.idsell,old.tanggal,old.waktu,old.kasir,old.IDcustomer,old.kodecustomer,old.customer,old.alamat,old.kota,old.pembayaran,old.nogiro,old.tgljatuhtempo,old.subtotal,old.ppn,old.total,old.diskon,old.diskonrp,old.grandtotal,old.bayar,old.kembali,0,old.lunas,old.totalpayment,old.kodesales,old.namasales,old.bayarskrg,old.kodepromo,old.checked,old.notes from sellmaster s 
  where s.totdet>vmaxjumdet and s.idsellorder=old.idsell;
  
  insert into selldetail (faktur,kode,nama,kategori,merk,tipe,seri,hargajual,diskon,diskon2,diskonrp,diskon_rp,quantity,hargabeli,satuan,subtotal,isposted,idstts,idsell,komisisales,kodepromo,vsubtotal) 
  select j.faktur,d.kode,d.nama,d.kategori,d.merk,d.tipe,d.seri,d.hargajual,d.diskon,d.diskon2,d.diskonrp,d.diskon_rp,d.quantity,d.hargabeli,d.satuan,d.subtotal,d.isposted,d.idstts,j.idsell,d.komisisales,d.kodepromo,d.vsubtotal from `selldetail` d 
  left join sellmaster s on d.idsell=s.idsell 
  left join sellmaster j on s.idsellorder=j.idsellorder and left(j.faktur,1)=d.kategori
  where s.totdet>vmaxjumdet and s.idsellorder=old.idsell and d.`nomordet`>vmaxjumdet and j.`totdet`=0 ;
  
  delete from selldetail where nomordet>vmaxjumdet;

  update sellmaster set grandtotal=1,isposted=1 where idsellorder=old.idsell;

END;

CREATE TABLE `sellorderdetail` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kategori` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `merk` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `seri` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hargajual` DOUBLE(15,3) DEFAULT '0.000',
  `diskon` FLOAT(9,3) DEFAULT '0.000',
  `diskon2` FLOAT(9,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `diskon_rp` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `quantity` DOUBLE(15,3) DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) DEFAULT '0.000',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `subtotal` DOUBLE(15,3) DEFAULT '0.000',
  `isposted` TINYINT(1) DEFAULT '1',
  `idstts` TINYINT(4) DEFAULT '0' COMMENT '0 = Value\r\n1 = Free\r\n2 = Tukar',
  `idsell` INTEGER(11) NOT NULL,
  `komisisales` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `kodepromo` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tipe` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `vsubtotal` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT '0',
  KEY `faktur` (`faktur`),
  KEY `idsell` (`idsell`),
  CONSTRAINT `sellorderdetail_fk` FOREIGN KEY (`faktur`) REFERENCES `sellorder` (`faktur`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sellorderdetail_fk1` FOREIGN KEY (`idsell`) REFERENCES `sellorder` (`idsell`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `sellpayment` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kodecustomer` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `customer` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tanggal` DATE NOT NULL,
  `waktu` TIME NOT NULL,
  `kasir` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `transfer` DOUBLE(15,3) DEFAULT '0.000',
  `tunai` DOUBLE(15,3) DEFAULT '0.000',
  `bg` DOUBLE(15,3) DEFAULT '0.000',
  `totalpiutangfaktur` DOUBLE(15,3) DEFAULT '0.000',
  `totalretur` DOUBLE(15,3) DEFAULT '0.000',
  `diskonrp` DOUBLE(15,3) DEFAULT '0.000',
  `tanggalinput` DATE NOT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `isposted` TINYINT(1) DEFAULT '0',
  `saldo_piutang` DOUBLE(15,3) DEFAULT '0.000',
  PRIMARY KEY (`faktur`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `sellpaymentbg` (
  `faktur` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tgl` DATE DEFAULT NULL,
  `transfer` DOUBLE(15,3) DEFAULT '0.000',
  `bg` DOUBLE(15,3) DEFAULT '0.000',
  `bgno` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgbank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL,
  `bgtempo` DATE DEFAULT NULL,
  `tobank` VARCHAR(200) COLLATE latin1_swedish_ci DEFAULT NULL
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `struk` (
  `IDstruk` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `company` VARCHAR(150) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `cabang` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `phone` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `footer1` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `footer2` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `footer3` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `footer4` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `footer5` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `endfooter1` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `endfooter2` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `endfooter3` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `mintrans` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `presentfeebusrental` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `presentfeebusbesar` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `presentfeebuskecil` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `isaktif` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IDstruk`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `supplier` (
  `IDsupplier` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat` VARCHAR(250) COLLATE latin1_swedish_ci DEFAULT NULL,
  `alamat2` VARCHAR(255) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kota2` VARCHAR(100) COLLATE latin1_swedish_ci DEFAULT NULL,
  `kodepos` VARCHAR(10) COLLATE latin1_swedish_ci DEFAULT NULL,
  `telephone` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `telephone2` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `fax` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `rekening` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hp` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `hp2` VARCHAR(30) COLLATE latin1_swedish_ci DEFAULT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `tglnoneffective` DATE DEFAULT NULL,
  PRIMARY KEY (`kode`),
  UNIQUE KEY `kode` (`kode`),
  UNIQUE KEY `IDsupplier` (`IDsupplier`)
)ENGINE=InnoDB
AUTO_INCREMENT=345 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `terimagudang` (
  `IDterimagudang` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `docno` VARCHAR(30) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `doctgl` DATE NOT NULL,
  `IDgudangfrom` INTEGER(11) NOT NULL,
  `IDgudang` INTEGER(11) NOT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `usernameposted` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT '',
  `posted` DATETIME DEFAULT NULL,
  PRIMARY KEY (`IDterimagudang`),
  UNIQUE KEY `docno` (`docno`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `terimagudang_before_upd_tr` BEFORE UPDATE ON `terimagudang`
  FOR EACH ROW
BEGIN
 declare vkodegudang VARCHAR(10);
 declare vkodegudangfrom VARCHAR(10);

 select kodegudang into vkodegudang from gudang where IDgudang=new.IDgudang;

 if (old.posted is null) and (new.posted is not null) THEN
 begin
  insert into inventory (tgltrans,kodebrg,kodegudang,qty,satuan,hargabeli,hargajual,typetrans,faktur,IDtrans,IDuser,username,waktu,keterangan) 
  select new.doctgl,b.kode,vkodegudang,b.qty,b.satuan,b.hargabeli,b.hargajual,'terima gudang',new.docno,new.IDterimagudang,new.IDuserposted,new.usernameposted,time(now()),new.notes from terimagudangdet b where b.IDterimagudang=new.IDterimagudang;

 end;
 elseif (old.posted is not null) and (new.posted is null) THEN
 begin
  delete from inventory where IDtrans=old.IDterimagudang and typetrans='terima gudang';
 end;
 end if;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `terimagudang_before_del_tr` BEFORE DELETE ON `terimagudang`
  FOR EACH ROW
BEGIN
 delete from inventory where IDtrans=old.IDterimagudang and typetrans='terima gudang';
END;

CREATE TABLE `terimagudangdet` (
  `IDterimagudang` INTEGER(11) NOT NULL,
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  KEY `IDterimagudang` (`IDterimagudang`),
  KEY `kode` (`kode`),
  KEY `IDproduct` (`IDproduct`),
  CONSTRAINT `terimagudangdet_fk` FOREIGN KEY (`IDterimagudang`) REFERENCES `terimagudang` (`IDterimagudang`) ON DELETE CASCADE,
  CONSTRAINT `terimagudangdet_fk1` FOREIGN KEY (`IDproduct`) REFERENCES `product` (`IDproduct`),
  CONSTRAINT `terimagudangdet_fk2` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `terimagudangdetform` (
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `IDproduct` INTEGER(11) NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000'
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `terimapurchase` (
  `IDterimapurchase` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `docno` VARCHAR(30) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `doctgl` DATE NOT NULL,
  `pono` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `invoiceno` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDgudang` INTEGER(11) NOT NULL,
  `totalprice` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `usernameposted` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT '',
  `posted` DATETIME DEFAULT NULL,
  PRIMARY KEY (`IDterimapurchase`),
  UNIQUE KEY `docno` (`docno`),
  KEY `pono` (`pono`),
  CONSTRAINT `terimapurchase_fk` FOREIGN KEY (`pono`) REFERENCES `purchaseorder` (`pono`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE DEFINER = 'metabrain'@'%' TRIGGER `terimapurchase_before_upd_tr` BEFORE UPDATE ON `terimapurchase`
  FOR EACH ROW
BEGIN
 declare vkodegudang VARCHAR(10);

 select kodegudang into vkodegudang from gudang where IDgudang=new.IDgudang;

 if (old.posted is null) and (new.posted is not null) THEN
 begin
  insert into inventory (tgltrans,kodebrg,kodegudang,qty,satuan,hargabeli,hargajual,typetrans,faktur,IDtrans,IDuser,username,waktu,keterangan) 
  select new.doctgl,b.kode,vkodegudang,b.qty,b.satuan,b.hargabeli,b.hargajual,'terima purchase',new.docno,new.IDterimapurchase,new.IDuserposted,new.usernameposted,time(now()),new.notes from terimapurchasedet b where b.IDterimapurchase=new.IDterimapurchase;

 end;
 elseif (old.posted is not null) and (new.posted is null) THEN
 begin
  delete from inventory where IDtrans=old.IDterimapurchase and typetrans='terima purchase';
 end;
 end if;

END;

CREATE DEFINER = 'metabrain'@'%' TRIGGER `terimapurchase_before_del_tr` BEFORE DELETE ON `terimapurchase`
  FOR EACH ROW
BEGIN
 delete from inventory where IDtrans=old.IDterimapurchase and typetrans='terima purchase';
END;

CREATE TABLE `terimapurchasedet` (
  `IDterimapurchase` INTEGER(11) NOT NULL,
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  KEY `IDterimapurchase` (`IDterimapurchase`),
  KEY `IDproduct` (`IDproduct`),
  KEY `kode` (`kode`),
  CONSTRAINT `terimapurchasedet_fk` FOREIGN KEY (`IDterimapurchase`) REFERENCES `terimapurchase` (`IDterimapurchase`) ON DELETE CASCADE,
  CONSTRAINT `terimapurchasedet_fk1` FOREIGN KEY (`IDproduct`) REFERENCES `product` (`IDproduct`),
  CONSTRAINT `terimapurchasedet_fk2` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `terimapurchasedetform` (
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `IDproduct` INTEGER(11) NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `qty` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000'
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `ubahharga` (
  `IDubahharga` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `docno` VARCHAR(30) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `doctgl` DATE NOT NULL,
  `notes` VARCHAR(500) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDuserposted` INTEGER(11) DEFAULT NULL,
  `usernameposted` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  `posted` DATETIME DEFAULT NULL,
  PRIMARY KEY (`IDubahharga`),
  UNIQUE KEY `docno` (`docno`),
  UNIQUE KEY `docno_2` (`docno`)
)ENGINE=InnoDB
AUTO_INCREMENT=1 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `ubahhargadet` (
  `IDubahharga` INTEGER(11) NOT NULL,
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajualbaru` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `tglberlaku` DATE NOT NULL,
  KEY `IDubahharga` (`IDubahharga`),
  KEY `IDproduct` (`IDproduct`),
  KEY `kode` (`kode`),
  CONSTRAINT `ubahhargadet_fk` FOREIGN KEY (`IDubahharga`) REFERENCES `ubahharga` (`IDubahharga`) ON DELETE CASCADE,
  CONSTRAINT `ubahhargadet_fk1` FOREIGN KEY (`IDproduct`) REFERENCES `product` (`IDproduct`),
  CONSTRAINT `ubahhargadet_fk2` FOREIGN KEY (`kode`) REFERENCES `product` (`kode`) ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `ubahhargadetform` (
  `ipv` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `IDproduct` INTEGER(11) UNSIGNED NOT NULL,
  `kode` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `nama` VARCHAR(100) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `satuan` VARCHAR(20) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `hargabeli` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajual` DOUBLE(15,3) NOT NULL DEFAULT '0.000',
  `hargajualbaru` DOUBLE(15,3) DEFAULT '0.000',
  `tglberlaku` DATE DEFAULT NULL,
  KEY `IDproduct` (`IDproduct`),
  CONSTRAINT `ubahhargadetform_fk` FOREIGN KEY (`IDproduct`) REFERENCES `product` (`IDproduct`) ON DELETE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `user` (
  `IDuser` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `password` VARCHAR(20) COLLATE latin1_swedish_ci DEFAULT NULL,
  `IDusergroup` INTEGER(11) NOT NULL,
  `usergroup` VARCHAR(80) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `tglnoneffective` DATE DEFAULT NULL,
  UNIQUE KEY `IDuser` (`IDuser`),
  UNIQUE KEY `username` (`username`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE TABLE `usergroup` (
  `IDusergroup` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `usergroup` VARCHAR(80) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `isedit` TINYINT(1) DEFAULT '0',
  `isdel` TINYINT(1) DEFAULT '0',
  PRIMARY KEY (`IDusergroup`),
  UNIQUE KEY `usergroup` (`usergroup`)
)ENGINE=InnoDB
AUTO_INCREMENT=2 CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `usergroupmenu` (
  `IDusergroup` INTEGER(11) NOT NULL,
  `IDmenu` INTEGER(11) NOT NULL,
  KEY `IDusergroup` (`IDusergroup`),
  KEY `IDmenu` (`IDmenu`),
  CONSTRAINT `usergroupmenu_fk` FOREIGN KEY (`IDusergroup`) REFERENCES `usergroup` (`IDusergroup`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usergroupmenu_fk1` FOREIGN KEY (`IDmenu`) REFERENCES `menu` (`IDmenu`) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci';

CREATE TABLE `wilayah` (
  `kodewilayah` VARCHAR(2) COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `namawilayah` VARCHAR(50) COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`kodewilayah`)
)ENGINE=InnoDB
CHARACTER SET 'latin1' COLLATE 'latin1_swedish_ci'
COMMENT='InnoDB free: 731136 kB';

CREATE DEFINER = 'metabrain'@'%' FUNCTION `f_happy_birthday`()
    RETURNS varchar(500) CHARSET latin1
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare vnama VARCHAR(200);  
  declare vhasil VARCHAR(500);  
  
  begin
  declare c_emp cursor for (select nama from customer where month(tgllahir)=month(CURRENT_DATE) and dayofmonth(tgllahir)=dayofmonth(CURRENT_DATE)) union 
                           (select nama from sales where month(tgllahir)=month(CURRENT_DATE) and dayofmonth(tgllahir)=dayofmonth(CURRENT_DATE)) order by nama;
  declare exit handler for not found begin end;
  set vhasil = 'HAPPY BIRTHDAY TO ';
  open c_emp;
  loop
     fetch c_emp into vnama;
     set vhasil = concat(vhasil,' : ',vnama);
  end loop;
  close c_emp;
  end;
   
  if vhasil = 'HAPPY BIRTHDAY TO ' then set vhasil=''; end if;
  
  RETURN vhasil;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getcustomerpromodisplay`(
        vkodecustomer VARCHAR(20)
    )
    RETURNS varchar(60) CHARSET latin1
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare vresult varchar(60);
  declare vkodepromo varchar(20);
  declare c_cust cursor for select kodepromo from customerpromo where kodecustomer = vkodecustomer;
  declare exit handler for not found begin end; 
  set vresult = null; 
  open c_cust;
  loop
   fetch c_cust into vkodepromo;
   if (vkodepromo is not null) THEN
   begin
    if (vresult is null) then set vresult = vkodepromo;
    else set vresult = concat(vresult,',',vkodepromo); end if; 
   end;
   end if;
  end loop;
  close c_cust;
  
  RETURN vresult;
  
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getKodePromo`(
        vkodecustomer VARCHAR(20),
        vkodeproduct VARCHAR(50)
    )
    RETURNS varchar(20) CHARSET latin1
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare vkodepromo VARCHAR(20);
  declare ctpromo int(11);
  set vkodepromo = null;
  set ctpromo = 0;
  select kodepromo into vkodepromo from product where kode = vkodeproduct;
  if (vkodepromo is not null) then
  begin
   select count(kodepromo) into ctpromo from customerpromo where kodecustomer=vkodecustomer and kodepromo=vkodepromo;
   if (ctpromo=0) then set vkodepromo=null; end if;
  end;
  end if;
   
  RETURN vkodepromo;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getpembelianstock`(vkodebrg VARCHAR(50), vkodegudang VARCHAR(10), vtglstart DATE, vtglend DATE)
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare qtytot DOUBLE(15,3);
  set qtytot = 0;
  select sum(qty) into qtytot from inventory where kodebrg = vkodebrg and kodegudang = vkodegudang and qty>0 and tgltrans between vtglstart and vtglend;
  if (qtytot is null) then set qtytot = 0; end if;
  RETURN qtytot;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getpenjualanstock`(
        vkodebrg VARCHAR(50),
        vkodegudang VARCHAR(10),
        vtglstart DATE,
        vtglend DATE
    )
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare qtytot DOUBLE(15,3);
  set qtytot = 0;

  select coalesce(sum(-1*qty),0) into qtytot from inventory where kodebrg = vkodebrg and kodegudang = vkodegudang and qty<0 and tgltrans between vtglstart and vtglend;
  if (qtytot is null) then set qtytot = 0; end if;

  RETURN qtytot;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getproductbuyprice`(
        kodeproduct VARCHAR(50)
    )
    RETURNS double(50,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare vbuyprice double(50,3);
  set vbuyprice = 0;
  select hargabeli into vbuyprice from product where kode = kodeproduct;
  if (vbuyprice is null) then set vbuyprice = 0; end if;
  
  RETURN vbuyprice;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getQtysisaReturBeli`(
        fakturno VARCHAR(50),
        kodebrg VARCHAR(20)
    )
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 declare qtypcsbelitot,qtypcsreturtot,qtyresult double(15,3);
 
 select SUM(quantity) into qtypcsbelitot from buydetail where faktur=fakturno and kode=kodebrg;
 select SUM(d.qtyretur) into qtypcsreturtot from returbelidetail d 
 left join returbelimaster m on d.faktur=m.faktur  
 where d.fakturbeli=fakturno and d.kode=kodebrg and m.isposted=1;
 
 if (qtypcsbelitot is null) then set qtypcsbelitot=0; end if; 
 if (qtypcsreturtot is null) then set qtypcsreturtot=0; end if; 
 
 set qtyresult = qtypcsbelitot - qtypcsreturtot;
  
 return qtyresult;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getQtysisaReturJual`(
        fakturno VARCHAR(50),
        kodebrg VARCHAR(20)
    )
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 declare qtypcsjualtot,qtypcsreturtot,qtyresult double(15,3);
 
 select SUM(quantity) into qtypcsjualtot from selldetail where faktur=fakturno and kode=kodebrg;
 select SUM(d.qtyretur) into qtypcsreturtot from returjualdetail d 
 left join returjualmaster m on d.faktur=m.faktur  
 where d.fakturjual=fakturno and d.kode=kodebrg and m.isposted=1;
 
 if (qtypcsjualtot is null) then set qtypcsjualtot=0; end if; 
 if (qtypcsreturtot is null) then set qtypcsreturtot=0; end if; 
 
 set qtyresult = qtypcsjualtot - qtypcsreturtot;
  
 return qtyresult;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getQtyStock`(vkodebrg VARCHAR(50), vkodegudang VARCHAR(10))
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare qtytot double(15,3);
  set qtytot = 0;
  select sum(qty) into qtytot from inventory where kodebrg = vkodebrg and kodegudang = vkodegudang;
  if (qtytot is null) then set qtytot = 0; end if;
  RETURN qtytot;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getreturpromo`(
        vkodecust VARCHAR(20),
        vkodepromo VARCHAR(20),
        vstartdate DATE,
        venddate DATE
    )
    RETURNS double(50,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 declare vtotalretur double(50,3);
 set vtotalretur = 0;
 select sum((a.qtyretur * a.hargajual)-a.diskonrp) as totalretur into vtotalretur 
 from returjualdetail a inner join returjualmaster b on a.faktur = b.faktur 
 inner join selldetail i on ((a.fakturjual = i.faktur) and (a.kode=i.kode)) 
 where b.kodecustomer=vkodecust and b.isposted=1 and i.kodepromo=vkodepromo and b.tanggal between vstartdate and venddate; 
 
 if (vtotalretur is null) then set vtotalretur=0; end if;
 
 return vtotalretur;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `getsaldostock`(vkodebrg VARCHAR(50), vkodegudang VARCHAR(10), vtgl DATE)
    RETURNS double(15,3)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare qtytot DOUBLE(15,3);
  set qtytot = 0;
  select sum(qty) into qtytot from inventory where kodebrg = vkodebrg and kodegudang = vkodegudang and tgltrans<=vtgl;
  if (qtytot is null) then set qtytot = 0; end if;
  RETURN qtytot;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `iscustomerpromo`(
        vkodecustomer VARCHAR(20)
    )
    RETURNS tinyint(1)
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
  declare ctpromo tinyint(4);
  set ctpromo = 0;
  select count(kodepromo) into ctpromo from customerpromo where kodecustomer = vkodecustomer; 
  RETURN ctpromo;
END;

CREATE DEFINER = 'metabrain'@'%' FUNCTION `TextTo128C`(
        inpstring VARCHAR(100)
    )
    RETURNS varchar(100) CHARSET latin1
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 declare l,i,j,asciino,wm integer(11);   
 declare bufstr varchar(2);
 declare rstring VARCHAR(100);
 
 set rstring='';
 
 set l=LENGTH(inpstring);
 
 if (l>0) then
 begin 

 set rstring=char('205' using latin1);
 
 if (l%2)<>0 then 
 begin 
  set inpstring=concat('0',inpstring);
  set l=l+1;
 end;
 end if; 
 
 set wm = 105;
 set asciino=0;
 set i=1;
 set j=1;
 while (i <= (l-1)) do
 begin
  set bufstr = SUBSTRING(inpstring,i,2);
  
  if (bufstr='00') then set asciino=194;
  else
  begin
   set asciino=cast(bufstr as signed)+32; 
  end;
  end if;
  
  set rstring=CONCAT(rstring,char(asciino using latin1));
  
  set wm = wm + (cast(bufstr as signed) * j);  
    
  set i=i+2;
  set j=j+1;
 end;
 end while;

 set wm = (wm % 103)+32;
 set rstring=CONCAT(rstring,char(wm using latin1));
 
 set rstring=CONCAT(rstring,char('206' using latin1));
 
 end; 
 end if;
 
 
 RETURN rstring;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `cleardata`()
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
SET FOREIGN_KEY_CHECKS=0;

 truncate adjustdetail;
 truncate adjustmaster;
 truncate buydetail;
 truncate buymaster;

 truncate buypayment;
 truncate buypaymentbg;

 truncate inventory;
 truncate inventoryimp;
 truncate productgudang;
 truncate product;
 
 truncate jasa;
 truncate loginfo;
 truncate operasional;
 
 truncate  returbelidetail;
 truncate  returbelimaster;
 truncate  returjualdetail;
 truncate  returjualmaster;
 truncate  rusakdetail;
 truncate rusakmaster;
 truncate selldetail;
 truncate sellmaster;
 truncate sellpaymentbg; 
 truncate sellpayment;


truncate formadjust;
truncate formbg;
truncate formbuy;
truncate formkeuangan;
truncate formretur;
truncate formsell;
truncate formsellorder;
truncate historybuysell;

END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_canceladjust`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from operasional where faktur=vfaktur and upper(kategori)='ADJUSTMENT';
 delete from inventory where faktur=vfaktur and upper(typetrans)='ADJUSTMENT';
 delete from adjustdetail where faktur=vfaktur;
 delete from adjustmaster where faktur=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelbuy`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from operasional where faktur=vfaktur and upper(kategori)='PEMBELIAN';
 delete from inventory where faktur=vfaktur and upper(typetrans)='PEMBELIAN';
 delete from buydetail where faktur=vfaktur;
 delete from buymaster where faktur=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelfaktur`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from operasional where faktur=vfaktur and upper(kategori)='PENJUALAN';
 delete from inventory where faktur=vfaktur and upper(typetrans)='PENJUALAN';
 delete from selldetail where faktur=vfaktur;
 delete from sellmaster where faktur=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelpindahgudang`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from inventory where faktur=vfaktur and upper(typetrans)='PINDAH GUDANG';
 delete from pindahgudangdet where IDpindahgudang=(select IDpindahgudang from pindahgudang where docno = vfaktur);
 delete from pindahgudang where docno=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelpo`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from purchaseorderdet where IDpurchaseorder=(select IDpurchaseorder from purchaseorder where pono = vfaktur);
 delete from purchaseorder where pono=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelpromodiskon`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from diskondet where IDdiskon=(select IDdiskon from diskon where docno = vfaktur);
 delete from diskon where docno=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelretur`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from operasional where faktur=vfaktur and upper(kategori)='RETUR PENJUALAN TUNAI';
 delete from inventory where faktur=vfaktur and trim(typetrans)='retur penjualan';
 delete from returjualdetail where faktur=vfaktur;
 delete from returjualmaster where faktur=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelreturbeli`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from operasional where faktur=vfaktur and upper(kategori)='RETUR PEMBELIAN TUNAI';
 delete from inventory where faktur=vfaktur and trim(typetrans)='retur pembelian';
 delete from returbelidetail where faktur=vfaktur;
 delete from returbelimaster where faktur=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelterimagudang`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from inventory where faktur=vfaktur and upper(typetrans)='TERIMA GUDANG';
 delete from terimagudangdet where IDterimagudang=(select IDterimagudang from terimagudang where docno = vfaktur);
 delete from terimagudang where docno=vfaktur;
END;

CREATE DEFINER = 'metabrain'@'%' PROCEDURE `p_cancelubahharga`(
        IN vfaktur VARCHAR(50)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
 delete from ubahhargadet where IDubahharga=(select IDubahharga from ubahharga where docno = vfaktur);
 delete from ubahharga where docno=vfaktur;
END;

CREATE ALGORITHM=UNDEFINED DEFINER=`metabrain`@`%` SQL SECURITY DEFINER VIEW v_buy AS 
  select 
    `a`.`tanggal` AS `tanggal`,
    `b`.`faktur` AS `faktur`,
    `b`.`kode` AS `kode`,
    `b`.`nama` AS `nama`,
    `b`.`kategori` AS `kategori`,
    `b`.`merk` AS `merk`,
    `b`.`seri` AS `seri`,
    `b`.`harganondiskon` AS `harganondiskon`,
    `b`.`diskon` AS `diskon`,
    `b`.`hargabeli` AS `hargabeli`,
    `b`.`quantity` AS `quantity`,
    `b`.`satuan` AS `satuan` 
  from 
    (`buydetail` `b` left join `buymaster` `a` on((`b`.`faktur` = `a`.`faktur`)));



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;