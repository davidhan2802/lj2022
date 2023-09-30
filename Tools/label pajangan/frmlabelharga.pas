unit frmlabelharga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG, DB,
  RzButton, RzRadChk, RzLstBox;

type
  Tfrmlabelharga = class(TForm)
    Panelsales: TRzPanel;
    RzPanel2: TRzPanel;
    LblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    SellBtnPrint: TAdvSmoothButton;
    SellBtnDel: TAdvSmoothButton;
    RzListBox1: TRzListBox;
    RzLabel16: TRzLabel;
    edt_kode: TRzEdit;
  private
    procedure InsertData;
    procedure UpdateData;
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  frmlabelharga: Tfrmlabelharga;

implementation

uses SparePartFunction, Data;

{$R *.dfm}

procedure Tfrmlabelharga.InsertData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.sales');
    SQL.Add('(kode,nama,alamat,kota,tempatlahir,tgllahir,tglmasuk,noktp,tglnoneffective) values');
    SQL.Add('(' + QuotedStr(SalesTxtKode.Text) + ',');
    SQL.Add( QuotedStr(SalesTxtNama.Text) + ',');
    SQL.Add( QuotedStr(SalesTxtAlamat.Text) + ',');
    SQL.Add( QuotedStr(SalesTxtKota.Text) + ',');
    SQL.Add( QuotedStr(SalesTxttempatlahir.Text) + ',');
    SQL.Add( QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtTglLahir.Date)) + ',');
    SQL.Add( QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtTglmasuk.Date)) + ',');
    SQL.Add( QuotedStr(SalesTxtnoktp.Text) + ',');
    if SalesTxtNonEfektif.Text = '' then
      SQL.Add('null)')
    else
      SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtNonEfektif.Date)) + ')');
    ExecSQL;
  end;
end;

procedure Tfrmlabelharga.UpdateData;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update sparepart.sales set ');
    SQL.Add('nama = ' + QuotedStr(SalesTxtNama.Text) + ',');
    SQL.Add('alamat = ' + QuotedStr(SalesTxtAlamat.Text) + ',');
    SQL.Add('kota = ' + QuotedStr(SalesTxtKota.Text) + ',');
    SQL.Add('tempatlahir = ' + QuotedStr(SalesTxttempatlahir.Text) + ',');
    SQL.Add('noktp = ' + QuotedStr(SalesTxtnoktp.Text) + ',');

    if SalesTxtTgllahir.Text='' then
       SQL.Add('tgllahir = null,')
    else SQL.Add('tgllahir = ' + QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtTgllahir.Date)) +',');

    if SalesTxtTglmasuk.Text='' then
       SQL.Add('tglmasuk = null,')
    else SQL.Add('tglmasuk = ' + QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtTglmasuk.Date)) +',');

    if SalesTxtNonEfektif.Text='' then
       SQL.Add('tglnoneffective = null')
    else SQL.Add('tglnoneffective = ' + QuotedStr(FormatDateTime('yyyy-MM-dd',SalesTxtNonEfektif.Date)) );
    SQL.Add('where kode = ' + QuotedStr(SalesTxtKode.Text));
    ExecSQL;
  end;
end;


procedure Tfrmlabelharga.FormShowFirst;
begin
  if LblCaption.Caption = 'Tambah Sales' then
  begin
    SalesTxtKode.Enabled := True;
    SalesTxtKode.Text := '';
    SalesTxtNama.Text := '';
    SalesTxtAlamat.Text := '';
    SalesTxtKota.Text := '';
    SalesTxtnoktp.Text := '';
    SalesTxtTempatlahir.Text := '';
    SalesTxttgllahir.Text := '';
    SalesTxttglmasuk.Date := TglSkrg;
    SalesTxtNonEfektif.Enabled := False;
    SalesTxtNonEfektif.Text := '';
  end
  else
  begin
    SalesTxtKode.Text := '';
    SalesTxtNama.Text := '';
    SalesTxtAlamat.Text := '';
    SalesTxtKota.Text := '';
    SalesTxtnoktp.Text := '';
    SalesTxtTempatlahir.Text := '';

    SalesTxtKode.Enabled := False;

    if DataModule1.ZQrySaleskode.IsNull=false then
    SalesTxtKode.Text := DataModule1.ZQrySaleskode.Text;

    if DataModule1.ZQrySalesnama.IsNull=false then
    SalesTxtNama.Text := DataModule1.ZQrySalesnama.Text;

    if DataModule1.ZQrySalesalamat.IsNull=false then
    SalesTxtAlamat.Text := DataModule1.ZQrySalesalamat.Text;

    if DataModule1.ZQrySaleskota.IsNull=false then
    SalesTxtKota.Text := DataModule1.ZQrySaleskota.Text;

    if DataModule1.ZQrySalesnoktp.IsNull=false then
    SalesTxtnoktp.Text := DataModule1.ZQrySalesnoktp.Text;

    if DataModule1.ZQrySalestgllahir.Text <> '' then
      SalesTxtTgllahir.Date := DataModule1.ZQrySalestgllahir.Value
    else
      SalesTxtTgllahir.Text := '';

    if DataModule1.ZQrySalestglmasuk.Text <> '' then
      SalesTxtTglmasuk.Date := DataModule1.ZQrySalestglmasuk.Value
    else
      SalesTxtTglmasuk.Text := '';

    if DataModule1.ZQrySalestglnoneffective.Text <> '' then
      SalesTxtNonEfektif.Date := DataModule1.ZQrySalestglnoneffective.Value
    else
      SalesTxtNonEfektif.Text := '';
  end;
end;

end.
