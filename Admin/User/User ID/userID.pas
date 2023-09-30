unit userID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Mask, RzEdit, ExtCtrls, ComCtrls,
  AdvSmoothButton, RzLabel, RzPanel, RzDTP, RzCmboBx, RzButton,
  RzRadChk, VolDBGrid, RzRadGrp;

type
  TFrmUserID = class(TForm)
    GBAccess: TGroupBox;
    Label1: TLabel;
    edt_nama: TRzEdit;
    pnl_usergroup: TRzPanel;
    lbl_caption: TRzLabel;
    pnl_accusergroup: TRzPanel;
    lbl_accusergroup: TRzLabel;
    Panel1: TPanel;
    DBGUser: TVolgaDBGrid;
    RzPanel3: TRzPanel;
    lblCancel: TRzLabel;
    lblsave: TRzLabel;
    lblAdd: TRzLabel;
    lbledit: TRzLabel;
    lblDel: TRzLabel;
    BtnCancel: TAdvSmoothButton;
    BtnSave: TAdvSmoothButton;
    BtnAdd: TAdvSmoothButton;
    BtnEdit: TAdvSmoothButton;
    BtnDel: TAdvSmoothButton;
    UserFilter: TRzRadioGroup;
    Label2: TLabel;
    edt_passwd: TRzEdit;
    Label3: TLabel;
    RzLabel22: TRzLabel;
    UserTxtNonEfektif: TRzDateTimeEdit;
    RzLabel4: TRzLabel;
    cb_usergroup: TRzComboBox;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure UserFilterClick(Sender: TObject);
  private
    { Private declarations }
    procedure setdisplaycontrol(vtag: byte);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmUserID: TFrmUserID;

implementation

uses sparepartfunction, Data;

{$R *.dfm}

procedure TFrmUserID.setdisplaycontrol(vtag: byte);
var isbrowse: boolean;
begin
 isbrowse := false;
 tag := vtag;
 if tag=BROWSE_ACCESS then isbrowse := true;

 pnl_usergroup.Visible    := isbrowse;
 pnl_accusergroup.Visible := not isbrowse;
 if tag=ADD_ACCESS then lbl_accusergroup.Caption := 'Tambah User'
 else lbl_accusergroup.Caption := 'Edit User';

 GBAccess.Visible   := not isbrowse;
 Userfilter.Enabled := isbrowse;

 BtnAdd.Visible := isbrowse;
 BtnEdit.Visible := isbrowse;
 Btndel.Visible := isbrowse;
 lblAdd.Visible := isbrowse;
 lblEdit.Visible := isbrowse;
 lbldel.Visible := isbrowse;
 Btnsave.Visible := not isbrowse;
 Btncancel.Visible := not isbrowse;
 lblsave.Visible := not isbrowse;
 lblcancel.Visible := not isbrowse;
end;

procedure TFrmUserID.FormShowFirst;
begin
 GBAccess.Left   := Panel1.Left;
 GBAccess.Top    := Panel1.Top;
 GBAccess.Width  := DBGUser.Width;
 GBAccess.Height := DBGUser.Height;

 BtnEdit.Enabled := isedit;
 BtnDel.Enabled  := isdel;

 setdisplaycontrol(BROWSE_ACCESS);

 Userfilter.ItemIndex := 0;
 UserFilterclick(Userfilter);
end;

procedure TFrmUserID.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 DataModule1.ZQryUser.Close;
end;

procedure TFrmUserID.BtnAddClick(Sender: TObject);
begin
 setdisplaycontrol(ADD_ACCESS);

 Fill_ComboBox_with_Data_n_ID(cb_usergroup,'select IDusergroup,usergroup from usergroup order by usergroup','usergroup','IDusergroup');

 edt_nama.Enabled := true;
 edt_nama.Text:='';
 edt_passwd.Text:='';
 cb_usergroup.Text := '';
 UserTxtNonEfektif.Text := '';

 edt_nama.SetFocus;
end;

procedure TFrmUserID.BtnEditClick(Sender: TObject);
begin
 setdisplaycontrol(EDIT_ACCESS);

 Fill_ComboBox_with_Data_n_ID(cb_usergroup,'select IDusergroup,usergroup from usergroup order by usergroup','usergroup','IDusergroup');

 edt_nama.Enabled := false;
 edt_nama.Text:='';
 edt_passwd.Text:='';
 cb_usergroup.Text := '';
 UserTxtNonEfektif.Text := '';


 if DataModule1.ZQryUserusername.IsNull=false then edt_nama.Text := DataModule1.ZQryUserusername.Value;
 if DataModule1.ZQryUserpassword.IsNull=false then edt_passwd.Text := DataModule1.ZQryUserpassword.Value;
 if DataModule1.ZQryUserIDusergroup.IsNull=false then cb_usergroup.itemindex := cb_usergroup.items.indexofobject(TObject(DataModule1.ZQryUserIDusergroup.Value));
 if DataModule1.ZQryUsertglnoneffective.IsNull=false then UserTxtNonEfektif.Date := DataModule1.ZQryUsertglnoneffective.Value;


