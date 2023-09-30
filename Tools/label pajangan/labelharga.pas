unit labelharga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs,
  RzButton, RzLstBox, frxclass;

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
    lb_product: TRzListBox;
    RzLabel16: TRzLabel;
    edt_kode: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure edt_kodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellBtnDelClick(Sender: TObject);
    procedure lb_productKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SellBtnPrintClick(Sender: TObject);
  private
    { Private declarations }
    procedure inputkodebarcode(nilai:string);
  public
    { Public declarations }
  end;

var
  frmlabelharga: Tfrmlabelharga;

implementation

uses SparePartFunction, Data;

{$R *.dfm}

procedure Tfrmlabelharga.FormShow(Sender: TObject);
begin
 ipcomp := getComputerIP;
 edt_kode.Text := '';
 lb_product.Clear;
end;

procedure Tfrmlabelharga.inputkodebarcode(nilai:string);
var bufstr : string;
begin
 bufstr := trim(nilai);

 DataModule1.ZQrySearchProduct.Close;
 DataModule1.ZQrySearchProduct.SQL.Strings[0] := 'select p.*,cast("" as char(20)) faktur,p.'+kodegudang+' qty,p.'+kodegudang+'T qtytoko,p.'+kodegudang+'R qtybad,null kategori from product p ';
 DataModule1.ZQrySearchProduct.SQL.Strings[1] := '';
 DataModule1.ZQrySearchProduct.SQL.Strings[2] := 'where (p.kode='+Quotedstr(bufstr)+')or(p.barcode='+Quotedstr(bufstr)+')';
 DataModule1.ZQrySearchProduct.Open;

 if DataModule1.ZQrySearchProduct.IsEmpty then infodialog('Barang Kosong')
 else
 begin
  lb_product.Items.AddObject(DataModule1.ZQrySearchProductkode.Value+' '+DataModule1.ZQrySearchProductnama.Value,TObject(DataModule1.ZQrySearchProductIdproduct.Value));
 end;

 DataModule1.ZQrySearchProduct.Close;
end;

procedure Tfrmlabelharga.edt_kodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_RETURN then
 begin
  inputkodebarcode(edt_kode.Text);
  edt_kode.Text:='';
  edt_kode.SetFocus;
 end;
end;

procedure Tfrmlabelharga.SellBtnDelClick(Sender: TObject);
begin
 FormShow(Sender);
end;

procedure Tfrmlabelharga.lb_productKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_Delete then lb_product.Items.Delete(lb_product.ItemIndex);
end;

procedure Tfrmlabelharga.SellBtnPrintClick(Sender: TObject);
var i : integer;
    idprod1,idprod2,idprod3 : string;
    FrxMemo : TfrxMemoView;
begin
 if lb_product.Items.Count=0 then
 begin
  infodialog('Isi dahulu data product yang dipilih!');
  exit;
 end;

 ClearTabel('labelharga where ipv='+ Quotedstr(ipcomp) );

 i:=0;
 while (i < lb_product.Items.Count) do
 begin
  idprod1:='null'; idprod2:='null'; idprod3:='null';
  if i<lb_product.Items.Count then idprod1:= inttostr(longint(lb_product.Items.Objects[i]));
  if i+1<lb_product.Items.Count then idprod2:= inttostr(longint(lb_product.Items.Objects[i+1]));
  if i+2<lb_product.Items.Count then idprod3:= inttostr(longint(lb_product.Items.Objects[i+2]));

  Datamodule1.ZConnection1.ExecuteDirect('insert into labelharga (ipv,IDproduct,IDproduct2,IDproduct3) values ('+
                                        Quotedstr(ipcomp) +
                                        ',' + idprod1 + ',' + idprod2 + ',' + idprod3 + ')');
  i:=i+3;
 end;

 Datamodule1.ZQrylabelharga.Close;
 Datamodule1.ZQrylabelharga.SQL.Clear;
 Datamodule1.ZQrylabelharga.SQL.Text := 'select p1.kode kode1,p2.kode kode2,p3.kode kode3,' +
          'p1.nama nama1,p2.nama nama2,p3.nama nama3,' +
          'p1.hargajual hjual1,p2.hargajual hjual2,p3.hargajual hjual3,' +
          'p1.barcode barcode1,p2.barcode barcode2,p3.barcode barcode3 ' +
          'from labelharga l ' +
          'left join product p1 on l.IDproduct=p1.IDproduct ' +
          'left join product p2 on l.IDproduct2=p2.IDproduct ' +
          'left join product p3 on l.IDproduct3=p3.IDproduct ' +
          'where l.ipv=' + Quotedstr(ipcomp) + ' ' +
          'order by p1.kode;';

 Datamodule1.ZQrylabelharga.Open;

 Datamodule1.frxReport1.LoadFromFile(vpath+'Report\labelharga.fr3');

 FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
 FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

 Datamodule1.frxReport1.ShowReport();

 Datamodule1.ZQrylabelharga.Close;
end;

end.
