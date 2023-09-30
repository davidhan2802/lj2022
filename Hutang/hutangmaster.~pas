unit hutangmaster;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzRadGrp, RzEdit, StdCtrls, RzCmboBx, Mask, RzPanel,
  AdvSmoothButton, RzLabel, Grids, DBGrids, RzDBGrid, ExtCtrls, dateutils, frxclass,
  VolDBGrid, ComCtrls, RzDTP, frxpngimage, ZDataSet, Db;

type
  TFrmhutangmaster = class(TForm)
    PanelHutang: TRzPanel;
    RzPanel24: TRzPanel;
    RzLabel89: TRzLabel;
    Image2: TImage;
    RzPanel21: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabel90: TRzLabel;
    RzLabel91: TRzLabel;
    RzLabel92: TRzLabel;
    htgcbxkodesupp: TRzComboBox;
    htgcbxnamasupp: TRzComboBox;
    HtgDtpTempoAwal: TRzDateTimePicker;
    HtgDtpTempoAkhir: TRzDateTimePicker;
    HtgTxtTotal: TRzNumericEdit;
    RzPanel22: TRzPanel;
    RzLabel93: TRzLabel;
    HtgBtnPrint: TAdvSmoothButton;
    htgpnlbayar: TRzPanel;
    lblbayar: TRzLabel;
    RzLabel95: TRzLabel;
    lblbatal: TRzLabel;
    RzLabel97: TRzLabel;
    RzLabel98: TRzLabel;
    RzLabel99: TRzLabel;
    RzLabel261: TRzLabel;
    RzLabel262: TRzLabel;
    RzLabel263: TRzLabel;
    RzLabel264: TRzLabel;
    HtgBtnBack: TAdvSmoothButton;
    HtgBtnList: TAdvSmoothButton;
    HtgBtnPost: TAdvSmoothButton;
    HtgBtnAdd: TAdvSmoothButton;
    HtgTxtTgl: TRzDateTimePicker;
    HtgTxtFaktur: TRzEdit;
    HtgTxtSisaBayar: TRzNumericEdit;
    HtgTxtNotes: TRzEdit;
    RzGroupBox8: TRzGroupBox;
    RzLabel265: TRzLabel;
    RzLabel266: TRzLabel;
    RzLabel267: TRzLabel;
    HtgTxtTunai: TRzNumericEdit;
    HtgTxtBG: TRzNumericEdit;
    HtgTxtTsf: TRzNumericEdit;
    HtgTxtTagihan: TRzNumericEdit;
    HtgTxtBayar: TRzNumericEdit;
    HtgTxtSisaHutang: TRzNumericEdit;
    RzPanel25: TRzPanel;
    RzLabel268: TRzLabel;
    RzLabel269: TRzLabel;
    RzLabel270: TRzLabel;
    htgTxtTotalRetur: TRzNumericEdit;
    htgTxtTotalhutangFaktur: TRzNumericEdit;
    htgTxtdiskonrp: TRzNumericEdit;
    HutangDBGrid: TVolgaDBGrid;
    HtgReturDBGrid: TVolgaDBGrid;
    procedure htgcbxkodesuppChange(Sender: TObject);
    procedure htgcbxnamasuppChange(Sender: TObject);
    procedure HtgDtpTempoAwalChange(Sender: TObject);
    procedure HutangDBGridCellClick(Sender: TObject; Column: TVolgaColumn);
    procedure HutangDBGridTitleClick(Sender: TObject;
      Column: TVolgaColumn);
    procedure HtgReturDBGridTitleClick(Sender: TObject;
      Column: TVolgaColumn);
    procedure HtgBtnPrintClick(Sender: TObject);
    procedure htgTxtdiskonrpChange(Sender: TObject);
    procedure HtgTxtTagihanChange(Sender: TObject);
    procedure HtgTxtTunaiChange(Sender: TObject);
    procedure HtgTxtBGKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HtgBtnAddClick(Sender: TObject);
    procedure HtgBtnListClick(Sender: TObject);
    procedure HtgBtnBackClick(Sender: TObject);
    procedure HtgBtnPostClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
    procedure Htgdisplayfaktur;
    procedure HtgCalculateRefreshChecked(Faktur,Retur: boolean);
    procedure PrintListHutang;
  end;

var
  Frmhutangmaster: TFrmhutangmaster;
  vtotalhutangnodisc : double;
  ShowDetail : boolean;

