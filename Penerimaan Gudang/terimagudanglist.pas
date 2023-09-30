unit terimagudanglist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, PDJDBGridex, RzEdit, StdCtrls, RzCmboBx, Mask,
  RzPanel, AdvSmoothButton, RzLabel, ExtCtrls, frxClass, RzRadGrp;

type
  TFrmterimagudanglist = class(TForm)
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
    RGgroup: TRzRadioGroup;
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
    procedure PrintListterimagudang;
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  Frmterimagudanglist: TFrmterimagudanglist;
  SearchCategories: string;

implementation

uses SparePartFunction, data, terimagudang;

{$R *.dfm}

procedure TFrmterimagudanglist.FormShowFirst;
begin
 pnl_del.Visible    := isdel;
 pnl_edit.Visible   := isedit;

 SellTxtSearchFirst.Date := TglSkrg;
 SellTxtSearchLast.Date  := TglSkrg;

 SellBtnClearClick(Self);
end;

procedure TFrmterimagudanglist.PrintListterimagudang;
var
  FrxMemo: TfrxMemoView;
begin
 Datamodule1.ZQryterimagudanglistrep.Close;
 Datamodule1.ZQryterimagudanglistrep.SQL.Clear;
 Datamodule1.ZQryterimagudanglistrep.SQL.Text := 'select i.IDterimagudang,g.IDgolongan,g.kode,g.nama,sum(i.qty) qty, sum(i.qty*i.hargabeli) value from terimagudangdet i ' +
                                                 'left join product p on i.IDproduct=p.IDproduct ' +
                                                 'left join golongan g on p.IDgolongan=g.IDgolongan ' +
                                                 'where i.IDterimagudang=' + Datamodule1.ZQryterimagudanglistIDterimagudang.AsString + ' ' +
                                                 'group by i.IDterimagudang,g.IDgolongan,g.kode,g.nama ' +
                                                 'order by g.kode; ';
 Datamodule1.ZQryterimagudanglistrep.Open;

 if RGgroup.ItemIndex=0 then  Datamodule1.frxReport1.LoadFromFile(vpath+'Report\terimagudanglist.fr3')
 else
 begin
  Datamodule1.ZQryterimagudanglistrepdet.close;
  Datamodule1.ZQryterimagudanglistrepdet.open;

  Datamodule1.frxReport1.LoadFromFile(vpath+'Report\terimagudanglistdet.fr3');
 end;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('FooterCaption'));
  FrxMemo.Memo.Text := 'Printed By ' + UserName + ' ' + FormatDateTime('dd-MM-yyyy hh:nn:ss',Now) ;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('judul'));
  FrxMemo.Memo.Text := 'LAPORAN PENERIMAAN ' + Datamodule1.ZQryterimagudanglistnmgudangto.AsString + ' PER DEPARTEMEN';

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('docno'));
  FrxMemo.Memo.Text := Datamodule1.ZQryterimagudanglistdocno.AsString;

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('doctgl'));
  FrxMemo.Memo.Text := FormatDateTime('dd-MM-yyyy',Datamodule1.ZQryterimagudanglistdoctgl.Asdatetime);

  FrxMemo := TfrxMemoView(Datamodule1.frxReport1.FindObject('from'));
  FrxMemo.Memo.Text := Datamodule1.ZQryterimagudanglistnmgudang.AsString;

  Datamodule1.frxReport1.ShowReport();

  Datamodule1.ZQryterimagudanglistrepdet.Close;
  Datamodule1.ZQryterimagudanglistrep.Close;

end;

procedure TFrmterimagudanglist.SellBtnDelClick(Sender: TObject);
begin
  if Datamodule1.ZQryterimagudanglist.IsEmpty then Exit;

  if QuestionDialog('Menghapus Data Penerimaan Gudang Doc No. ' + Datamodule1.ZQryterimagudanglistdocno.Value + ' ?') = True then
  begin
      LogInfo(UserName,'Menghapus Data Penerimaan Gudang Doc No. ' + Datamodule1.ZQryterimagudanglistdocno.Value);
      with Datamodule1.ZQryFunction do
      begin
        Close;
        SQL.Clear;
        SQL.Add('delete from terimagudangdet ');
        SQL.Add('where IDterimagudang = ' + QuotedStr(Datamodule1.ZQryterimagudanglistIDterimagudang.AsString));
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('delete from terimagudang ');
        SQL.Add('where IDterimagudang = ' + QuotedStr(Datamodule1.ZQryterimagudanglistIDterimagudang.AsString));
        ExecSQL;

      end;
      InfoDialog('Doc No. ' + Datamodule1.ZQryterimagudanglistdocno.Value + ' berhasil dihapus !');

    ///Hitung Ulang Sum of Total
    if Trim(SellTxtSearch.Text) = '' then SellBtnClearClick(Self)
    else SellBtnSearchClick(Self);
  end;
