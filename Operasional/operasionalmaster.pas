unit operasionalmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzEdit, StdCtrls, RzCmboBx, Mask, RzPanel, AdvSmoothButton,
  RzLabel, Grids, DBGrids, RzDBGrid, ExtCtrls, dateutils, frxclass,
  ESDBGrids;

type
  TFrmoperasionalmaster = class(TForm)
    PanelOperasional: TRzPanel;
    RzPanel17: TRzPanel;
    RzLabel63: TRzLabel;
    RzPanel18: TRzPanel;
    RzLabel64: TRzLabel;
    RzLabel65: TRzLabel;
    RzLabel66: TRzLabel;
    RzLabel67: TRzLabel;
    OprBtnAdd: TAdvSmoothButton;
    OprBtnEdit: TAdvSmoothButton;
    OprBtnDel: TAdvSmoothButton;
    OprBtnPrint: TAdvSmoothButton;
    RzGroupBox6: TRzGroupBox;
    RzLabel68: TRzLabel;
    RzLabel69: TRzLabel;
    RzLabel70: TRzLabel;
    RzLabel71: TRzLabel;
    RzLabel72: TRzLabel;
    OprLblDateLast: TRzLabel;
    OprBtnSearch: TAdvSmoothButton;
    OprTxtSearch: TRzEdit;
    OprTxtSearchby: TRzComboBox;
    OprBtnClear: TAdvSmoothButton;
    OprTxtSearchFirst: TRzDateTimeEdit;
    OprTxtSearchLast: TRzDateTimeEdit;
    RzPanel19: TRzPanel;
    RzLabel74: TRzLabel;
    OprTxtTotal: TRzNumericEdit;
    RzPanel16: TRzPanel;
    RzLabel78: TRzLabel;
    OprTxtFilter: TRzComboBox;
    OperasionalDBGrid: TESDBGrid;
    OprBtnPrintLR: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    procedure OprBtnAddClick(Sender: TObject);
    procedure OprBtnEditClick(Sender: TObject);
    procedure OprBtnDelClick(Sender: TObject);
    procedure OprBtnPrintClick(Sender: TObject);
    procedure OprBtnSearchClick(Sender: TObject);
    procedure OprBtnClearClick(Sender: TObject);
    procedure OperasionalDBGridDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure OprTxtFilterChange(Sender: TObject);
    procedure OprBtnPrintLRClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListOperasional(SearchFirstDate,SearchLastDate : TDate; TxtFilterValue : string);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmoperasionalmaster: TFrmoperasionalmaster;
  UserRight : string;
  ShowDetail: boolean;
  vtglopr : TDate;
  vcolopr : TColor;

implementation

uses SparePartFunction, Data, frmOperasional;

{$R *.dfm}

procedure TFrmoperasionalmaster.FormShowFirst;
begin
  ShowDetail := false;

  ipcomp := getComputerIP;

  OprBtnEdit.Enabled := isedit;
  OprBtnDel.Enabled := isdel;

  OprTxtFilter.ItemIndex := 0;

  OprTxtSearchFirst.Date := startofthemonth(TglSkrg);
  OprTxtSearchLast.Date  := endofthemonth(TglSkrg);

  if UserRight = 'Administrator' then
  begin
    OprTxtSearchLast.Visible := True;
    OprLblDateLast.Visible := True;
    OprTxtSearchFirst.Width := 105;
    OprTxtSearchFirst.Enabled := True;
  end
  else
  begin
    OprTxtSearchLast.Visible := False;
    OprLblDateLast.Visible := False;
    OprTxtSearchFirst.Width := 249;
    OprTxtSearchFirst.Enabled := False;
  end;
  OprBtnClearClick(Self);

end;

