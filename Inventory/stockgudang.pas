unit stockgudang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzButton, RzRadChk, dateutils, db,
  RzRadGrp;

type
  TFrmstockgudanglist = class(TForm)
    PanelPenjualan: TRzPanel;
    RzPanel11: TRzPanel;
    RzLabel39: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    RzLabel60: TRzLabel;
    SellLblDateLast: TRzLabel;
    SellTxtSearchFirst: TRzDateTimeEdit;
    SellTxtSearchLast: TRzDateTimeEdit;
    pnl_cetak_list: TRzPanel;
    RzLabel43: TRzLabel;
    SellBtnPrintList: TAdvSmoothButton;
    RzPanel15: TRzPanel;
    RzLabel62: TRzLabel;
    SellTxtTotalJual: TRzNumericEdit;
    RzLabel1: TRzLabel;
    cb_gudang: TRzComboBox;
    RzPanel1: TRzPanel;
    btn_expdaterep: TAdvSmoothButton;
    RzLabel2: TRzLabel;
    RGgroup: TRzRadioGroup;
    Panel1: TPanel;
    DBGmaster: TPDJDBGridEx;
    DBGdet: TPDJDBGridEx;
    btn_mutasirep: TAdvSmoothButton;
    RzLabel3: TRzLabel;
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SellTxtSearchFirstChange(Sender: TObject);
    procedure btn_expdaterepClick(Sender: TObject);
    procedure btn_mutasirepClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmstockgudanglist: TFrmstockgudanglist;

implementation

uses SparePartFunction, Data;

{$R *.dfm}

procedure TFrmstockgudanglist.FormShowFirst;
begin
 ipcomp := getComputerIP;

 pnl_cetak_list.Visible   := true;//isprintlistpenjualan;

 cb_gudang.Clear;
 SellTxtSearchFirst.Date := dateof(incday(TglSkrg,-365));
 SellTxtSearchLast.Date  := dateof(TglSkrg);

 Fill_ComboBox_with_Data_n_ID(cb_gudang,'select IDgudang,namagudang from gudang where left(kodegudang,2)='+Quotedstr(kodegudang)+' order by IDgudang','namagudang','IDgudang',true);
 cb_gudang.Items[0] := 'TOKO & '+namagudang;
 cb_gudang.ItemIndex:=0;
 SellTxtSearchFirstChange(Self);
end;

procedure TFrmstockgudanglist.SellBtnPrintListClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
  if DataModule1.ZQryStokGol.IsEmpty then Exit;

  case RGgroup.ItemIndex of
  0 : DataModule1.frxReport1.LoadFromFile(vpath+'Report\stokgudang.fr3');
  1 : DataModule1.frxReport1.LoadFromFile(vpath+'Report\stokgudangdet.fr3');
  2 : DataModule1.frxReport1.LoadFromFile(vpath+'Report\stokgudangdetdept.fr3');
  end;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',tglskrg) ;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('judul'));
  if RGgroup.ItemIndex=2 then FrxMemo.Memo.Text := 'LAPORAN STOK ' + cb_gudang.Text + ' (KODE DEPT : ' + DataModule1.ZQrystokGolkode.Value + ')'
  else FrxMemo.Memo.Text := 'LAPORAN STOK ' + cb_gudang.Text;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  FrxMemo.Memo.Text := 'PERIODE ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchLast.Date);
  DataModule1.frxReport1.ShowReport();

end;

procedure TFrmstockgudanglist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// if ShowDetail=false then

 DataModule1.ZQryStokGol.Close;

end;

procedure TFrmstockgudanglist.SellTxtSearchFirstChange(Sender: TObject);
var strgdg : string;
begin
  if cb_gudang.Items.Count=0 then exit;

  strgdg := '';
  case cb_gudang.ItemIndex of
   0 : strgdg := 'p.'+kodegudang+'+p.'+kodegudang+'T';
   1 : strgdg := 'p.'+kodegudang;
   2 : strgdg := 'p.'+kodegudang+'T';
   3 : strgdg := 'p.'+kodegudang+'R';
  end;

  with DataModule1.ZQryStokGol do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select g.IDgolongan,g.kode,g.nama,sum('+strgdg+') qty, sum('+strgdg+')*p.hargabeli value from product p ');
    SQL.Add('left join golongan g on p.IDgolongan=g.IDgolongan ');
    SQL.Add('group by g.IDgolongan,g.kode,g.nama having qty<>0 ');
    SQL.Add('order by g.kode;');

    Open;
    Last;
  end;

  with DataModule1.ZQryStokGoldet do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select p.IDgolongan,p.kode,p.barcode,p.nama,sum('+strgdg+') qty, sum('+strgdg+')*p.hargabeli value from product p ');
    SQL.Add('where p.IDgolongan=:IDgolongan ');
    SQL.Add('group by p.IDgolongan,p.kode,p.barcode,p.nama having qty<>0 ');
    SQL.Add('order by p.kode;');

    Open;
  end;

  ///Cari Total Nilai Jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum('+strgdg+')*p.hargabeli value from product p ');
    Open;
    SellTxtTotalJual.Value := Fields[0].AsFloat;
    Close;
  end;