implementation

uses SparePartFunction, Data, frmHutang, frmHutangBG;

{$R *.dfm}

procedure TFrmHutangmaster.PrintListHutang;
var
  FrxMemo: TfrxMemoView;
  strTgl : string;
begin
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\hutang.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('titleJual'));
  if htgcbxkodesupp.ItemIndex>0 then FrxMemo.Memo.Text := 'DAFTAR HUTANG (' + htgcbxnamasupp.Text + ')'
  else FrxMemo.Memo.Text := 'DAFTAR HUTANG';

  strtgl  := '';
  if htgDtpTempoAwal.Checked and htgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',htgDtpTempoAwal.Date) +' s/d '+FormatDateTime('dd-MM-yyyy',htgDtpTempoAkhir.Date)
  else if htgDtpTempoAwal.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo '+ FormatDateTime('dd-MM-yyyy',htgDtpTempoAwal.Date) + ' dan seterusnya '
  else if htgDtpTempoAkhir.Checked then
       strtgl := strtgl + 'Tgl Jatuh Tempo'+ ' s/d '+FormatDateTime('dd-MM-yyyy',htgDtpTempoAkhir.Date);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglJual'));
  FrxMemo.Memo.Text := strtgl;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  DataModule1.frxReport1.ShowReport();
end;

