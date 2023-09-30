unit promodiskonlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, dateutils;

type
  TFrmpromodiskonlist = class(TForm)
    PanelPenjualan: TRzPanel;
    RzPanel11: TRzPanel;
    RzLabel39: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    RzLabel44: TRzLabel;
    RzLabel45: TRzLabel;
    RzLabel46: TRzLabel;
    RzLabel47: TRzLabel;
    RzLabel60: TRzLabel;
    SellLblDateLast: TRzLabel;
    SellBtnSearch: TAdvSmoothButton;
    SellTxtSearch: TRzEdit;
    SellTxtSearchby: TRzComboBox;
    SellBtnClear: TAdvSmoothButton;
    SellTxtSearchFirst: TRzDateTimeEdit;
    SellTxtSearchLast: TRzDateTimeEdit;
    pnl_cetak_list: TRzPanel;
    RzLabel43: TRzLabel;
    SellBtnPrintList: TAdvSmoothButton;
    pnl_del: TRzPanel;
    SellBtnDel: TAdvSmoothButton;
    RzLabel42: TRzLabel;
    RzPanel1: TRzPanel;
    DBMaster: TPDJDBGridEx;
    DBGdet: TPDJDBGridEx;
    pnl_edit: TRzPanel;
    BtnEdit: TAdvSmoothButton;
    lbledit: TRzLabel;
    procedure SellBtnDelClick(Sender: TObject);
    procedure SellBtnPrintListClick(Sender: TObject);
    procedure SellBtnSearchClick(Sender: TObject);
    procedure SellBtnClearClick(Sender: TObject);
    procedure DBMasterDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SellTxtSearchbyChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmpromodiskonlist: TFrmpromodiskonlist;
  SearchCategories: string;

implementation

uses SparePartFunction, data, promodiskon;

{$R *.dfm}

procedure TFrmpromodiskonlist.FormShowFirst;
begin
 pnl_del.Visible    := isdel;
 pnl_edit.Visible   := isedit;

 SellTxtSearchFirst.Date := TglSkrg;
 SellTxtSearchLast.Date  := TglSkrg;

 SellBtnClearClick(Self);
end;

procedure TFrmpromodiskonlist.SellBtnDelClick(Sender: TObject);
begin
  if Datamodule1.ZQrydiskonlist.IsEmpty then Exit;

{  if dateof(Datamodule1.ZQrydiskonlisttglawal.Value)<=dateof(tglskrg) then
  begin
   errordialog('Tidak dapat hapus promo ini krn tgl ini sudah berlaku.');
   exit;
  end; }

  if QuestionDialog('Menghapus Data Promo Diskon Doc No. ' + Datamodule1.ZQrydiskonlistdocno.Value + ' ?') = True then
  begin
      LogInfo(UserName,'Menghapus Data Promo Diskon Doc No. ' + Datamodule1.ZQrydiskonlistdocno.Value);
      with Datamodule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from diskondet ');
        SQL.Add('where IDdiskon = ' + QuotedStr(Datamodule1.ZQrydiskonlistIDdiskon.AsString));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from diskon ');
        SQL.Add('where IDdiskon = ' + QuotedStr(Datamodule1.ZQrydiskonlistIDdiskon.AsString));
        ExecSQL;

      end;
      InfoDialog('Doc No. ' + Datamodule1.ZQrydiskonlistdocno.Value + ' berhasil dihapus !');

    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmpromodiskonlist.SellBtnPrintListClick(Sender: TObject);
var FrxMemo: TfrxMemoView;
begin
  if Datamodule1.ZQrydiskonlist.IsEmpty then Exit;

  Datamodule1.frxReport1.LoadFromFile(vpath+'Report\promodiskon.fr3');

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('docno'));
  FrxMemo.Memo.Text := Datamodule1.ZQrydiskonlistdocno.Value ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('doctgl'));
  FrxMemo.Memo.Text := FormatDateTime('dd-mm-yyyy',Datamodule1.ZQrydiskonlistdoctgl.Value);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('tglawal'));
  FrxMemo.Memo.Text := FormatDateTime('dd-mm-yyyy',Datamodule1.ZQrydiskonlisttglawal.Value);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('tglakhir'));
  FrxMemo.Memo.Text := FormatDateTime('dd-mm-yyyy',Datamodule1.ZQrydiskonlisttglakhir.Value);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('isactive'));
  if Datamodule1.ZQrydiskonlistisactive.Value=1 then FrxMemo.Memo.Text := 'AKTIF' else FrxMemo.Memo.Text := 'NON AKTIF';

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('notes'));
  FrxMemo.Memo.Text := Datamodule1.ZQrydiskonlistnotes.Value ;

  Datamodule1.frxReport1.ShowReport();

end;

procedure TFrmpromodiskonlist.SellBtnSearchClick(Sender: TObject);
//var
//  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'docno like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'usernameposted like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with Datamodule1.ZQrydiskonlist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from diskon ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and posted is not null ');
    SQL.Add('and doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by tglawal ');
    Open;
    Last;
  end;

  Datamodule1.ZQrydiskondetlist.Close;
  Datamodule1.ZQrydiskondetlist.Open;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmpromodiskonlist.SellBtnClearClick(Sender: TObject);
begin
  with Datamodule1.ZQrydiskonlist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from diskon ');
    SQL.Add('where posted is not null ');
    SQL.Add('and doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by tglawal ');
    Open;
    Last;
  end;

  Datamodule1.ZQrydiskondetlist.Close;
  Datamodule1.ZQrydiskondetlist.Open;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmpromodiskonlist.DBMasterDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Datamodule1.ZQrydiskonlistposted.IsNull=false then
    DBMaster.Canvas.Brush.Color := $00A8FFA8
  else
    DBMaster.Canvas.Brush.Color := clWindow;
  DBMaster.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmpromodiskonlist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQrydiskondetlist.Close;
 Datamodule1.ZQrydiskonlist.Close;

end;

procedure TFrmpromodiskonlist.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmpromodiskonlist.FormShow(Sender: TObject);
begin
// FormShowFirst;
end;

procedure TFrmpromodiskonlist.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQrydiskonlistIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF frmpromodiskon=nil then
 application.CreateForm(Tfrmpromodiskon,frmpromodiskon);
 frmpromodiskon.Align:=alclient;
 frmpromodiskon.Parent:=self.parent;
 frmpromodiskon.BorderStyle:=bsnone;
 frmpromodiskon.tagacc := EDIT_ACCESS;
 frmpromodiskon.Show;

end;

end.