end;

procedure TFrmstockgudanglist.btn_expdaterepClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
 DataModule1.ZQrystokexpdate.close;
 DataModule1.ZQrystokexpdate.SQL.Clear;
 DataModule1.ZQrystokexpdate.SQL.Text := 'select kode,barcode,nama,hargabeli,hargajual,('+kodegudang+'+'+kodegudang+'T) qty,expdate,datediff(expdate,now()) sisahari from product ' +
                                         'where expdate is not null and date(now())>=expdate ' +
                                         'order by kode;';
 DataModule1.ZQrystokexpdate.open;

 if DataModule1.ZQrystokexpdate.isempty then
 begin
  infodialog('Tidak ada Data.');
  exit;
 end;

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\stokexpdate.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',tglskrg) ;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('judul'));
  FrxMemo.Memo.Text := 'DAFTAR KADALUARSA BARANG (TOKO DAN ' + namagudang + ')';

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  FrxMemo.Memo.Text := 'Mulai Tanggal ' + FormatDateTime('dd/MM/yyyy',Tglskrg);
  DataModule1.frxReport1.ShowReport();

 DataModule1.ZQrystokexpdate.close;

end;

procedure TFrmstockgudanglist.btn_mutasirepClick(Sender: TObject);
var FrxMemo: TfrxMemoView;
    strgdg : string;
begin
  if cb_gudang.Items.Count=0 then exit;

  strgdg := '';
  case cb_gudang.ItemIndex of
   0 : strgdg := '((i.kodegudang='+Quotedstr(kodegudang)+')or(i.kodegudang='+Quotedstr(kodegudang+'T')+')) and ';
   1 : strgdg := '(i.kodegudang='+Quotedstr(kodegudang)+') and ';
   2 : strgdg := '(i.kodegudang='+Quotedstr(kodegudang+'T')+') and ';
   3 : strgdg := '(i.kodegudang='+Quotedstr(kodegudang+'R')+') and ';
  end;

 DataModule1.ZQrystokmutasirep.close;
 DataModule1.ZQrystokmutasirep.SQL.Clear;
 DataModule1.ZQrystokmutasirep.SQL.Text :=
 'select g.kode,g.nama,(select coalesce(sum(y1.qty),0) from inventory y1 where (y1.kodegudang=i.kodegudang) and (y1.kodebrg=i.kodebrg) and (y1.tgltrans<'+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+')) qtyawal,' +
 '(select coalesce(sum(y2.qty)*p.hargabeli,0) from inventory y2 where (y2.kodegudang=i.kodegudang) and (y2.kodebrg=i.kodebrg) and (y2.tgltrans<'+Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date))+')) amountawal,' +
 'sum(if(i.qty>0,i.qty,0)) qtymasuk,sum(if(i.qty>0,i.qty,0))*p.hargabeli amountmasuk,' +
 '-1*sum(if((i.qty<0)and(trim(i.`typetrans`)="penjualan"),i.qty,0)) qtyjual,' +
 '-1*sum(if((i.qty<0)and(trim(i.`typetrans`)="penjualan"),i.qty,0))*p.hargabeli amountjual,' +
 '-1*sum(if((i.qty<0)and(trim(i.`typetrans`)<>"penjualan"),i.qty,0)) qtykeluar,' +
 '-1*sum(if((i.qty<0)and(trim(i.`typetrans`)<>"penjualan"),i.qty,0))*p.hargabeli amountkeluar ' +
 'from inventory i ' +
 'left join product p on i.`kodebrg`=p.kode ' +
 'left join golongan g on p.`IDgolongan`=g.`IDgolongan` ' +
 'where '+strgdg+'(i.tgltrans between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ' +
 'and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) + ') ' +
 'group by g.kode,g.nama having (qtyawal+amountawal+qtymasuk+amountmasuk+qtyjual+amountjual+qtykeluar+amountkeluar)<>0 order by g.kode; ';

 DataModule1.ZQrystokmutasirep.open;

 if DataModule1.ZQrystokmutasirep.isempty then
 begin
  infodialog('Tidak ada Data.');
  exit;
 end;

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\stokmutasi.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',tglskrg) ;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('judul'));
  FrxMemo.Memo.Text := 'LAPORAN MUTASI STOK ' + cb_gudang.Text;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  FrxMemo.Memo.Text := 'PERIODE ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',SellTxtSearchLast.Date);

  DataModule1.frxReport1.ShowReport();

 DataModule1.ZQrystokmutasirep.close;

end;

end.
