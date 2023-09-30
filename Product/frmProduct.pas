unit frmProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzButton, RzRadChk, DB;

type
  TfrmProd = class(TForm)
    PanelProd: TRzPanel;
    RzPanel2: TRzPanel;
    ProdLblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    ProdBtnAdd: TAdvSmoothButton;
    ProdBtnDel: TAdvSmoothButton;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    ProdTxtNama: TRzEdit;
    RzLabel5: TRzLabel;
    ProdTxtSatuan: TRzComboBox;
    RzLabel7: TRzLabel;
    ProdTxtHrgJual: TRzNumericEdit;
    RzLabel9: TRzLabel;
    ProdTxtNonEfektif: TRzDateTimeEdit;
    RzLabel16: TRzLabel;
    RzLabel18: TRzLabel;
    ProdTxtSeri: TRzEdit;
    ProdTxtKeterangan: TRzEdit;
    RzLabel22: TRzLabel;
    ProdTxtKode: TRzEdit;
    RzLabel8: TRzLabel;
    RzLabel10: TRzLabel;
    ProdTxtDiskon: TRzNumericEdit;
    ProdTxtDiskonRp: TRzNumericEdit;
    RzLabel1: TRzLabel;
    ProdTxtHrgBeli: TRzNumericEdit;
    RzLabel11: TRzLabel;
    edt_barcode: TRzEdit;
    RzLabel13: TRzLabel;
    edtnum_reorderqty: TRzNumericEdit;
    ProdTxtMerk: TRzComboBox;
    RzLabel6: TRzLabel;
    ProdTxtTipe: TRzComboBox;
    ProdTxtkategori: TRzEdit;
    procedure ProdBtnAddClick(Sender: TObject);
    procedure ProdBtnDelClick(Sender: TObject);
//    procedure ProdImageDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ProdTxtMerkChange(Sender: TObject);
  private
    procedure FillCombo;
    procedure InsertData;
    procedure UpdateData;
    { Private declarations }
  public
    PicPath: string;
    procedure FormShowFirst;
    { Public declarations }
  end;

var
  frmProd: TfrmProd;

implementation

uses productmaster, frmbuying, SparePartFunction, Data;

{$R *.dfm}

procedure TfrmProd.FillCombo;
begin
  FillComboBox('distinct tipe','product',ProdTxtTipe,false,'tipe');
  FillComboBox('distinct merk','merk',ProdTxtMerk,false,'merk');

  FillComboBox('distinct Satuan','product',ProdTxtSatuan,false,'Satuan');

end;

procedure TfrmProd.InsertData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into product');
    SQL.Add('(kode,nama,merk,seri,satuan,kategori,tipe,hargajual,hargabeli,');
    SQL.Add('keterangan,diskon,diskonrp,barcode,reorderqty,tglnoneffective) values');
    SQL.Add('(' + QuotedStr(trim(ProdTxtKode.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtNama.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtMerk.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtSeri.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtSatuan.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtkategori.Text)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxttipe.Text)) + ',');
    SQL.Add(QuotedStr(FloatToStr(ProdTxtHrgJual.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(ProdTxtHrgBeli.Value)) + ',');
    SQL.Add(QuotedStr(trim(ProdTxtKeterangan.Text)) + ',');
    SQL.Add(QuotedStr(FloatToStr(ProdTxtDiskon.Value)) + ',');
    SQL.Add(QuotedStr(FloatToStr(ProdTxtDiskonRp.Value)) + ',');
    SQL.Add(QuotedStr(trim(edt_barcode.Text)) + ',');
    SQL.Add(QuotedStr(Floattostr(edtnum_reorderqty.value)) + ',');

    ///Set Tgl ke Null jika tgl tidak diisi
    if ProdTxtNonEfektif.Text = '' then
      SQL.Add('null)')
    else
      SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd',ProdTxtNonEfektif.Date)) + ')');
    ExecSQL;

  end;
end;