procedure TFrmhutangmaster.HtgCalculateRefreshChecked(Faktur,Retur: boolean);
begin
  if (Faktur=False)and(Retur=False) then exit;

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
   if Faktur then
   begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal-totalpayment) from buymaster ');
    SQL.Add('where isposted=1 and checked=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    if htgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',htgDtpTempoAwal.Date)) + ' ');
    if htgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',htgDtpTempoAkhir.Date)) + ' ');
    Open;
    htgTxtTotalhutangFaktur.value := Fields[0].AsFloat;
    Close;
   end;

   if Retur then
   begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(totalretur) from returbelimaster ');
    SQL.Add('where isposted=1 and checked=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    Open;
    htgTxtTotalRetur.Value := Fields[0].AsFloat;
    Close;
   end;
  end;

  htgTxtTagihan.Value := htgTxtTotalhutangFaktur.value - htgTxtTotalRetur.Value - htgTxtdiskonrp.Value;
end;

procedure TFrmhutangmaster.Htgdisplayfaktur;
begin
  HutangDBGrid.Columns[7].Visible := HtgBtnPost.Visible;

  HutangDBGrid.Columns[0].ReadOnly := (htgcbxkodesupp.ItemIndex = 0);

  with DataModule1.ZQryHutang do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,(grandtotal-totalpayment) hutang,concat("[",kodesupplier,"] ",supplier) kodenmsupp from buymaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    if HtgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAwal.Date)) + ' ');
    if HtgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAkhir.Date)) + ' ');
    SQL.Add('order by faktur');
    Open;
  end;

  with DataModule1.ZQryHutangRetur do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select *,concat("[",kodesupplier,"] ",supplier) kodenmsupp from returbelimaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    SQL.Add('order by faktur');
    Open;
  end;

  htgpnlbayar.visible := (htgcbxkodesupp.ItemIndex > 0); //and (DataModule1.ZQryHutang.IsEmpty=false);

  ///cari total nilai jual
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select sum(grandtotal-totalpayment) from buymaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    if HtgDtpTempoAwal.Checked then
       SQL.Add('and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAwal.Date)) + ' ');
    if HtgDtpTempoAkhir.Checked then
       SQL.Add('and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAkhir.Date)) + ' ');
    Open;
    htgTxtTotalhutangFaktur.value := Fields[0].AsFloat;
    Close;
    SQL.Clear;
    SQL.Add('select sum(totalretur) from returbelimaster ');
    SQL.Add('where isposted=1 and lunas=0 ');
    if htgcbxkodesupp.ItemIndex>0 then SQL.Add('and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ');
    Open;
    htgTxtTotalRetur.Value := Fields[0].AsFloat;
    Close;
  end;

  vtotalhutangnodisc := htgTxtTotalhutangFaktur.value - htgTxtTotalRetur.Value;
  HtgTxtTotal.Value   := vtotalhutangnodisc - htgTxtdiskonrp.Value;
  HtgTxtTagihan.Value := HtgTxtTotal.Value;
end;

procedure TFrmhutangmaster.FormShowFirst;
begin
  ipcomp := getComputerIP;

  FillComboBox('kode','supplier where tglnoneffective is null ',htgcbxkodesupp,false,'kode',true);
  FillComboBox('nama','supplier where tglnoneffective is null ',htgcbxnamasupp,false,'kode',true);
  HtgDtpTempoAwal.Checked  := false;
  HtgDtpTempoAkhir.Checked := false;

  htgBtnAdd.Visible   := true;
  htgBtnlist.Visible  := true;
  htgBtnPost.Visible  := false;
  htgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  htgcbxkodesupp.Enabled   := true;
  htgcbxnamasupp.Enabled   := true;
  htgDtpTempoAwal.Enabled  := true;
  htgDtpTempoAkhir.Enabled := true;
  htgTxtTunai.enabled      := true;
  htgTxtBG.enabled         := true;
  htgTxtTsf.enabled        := true;
  htgTxtdiskonrp.enabled   := true;

  DataModule1.ZConnection1.ExecuteDirect('update buymaster set bayarskrg=0,checked=1 where isposted=1 and lunas=0 ');
  DataModule1.ZConnection1.ExecuteDirect('update returbelimaster set checked=1 where isposted=1 and lunas=0 ');

  htgcbxkodesupp.ItemIndex := 0;
  htgcbxkodesuppchange(self);
end;

procedure TFrmhutangmaster.htgcbxkodesuppChange(Sender: TObject);
begin
 htgcbxnamasupp.ItemIndex := htgcbxkodesupp.ItemIndex;

  HtgTxtTsf.Value          := 0;
  HtgTxtTunai.Value        := 0;
  HtgTxtBG.Value           := 0;
  HtgTxtTgl.Date           := now;

  HtgTxtTagihan.Value      := 0;
  HtgTxtBayar.Value        := 0;
  HtgTxtSisaBayar.Value    := 0;
  HtgTxtSisaHutang.Value  := 0;

  HtgTxtnotes.Text         := '';

 htgTxtdiskonrp.Value := 0;

 Htgdisplayfaktur;


end;

procedure TFrmhutangmaster.htgcbxnamasuppChange(Sender: TObject);
begin
 htgcbxkodesupp.ItemIndex := htgcbxnamasupp.ItemIndex;

  HtgTxtTsf.Value          := 0;
  HtgTxtTunai.Value        := 0;
  HtgTxtBG.Value           := 0;
  HtgTxtTgl.Date           := now;

  HtgTxtTagihan.Value      := 0;
  HtgTxtBayar.Value        := 0;
  HtgTxtSisaBayar.Value    := 0;
  HtgTxtSisaHutang.Value  := 0;

  htgTxtnotes.Text         := '';

 htgTxtdiskonrp.Value := 0;

 Htgdisplayfaktur;
end;

procedure TFrmhutangmaster.HtgDtpTempoAwalChange(Sender: TObject);
begin
 Htgdisplayfaktur;
end;

procedure TFrmhutangmaster.HutangDBGridCellClick(Sender: TObject;
  Column: TVolgaColumn);
begin
 if (column.Index=0)and((Sender as TVolgaDBGrid).DataSource.DataSet.State=dsEdit) then
 begin
  ((Sender as TVolgaDBGrid).DataSource.DataSet as TZQuery).CommitUpdates;
  HtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
 end;
end;

procedure TFrmhutangmaster.HutangDBGridTitleClick(Sender: TObject;
  Column: TVolgaColumn);
var ischeck: byte;
    strbuf : string;
begin
 if (htgcbxkodesupp.ItemIndex=0)or(DataModule1.ZQryHutang.IsEmpty) then exit;

 if DataModule1.ZQryHutangchecked.Value=0 then ischeck:=1 else ischeck:=0;
 strbuf := 'where isposted=1 and lunas=0 ';
 if htgcbxkodesupp.ItemIndex>0 then strbuf := strbuf + 'and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ';
 if HtgDtpTempoAwal.Checked then
    strbuf := strbuf + 'and tgljatuhtempo >= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAwal.Date)) + ' ';
 if HtgDtpTempoAkhir.Checked then
    strbuf := strbuf + 'and tgljatuhtempo <= ' + QuotedStr(FormatDateTime('yyyy-MM-dd',HtgDtpTempoAkhir.Date)) + ' ';

 DataModule1.ZConnection1.ExecuteDirect('update buymaster set checked='+inttostr(ischeck)+' '+strbuf);

 RefreshTabel(DataModule1.ZQryHutang);
 HtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
end;

procedure TFrmhutangmaster.HtgReturDBGridTitleClick(Sender: TObject;
  Column: TVolgaColumn);
var ischeck: byte;
    strbuf : string;
begin
 if (htgcbxkodesupp.ItemIndex=0)or(DataModule1.ZQryHutangretur.IsEmpty) then exit;

 if DataModule1.ZQryHutangreturchecked.Value=0 then ischeck:=1 else ischeck:=0;
 strbuf := 'where isposted=1 and lunas=0 ';
 if htgcbxkodesupp.ItemIndex>0 then strbuf := strbuf + 'and kodesupplier = ' + QuotedStr(htgcbxkodesupp.Text) + ' ';

 DataModule1.ZConnection1.ExecuteDirect('update returbelimaster set checked='+inttostr(ischeck)+' '+strbuf);

 RefreshTabel(DataModule1.ZQryHutangretur);
 HtgCalculateRefreshChecked((Sender as TVolgaDBGrid).tag=0,(Sender as TVolgaDBGrid).tag=1);
end;

procedure TFrmhutangmaster.HtgBtnPrintClick(Sender: TObject);
begin
  if DataModule1.ZQryHutang.IsEmpty then Exit;
  PrintListHutang;
end;

procedure TFrmhutangmaster.htgTxtdiskonrpChange(Sender: TObject);
begin
  HtgTxtTotal.Value   := vtotalhutangnodisc - htgTxtdiskonrp.Value;
  HtgTxtTagihan.Value := htgTxtTotalhutangFaktur.value - htgTxtTotalRetur.Value - htgTxtdiskonrp.Value;
end;

procedure TFrmhutangmaster.HtgTxtTagihanChange(Sender: TObject);
begin
 htgTxtSisaBayar.Value  := HtgTxtTagihan.Value - HtgTxtBayar.Value;
 htgTxtSisaHutang.Value := HtgTxtTotal.Value - HtgTxtBayar.Value;

end;

procedure TFrmhutangmaster.HtgTxtTunaiChange(Sender: TObject);
begin
 htgTxtBayar.Value := HtgTxtTunai.Value + HtgTxtBG.Value + HtgTxtTsf.Value;

end;

procedure TFrmhutangmaster.HtgTxtBGKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) then
  begin
   if htgTxtFaktur.Text='' then
   begin
    warningdialog('Isi No. TT dahulu!');
    htgTxtFaktur.SetFocus;
    exit;
   end;

   frmHtgBG.HtgTxtfaktur.Text := HtgTxtfaktur.Text;
   frmHtgBG.HtgTxtTgl.Date := HtgTxtTgl.Date;
   frmHtgBG.HtgTxtTsf.Value := HtgTxtTsf.Value;
   frmHtgBG.HtgTxtBG.Value := HtgTxtBG.Value;

   frmHtgBG.ShowModal;
  end;

end;

procedure TFrmhutangmaster.HtgBtnAddClick(Sender: TObject);
var totpay: double;
begin
  if (DataModule1.ZQryHutang.IsEmpty)or(htgTxtTagihan.Value=0) then
  begin
    ErrorDialog('Pilih/Check Faktur yang akan dibayar dahulu!');
    Exit;
  end;

  if (htgTxtFaktur.text='') then
  begin
    ErrorDialog('Isi No. TT Pembayaran dahulu! dengan No. Kwitansi atau yang lain...');
    Exit;
  end
  else if ((htgTxtTsf.value+htgTxtTunai.value+htgTxtBG.value)<=0)or(htgTxtBG.value<0)or(htgTxtTsf.value<0) then
  begin
    ErrorDialog('Isi Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan atau BG dengan benar!');
    Exit;
  end
  else if (htgTxtTsf.value+htgTxtTunai.value+htgTxtBG.value)>htgTxtTagihan.Value then
  begin
    ErrorDialog('Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan BG tidak boleh lebih besar dari Jumlah Tagihan!');
    Exit;
  end;

  if QuestionDialog('Bayar Hutang ?') = false then exit;

  htgBtnAdd.Visible   := false;
  htgBtnlist.Visible  := false;
  htgBtnPost.Visible  := true;
  htgBtnBack.Visible  := true;
  lblbayar.Caption    := 'Posting';
  lblbatal.Caption    := 'Batal';

  DataModule1.ZConnection1.ExecuteDirect('update buymaster set bayarskrg=0 where bayarskrg<>0 and isposted=1 and lunas=0 ');
  totpay := htgTxtTsf.value + htgTxtTunai.value + htgTxtBG.value + htgTxtTotalRetur.Value + htgTxtdiskonrp.Value;
  with DataModule1 do
  begin
   ZQryHutang.First;
   while (not ZQryHutang.Eof)and(totpay>0) do
   begin
    if ZQryHutangchecked.Value=0 then
    begin
     ZQryHutang.Next;
     continue;
    end;

    ZQryHutang.Edit;

    if totpay > ZQryHutangHutang.Value then
       ZQryHutangbayarskrg.Value := ZQryHutangHutang.Value
    else ZQryHutangbayarskrg.Value := totpay;
    totpay := totpay - ZQryHutangHutang.Value;

    ZQryHutang.Post;
    ZQryHutang.Next;
   end;
  end;

  htgcbxkodesupp.Enabled   := false;
  htgcbxnamasupp.Enabled   := false;
  htgDtpTempoAwal.Enabled  := false;
  htgDtpTempoAkhir.Enabled := false;
  htgTxtTsf.enabled        := false;
  htgTxtTunai.enabled      := false;
  htgTxtBG.enabled         := false;
  htgTxtdiskonrp.enabled   := false;

  hutangDBGrid.Columns[7].Visible  := htgBtnPost.Visible;
  RefreshTabel(DataModule1.ZQryHutang);
end;

procedure TFrmhutangmaster.HtgBtnListClick(Sender: TObject);
begin
 ShowDetail := true;

 TUTUPFORM(self.parent);
 IF frmHtg=nil then
 application.CreateForm(TfrmHtg,frmHtg);
 frmHtg.Align:=alclient;
 frmHtg.Parent:=self.parent;
 frmHtg.BorderStyle:=bsnone;
 frmHtg.FormShowFirst;
 frmHtg.Show;

end;

procedure TFrmhutangmaster.HtgBtnBackClick(Sender: TObject);
begin
//  if DataModule1.ZQryPiutang.IsEmpty then Exit;
  if QuestionDialog('Batal Bayar Hutang ?') = false then exit;

  HtgBtnAdd.Visible   := true;
  HtgBtnlist.Visible  := true;
  HtgBtnPost.Visible  := false;
  HtgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  Htgcbxkodesupp.Enabled   := true;
  Htgcbxnamasupp.Enabled   := true;
  HtgDtpTempoAwal.Enabled  := true;
  HtgDtpTempoAkhir.Enabled := true;
  HtgTxtTsf.enabled        := true;
  HtgTxtTunai.enabled      := true;
  HtgTxtBG.enabled         := true;
  HtgTxtdiskonrp.enabled   := true;

  DataModule1.ZConnection1.ExecuteDirect('update buymaster set bayarskrg=0 where bayarskrg<>0 and isposted=1 and lunas=0 ');

  HutangDBGrid.Columns[7].Visible := HtgBtnPost.Visible;
  RefreshTabel(DataModule1.ZQryHutang);
end;

procedure TFrmhutangmaster.HtgBtnPostClick(Sender: TObject);
var vbyrskrg,vsisahutang: double;
    ketstr,pketstr  : string;
begin
  if (DataModule1.ZQryhutang.IsEmpty)or(htgTxtTagihan.Value=0) then
  begin
    ErrorDialog('Pilih/Check Faktur yang akan dibayar dahulu!');
    Exit;
  end;

  if (htgTxtFaktur.text='') then
  begin
    ErrorDialog('Isi No. TT dahulu!');
    Exit;
  end
  else if isDataExist('select faktur from buypayment where faktur='+ QuotedStr(htgTxtFaktur.text)) then
  begin
    ErrorDialog('No. TT telah terdaftar! Isi dengan Nomor yang lain...');
    Exit;
  end
  else if ((htgTxtTsf.value+htgTxtTunai.value+htgTxtBG.value)<=0)or(htgTxtBG.value<0)or(htgTxtTsf.value<0) then
  begin
    ErrorDialog('Isi Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan atau BG dengan benar!');
    Exit;
  end
  else if (htgTxtTsf.value+htgTxtTunai.value+htgTxtBG.value)>htgTxtTagihan.Value then
  begin
    ErrorDialog('Jumlah yang harus dibayarkan dalam bentuk TRANSFER, TUNAI dan BG tidak boleh lebih besar dari Jumlah Tagihan!');
    Exit;
  end;

  if QuestionDialog('Posting Pembayaran Hutang ini ?') = False then Exit;

  ketstr := '';
  pketstr := '';
  if htgTxtTunai.Value>0 then pketstr := 'Tunai '+ FormatCurr('Rp ###,##0',htgTxtTunai.Value) + ' ';
  if htgTxtTsf.Value>0 then pketstr := pketstr + 'Transfer '+ FormatCurr('Rp ###,##0',htgTxtTsf.Value) + ' ';
  if htgTxtBG.Value>0 then pketstr := pketstr + 'BG '+FormatCurr('Rp ###,##0',htgTxtBG.Value)+' ';

  with DataModule1 do
  begin
   ZQryHutang.First;
   while (not ZQryHutang.Eof) do
   begin
    if ZQryHutangbayarskrg.Value<>0 then
    begin
     ZQryHutang.Edit;
     vbyrskrg := ZQryHutangtotalpayment.Value + ZQryHutangbayarskrg.Value;
     vsisaHutang := ZQryHutanggrandtotal.Value - vbyrskrg;
     if vsisaHutang<=0 then ZQryHutanglunas.Value := 1;
     ZQryHutangtotalpayment.Value := vbyrskrg;
     vbyrskrg := ZQryHutangbayarskrg.Value;
     ZQryHutangbayarskrg.Value    := 0;
     ZQryHutang.Post;

     if ZQryHutanglunas.Value = 1 then
        ketstr := 'Pelunasan Hutang Faktur ' + ZQryHutangfaktur.value + ' : ' + FormatCurr('Rp ###,##0',vbyrskrg)+' . Total Tagihan Faktur : '+FormatCurr('Rp ###,##0',htgTxtTotalHutangFaktur.Value)+' . Total Retur : '+FormatCurr('Rp ###,##0',htgTxtTotalRetur.Value)+' . Diskon '+FormatCurr('Rp ###,##0',htgTxtdiskonrp.Value)+' . TT No: '+htgTxtFaktur.text+' pada Tanggal '+Formatdatetime('dd-mm-yyyy',htgTxtTgl.Date)+' dengan Total '+ pketstr
     else ketstr := 'Cicilan Pembayaran Hutang Faktur ' + ZQryHutangfaktur.value + ' : ' + FormatCurr('Rp ###,##0',vbyrskrg) +' (sisa Hutang jadi ' + FormatCurr('Rp ###,##0',vsisaHutang) + '). Total Tagihan Faktur : '+FormatCurr('Rp ###,##0',htgTxtTotalHutangFaktur.Value)+' . Total Retur : '+FormatCurr('Rp ###,##0',htgTxtTotalRetur.Value)+' . Diskon '+FormatCurr('Rp ###,##0',htgTxtdiskonrp.Value)+' . TT No: '+htgTxtFaktur.text+' pada Tanggal '+Formatdatetime('dd-mm-yyyy',htgTxtTgl.Date)+' dengan Total '+ pketstr;

     ZConnection1.ExecuteDirect('insert into operasional '+
                                            '(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,kredit,fakturpay,saldoawaltagihan) values '+
                                            '("' + ZQryHutangidbeli.AsString  + '",' +
                                            '"' + ZQryHutangfaktur.value      + '",' +
                                            '"' + FormatDateTime('yyyy-MM-dd',htgTxtTgl.Date) + '",' +
                                            '"' + FormatDateTime('hh:mm:ss',Now) + '",' +
                                            '"' + UserName + '",' +
                                            '"' + 'HUTANG PEMBELIAN' + '",' +
                                            '"' + ketstr + '",' +
                                            '"' + FloatToStr(vbyrskrg) + '",' +
                                            '"' + htgTxtFaktur.text + '",' +
                                            '"' + ZQryHutangHutang.AsString  + '")');

     LogInfo(UserName,ketstr);
    end;

    ZQryHutang.Next;
   end;

     ZConnection1.ExecuteDirect('insert into buypayment '+
                                            '(faktur,kodesupplier,supplier,tanggal,waktu,kasir,saldo_hutang,transfer,tunai,bg,totalhutangfaktur,totalretur,diskonrp,tanggalinput,notes,isposted) values '+
                                            '(' + QuotedStr(htgTxtFaktur.text) + ',' +
                                                  QuotedStr(htgcbxkodesupp.text) + ',' +
                                                  QuotedStr(htgcbxnamasupp.text) + ',' +
                                                  QuotedStr(FormatDateTime('yyyy-MM-dd',htgTxtTgl.Date)) + ',' +
                                                  QuotedStr(FormatDateTime('hh:mm:ss',Now)) + ',' +
                                                  QuotedStr(UserName) + ',' +
                                                  QuotedStr(FloatToStr(htgTxtsisaHutang.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxttsf.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxttunai.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxtBG.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxtTotalHutangFaktur.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxtTotalRetur.Value)) + ',' +
                                                  QuotedStr(FloatToStr(htgTxtdiskonrp.Value)) + ',CURRENT_DATE,' +
                                                  QuotedStr(htgTxtnotes.Text) + ',1)');

     ZConnection1.ExecuteDirect('insert into buypaymentbg (faktur,tgl,transfer,bg,bgno,bgbank,bgtempo,tobank) select faktur,tgl,transfer,bg,bgno,bgbank,bgtempo,tobank from formbg where ipv='+Quotedstr(ipcomp)+' and faktur = '+QuotedStr(htgTxtfaktur.Text));
//     ZConnection1.ExecuteDirect('delete from formbg where ipv='+Quotedstr(ipcomp)+' and faktur = '+QuotedStr(htgTxtfaktur.Text));
     ClearTabel('formbg where ipv='+ Quotedstr(ipcomp));

     ZQryHutangRetur.First;
     while (not ZQryHutangRetur.Eof) do
     begin
      if ZQryHutangReturchecked.Value=0 then
      begin
       ZQryHutangRetur.Next;
       continue;
      end;

      ZConnection1.ExecuteDirect('insert into operasional '+
                                 '(idTrans,faktur,tanggal,waktu,kasir,kategori,keterangan,debet,fakturpay,saldoawaltagihan) values '+
                                 '("' + ZQryHutangReturidReturBeli.AsString + '",' +
                                 '"' + ZQryHutangReturfaktur.AsString + '",' +
                                 '"' + FormatDateTime('yyyy-MM-dd',htgTxtTgl.Date) + '",' +
                                 '"' + FormatDateTime('hh:mm:ss',Now) + '",' +
                                 '"' + UserName + '",' +
                                 '"' + 'RETUR PEMBELIAN' + '",' +
                                 '"' + 'LUNAS' + '",' +
                                 '"' + ZQryHutangReturtotalretur.AsString + '",' +
                                 '"' + htgTxtFaktur.text + '",' +
                                 '"' + ZQryHutangReturtotalretur.AsString + '")');

      ZConnection1.ExecuteDirect('update returbelimaster set lunas=1 where isposted=1 and lunas=0 and faktur="' + ZQryHutangReturfaktur.Value + '" ');

      ZQryHutangRetur.Next;
     end;
  end;

  InfoDialog('Pembayaran Hutang berhasil diterima !');

  HtgBtnAdd.Visible   := true;
  HtgBtnlist.Visible  := true;
  HtgBtnPost.Visible  := false;
  HtgBtnBack.Visible  := false;
  lblbayar.Caption    := 'Bayar';
  lblbatal.Caption    := 'List';

  htgcbxkodesupp.Enabled   := true;
  htgcbxnamasupp.Enabled   := true;
  HtgDtpTempoAwal.Enabled  := true;
  HtgDtpTempoAkhir.Enabled := true;
  htgTxtTsf.enabled        := true;
  htgTxtTunai.enabled      := true;
  htgTxtBG.enabled         := true;
  htgTxtdiskonrp.enabled   := true;

  htgTxtFaktur.text        := '';
  htgTxtTsf.Value          := 0;
  htgTxtTunai.Value        := 0;
  htgTxtBG.Value           := 0;
  htgTxtTgl.Date           := now;

  htgTxtTagihan.Value      := 0;
  htgTxtBayar.Value        := 0;
  htgTxtSisaBayar.Value    := 0;
  htgTxtSisaHutang.Value  := 0;

  htgTxtnotes.Text         := '';

  htgTxtdiskonrp.Value := 0;

  Htgdisplayfaktur;

end;

end.
