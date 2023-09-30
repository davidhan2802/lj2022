unit ubahhargalist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzRadGrp;

type
  TFrmubahhargalist = class(TForm)
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
    procedure PrintListubahharga;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmubahhargalist: TFrmubahhargalist;
  SearchCategories: string;

implementation

uses SparePartFunction, data, ubahharga;

{$R *.dfm}

procedure TFrmubahhargalist.FormShowFirst;
begin
 pnl_del.Visible    := isdel;

 SellTxtSearchFirst.Date := TglSkrg;
 SellTxtSearchLast.Date  := TglSkrg;

 SellBtnClearClick(Self);
end;

procedure TFrmubahhargalist.PrintListubahharga;
var
  FrxMemo: TfrxMemoView;
begin
  Datamodule1.frxReport1.LoadFromFile(vpath+'Report\ubahhargalist.fr3');

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('judul'));
  FrxMemo.Memo.Text := 'LAPORAN PERUBAHAN HARGA';

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('docno'));
  FrxMemo.Memo.Text := Datamodule1.ZQryubahhargalistdocno.AsString;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('doctgl'));
  FrxMemo.Memo.Text := FormatDateTime('dd-MM-yyyy',Datamodule1.ZQryubahhargalistdoctgl.Asdatetime);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('notes'));
  FrxMemo.Memo.Text := Datamodule1.ZQryubahhargalistnotes.AsString;

  Datamodule1.frxReport1.ShowReport();

end;

procedure TFrmubahhargalist.SellBtnDelClick(Sender: TObject);
begin
  if Datamodule1.ZQryubahhargalist.IsEmpty then Exit;

  if QuestionDialog('Menghapus Data Ubah Harga Doc No. ' + Datamodule1.ZQryubahhargalistdocno.Value + ' ?') = True then
  begin
      LogInfo(UserName,'Menghapus Data Ubah Harga Doc No. ' + Datamodule1.ZQryubahhargalistdocno.Value);
      with Datamodule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from ubahhargadet ');
        SQL.Add('where IDubahharga = ' + QuotedStr(Datamodule1.ZQryubahhargalistIDubahharga.AsString));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from ubahharga ');
        SQL.Add('where IDubahharga = ' + QuotedStr(Datamodule1.ZQryubahhargalistIDubahharga.AsString));
        ExecSQL;

      end;
      InfoDialog('Doc No. ' + Datamodule1.ZQryubahhargalistdocno.Value + ' berhasil dihapus !');

    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmubahhargalist.SellBtnPrintListClick(Sender: TObject);
begin
  if Datamodule1.ZQryubahhargalist.IsEmpty then Exit;
  PrintListubahharga;

end;

procedure TFrmubahhargalist.SellBtnSearchClick(Sender: TObject);
//var
//  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'b.docno like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'b.usernameposted like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with Datamodule1.ZQryubahhargalist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.* from ubahharga b ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQryubahhargalistdet.Close;
  Datamodule1.ZQryubahhargalistdet.Open;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmubahhargalist.SellBtnClearClick(Sender: TObject);
begin
  with Datamodule1.ZQryubahhargalist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.* from ubahharga b ');
    SQL.Add('where b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQryubahhargalistdet.Close;
  Datamodule1.ZQryubahhargalistdet.Open;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmubahhargalist.DBMasterDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Datamodule1.ZQryubahhargalistposted.IsNull=false then
    DBMaster.Canvas.Brush.Color := $00A8FFA8
  else
    DBMaster.Canvas.Brush.Color := clWindow;
  DBMaster.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmubahhargalist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQryubahhargalistdet.Close;
 Datamodule1.ZQryubahhargalist.Close;

end;

procedure TFrmubahhargalist.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmubahhargalist.FormShow(Sender: TObject);
begin
// FormShowFirst;
end;

procedure TFrmubahhargalist.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQryubahhargalistIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF Frmubahharga=nil then
 application.CreateForm(TFrmubahharga,Frmubahharga);
 Frmubahharga.Align:=alclient;
 Frmubahharga.Parent:=self.parent;
 Frmubahharga.BorderStyle:=bsnone;
 Frmubahharga.tagacc := EDIT_ACCESS;
 Frmubahharga.Show;

end;

end.
