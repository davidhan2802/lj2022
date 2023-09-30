unit frmHutangBG;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzCmboBx, Mask, RzEdit, RzPanel,
  AdvSmoothButton, Grids, DBGrids, RzDBGrid, RzLabel, ExtDlgs, JPEG,
  RzRadGrp, PDJDBGridex, ComCtrls, RzDTP, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset;

type
  TfrmHtgbg = class(TForm)
    PanelBG: TRzPanel;
    RzPanel2: TRzPanel;
    BGLblCaption: TRzLabel;
    RzPanel3: TRzPanel;
    BGDBGrid: TPDJDBGridEx;
    RzPanel1: TRzPanel;
    RzLabel85: TRzLabel;
    htgTxtfaktur: TRzEdit;
    RzLabel256: TRzLabel;
    HtgTxtTsf: TRzNumericEdit;
    RzLabel84: TRzLabel;
    HtgTxtBG: TRzNumericEdit;
    RzLabel254: TRzLabel;
    HtgTxtTgl: TRzDateTimePicker;
    RzLabel12: TRzLabel;
    BGBtnAdd: TAdvSmoothButton;
    ZQryFormBG: TZQuery;
    ZQryFormBGfaktur: TStringField;
    ZQryFormBGtgl: TDateField;
    ZQryFormBGtransfer: TFloatField;
    ZQryFormBGbg: TFloatField;
    ZQryFormBGbgno: TStringField;
    ZQryFormBGbgbank: TStringField;
    ZQryFormBGbgtempo: TDateField;
    ZQryFormBGtobank: TStringField;
    DSFormBG: TDataSource;
    ZQryFormBGnourut: TSmallintField;
    ZQryFormBGipv: TStringField;
    procedure FormShow(Sender: TObject);
    procedure BGDBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BGBtnAddClick(Sender: TObject);
    procedure ZQryFormBGAfterPost(DataSet: TDataSet);
    procedure ZQryFormBGAfterDelete(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZQryFormBGBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    procedure RefreshTotal;
  public
    { Public declarations }
  end;

var
  frmHtgbg : TfrmHtgbg;

implementation

uses hutangmaster, SparePartFunction, Data;

{$R *.dfm}

procedure TfrmHtgbg.FormShow(Sender: TObject);
begin
 ipcomp := getComputerIP;

 ZQryFormBG.Close;
 ZQryFormBG.SQL.Text := 'select * from formbg where ipv='+Quotedstr(ipcomp)+' and faktur='+QuotedStr(htgTxtfaktur.Text)+' order by tgl,bgno';
 ZQryFormBG.Open;

 BGDBGrid.SetFocus;
end;

procedure TfrmHtgbg.BGDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=VK_RETURN) then Key := VK_TAB;

 if (Key=VK_DELETE) then ZQryFormBG.Delete;
end;

procedure TfrmHtgbg.BGBtnAddClick(Sender: TObject);
begin
 ZQryFormBG.CommitUpdates;

 if ZQryFormBG.IsEmpty then
 begin
  //errordialog('Data BG/Transfer kosong!');
  Close;
  exit;
 end;

 ZQryFormBG.First;
 while not ZQryFormBG.Eof do
 begin
  if (BGDBGrid.Fields[1].AsFloat<0)or(BGDBGrid.Fields[2].AsFloat<0)or((BGDBGrid.Fields[1].AsFloat<=0)and(BGDBGrid.Fields[2].AsFloat<=0))or((BGDBGrid.Fields[1].AsFloat>0)and(BGDBGrid.Fields[2].AsFloat>0)) then
  begin
   errordialog('Isi salah satu Jumlah Transfer atau BG dengan benar dahulu!');
   BGDBGrid.SelectedIndex := 2;
   exit;
  end
  else
  if (BGDBGrid.Fields[1].AsFloat>0)and((BGDBGrid.Fields[0].IsNull)or(BGDBGrid.Fields[6].IsNull)or(trim(BGDBGrid.Fields[0].AsString)='')or(trim(BGDBGrid.Fields[6].AsString)='')) then
  begin
   ErrorDialog('Isi Tanggal Transfer dan Bank Tujuan Transfer dengan benar!');
   BGDBGrid.SelectedIndex := 6;
   exit;
  end
  else
  if (BGDBGrid.Fields[2].AsFloat>0)and((BGDBGrid.Fields[0].IsNull)or(BGDBGrid.Fields[3].IsNull)or(BGDBGrid.Fields[4].IsNull)or(BGDBGrid.Fields[5].IsNull)or(BGDBGrid.Fields[6].IsNull)or(trim(BGDBGrid.Fields[0].AsString)='')or(trim(BGDBGrid.Fields[3].AsString)='')or(trim(BGDBGrid.Fields[4].AsString)='')or(trim(BGDBGrid.Fields[5].AsString)='')or(trim(BGDBGrid.Fields[6].AsString)='')or(BGDBGrid.Fields[0].AsDateTime>BGDBGrid.Fields[5].AsDateTime)) then
  begin
   ErrorDialog('Isi No.BG dan Bank BG dan Bank Tujuan Pencairan BG dengan benar! Tanggal Jatuh Tempo BG tidak boleh sebelum Tanggal BG!');
   BGDBGrid.SelectedIndex := 3;
   exit;
  end;

  ZQryFormBG.Next;
 end;

 Close;
end;

procedure TfrmHtgbg.RefreshTotal;
begin
 DataModule1.ZQryUtil.Close;
 DataModule1.ZQryUtil.SQL.Text := 'select sum(transfer),sum(bg) from formbg where ipv='+ Quotedstr(ipcomp) + ' and faktur='+QuotedStr(htgTxtfaktur.Text);
 DataModule1.ZQryUtil.Open;

 htgTxtTsf.Value := DataModule1.ZQryUtil.Fields[0].AsFloat;
 htgTxtBG.Value  := DataModule1.ZQryUtil.Fields[1].AsFloat;

 Frmhutangmaster.htgTxtTsf.Value := htgTxtTsf.Value;
 Frmhutangmaster.htgTxtBG.Value := htgTxtBG.Value;

 DataModule1.ZQryUtil.Close;
end;

procedure TfrmHtgbg.ZQryFormBGAfterPost(DataSet: TDataSet);
begin
 RefreshTotal;
end;

procedure TfrmHtgbg.ZQryFormBGAfterDelete(DataSet: TDataSet);
begin
 RefreshTotal;
end;

procedure TfrmHtgbg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ZQryFormBG.Close;
end;

procedure TfrmHtgbg.ZQryFormBGBeforePost(DataSet: TDataSet);
begin
 ZQryFormBGfaktur.Value := htgTxtfaktur.Text;
 ZQryFormBGipv.Value := ipcomp;
end;

end.