procedure TfrmProd.UpdateData;
begin

  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update product set ');
    SQL.Add('kode = ' + QuotedStr(trim(ProdTxtKode.Text)) + ',');
    SQL.Add('nama = ' + QuotedStr(trim(ProdTxtNama.Text)) + ',');
    SQL.Add('merk = ' + QuotedStr(trim(ProdTxtMerk.Text)) + ',');
    SQL.Add('tipe = ' + QuotedStr(trim(ProdTxtTipe.Text)) + ',');
    SQL.Add('seri = ' + QuotedStr(trim(ProdTxtSeri.Text)) + ',');
    SQL.Add('satuan = ' + QuotedStr(trim(ProdTxtSatuan.Text)) + ',');
    SQL.Add('kategori = ' + QuotedStr(trim(ProdTxtkategori.Text)) + ',');
    SQL.Add('hargajual = ' + QuotedStr(FloatToStr(ProdTxtHrgJual.Value)) + ',');
    SQL.Add('hargabeli = ' + QuotedStr(FloatToStr(ProdTxtHrgBeli.Value)) + ',');
    SQL.Add('keterangan = ' + QuotedStr(ProdTxtKeterangan.Text) + ',');
    SQL.Add('diskon = ' + QuotedStr(FloatToStr(ProdTxtDiskon.Value)) + ',');
    SQL.Add('diskonrp = ' + QuotedStr(FloatToStr(ProdTxtDiskonRp.Value)) + ',');
    SQL.Add('barcode = ' + QuotedStr(trim(edt_barcode.Text)) + ',');
    SQL.Add('reorderqty = ' + QuotedStr(Floattostr(edtnum_reorderqty.value)) + ',');

    ///Set Tgl ke Null jika tgl tidak diisi
    if ProdTxtNonEfektif.Text = '' then
      SQL.Add('tglnoneffective = null')
    else
      SQL.Add('tglnoneffective = ' + QuotedStr(FormatDateTime('yyyy-MM-dd',ProdTxtNonEfektif.Date)) );
    SQL.Add('where IDproduct = ' + DataModule1.ZQryProductIDproduct.AsString );
    ExecSQL;

  end;
end;

procedure TfrmProd.FormShowFirst;
begin
  ipcomp := getComputerIP;

  FillCombo;
  if ProdLblCaption.Caption = 'Tambah Item' then
  begin
    ProdTxtKode.Enabled := True;
    ProdTxtHrgJual.enabled := True;
    ProdTxtHrgBeli.enabled := True;

    ProdTxtKode.Text := '';
    ProdTxtNama.Text := '';
    ProdTxtMerk.Text := '';
    ProdTxtSeri.Text := '';
    ProdTxtSatuan.Text := '';
    ProdTxtKategori.Text := '';
    ProdTxtTipe.Text := '';
    ProdTxtHrgJual.Value := 0;
    ProdTxtHrgBeli.Value := 0;
    ProdTxtNonEfektif.Text := '';
    ProdTxtKeterangan.Text := '';
    ProdTxtDiskon.Value := 0;
    ProdTxtDiskonRp.Value := 0;
    edt_barcode.Text := '';
    edtnum_reorderqty.Value := 0;
  end
  else
  begin
    ProdTxtKode.Text := '';
    ProdTxtNama.Text := '';
    ProdTxtMerk.Text := '';
    ProdTxtSeri.Text := '';
    ProdTxtSatuan.Text := '';
    ProdTxtKategori.Text := '';
    ProdTxtTipe.Text := '';
    ProdTxtHrgJual.Value := 0;
    ProdTxtHrgBeli.Value := 0;
    ProdTxtNonEfektif.Text := '';
    ProdTxtKeterangan.Text := '';
    ProdTxtDiskon.Value := 0;
    ProdTxtDiskonRp.Value := 0;
    edt_barcode.Text := '';
    edtnum_reorderqty.Value := 0;

    ProdTxtKode.Enabled := true;

    if DataModule1.ZQryProductkode.IsNull=false then
    ProdTxtKode.Text := DataModule1.ZQryProductkode.Text;

    if DataModule1.ZQryProductnama.IsNull=false then
    ProdTxtNama.Text := DataModule1.ZQryProductnama.Text;

    if DataModule1.ZQryProductmerk.IsNull=false then
    ProdTxtMerk.itemindex := ProdTxtMerk.Items.IndexOf(DataModule1.ZQryProductmerk.Text);

    if DataModule1.ZQryProductseri.IsNull=false then
    ProdTxtSeri.Text := DataModule1.ZQryProductseri.Text;

    if DataModule1.ZQryProductkategori.IsNull=false then
    ProdTxtkategori.Text := DataModule1.ZQryProductkategori.Text;

    if DataModule1.ZQryProducttipe.IsNull=false then
    ProdTxttipe.itemindex := ProdTxttipe.Items.IndexOf(DataModule1.ZQryProducttipe.Text);

    if DataModule1.ZQryProductsatuan.IsNull=false then
    ProdTxtSatuan.Text := DataModule1.ZQryProductsatuan.Text;

    if DataModule1.ZQryProducthargajual.IsNull=false then
    ProdTxtHrgJual.Value := DataModule1.ZQryProducthargajual.Value;

    if DataModule1.ZQryProducthargabeli.IsNull=false then
    ProdTxtHrgbeli.Value := DataModule1.ZQryProducthargabeli.Value;

    if DataModule1.ZQryProducttglnoneffective.Text <> '' then
      ProdTxtNonEfektif.Date := DataModule1.ZQryProducttglnoneffective.Value
    else
      ProdTxtNonEfektif.Text := '';

    if DataModule1.ZQryProductketerangan.IsNull=false then
    ProdTxtKeterangan.Text := DataModule1.ZQryProductketerangan.Value;

    if DataModule1.ZQryProductdiskon.IsNull=false then
    ProdTxtDiskon.Value := DataModule1.ZQryProductdiskon.Value;

    if DataModule1.ZQryProductdiskonrp.IsNull=false then
    ProdTxtDiskonRp.Value := DataModule1.ZQryProductdiskonrp.Value;

    if DataModule1.ZQryProductbarcode.IsNull=false then
    edt_barcode.Text := DataModule1.ZQryProductbarcode.Value;

    if DataModule1.ZQryProductreorderqty.IsNull=false then
    edtnum_reorderqty.Value := DataModule1.ZQryProductreorderqty.Value;

    {    PicPath := PicturePath + '\' + DataModule1.ZQryProductkode.Text + '.jpg';
    if FileExists(PicPath) then
      ProdImage.Picture.LoadFromFile(PicPath); }
  end;