end;

procedure TFrmterimagudanglist.SellBtnPrintListClick(Sender: TObject);
begin
  if Datamodule1.ZQryterimagudanglist.IsEmpty then Exit;
  PrintListterimagudang;

end;

procedure TFrmterimagudanglist.SellBtnSearchClick(Sender: TObject);
//var
//  SearchCategories: string;
begin
  if (Trim(SellTxtSearch.Text) = '')and(SellTxtSearchby.ItemIndex>=0) then Exit;
  case SellTxtSearchby.ItemIndex of
  0 : SearchCategories := 'b.docno like ''' + SellTxtSearch.Text + '%' + ''' ';
  1 : SearchCategories := 'b.usernameposted like ''' + SellTxtSearch.Text + '%' + ''' ';
  end;

  with Datamodule1.ZQryterimagudanglist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.*,g.namagudang nmgudang,o.namagudang nmgudangto from terimagudang b ');
    SQL.Add('left join gudang g on b.IDgudangfrom=g.IDgudang ');
    SQL.Add('left join gudang o on b.IDgudang=o.IDgudang ');
    SQL.Add('where ' + SearchCategories );
    SQL.Add('and b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQryterimagudanglistdet.Close;
  Datamodule1.ZQryterimagudanglistdet.Open;

  SellBtnPrintList.Enabled := true;
end;

procedure TFrmterimagudanglist.SellBtnClearClick(Sender: TObject);
begin
  with Datamodule1.ZQryterimagudanglist do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select b.*,g.namagudang nmgudang,o.namagudang nmgudangto from terimagudang b ');
    SQL.Add('left join gudang g on b.IDgudangfrom=g.IDgudang ');
    SQL.Add('left join gudang o on b.IDgudang=o.IDgudang ');
    SQL.Add('where b.posted is not null ');
    SQL.Add('and b.doctgl between ' + Quotedstr(getmysqldatestr(SellTxtSearchFirst.Date)) + ' ');
    SQL.Add('and ' + Quotedstr(getmysqldatestr(SellTxtSearchLast.Date)) );
    SQL.Add('order by b.doctgl,b.docno ');
    Open;
    Last;
  end;

  Datamodule1.ZQryterimagudanglistdet.Close;
  Datamodule1.ZQryterimagudanglistdet.Open;

  SellTxtSearchBy.ItemIndex  :=  0;
//  SellTxtSearchBychange(sender);
  SellTxtSearch.Text := '';

  SellBtnPrintList.Enabled := true;

end;

procedure TFrmterimagudanglist.DBMasterDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Datamodule1.ZQryterimagudanglistposted.IsNull=false then
    DBMaster.Canvas.Brush.Color := $00A8FFA8
  else
    DBMaster.Canvas.Brush.Color := clWindow;
  DBMaster.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;

procedure TFrmterimagudanglist.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQryterimagudanglistdet.Close;
 Datamodule1.ZQryterimagudanglist.Close;

end;

procedure TFrmterimagudanglist.SellTxtSearchbyChange(Sender: TObject);
begin
  SellBtnPrintList.Enabled := false;

end;

procedure TFrmterimagudanglist.FormShow(Sender: TObject);
begin
// FormShowFirst;
end;

procedure TFrmterimagudanglist.BtnEditClick(Sender: TObject);
begin
 if (IDuserlogin<>Datamodule1.ZQryterimagudanglistIDuserposted.value)and(IDUserGroup<>1) then
 begin
  errordialog('Maaf tidak diperbolehkan Edit !');
  exit;
 end;

// TUTUPFORM(self.parent);
 IF Frmterimagudang=nil then
 application.CreateForm(TFrmterimagudang,Frmterimagudang);
 Frmterimagudang.Align:=alclient;
 Frmterimagudang.Parent:=self.parent;
 Frmterimagudang.BorderStyle:=bsnone;
 Frmterimagudang.tagacc := EDIT_ACCESS;
 Frmterimagudang.Show;

end;

end.
