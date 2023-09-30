unit usergroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Mask, RzEdit, ExtCtrls, ComCtrls,
  AdvSmoothButton, RzLabel, RzPanel, RzDTP, RzCmboBx, RzButton,
  RzRadChk, VolDBGrid, CheckLst;

type
  TFrmUserGroup = class(TForm)
    RzPanel1: TRzPanel;
    DBGUser: TVolgaDBGrid;
    GBAccess: TGroupBox;
    Label1: TLabel;
    edt_nama: TRzEdit;
    ccx_isedit: TRzCheckBox;
    ccx_isdel: TRzCheckBox;
    pnl_usergroup: TRzPanel;
    lbl_caption: TRzLabel;
    pnl_accusergroup: TRzPanel;
    lbl_accusergroup: TRzLabel;
    RzPanel3: TRzPanel;
    lblCancel: TRzLabel;
    lblsave: TRzLabel;
    lblAdd: TRzLabel;
    lbledit: TRzLabel;
    lblDel: TRzLabel;
    RzLabel1: TRzLabel;
    BtnCancel: TAdvSmoothButton;
    BtnSave: TAdvSmoothButton;
    BtnAdd: TAdvSmoothButton;
    BtnEdit: TAdvSmoothButton;
    BtnDel: TAdvSmoothButton;
    clb_Menus: TCheckListBox;
    Label2: TLabel;
    btn_SelectAll: TButton;
    btn_DeselectAll: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_SelectAllClick(Sender: TObject);
    procedure btn_DeselectAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure setdisplaycontrol(vtag: byte);
    procedure displayMenuList;
    procedure SelectedMenuList(vIDGroup:Integer);
    procedure SettingMenuList(IsSelected: boolean);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmUserGroup: TFrmUserGroup;

implementation

uses sparepartfunction, data;

{$R *.dfm}

procedure TFrmUserGroup.setdisplaycontrol(vtag: byte);
var isbrowse: boolean;
begin
 isbrowse := false;
 tag := vtag;
 if tag=BROWSE_ACCESS then isbrowse := true;

 pnl_usergroup.Visible    := isbrowse;
 pnl_accusergroup.Visible := not isbrowse;
 if tag=ADD_ACCESS then lbl_accusergroup.Caption := 'Tambah User Group'
 else lbl_accusergroup.Caption := 'Edit User Group';

 GBAccess.Visible := not isbrowse;

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

procedure TFrmUserGroup.displayMenuList;
begin
 clb_Menus.Clear;

 if Datamodule1.ZQryUtil.Active then Datamodule1.ZQryUtil.Close;
 Datamodule1.ZQryUtil.SQL.Clear;
 Datamodule1.ZQryUtil.SQL.Add('select IDMenu,Nama from menu order by IDmenu');
 Datamodule1.ZQryUtil.Open;
 while not Datamodule1.ZQryUtil.Eof do
 begin
  clb_Menus.Items.AddObject(Datamodule1.ZQryUtil.Fields[1].AsString,TObject(Datamodule1.ZQryUtil.Fields[0].AsInteger));
  Datamodule1.ZQryUtil.Next;
 end;
 Datamodule1.ZQryUtil.Close;
end;

procedure TFrmUserGroup.FormShowFirst;
begin
 setdisplaycontrol(BROWSE_ACCESS);

 BtnEdit.Enabled := isedit;
 BtnDel.Enabled  := isdel;

 Datamodule1.ZQryUserGroup.Close;
 Datamodule1.ZQryUserGroup.Open;

 displayMenuList;

end;

procedure TFrmUserGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Datamodule1.ZQryUserGroup.Close;
end;

procedure TFrmUserGroup.BtnAddClick(Sender: TObject);
begin
 setdisplaycontrol(ADD_ACCESS);

 edt_nama.Enabled := true;
 edt_nama.Text:='';

 ccx_isedit.Checked := false;
 ccx_isdel.Checked := false;

 SettingMenuList(False);

 edt_nama.SetFocus;