end;

procedure TfrmProd.ProdBtnAddClick(Sender: TObject);
var
  EmptyValue: Boolean;
begin
  if ProdTxtKode.Text='' then
  begin
   errorDialog('Masukkan Kode Item dahulu !');
   exit;
  end
  else if ProdTxtNama.Text='' then
  begin
   errorDialog('Masukkan Nama Item dahulu !');
   exit;
  end
  else if ProdTxtMerk.Text='' then
  begin
   errorDialog('Masukkan Merk Item dahulu !');
   exit;
  end
  else if ProdTxtTipe.Text='' then
  begin
   errorDialog('Masukkan Tipe Item dahulu !');
   exit;
  end
  else if ProdTxtsatuan.Text='' then
  begin
   errorDialog('Masukkan Satuan Item dahulu !');
   exit;
  end
  else if edtnum_reorderqty.Value<0 then
  begin
   errorDialog('Reorder Qty tidak boleh lebih kecil dari 0 !');
   exit;
  end
  else if ProdTxtHrgBeli.Value>=ProdTxtHrgJual.Value then
  begin
   errorDialog('Harga Jual harus lebih besar dari Harga Beli !');
   if IDusergroup<>1 then exit;
  end;

  with DataModule1.ZQrySearch do
  begin
    ///Check if exists
    Close;
    SQL.Clear;
    SQL.Add('select * from product');
    SQL.Add('where kode = ''' + ProdTxtKode.Text + '''');
    Open;
    EmptyValue := IsEmpty;
  end;

  if ProdLblCaption.Caption = 'Tambah Item' then
  begin
    if EmptyValue = False then
    begin
      InfoDialog('Kode ' + ProdTxtKode.Text + ' sudah terdaftar');
      Exit;
    end;

    DataModule1.ZConnection1.StartTransaction;
    try
    InsertData;
    LogInfo(UserName,'Insert Item kode: ' + ProdTxtKode.Text + ',nama: ' + ProdTxtNama.Text);
    DataModule1.ZConnection1.Commit;
    InfoDialog('Tambah Item ' + ProdTxtNama.Text + ' berhasil');
    except
     DataModule1.ZConnection1.Rollback;
     ErrorDialog('Gagal Simpan Item, coba ulangi Simpan lagi!');
    end;
  end
  else
  begin
    DataModule1.ZConnection1.StartTransaction;
    try
    UpdateData;
    LogInfo(UserName,'Edit Item kode: ' + ProdTxtKode.Text + ',nama: ' + ProdTxtNama.Text);
    DataModule1.ZConnection1.Commit;
    InfoDialog('Edit Item ' + ProdTxtNama.Text + ' berhasil');
    except
     DataModule1.ZConnection1.Rollback;
     ErrorDialog('Gagal Simpan Item, coba ulangi Simpan lagi!');
    end;
  end;

end;

procedure TfrmProd.ProdBtnDelClick(Sender: TObject);
begin
  Close;
end;

{procedure TfrmProd.ProdImageDblClick(Sender: TObject);
begin
  frmGambar.ShowModal;
  if OpenPictureDialog1.Execute and OpenPictureDialog1.FileName= '' then
  begin
    ProdImage.Picture := nil;
    ProdTxtImage.Visible := True;
  end
  else
  begin
    ProdImage.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    ProdTxtImage.Visible := False;
  end;
end;  }

procedure TfrmProd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// TUTUPFORM(Frmprod.Parent);
  IF Frmproductmaster=nil then
  application.CreateForm(TFrmproductmaster,Frmproductmaster);
  Frmproductmaster.Align:=alclient;
  Frmproductmaster.Parent:=Self.Parent;
  Frmproductmaster.BorderStyle:=bsnone;
  Frmproductmaster.FormShowFirst;
  Frmproductmaster.Show;
end;

procedure TfrmProd.ProdTxtMerkChange(Sender: TObject);
begin
 ProdTxtkategori.Text := getdata('kategori','merk where merk='+Quotedstr(trim(ProdTxtMerk.Text)) );
end;

end.
