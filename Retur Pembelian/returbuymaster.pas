unit returbuymaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzDBGrid;

type
  TFrmRtrBeliMaster = class(TForm)
    PanelReturBeli: TRzPanel;
    RzPanel32: TRzPanel;
    RzLabel3: TRzLabel;
    RzGroupBox9: TRzGroupBox;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    RzLabel10: TRzLabel;
    RzLabel75: TRzLabel;
    RzLabel129: TRzLabel;
    RzLabel156: TRzLabel;
    RtrBeliBtnSearch: TAdvSmoothButton;
    RtrBeliTxtSearch: TRzEdit;
    RtrBeliTxtSearchBy: TRzComboBox;
    RtrBeliBtnClear: TAdvSmoothButton;
    RtrBeliTxtSearchFirst: TRzDateTimeEdit;
    RtrBeliTxtSearchLast: TRzDateTimeEdit;
    RtrBeliDBGrid: TPDJDBGridEx;
    pnl_cetak: TRzPanel;
    RzLabel171: TRzLabel;
    RzLabel172: TRzLabel;
    RtrBeliBtnPrint: TAdvSmoothButton;
    pnl_del: TRzPanel;
    RtrBeliBtnDel: TAdvSmoothButton;
    RzLabel6: TRzLabel;
    pnl_cetak_faktur: TRzPanel;
    RzLabel204: TRzLabel;
    RtrBtnPrintStruck: TAdvSmoothButton;
    ReturBeliDBGrid: TRzDBGrid;
    procedure RtrBeliDBGridDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure RtrBeliBtnDelClick(Sender: TObject);
    procedure RtrBeliBtnPrintClick(Sender: TObject);
    procedure RtrBeliBtnSearchClick(Sender: TObject);
    procedure RtrBeliBtnClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RtrBtnPrintStruckClick(Sender: TObject);
    procedure RtrBeliTxtSearchByChange(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListReturBeli;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmRtrBeliMaster: TFrmRtrBeliMaster;

implementation

uses SparePartFunction, Data;

{$R *.dfm}

procedure TFrmRtrBeliMaster.FormShowFirst;
begin
  ipcomp := getComputerIP;

  pnl_del.Visible    := isdel;
  
  RtrBeliTxtSearchFirst.Date := Tglskrg;
  RtrBeliTxtSearchLast.Date  := TglSkrg;

  RtrBeliBtnClearClick(Self);
end;

procedure TFrmRtrBeliMaster.RtrBeliDBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if DataModule1.ZQryReturBeliisposted.Value <> 0 then
    RtrBeliDBGrid.Canvas.Brush.Color := $00D9D9FF
  else
    RtrBeliDBGrid.Canvas.Brush.Color := clWindow;
  RtrBeliDBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);


end;


procedure TFrmRtrBeliMaster.RtrBeliBtnDelClick(Sender: TObject);
var
  Qs: string;