end;

procedure TFrmUserGroup.BtnEditClick(Sender: TObject);
begin
 setdisplaycontrol(EDIT_ACCESS);

 edt_nama.Enabled := true;
 edt_nama.Text:='';

 ccx_isedit.Checked := false;
 ccx_isdel.Checked := false;

 SettingMenuList(False);

 if Datamodule1.ZQryUserGroupusergroup.IsNull=false then edt_nama.Text := Datamodule1.ZQryUserGroupusergroup.Value;

 if Datamodule1.ZQryUserGroupisedit.IsNull=false then ccx_isedit.checked := Datamodule1.ZQryUserGroupisedit.Value = 1;
 if Datamodule1.ZQryUserGroupisdel.IsNull=false then ccx_isdel.checked := Datamodule1.ZQryUserGroupisdel.Value = 1;
 if Datamodule1.ZQryUserGroupIDuserGroup.IsNull=false then SelectedMenuList(Datamodule1.ZQryUserGroupIDuserGroup.AsInteger);

 clb_Menus.SetFocus;
end;

procedure TFrmUserGroup.BtnDelClick(Sender: TObject);
var vusg : string;
    PosRecord: integer;
begin
 vusg := Datamodule1.ZQryUserGroupusergroup.AsString;
 if QuestionDialog('Hapus Data User Group '+vusg+' ?')=false then exit;

 if Datamodule1.ZConnection1.ExecuteDirect('delete from usergroup where IDusergroup='+Datamodule1.ZQryUserGroupIDusergroup.AsString) then
 begin
  PosRecord := Datamodule1.ZQryUserGroup.RecNo;
  Datamodule1.ZQryUserGroup.close;
  Datamodule1.ZQryUserGroup.open;
  Datamodule1.ZQryUserGroup.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus User Group ' + vusg);
//  InfoDialog('User Group ' + vusg + ' berhasil dihapus !');
 end
 else ErrorDialog('User Group ' + vusg + ' gagal dihapus !');
end;

procedure TFrmUserGroup.SelectedMenuList(vIDGroup:Integer);
begin
 if (clb_Menus.Items.Count>0) then
 begin
  SettingMenuList(False);
  if Datamodule1.ZQryUtil.Active then Datamodule1.ZQryUtil.Close;
  Datamodule1.ZQryUtil.SQL.Clear;
  Datamodule1.ZQryUtil.SQL.Add('select IDMenu from usergroupmenu');
  Datamodule1.ZQryUtil.SQL.Add('where IDusergroup='+ InttoStr(vIDGroup));
  Datamodule1.ZQryUtil.Open;
  while not Datamodule1.ZQryUtil.Eof do
  begin
   clb_Menus.Checked[clb_Menus.Items.IndexOfObject(TObject(Datamodule1.ZQryUtil.Fields[0].AsInteger))]:=True;
   Datamodule1.ZQryUtil.Next;
  end;
  Datamodule1.ZQryUtil.Close;
 end;
end;

procedure TFrmUserGroup.SettingMenuList(IsSelected: boolean);
var i:integer;
begin
 if (clb_Menus.Items.Count>0) then
  for i:= 0 to clb_Menus.items.count-1 do clb_Menus.Checked[i]:=IsSelected;
end;

procedure TFrmUserGroup.BtnSaveClick(Sender: TObject);
var clbcount,cgroup,vIDUsergroup : integer;
    SelectedMenu : boolean;
    visedit,visdel : byte;