procedure TFrmoperasionalmaster.OprBtnAddClick(Sender: TObject);
begin
  ShowDetail := true;
  TUTUPFORM(self.parent);
  IF frmOpr=nil then application.CreateForm(TfrmOpr,frmOpr);
  frmOpr.Align:=alclient;
  frmOpr.Parent:=self.parent;
  frmOpr.BorderStyle:=bsnone;
  frmOpr.OprLblCaption.Caption := 'Tambah Operasional';
  frmOpr.Show;

{  RefreshTabel(DataModule1.ZQryFormOperasional,'faktur',frmOpr.OprTxtNo.Text);
  if Trim(OprTxtSearch.Text) = '' then OprBtnClearClick(Self)
    else OprBtnSearchClick(Self); }

end;

procedure TFrmoperasionalmaster.OprBtnEditClick(Sender: TObject);
begin
  if DataModule1.ZQryFormOperasional.IsEmpty then Exit;
  if (DataModule1.ZQryFormOperasionalkategori.Value <> 'OPERASIONAL')and(DataModule1.ZQryFormOperasionalkategori.Value <> 'SETOR BANK') then
  begin
    ErrorDialog('Edit hanya untuk kategori operasional dan setor Bank saja');
    Exit;
  end;

  ShowDetail := true;
  TUTUPFORM(self.parent);
  IF frmOpr=nil then application.CreateForm(TfrmOpr,frmOpr);
  frmOpr.Align:=alclient;
  frmOpr.Parent:=self.parent;
  frmOpr.BorderStyle:=bsnone;
  frmOpr.OprLblCaption.Caption := 'Edit Operasional';
  frmOpr.Show;

{  RefreshTabel(DataModule1.ZQryFormOperasional,'faktur',frmOpr.OprTxtNo.Text);
  if Trim(OprTxtSearch.Text) = '' then OprBtnClearClick(Self)
    else OprBtnSearchClick(Self);  }

end;

procedure TFrmoperasionalmaster.OprBtnDelClick(Sender: TObject);
begin
  if DataModule1.ZQryFormOperasional.IsEmpty then Exit;
  if (DataModule1.ZQryFormOperasionalkategori.Value <> 'OPERASIONAL')and(DataModule1.ZQryFormOperasionalkategori.Value <> 'SETOR BANK') then
  begin
    ErrorDialog('Hapus hanya untuk kategori operasional dan setor Bank saja');
    Exit;
  end;
  if QuestionDialog('Hapus operasional ' + DataModule1.ZQryFormOperasionalfaktur.Value + ' ?') = True then
  begin
    LogInfo(UserName,'Menghapus operasional ' + DataModule1.ZQryFormOperasionalfaktur.Text + ', nilai operasional : ' + FormatCurr('Rp ###,##0', DataModule1.ZQryFormOperasionaldebet.Value));
    frmOpr.DeleteData(DataModule1.ZQryFormOperasionalfaktur.Value);
  end;

end;

procedure TFrmoperasionalmaster.PrintListOperasional(SearchFirstDate,SearchLastDate : TDate; TxtFilterValue : string);
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\operasional.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := HeaderTitleRep;
  if UserRight = 'Administrator' then
  begin
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglTransaksi'));
    FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMM yyyy',SearchFirstDate) + ' s/d Tgl ' + FormatDateTime('dd MMM yyyy',SearchLastDate);
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NmKasir'));
    FrxMemo.Memo.Text := UserName;
  end
  else
  begin
    if TxtFilterValue <> 'Operasional' then
    begin
      ErrorDialog('Hanya bisa cetak transaksi operasional saja !');
      Exit;
    end;
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglTransaksi'));
    FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMM yyyy',SearchFirstDate);
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NmKasir'));
    FrxMemo.Memo.Text := 'Kasir : ' + UserName;
  end;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',Now) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmoperasionalmaster.OprBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryFormOperasional.IsEmpty then Exit;
  PrintListOperasional(OprTxtSearchFirst.Date,OprTxtSearchLast.Date,OprTxtFilter.Value);

end;