end;

procedure TFrmUserID.BtnDelClick(Sender: TObject);
var vusg : string;
    PosRecord: integer;
begin
 vusg := DataModule1.ZQryUserusername.AsString;
 if QuestionDialog('Hapus Data User '+vusg+' ?')=false then exit;

 if DataModule1.ZConnection1.ExecuteDirect('delete from user where IDuser='+DataModule1.ZQryUserIDuser.AsString) then
 begin
  PosRecord := DataModule1.ZQryUser.RecNo;
  DataModule1.ZQryUser.close;
  DataModule1.ZQryUser.open;
  DataModule1.ZQryUser.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus User ' + vusg);
  InfoDialog('User ' + vusg + ' berhasil dihapus !');
 end
 else ErrorDialog('User ' + vusg + ' gagal dihapus !');
end;

procedure TFrmUserID.BtnSaveClick(Sender: TObject);
var tglne : string;
begin
 if (edt_nama.Text='') then
 begin
  ErrorDialog('Isi dahulu Nama User !');
  exit;
 end
 else
 if (edt_passwd.Text='') then
 begin
  ErrorDialog('Isi dahulu Password User !');
  exit;
 end
 else
 if (tag=ADD_ACCESS) and (isDataExist('select IDuser from user where username='+ QuotedStr(edt_nama.Text) )) then
 begin
  ErrorDialog('User Name  '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end
 else
 if (tag=EDIT_ACCESS) and (isDataExist('select IDuser from user where username='+ QuotedStr(edt_nama.Text) + ' and IDuser<>' + DataModule1.ZQryUserIDuser.AsString )) then
 begin
  ErrorDialog('User '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end
 else
 if cb_usergroup.ItemIndex=-1 then
 begin
  ErrorDialog('Group User harus diisi!');
  exit;
 end;

 if UserTxtNonEfektif.Text='' then tglne := 'null' else tglne := QuotedStr(getMySQLDateStr(UserTxtNonEfektif.Date));

 if tag=ADD_ACCESS then
 begin
   if DataModule1.ZConnection1.ExecuteDirect('insert into user (username,password,IDusergroup,usergroup,tglnoneffective) values (' +
                                                  QuotedStr(edt_nama.Text) +
                                                  ',' + QuotedStr(edt_passwd.Text) +
                                                  ',' + IntToStr(Longint(cb_usergroup.Items.Objects[cb_usergroup.ItemIndex])) +
                                                  ',' + QuotedStr(cb_usergroup.Text) +
                                                  ',' + tglne +
                                                  ')') then
   begin
    InfoDialog('Tambah User ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Insert User ' + edt_Nama.Text );
   end
   else ErrorDialog('Tambah User ' + edt_Nama.Text + ' Gagal');
 end
 else
 begin
  if DataModule1.ZConnection1.ExecuteDirect('update user set username=' + QuotedStr(edt_nama.Text) +
                                                  ',password=' + QuotedStr(edt_passwd.Text) +
                                                  ',IDusergroup=' + IntToStr(Longint(cb_usergroup.Items.Objects[cb_usergroup.ItemIndex])) +
                                                  ',usergroup=' + QuotedStr(cb_usergroup.Text) +
                                                  ',tglnoneffective=' + tglne +
                                                  ' where IDuser=' + DataModule1.ZQryUserIDuser.AsString) then
  begin
    InfoDialog('Edit User ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Edit User ' + edt_Nama.Text );
  end
  else errorDialog('Edit User ' + edt_Nama.Text + ' gagal');
 end;

 setdisplaycontrol(BROWSE_ACCESS);

 DataModule1.ZQryUser.close;
 DataModule1.ZQryUser.Open;
end;

procedure TFrmUserID.BtnCancelClick(Sender: TObject);
begin
 setdisplaycontrol(BROWSE_ACCESS);
end;

procedure TFrmUserID.UserFilterClick(Sender: TObject);
begin
 DataModule1.ZQryUser.Close;
 if Userfilter.ItemIndex = 0 then
      DataModule1.ZQryUser.SQL.Text := 'select * from user where tglnoneffective is null order by username'
 else DataModule1.ZQryUser.SQL.Text := 'select * from user where tglnoneffective is not null order by username';
 DataModule1.ZQryUser.Open;

end;

end.
