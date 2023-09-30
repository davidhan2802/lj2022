unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzButton, StdCtrls, RzLabel, Mask, RzEdit,
  RzCmboBx, RzBckgnd;

type
  TFLogin = class(TForm)
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    edtPasswd: TRzEdit;
    btnOK: TRzBitBtn;
    btnKluar: TRzBitBtn;
    edt_user: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnKluarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtPasswdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;

implementation

{$R *.dfm}

uses UMain, sparepartfunction, Data;

procedure TFLogin.FormShow(Sender: TObject);
begin
 Frmain.tutupmenu;

 isLoged := false;
 EDT_user.Text:='';
 EDTPASSWD.Text:='';
end;

procedure TFLogin.btnOKClick(Sender: TObject);
begin
 if (edtpasswd.Text='') then
 begin
  ErrorDialog('Isi dahulu Password!');
  edtpasswd.SetFocus;
  exit;
 end;

 DataModule1.ZQryUtil.close;
 DataModule1.ZQryUtil.SQL.Text:='select u.IDuser,u.username,u.IDusergroup,g.usergroup,u.password,g.isedit,g.isdel '+
                                ' from user u inner join usergroup g on u.IDusergroup=g.IDusergroup where u.username='+QuotedStr(edt_User.Text)+
                                ' and u.password = '+QuotedStr(edtPasswd.Text);
 DataModule1.ZQryUtil.open;

 if DataModule1.ZQryUtil.IsEmpty then
 begin
  DataModule1.ZQryUtil.close;
  ErrorDialog('User Name dan Password tidak cocok!');
  exit;
 end;

  IDUserLogin      := -1001;
  IDUserGroup      := -1001;

 if (DataModule1.ZQryUtil.RecordCount>0) then
 begin
  IDUserLogin      := DataModule1.ZQryUtil.Fields[0].AsInteger;
  UserName         := DataModule1.ZQryUtil.Fields[1].AsString;
  IDUserGroup      := DataModule1.ZQryUtil.Fields[2].AsInteger;
  UserGroup        := DataModule1.ZQryUtil.Fields[3].AsString;
  Passwd           := DataModule1.ZQryUtil.Fields[4].AsString;
  isedit           := DataModule1.ZQryUtil.Fields[5].AsInteger=1;
  isdel            := DataModule1.ZQryUtil.Fields[6].AsInteger=1;
  isLoged := true;
  Close;
 end
 else
  ErrorDialog('User Name dan Password tidak cocok!');

 DataModule1.ZQryUtil.close;
end;

procedure TFLogin.btnKluarClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose := isLoged;
end;

procedure TFLogin.edtPasswdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = VK_Return then btnOKClick(btnOK);
end;

procedure TFLogin.FormClose(Sender: TObject; var Action: TCloseAction);
var i : integer;
    isadamaster,isadatransaksi,isadareports,isadakeuangan,isadatools : boolean;
begin
 if isloged=true then
 begin
  if (iduserlogin<>-1001)and(idusergroup<>-1001) then
  begin
   Frmain.File1.Visible := true;
   Frmain.Master1.Visible := true;
   Frmain.Transaction1.Visible := true;
   Frmain.Keuangan1.Visible := true;
   Frmain.Reports1.Visible := true;
   Frmain.Tools1.Visible := true;

   isadamaster:=false;
   isadatransaksi:=false;
   isadareports:=false;
   isadakeuangan:=false;
   isadatools:=false;

   if Datamodule1.ZQryUtil.Active then Datamodule1.ZQryUtil.Close;
   Datamodule1.ZQryUtil.SQL.Clear;
   Datamodule1.ZQryUtil.SQL.Add('select g.IDmenu from usergroup u left join usergroupmenu g on u.IDuserGroup=g.IDuserGroup ');
   Datamodule1.ZQryUtil.SQL.Add('where u.IDuserGroup='+IntToStr(idusergroup)+' order by g.IDmenu ' );
   Datamodule1.ZQryUtil.Open;
   while not Datamodule1.ZQryUtil.Eof do
   begin
    for i := 0 to 4 do
     if Frmain.Master1.Items[i].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then
     begin
      Frmain.Master1.Items[i].visible := true;
      isadamaster:=true;
     end;

    for i := 0 to 9 do
     if Frmain.Transaction1.Items[i].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then
     begin
      Frmain.Transaction1.Items[i].Visible := true;
      isadatransaksi:=true;
     end;

    if Frmain.Keuangan1.Items[0].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then
    begin
     Frmain.Keuangan1.Items[0].Visible := true;
     isadakeuangan:=true;
    end;

    for i := 0 to 5 do
     if Frmain.reports1.Items[i].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then
     begin
      Frmain.reports1.Items[i].Visible := true;
      isadareports:=true;
     end;

    if Frmain.Tools1.Items[0].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then
    begin
     Frmain.Tools1.Items[0].Visible := true;
     isadatools:=true;
    end;

    for i := 1 to 3 do
     if Frmain.file1.Items[i].tag = Datamodule1.ZQryUtil.Fields[0].AsInteger then Frmain.file1.Items[i].Visible := true;

    Datamodule1.ZQryUtil.Next;
   end;
   Datamodule1.ZQryUtil.Close;

   Frmain.Master1.Visible := isadamaster;
   Frmain.Transaction1.Visible := isadatransaksi;
   Frmain.Keuangan1.Visible := isadakeuangan;
   Frmain.Reports1.Visible := isadareports;
   Frmain.Tools1.Visible := isadatools;

  end;

 end
 else
 begin
 end;

end;

end.