procedure TFrmoperasionalmaster.OprBtnSearchClick(Sender: TObject);
var
  SearchCategories, FilterView: string;
  SisaSaldo: string;
begin
  if Trim(OprTxtSearch.Text) = '' then Exit;

  case OprTxtSearchby.ItemIndex of
  0 : SearchCategories := 'faktur';
  1 : SearchCategories := 'kategori';
  end;

  case OprTxtFilter.ItemIndex of
  0: FilterView := '';
  1: FilterView := 'and kategori = ''' + 'OPERASIONAL' + '''';
  2: FilterView := 'and kategori like ''' + '%PEMBELIAN%' + '''';
  3: FilterView := 'and kategori like ''' + '%PENJUALAN%' + '''';
  4: FilterView := 'and kategori = ''' + 'SETOR BANK' + '''';
  5: FilterView := 'and debet > 0 and kategori <> ''%TRANSFER%''';
  6: FilterView := 'and kredit > 0 and kategori <> ''%TRANSFER%''';
  end;

  ///Clear Table Form Operasional
  ClearTabel('formkeuangan where ipv='+ Quotedstr(ipcomp));

  ///Cari Jumlah sisa saldo di awal
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(debet-kredit) as saldo from operasional');
    SQL.Add('where tanggal < ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + ''' and kategori<>''%TRANSFER%''');
    Open;

    if Fields[0].AsString = '' then
      SisaSaldo := '0'
    else
      SisaSaldo := Fields[0].AsString;

    Close;
    SQL.Clear;
    SQL.Add('insert into formkeuangan ');
    SQL.Add('(ipv,idoperasional,idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
    SQL.Add('('+Quotedstr(ipcomp)+',''' + '0' + ''',');
    SQL.Add('''' + '0' + ''',');
    SQL.Add('''' + '0' + ''',');
    SQL.Add('''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + ''',');
    SQL.Add('''' + '00:00:01' + ''',');
    SQL.Add('''' + 'ADMIN' + ''',');
    SQL.Add('''' + 'SALDO AWAL' + ''',');
    SQL.Add('''' + 'Saldo Tgl ' + FormatDateTime('dd MM yyyy',OprTxtSearchFirst.Date - 1) + ''',');
    SQL.Add('''' + SisaSaldo + ''')');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into formkeuangan ');
    SQL.Add('select '+Quotedstr(ipcomp)+',* from operasional');
    SQL.Add('where ' + SearchCategories + ' like ''' + OprTxtSearch.Text + '%' + '''');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('and tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView);
    end
    else
    begin
      SQL.Add('and tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView);
    end;
    ExecSQL;
  end;

  FilterView := FilterView + ' or Kategori = ''' + 'SALDO AWAL' + '''';
  DataModule1.ZSQLProcessor1.Execute;
  with DataModule1.ZQryFormOperasional do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,@balance:=(@balance+debet-kredit) as saldo from formkeuangan ');
    SQL.Add('where ipv='+Quotedstr(ipcomp)+' and ' + SearchCategories + ' like ''' + OprTxtSearch.Text + '%' + '''');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('and tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView+' order by tanggal,waktu,faktur');
    end
    else
    begin
      SQL.Add('and tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView+' order by tanggal,waktu,faktur');
    end;
    Open;
  end;

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(debet - kredit) from operasional');
    SQL.Add('where ' + SearchCategories + ' like ''' + OprTxtSearch.Text + '%' + '''');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('and tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView);
    end
    else
    begin
      SQL.Add('and tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView);
    end;
    Open;
    OprTxtTotal.Value := Fields[0].AsFloat;
  end;

end;

procedure TFrmoperasionalmaster.OprBtnClearClick(Sender: TObject);
var
  FilterView, SisaSaldo: string;
begin
  case OprTxtFilter.ItemIndex of
  0: FilterView := '';
  1: FilterView := 'and kategori = ''' + 'OPERASIONAL' + '''';
  2: FilterView := 'and kategori like ''' + '%PEMBELIAN%' + '''';
  3: FilterView := 'and kategori like ''' + '%PENJUALAN%' + '''';
  4: FilterView := 'and kategori = ''' + 'SETOR BANK' + '''';
  5: FilterView := 'and debet > 0 and kategori <> ''%TRANSFER%''';
  6: FilterView := 'and kredit > 0 and kategori <> ''%TRANSFER%''';
  end;

  ///Clear Table Form Operasional
  ClearTabel('formkeuangan where ipv='+ Quotedstr(ipcomp));

  ///Cari Jumlah sisa saldo di awal
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(debet-kredit) as saldo from operasional');
    SQL.Add('where tanggal < ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + ''' and kategori<>''%TRANSFER%''');
    Open;

    if Fields[0].AsString = '' then
      SisaSaldo := '0'
    else
      SisaSaldo := Fields[0].AsString;

    Close;
    SQL.Clear;
    SQL.Add('insert into formkeuangan ');
    SQL.Add('(ipv,idoperasional,idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
    SQL.Add('('+Quotedstr(ipcomp)+',''' + '0' + ''',');
    SQL.Add('''' + '0' + ''',');
    SQL.Add('''' + '0' + ''',');
    SQL.Add('''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + ''',');
    SQL.Add('''' + '00:00:01' + ''',');
    SQL.Add('''' + 'ADMIN' + ''',');
    SQL.Add('''' + 'SALDO AWAL' + ''',');
    SQL.Add('''' + 'Saldo Tgl ' + FormatDateTime('dd MM yyyy',OprTxtSearchFirst.Date - 1) + ''',');
    SQL.Add('''' + SisaSaldo + ''')');
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into formkeuangan (ipv,idoperasional,idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet,kredit,fakturpay,saldoawaltagihan) ');
    SQL.Add('select '+Quotedstr(ipcomp)+',idoperasional,idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet,kredit,fakturpay,saldoawaltagihan from operasional');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('where tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView);
    end
    else
    begin
      SQL.Add('where tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView)
    end;
    ExecSQL;
  end;

  FilterView := FilterView + ' or Kategori = ''' + 'SALDO AWAL' + '''';
  DataModule1.ZSQLProcessor1.Execute;
  with DataModule1.ZQryFormOperasional do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,@balance:=(@balance+debet-kredit) as saldo from formkeuangan ');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('where ipv='+ Quotedstr(ipcomp) + ' and tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView+' order by tanggal,waktu,faktur')
    end
    else
    begin
      SQL.Add('where ipv='+ Quotedstr(ipcomp) + ' and tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView+' order by tanggal,waktu,faktur')
    end;
    Open;

  end;
  OprTxtSearch.Text := '';

  ///Cari Total Nilai Jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(debet - kredit) from operasional');
    if UserRight = 'Administrator' then
    begin
      SQL.Add('where tanggal >= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '''');
      SQL.Add(FilterView);
    end
    else
    begin
      SQL.Add('where tanggal = ''' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '''');
      SQL.Add('and kasir = ''' + UserName + '''');
      SQL.Add(FilterView);
    end;
    Open;
    OprTxtTotal.Value := Fields[0].AsFloat;
  end;

end;

procedure TFrmoperasionalmaster.OperasionalDBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  ///Jika ada operasional yang bersifat biaya, warna merah
  ///Jika ada operasional yang bersifat pendapatan, warna hijau

{  if DataModule1.ZQryFormOperasionaldebet.Value > 0 then
    OperasionalDBGrid.Canvas.Brush.Color := clLime
  else
    OperasionalDBGrid.Canvas.Brush.Color := clRed;
 }
  if Column.Index=0 then
  begin
   if (DataModule1.ZQryFormOperasional.RecNo<>1)and(vtglopr<>DataModule1.ZQryFormOperasionaltanggal.Value) then
   begin
    if vcolopr = clWindow then vcolopr := $0080FFFF else vcolopr := clWindow;
   end;

   vtglopr:=DataModule1.ZQryFormOperasionaltanggal.Value;
  end;

  if (vcolopr<>clwindow)and(vcolopr<>$0080FFFF) then vcolopr:=clwindow;

  OperasionalDBGrid.Canvas.Brush.Color:=vcolopr;

  OperasionalDBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmoperasionalmaster.OprTxtFilterChange(Sender: TObject);
begin
  if OprTxtSearch.Text = '' then
    OprBtnClearClick(Self)
  else
    OprBtnSearchClick(Self);

end;

procedure TFrmoperasionalmaster.OprBtnPrintLRClick(Sender: TObject);
var
  FrxMemo: TfrxMemoView;
begin
  if DataModule1.ZQryFormOperasional.IsEmpty then Exit;

        ClearTabel('reportrugilaba where ipv='+ Quotedstr(ipcomp));
        with DataModule1.ZQrySearch do
        begin
          Close;
          SQL.Clear;
          SQL.Add('insert into reportrugilaba (ipv,tanggal,labakotor,keterangan)');
          SQL.Add('select '+Quotedstr(ipcomp)+',null,sum((a.hargajual * a.quantity)-(a.hargabeli * a.quantity)) as labakotor,"Penjualan" from selldetail a left join sellmaster b');
          SQL.Add('on a.faktur = b.faktur');
          SQL.Add('where (b.isposted=1) and (b.tanggal between "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '"');
          SQL.Add('and "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '")');
          ExecSQL;

          SQL.Clear;
          SQL.Add('insert into reportrugilaba (ipv,tanggal,labakotor,keterangan)');
          SQL.Add('select '+Quotedstr(ipcomp)+',null,sum((a.hargajual * a.qtyretur)-(a.hargabeli * a.qtyretur)) * -1 as labakotor,"Retur Penjualan" from returjualdetail a left join returjualmaster b');
          SQL.Add('on a.faktur = b.faktur');
          SQL.Add('where (b.isposted=1) and (b.tanggal between "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '"');
          SQL.Add('and "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '") having (labakotor<>0) ');
          ExecSQL;

          Close;
          SQL.Clear;
          SQL.Add('insert into reportrugilaba (ipv,tanggal,operasional,keterangan)');
          SQL.Add('select '+Quotedstr(ipcomp)+',tanggal,kredit as operasional,keterangan from operasional');
          SQL.Add('where (kategori="OPERASIONAL") and (kredit<>0) and (tanggal between "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchFirst.Date) + '"');
          SQL.Add('and "' + FormatDateTime('yyyy-MM-dd',OprTxtSearchLast.Date) + '")');
         { SQL.Add('on duplicate key update operasional = (select sum(kredit) as operasional from operasional');
          SQL.Add('where tanggal >= ''' + FormatDateTime('yyyy-MM-dd',RptCashTxtStartDate.Date) + '''');
          SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',RptCashTxtFinishDate.Date) + ''')'); }
          ExecSQL;
        end;

        DataModule1.ZQryListRugiLaba.Close;
        DataModule1.ZQryListRugiLaba.SQL.Strings[0] := 'select *,labakotor-operasional-pajak as lababersih from reportrugilaba where ipv='+ Quotedstr(ipcomp);
        DataModule1.ZQryListRugiLaba.Open;
        RefreshTabel(DataModule1.ZQryListRugiLaba);

        if DataModule1.ZQryListRugiLaba.IsEmpty then
        begin
          ErrorDialog('Tidak ada Transaksi pada tanggal tersebut');
          Exit;
        end;

        DataModule1.frxReport1.LoadFromFile(vpath+'Report\labarugi.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMM yyyy',OprTxtSearchFirst.Date) + ' s/d ' + FormatDateTime('dd MMM yyyy',OprTxtSearchLast.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('dd-mm-yyyy hh:nn:ss',Now) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();

end;

end.
