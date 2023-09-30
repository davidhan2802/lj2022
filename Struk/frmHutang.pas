unit frmHutang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG;

type
  TfrmHtg = class(TForm)
    Panel: TRzPanel;
    RzPanel2: TRzPanel;
    LblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    RzLabel12: TRzLabel;
    RzLabel14: TRzLabel;
    HtgBtnAdd: TAdvSmoothButton;
    HtgBtnDel: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel5: TRzLabel;
    HtgTxtTgl: TRzDateTimeEdit;
    HtgTotal: TRzNumericEdit;
    RzLabel6: TRzLabel;
    HtgTxtNamaSupp: TRzEdit;
    HtgTxtFaktur: TRzEdit;
    procedure HtgBtnAddClick(Sender: TObject);
    procedure HtgBtnDelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure DeleteData(Data: String);
    { Public declarations }
  end;

var
  frmHtg: TfrmHtg;

implementation

uses SparePartFunction, Data, DB, hutangmaster;

{$R *.dfm}

procedure TfrmHtg.DeleteData(Data: String);
var
  Nama: string;
  PosRecord: integer;
begin
  Nama := Data;
  LogInfo(UserName,'Menghapus Pembayaran Faktur ' + Nama);
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Delete from sparepart.operasional');
    SQL.Add('where faktur = ' + Quotedstr(Nama) + ' and kategori = '+ Quotedstr('HUTANG PEMBELIAN') );
    ExecSQL;
  end;

//  DataModule1.ZConnection1.Executedirect('update sparepart.buymaster set lunas=0');

  PosRecord := DataModule1.ZQryHutang.RecNo;
  DataModule1.ZQryHutang.Close;
  DataModule1.ZQryHutang.Open;
  DataModule1.ZQryHutang.RecNo := PosRecord;
  InfoDialog('Pembayaran ' + Nama + ' berhasil dibatalkan !');
end;

procedure TfrmHtg.HtgBtnAddClick(Sender: TObject);
begin
  if HtgTxtTgl.Text='' then
  begin
   errordialog('Tanggal wajib diisi !');
   exit;
  end;

  if QuestionDialog('Terima Pelunasan Faktur ' + HtgTxtFaktur.Text + ' ?') = False then Exit;
  with DataModule1.ZQryFunction do
  begin
    ///Input ke Operasional
    Close;
    SQL.Clear;
    SQL.Add('insert into sparepart.operasional');
    SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,kredit) values');
    SQL.Add('(''' + DataModule1.ZQryHutangidBeli.AsString + ''',');
    SQL.Add('''' + DataModule1.ZQryHutangfaktur.Value + ''',');
    SQL.Add('''' + FormatDateTime('yyyy-MM-dd',HtgTxtTgl.Date) + ''',');
    SQL.Add('''' + FormatDateTime('hh:nn:ss',Now) + ''',');
    SQL.Add('''' + UserName + ''',');
    SQL.Add('''' + 'HUTANG PEMBELIAN' + ''',');
    SQL.Add('''' + 'Pembayaran Hutang' + ''',');
    SQL.Add('''' + FloatToStr(HtgTotal.Value) + ''')');
    ExecSQL;

    ///Edit SellMaster
    Close;
    SQL.Clear;
    SQL.Add('update sparepart.buymaster set lunas=1, totalpayment=grandtotal ');
    SQL.Add('where faktur = ''' + DataModule1.ZQryHutangfaktur.Value + '''');
    ExecSQL;
  end;

  InfoDialog('Pelunasan Hutang Faktur ' + HtgTxtFaktur.Text + ' berhasil diterima ');
  LogInfo(UserName,'Pelunasan Hutang Faktur ' + HtgTxtFaktur.Text + ' sebesar ' + FormatCurr('Rp ###,##0',HtgTotal.Value));
  Close;
end;

procedure TfrmHtg.HtgBtnDelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHtg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 IF Frmhutangmaster=nil then
 application.CreateForm(TFrmhutangmaster,Frmhutangmaster);
 Frmhutangmaster.Align:=alclient;
 Frmhutangmaster.Parent:=Self.Parent;
 Frmhutangmaster.BorderStyle:=bsnone;
// Frmhutangmaster.FormShowFirst;
 Frmhutangmaster.FormShowFirst;
 Frmhutangmaster.Show;
end;

end.