begin
  if DataModule1.ZQryReturBeli.IsEmpty then Exit;
  if DataModule1.ZQryReturBeliisposted.Value = 0 then
    Qs := 'Hapus Retur '
  else
    Qs := 'Faktur ' + DataModule1.ZQryReturBelifaktur.Value + ' sudah diposting !' + #13+#10 + 'Batalkan Retur ';
  if QuestionDialog(Qs + 'pembelian ' + DataModule1.ZQryReturBelifaktur.Value + ' ?') = True then
  begin
    if Qs = 'Hapus Retur ' then
    begin
      LogInfo(UserName,'Menghapus faktur retur pembelian ' + DataModule1.ZQryReturBelifaktur.Text + ', nilai pembelian : ' + FormatCurr('Rp ###,##0',DataModule1.ZQryReturBelitotalretur.Value));
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from returBelidetail');
        SQL.Add('where faktur = ''' + DataModule1.ZQryReturBelifaktur.Value + '''');
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from returBelimaster');
        SQL.Add('where faktur = ''' + DataModule1.ZQryReturBelifaktur.Value + '''');
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryReturBelifaktur.Value + ' berhasil dihapus !');
    end
    else
    begin
      LogInfo(UserName,'Membatalkan faktur retur pembelian ' + DataModule1.ZQryReturBelifaktur.Text + ', nilai retur pembelian : ' + FormatCurr('Rp ###,##0',DataModule1.ZQryReturBelitotalretur.Value));
      with DataModule1.ZQryFunction do
      begin
        {Close;
        SQL.Clear;
        SQL.Add('update returBelidetail set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryReturBelifaktur.Value + '''');
        ExecSQL;}

        Close;
        SQL.Clear;
        SQL.Add('update returBelimaster set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryReturBelifaktur.Value + '''');
        ExecSQL;

          {Close;
          SQL.Clear;
          SQL.Add('insert into operasional');
          SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
          SQL.Add('(''' + DataModule1.ZQrySellMasteridsell.AsString + ''',');
          SQL.Add('''' + DataModule1.ZQrySellMasterfaktur.Value + ''',');
          SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
          SQL.Add('''' + FormatDateTime('hh:nn:ss',Now) + ''',');
          SQL.Add('''' + UserName + ''',');
          SQL.Add('''' + 'PEMBATALAN pembelian TUNAI' + ''',');
          SQL.Add('''' + 'PEMBATALAN FAKTUR NO. ' + DataModule1.ZQrySellMasterfaktur.Value + ''',');
          SQL.Add('''' + FloatToStr(DataModule1.ZQrySellMastergrandtotal.Value) + ''')');
          ExecSQL;  }

        ///Hapus data di operasional
        Close;
        SQL.Clear;
        SQL.Add('delete from operasional ');
        SQL.Add('where faktur = ' + QuotedStr(DataModule1.ZQryReturBelifaktur.Value) + ' and kategori like "RETUR PEMBELIAN%" ' );
        ExecSQL;

        ///Hapus data di hutang

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from inventory');
        SQL.Add('where faktur = ' + Quotedstr(DataModule1.ZQryReturBelifaktur.Value) + ' and typetrans = ' + Quotedstr('retur pembelian') );
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryReturBelifaktur.Value + ' berhasil dibatalkan !');
    end;
    if Trim(RtrBeliTxtSearch.Text) = '' then RtrBeliBtnClearClick(Self)
      else RtrBeliBtnSearchClick(Self);
  end;
end;

procedure TFrmRtrBeliMaster.PrintListReturBeli;
var
  FrxMemo: TfrxMemoView;
  ketstr, SearchCategories, strfilter : string;
begin
  case RtrBeliTxtSearchby.ItemIndex of
  0 : SearchCategories := 's.faktur';
  1 : SearchCategories := 's.supplier';
  end;

  strfilter := '';
  if RtrBeliTxtSearch.Text<>'' then strfilter := 'and ('+SearchCategories + ' like ' + Quotedstr(RtrBeliTxtSearch.Text + '%') + ') ';
  DataModule1.ZQryreturitem.Close;
  DataModule1.ZQryreturitem.SQL.Text := 'select s.tanggal, s.faktur, s.supplier customer, d.nama, d.qtyretur, d.hargaBeli, (d.qtyretur*d.hargaBeli) tot, (d.diskon*d.qtyretur*d.hargaBeli*0.01) disc, d.subtotal, d.keterangan from returBelidetail d ' +
                                        'inner join returBelimaster s on d.faktur=s.faktur where (s.isposted = 1) and (s.tanggal between '+Quotedstr(getmysqldatestr(RtrBeliTxtSearchFirst.Date))+' and '+Quotedstr(getmysqldatestr(RtrBeliTxtSearchLast.Date))+') '+ strfilter +'order by s.tanggal,s.faktur,d.nama';
  DataModule1.ZQryreturitem.Open;

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\returitem.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  ketstr := '';
  if (RtrBeliTxtSearch.Text<>'')and(RtrBeliTxtSearchby.ItemIndex>=0) then ketstr := ' (' + uppercase(RtrBeliTxtSearchby.Text) + ' : ' + RtrBeliTxtSearch.Text + '...)';

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  FrxMemo.Memo.Text := 'LAPORAN RETUR PEMBELIAN'+ketstr;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := 'Tanggal ' + FormatDateTime('dd/MM/yyyy',RtrBeliTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd/MM/yyyy',RtrBeliTxtSearchLast.Date);

  DataModule1.frxReport1.ShowReport();

  DataModule1.ZQryreturitem.Close;

end;

procedure TFrmRtrBeliMaster.RtrBeliBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryReturBeli.IsEmpty then Exit;
  PrintListReturBeli;

end;

procedure TFrmRtrBeliMaster.RtrBeliBtnSearchClick(Sender: TObject);
var
  SearchCategories: string;
begin
  if (Trim(RtrBeliTxtSearch.Text) = '')and(RtrBeliTxtSearchby.ItemIndex>=0) then Exit;
  case RtrBeliTxtSearchBy.ItemIndex of
  0 : SearchCategories := 'r.faktur like ''' + RtrBeliTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'r.supplier like ''' + RtrBeliTxtSearch.Text + '%' + ''' ';
  end;

  with DataModule1.ZQryReturBeli do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select r.* from returBelimaster r ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and r.isposted = 1 ');
    SQL.Add('and r.tanggal between ''' + FormatDateTime('yyyy-MM-dd',RtrBeliTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',RtrBeliTxtSearchLast.Date) + ''' ');
    Open;
  end;

  DataModule1.ZQryReturBelidet.Close;
  DataModule1.ZQryReturBelidet.Open;

  RtrBeliBtnPrint.Enabled := true;
end;

procedure TFrmRtrBeliMaster.RtrBeliBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryReturBeli do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select r.* from returBelimaster r ');
    SQL.Add('where (r.tanggal between ''' + FormatDateTime('yyyy-MM-dd',RtrBeliTxtSearchFirst.Date) + ''' ');
    SQL.Add('and ''' + FormatDateTime('yyyy-MM-dd',RtrBeliTxtSearchLast.Date) + ''') ');
    SQL.Add('and (r.isposted = 1) ');
    Open;
  end;

  DataModule1.ZQryReturBelidet.Close;
  DataModule1.ZQryReturBelidet.Open;

  RtrBeliTxtSearch.Text := '';

  RtrBeliTxtSearchBy.ItemIndex := 0;

  RtrBeliBtnPrint.Enabled := true;
end;

procedure TFrmRtrBeliMaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 DataModule1.ZQryReturBelidet.Close;
 DataModule1.ZQryReturBeli.Close;
end;

procedure TFrmRtrBeliMaster.RtrBtnPrintStruckClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
  if (DataModule1.ZQryReturBeli.IsEmpty)or(DataModule1.ZQryReturBelifaktur.IsNull) then
  begin
   ErrorDialog('Tidak ada Retur !');
   exit;
  end;

  DataModule1.frxReport1.LoadFromFile(vpath+'Report\FakturReturBeli.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := DataModule1.ZQryReturBelifaktur.Value;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglNota'));
  FrxMemo.Memo.Text := FormatDatetime('dd/mm/yyyy',DataModule1.ZQryReturBelitanggal.Value);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NmSupplier'));
  FrxMemo.Memo.Text := DataModule1.ZQryReturBelisupplier.Value;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('AlmCustomer'));
  FrxMemo.Memo.Text := DataModule1.ZQryReturBelialamat.Value + ' ' + DataModule1.ZQryReturBelikota.Value;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemGrandTotal'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryReturBelitotalretur.Value);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Kasir'));
  FrxMemo.Memo.Text := 'Printed By ' + Username + ' ' + FormatDatetime('dd/mm/yyyy hh:nn:ss',now);

  ClearTabel('formretur where ipv='+ Quotedstr(ipcomp));

  DataModule1.ZConnection1.ExecuteDirect('insert into formretur '+
    ' (ipv,faktur,nama,quantityretur,satuan,harga,diskon,diskon_rp,diskonrp,subtotal,fakturBeli,seri,merk,kategori,kode)' +
    ' select '+Quotedstr(ipcomp)+',faktur,nama,qtyretur,satuan,hargaBeli,diskon,diskon_rp,diskonrp,subtotal,fakturBeli,seri,merk,kategori,kode from returBelidetail' +
    ' where faktur = "' + DataModule1.ZQryReturBelifaktur.Value + '" order by kode');

  DataModule1.ZQryFormRetur.Close;
  DataModule1.ZQryFormRetur.SQL.Text := 'select * from formretur where ipv='+ Quotedstr(ipcomp) + ' order by kode ';
  RefreshTabel(DataModule1.ZQryFormRetur);

  DataModule1.frxReport1.ShowReport();

end;

procedure TFrmRtrBeliMaster.RtrBeliTxtSearchByChange(Sender: TObject);
begin
  RtrBeliBtnPrint.Enabled := false;
end;

end.
