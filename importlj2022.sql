insert into sales (idsales,kode,nama,alamat,kota,tglmasuk) 
select id,spno,sp_name,sp_address,sp_city,date(created_time) from lautanjaya.salesperson_master 
order by id;

insert into customer 
(IDcustomer,kode,nama,alamat,alamat2,kota,kota2,kodepos,telephone,telephone2,fax,hp,hp2,notes,tglreg,kodesales) 
select id,custno,cust_name,cust_address,cust_address2,cust_city,cust_city2,cust_zipcode,cust_phone1,cust_phone2,cust_fax,cust_mobile1,cust_mobile2,cust_note,date(created_time),if(trim(kodesales)='',null,trim(kodesales))  
from lautanjaya.cust_master 
order by id;

insert into supplier 
(IDsupplier,kode,nama,alamat,alamat2,kota,kota2,kodepos,telephone,telephone2,fax,rekening,hp,hp2) 
select id,suplno,supl_name,supl_address,supl_address2,supl_city,supl_city2,supl_zipcode,supl_phone1,supl_phone2,supl_fax,supl_acc_bank,supl_mobile1,supl_mobile2 from lautanjaya.supl_master 
order by id;

insert ignore into product 
(IDproduct,kode,nama,merk,kategori,tipe,satuan,hargabeli,hargajual,diskon,diskonrp,reorderqty,UT) 
select p.id,p.goodno,p.good_name,b.brand_name,d.div_code,p.good_category,p.good_unit,p.good_lastpurcprice,p.good_sell,p.good_disc,p.good_discvalue,ifnull(p.good_minstock,0),ifnull(p.good_stock,0)  
from lautanjaya.good_master p 
left join lautanjaya.brand_master b on p.brand_id=b.id 
left join lautanjaya.div_master d on b.div_id=d.id 
order by p.id;

insert into customerdiskon (id,IDcustomer,merk,disc) 
select c.id,c.cust_id,b.brand_name,c.disc from lautanjaya.cust_brand_disc_list c 
left join lautanjaya.brand_master b on c.brand_id=b.id 
where c.cust_id in (select id from lautanjaya.cust_master) 
having b.brand_name is not null 
order by c.id;

insert ignore into merk (id,merk,kategori) 
select b.id,b.brand_name,d.div_code from lautanjaya.brand_master b 
left join lautanjaya.div_master d on b.div_id=d.id ;

insert into inventory (kodebrg,qty,satuan,faktur,typetrans,idTrans,tglTrans,kodeGudang,IDuser,username,waktu,keterangan) 
select kode,UT,satuan,'STOK AWAL','STOK AWAL',idproduct,'2023-03-01','UT',1,'admin','00:01:00','STOK AWAL' from product order by idproduct;