begin
 if (edt_nama.Text='') then
 begin
  ErrorDialog('Isi dahulu Nama User Group!');
  exit;
 end;

 SelectedMenu:=False;
 for clbcount:= 0 to clb_Menus.Items.Count-1 do
  if clb_Menus.Checked[clbcount] then
  begin
   SelectedMenu:=True;
   break;
  end;
 if not SelectedMenu then
 begin
  ErrorDialog('Pilih data Menu Group dahulu ....');
  exit;
 end;

 if (tag=ADD_ACCESS) and (isDataExist('select IDusergroup from usergroup where usergroup='+ QuotedStr(trim(edt_nama.Text)) )) then
 begin
  ErrorDialog('User Group '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end
 else
 if (tag=EDIT_ACCESS) and (isDataExist('select IDusergroup from usergroup where usergroup='+ QuotedStr(trim(edt_nama.Text)) + ' and IDusergroup<>' + Datamodule1.ZQryUserGroupIDusergroup.AsString )) then
 begin
  ErrorDialog('User Group '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end;

 visedit:=0;
 visdel :=0;
 if ccx_isedit.Checked then visedit:=1;
 if ccx_isdel.Checked then visdel:=1;

 if tag=ADD_ACCESS then
 begin
   if Datamodule1.ZConnection1.ExecuteDirect('insert into usergroup (usergroup,isedit,isdel) values (' +
                                        QuotedStr(trim(edt_nama.Text)) +
                                        ',' + IntToStr(visedit) +
                                        ',' + IntToStr(visdel) +
                                        ')') then
   begin
    with DataModule1.ZQryFunction do
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'select IDusergroup from usergroup where usergroup='+ Quotedstr(trim(edt_nama.Text)) ;
    Open;
    vIDUsergroup := Fields[0].Asinteger;
    Close;
    end;

    for cgroup:= 0 to clb_Menus.Items.Count-1 do
    if clb_Menus.Checked[cgroup] then
       Datamodule1.ZConnection1.ExecuteDirect('insert into usergroupmenu values ('+ InttoStr(vIDUsergroup) + ','+ IntToStr(Longint(clb_Menus.Items.Objects[cgroup])) +')');

    InfoDialog('Tambah User Group ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Insert User Group ' + edt_Nama.Text );
   end
   else ErrorDialog('Tambah User Group ' + edt_Nama.Text + ' Gagal');
 end
 else
 begin
  if Datamodule1.ZConnection1.ExecuteDirect('update usergroup set '+
                                      'usergroup=' + QuotedStr(trim(edt_nama.Text)) +
                                      ',isedit=' + IntToStr(visedit) +
                                      ',isdel=' + IntToStr(visdel) +
                                      ' where IDusergroup=' + Datamodule1.ZQryUserGroupIDusergroup.AsString) then
  begin
     Datamodule1.ZConnection1.ExecuteDirect('delete from usergroupmenu where IDuserGroup='+ Datamodule1.ZQryUserGroupIDusergroup.AsString );

     for cgroup:= 0 to clb_Menus.Items.Count-1 do
      if clb_Menus.Checked[cgroup] then
      begin
       Datamodule1.ZConnection1.ExecuteDirect('insert into usergroupmenu values '+
          '('+ Datamodule1.ZQryUserGroupIDusergroup.AsString + ','+ IntToStr(Longint(clb_Menus.Items.Objects[cgroup])) +')');
      end;

    InfoDialog('Edit User Group ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Edit User Group ' + edt_Nama.Text );
  end
  else errorDialog('Edit User Group ' + edt_Nama.Text + ' gagal');
 end;

 setdisplaycontrol(BROWSE_ACCESS);

 Datamodule1.ZQryUserGroup.close;
 Datamodule1.ZQryUserGroup.Open;
 Datamodule1.ZQryUserGroup.Locate('usergroup',edt_nama.Text,[]);

end;

procedure TFrmUserGroup.BtnCancelClick(Sender: TObject);
begin
 setdisplaycontrol(BROWSE_ACCESS);
end;

procedure TFrmUserGroup.FormShow(Sender: TObject);
begin
 FormShowFirst;
end;

procedure TFrmUserGroup.btn_SelectAllClick(Sender: TObject);
begin
 SettingMenuList(True);

end;

procedure TFrmUserGroup.btn_DeselectAllClick(Sender: TObject);
begin
 SettingMenuList(False);
end;

end.
