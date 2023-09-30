unit adjustmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass;

type
  TFrmadjustmaster = class(TForm)
    PanelAdjust: TRzPanel;
    RzPanel53: TRzPanel;
    RzLabel219: TRzLabel;
    RzPanel54: TRzPanel;
    RzLabel220: TRzLabel;
    RzLabel221: TRzLabel;
    RzLabel222: TRzLabel;
    RzLabel223: TRzLabel;
    AdjustBtnAdd: TAdvSmoothButton;
    AdjustBtnDel: TAdvSmoothButton;
    AdjustBtnPosting: TAdvSmoothButton;
    RzGroupBox11: TRzGroupBox;
    RzLabel224: TRzLabel;
    RzLabel225: TRzLabel;
    RzLabel226: TRzLabel;
    RzLabel227: TRzLabel;
    RzLabel228: TRzLabel;
    RzLabel229: TRzLabel;
    AdjustBtnSearch: TAdvSmoothButton;
    AdjustTxtSearch: TRzEdit;
    AdjustTxtSearchBy: TRzComboBox;
    AdjustBtnClear: TAdvSmoothButton;
    AdjustTxtSearchFirst: TRzDateTimeEdit;
    AdjustTxtSearchLast: TRzDateTimeEdit;
    AdjustDBGrid: TPDJDBGridEx;
    pnl_cetak: TRzPanel;
    RzLabel230: TRzLabel;
    RzLabel231: TRzLabel;
    AdjustBtnPrint: TAdvSmoothButton;
    AdvSmoothButton9: TAdvSmoothButton;
    AdjustBtnEdit: TAdvSmoothButton;
    procedure AdjustBtnAddClick(Sender: TObject);
    procedure AdjustBtnEditClick(Sender: TObject);
    procedure AdjustBtnDelClick(Sender: TObject);
    procedure AdjustBtnPostingClick(Sender: TObject);
    procedure AdjustBtnPrintClick(Sender: TObject);
    procedure AdjustBtnSearchClick(Sender: TObject);
    procedure AdjustBtnClearClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintListAdjust;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmadjustmaster: TFrmadjustmaster;

implementation

uses frmAdjust, SparePartFunction, Data;

{$R *.dfm}

procedure TFrmadjustmaster.FormShowFirst;
begin
 pnl_cetak.Visible := isprintfakturadjust;

 AdjustTxtSearchFirst.Date := TglSkrg;
 AdjustTxtSearchLast.Date  := TglSkrg;

 AdjustBtnClearClick(AdjustBtnClear);
end;

procedure TFrmadjustmaster.AdjustBtnAddClick(Sender: TObject);
begin
  with frmAdj do
  begin
    LblCaption.Caption := 'Tambah Penyesuaian';
    ShowModal;
  end;
  RefreshTabel(DataModule1.ZQryAdjust);
  if Trim(AdjustTxtSearch.Text) = '' then AdjustBtnClearClick(Self)
    else AdjustBtnSearchClick(Self);
  DataModule1.ZQryAdjust.Last;

end;

procedure TFrmadjustmaster.AdjustBtnEditClick(Sender: TObject);
begin
  if DataModule1.ZQryAdjust.IsEmpty then Exit;
  if DataModule1.ZQryAdjustisposted.Value <> 0 then
  begin
    ErrorDialog('Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' tidak bisa diedit karena sudah diposting');
    Exit;
  end;
  with frmAdj do
  begin
    LblCaption.Caption := 'Edit Penyesuaian';
    ShowModal;
  end;
  RefreshTabel(DataModule1.ZQryAdjust);
  if Trim(AdjustTxtSearch.Text) = '' then AdjustBtnClearClick(Self)
    else AdjustBtnSearchClick(Self);

end;

procedure TFrmadjustmaster.AdjustBtnDelClick(Sender: TObject);
var
  Qs: string;
begin
  if DataModule1.ZQryAdjust.IsEmpty then Exit;
  if DataModule1.ZQryAdjustisposted.Value = 0 then
    Qs := 'Hapus '
  else
    Qs := 'Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' sudah diposting !' + #13+#10 + 'Batalkan ';
  if QuestionDialog(Qs + 'penyesuaian ' + DataModule1.ZQryAdjustfaktur.Value + ' ?') = True then
  begin
    if Qs = 'Hapus Retur ' then
    begin
      LogInfo(UserName,'Menghapus faktur penyesuaian ' + DataModule1.ZQryAdjustfaktur.Text);
      with DataModule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from sparepart.adjustdetail');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from sparepart.adjustmaster');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' berhasil dihapus !');
    end
    else
    begin
      LogInfo(UserName,'Membatalkan faktur penyesuaian ' + DataModule1.ZQryAdjustfaktur.Text);
      with DataModule1.ZQryFunction do
      begin
        {Close;
        SQL.Clear;
        SQL.Add('update sparepart.adjustdetail set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;}

        Close;
        SQL.Clear;
        SQL.Add('update sparepart.adjustmaster set');
        SQL.Add('isposted = ''' + '-1' + '''');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;

          {Close;
          SQL.Clear;
          SQL.Add('insert into sparepart.operasional');
          SQL.Add('(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet) values');
          SQL.Add('(''' + DataModule1.ZQrySellMasteridsell.AsString + ''',');
          SQL.Add('''' + DataModule1.ZQrySellMasterfaktur.Value + ''',');
          SQL.Add('''' + FormatDateTime('yyyy-MM-dd',TglSkrg) + ''',');
          SQL.Add('''' + FormatDateTime('hh:nn:ss',Now) + ''',');
          SQL.Add('''' + UserName + ''',');
          SQL.Add('''' + 'PEMBATALAN PENJUALAN TUNAI' + ''',');
          SQL.Add('''' + 'PEMBATALAN FAKTUR NO. ' + DataModule1.ZQrySellMasterfaktur.Value + ''',');
          SQL.Add('''' + FloatToStr(DataModule1.ZQrySellMastergrandtotal.Value) + ''')');
          ExecSQL;  }

        ///Hapus data di operasional
        Close;
        SQL.Clear;
        SQL.Add('delete from sparepart.operasional');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;

        ///Hapus data di hutang

        ///Hapus data di inventory
        Close;
        SQL.Clear;
        SQL.Add('delete from sparepart.inventory');
        SQL.Add('where faktur = ''' + DataModule1.ZQryAdjustfaktur.Value + '''');
        ExecSQL;
      end;
      InfoDialog('Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' berhasil dibatalkan !');
    end;
    if Trim(AdjustTxtSearch.Text) = '' then AdjustBtnClearClick(Self)
      else AdjustBtnSearchClick(Self);
  end;
end;

procedure TFrmadjustmaster.AdjustBtnPostingClick(Sender: TObject);
begin
  ///frmAdjust.PrintStruck(DataModule1.ZQryAdjustfaktur.Value);
  ///Exit;
  if DataModule1.ZQryAdjust.IsEmpty then Exit;
  case DataModule1.ZQryAdjustisposted.Value of
  0 : begin
        if QuestionDialog('Posting Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' ?') = False then Exit;
        frmAdj.PostingAdjust(DataModule1.ZQryAdjustfaktur.Value);
        if QuestionDialog('Cetak Struck untuk faktur ' + frmAdj.CetakFaktur + ' ?') = True then
          frmAdj.PrintStruck(frmAdj.CetakFaktur);
      end;
  1 : begin
        ErrorDialog('Faktur ' + DataModule1.ZQryAdjustfaktur.Value + ' sudah diposting !');
        Exit;
      end;
  end;
  RefreshTabel(DataModule1.ZQryAdjust);
end;

procedure TFrmadjustmaster.PrintListAdjust;
var
  FrxMemo: TfrxMemoView;
begin
  DataModule1.frxReport1.LoadFromFile('listadjust.fr3');
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := HeaderTitleRep;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Tgl'));
  FrxMemo.Memo.Text := 'Tgl ' + FormatDateTime('dd MMMM yyyy',frmAdjustMaster.AdjustTxtSearchFirst.Date) + ' s/d Tgl ' + FormatDateTime('dd MMMM yyyy',frmAdjustMaster.AdjustTxtSearchLast.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Dicetak ' + FormatDateTime('yyyy-MM-dd hh:nn:ss',TglSkrg) + ' oleh ' + UserName;
  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmadjustmaster.AdjustBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryAdjust.IsEmpty then Exit;
  PrintListAdjust;
//  frmAdj.PrintStruck(DataModule1.ZQryAdjustfaktur.Value);

end;

procedure TFrmadjustmaster.AdjustBtnSearchClick(Sender: TObject);
begin
  if Trim(AdjustTxtSearch.Text) = '' then Exit;

  with DataModule1.ZQryAdjust do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from sparepart.adjustmaster');
    SQL.Add('where faktur like %"' + AdjustTxtSearch.Text + '%' + '''');
    SQL.Add('and tanggal >= ''' + FormatDateTime('yyyy-MM-dd',AdjustTxtSearchFirst.Date) + '''');
    SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',AdjustTxtSearchLast.Date) + '''');
    SQL.Add('and isposted <> -1');
    Open;
  end;

end;

procedure TFrmadjustmaster.AdjustBtnClearClick(Sender: TObject);
begin
  with DataModule1.ZQryAdjust do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from sparepart.adjustmaster');
    SQL.Add('where tanggal >= ''' + FormatDateTime('yyyy-MM-dd',AdjustTxtSearchFirst.Date) + '''');
    SQL.Add('and tanggal <= ''' + FormatDateTime('yyyy-MM-dd',AdjustTxtSearchLast.Date) + '''');
    SQL.Add('and isposted <> -1');
    Open;
  end;
  AdjustTxtSearch.Text := '';

end;

end.
