unit usergroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Mask, RzEdit, ExtCtrls, ComCtrls,
  AdvSmoothButton, RzLabel, RzPanel, RzDTP, RzCmboBx, RzButton,
  RzRadChk, VolDBGrid;

type
  TFrmUserGroup = class(TForm)
    RzPanel3: TRzPanel;
    lblAdd: TRzLabel;
    lbledit: TRzLabel;
    lblDel: TRzLabel;
    BtnAdd: TAdvSmoothButton;
    BtnEdit: TAdvSmoothButton;
    BtnDel: TAdvSmoothButton;
    BtnSave: TAdvSmoothButton;
    lblsave: TRzLabel;
    BtnCancel: TAdvSmoothButton;
    RzLabel1: TRzLabel;
    lblCancel: TRzLabel;
    GBAccess: TGroupBox;
    Label1: TLabel;
    edt_nama: TRzEdit;
    DBGUser: TVolgaDBGrid;
    RzGroupBox1: TRzGroupBox;
    ccx_iscustomer: TRzCheckBox;
    ccx_issupplier: TRzCheckBox;
    ccx_issales: TRzCheckBox;
    RzGroupBox2: TRzGroupBox;
    ccx_isretur: TRzCheckBox;
    RzGroupBox3: TRzGroupBox;
    ccx_islistpenjualan: TRzCheckBox;
    ccx_islistretur: TRzCheckBox;
    pnl_usergroup: TRzPanel;
    lbl_caption: TRzLabel;
    RzGroupBox4: TRzGroupBox;
    ccx_isuser: TRzCheckBox;
    ccx_isusergroup: TRzCheckBox;
    ccx_ischangepassword: TRzCheckBox;
    pnl_accusergroup: TRzPanel;
    lbl_accusergroup: TRzLabel;
    ccx_ispenjualan: TRzCheckBox;
    ccx_isitem: TRzCheckBox;
    RzGroupBox5: TRzGroupBox;
    ccx_ispembelian: TRzCheckBox;
    ccx_ispiutang: TRzCheckBox;
    ccx_isreturpembelian: TRzCheckBox;
    ccx_ishutang: TRzCheckBox;
    ccx_isadjust: TRzCheckBox;
    ccx_islistpembelian: TRzCheckBox;
    ccx_islistreturpembelian: TRzCheckBox;
    ccx_isoperasional: TRzCheckBox;
    ccx_isbackup: TRzCheckBox;
    ccx_isrestore: TRzCheckBox;
    ccx_ispindahgudang: TRzCheckBox;
    ccx_islistpindahgudang: TRzCheckBox;
    ccx_isgolongan: TRzCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure setdisplaycontrol(vtag: byte);
  public
    { Public declarations }
    procedure FormShowFirst;
  end;

var
  FrmUserGroup: TFrmUserGroup;

implementation

uses sparepartfunction, Data;

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

procedure TFrmUserGroup.FormShowFirst;
begin

 setdisplaycontrol(BROWSE_ACCESS);

 DataModule1.ZQryUserGroup.Close;
 DataModule1.ZQryUserGroup.Open;

end;

procedure TFrmUserGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 DataModule1.ZQryUserGroup.Close;
end;

procedure TFrmUserGroup.BtnAddClick(Sender: TObject);
begin
 setdisplaycontrol(ADD_ACCESS);

 edt_nama.Enabled := true;
 edt_nama.Text:='';

 ccx_isitem.Checked := False;
 ccx_iscustomer.Checked := False;
 ccx_issales.Checked := False;
 ccx_issupplier.Checked := False;
 ccx_isgolongan.Checked := False;

 ccx_ispenjualan.Checked := False;
 ccx_isretur.Checked := False;
 ccx_ispiutang.Checked := False;

 ccx_ispembelian.Checked := False;
 ccx_isreturpembelian.Checked := False;
 ccx_ishutang.Checked := False;

 ccx_isadjust.Checked := False;

 ccx_isoperasional.Checked := False;
 ccx_islistpenjualan.Checked := False;
 ccx_islistretur.Checked := False;
 ccx_islistpembelian.Checked := False;
 ccx_islistreturpembelian.Checked := False;

 ccx_isbackup.Checked := False;
 ccx_isrestore.Checked := False;

 ccx_ischangepassword.Checked := False;
 ccx_isuser.Checked := False;
 ccx_isusergroup.Checked := False;

 ccx_ispindahgudang.Checked := False;
 ccx_islistpindahgudang.Checked := False;

 edt_nama.SetFocus;
end;

procedure TFrmUserGroup.BtnEditClick(Sender: TObject);
begin
 setdisplaycontrol(EDIT_ACCESS);

 edt_nama.Enabled := false;
 edt_nama.Text:='';

 ccx_isitem.Checked := False;
 ccx_iscustomer.Checked := False;
 ccx_issales.Checked := False;
 ccx_issupplier.Checked := False;
 ccx_isgolongan.Checked := False;

 ccx_ispenjualan.Checked := False;
 ccx_isretur.Checked := False;
 ccx_ispiutang.Checked := False;

 ccx_ispembelian.Checked := False;
 ccx_isreturpembelian.Checked := False;
 ccx_ishutang.Checked := False;

 ccx_isadjust.Checked := False;

 ccx_isoperasional.Checked := False;
 ccx_islistpenjualan.Checked := False;
 ccx_islistretur.Checked := False;
 ccx_islistpembelian.Checked := False;
 ccx_islistreturpembelian.Checked := False;

 ccx_isbackup.Checked := False;
 ccx_isrestore.Checked := False;

 ccx_ischangepassword.Checked := False;
 ccx_isuser.Checked := False;
 ccx_isusergroup.Checked := False;

 ccx_ispindahgudang.Checked := False;
 ccx_islistpindahgudang.Checked := False;

 if DataModule1.ZQryUserGroupusergroup.IsNull=false then edt_nama.Text := DataModule1.ZQryUserGroupusergroup.Value;

 if DataModule1.ZQryUserGroupisitem.IsNull=false then ccx_isitem.Checked := DataModule1.ZQryUserGroupisitem.Value = 1;
 if DataModule1.ZQryUserGroupiscustomer.IsNull=false then ccx_iscustomer.Checked := DataModule1.ZQryUserGroupiscustomer.Value = 1;
 if DataModule1.ZQryUserGroupissales.IsNull=false then ccx_issales.Checked := DataModule1.ZQryUserGroupissales.Value = 1;
 if DataModule1.ZQryUserGroupissupplier.IsNull=false then ccx_issupplier.Checked := DataModule1.ZQryUserGroupissupplier.Value = 1;
 if DataModule1.ZQryUserGroupisgolongan.IsNull=false then ccx_isgolongan.Checked := DataModule1.ZQryUserGroupisgolongan.Value = 1;

 if DataModule1.ZQryUserGroupispenjualan.IsNull=false then ccx_ispenjualan.Checked := DataModule1.ZQryUserGroupispenjualan.Value = 1;
 if DataModule1.ZQryUserGroupisretur.IsNull=false then ccx_isretur.Checked := DataModule1.ZQryUserGroupisretur.Value = 1;
 if DataModule1.ZQryUserGroupispiutang.IsNull=false then ccx_ispiutang.Checked := DataModule1.ZQryUserGroupispiutang.Value = 1;

 if DataModule1.ZQryUserGroupispembelian.IsNull=false then ccx_ispembelian.Checked := DataModule1.ZQryUserGroupispembelian.Value = 1;
 if DataModule1.ZQryUserGroupisreturpembelian.IsNull=false then ccx_isreturpembelian.Checked := DataModule1.ZQryUserGroupisreturpembelian.Value = 1;
 if DataModule1.ZQryUserGroupishutang.IsNull=false then ccx_ishutang.Checked := DataModule1.ZQryUserGroupishutang.Value = 1;

 if DataModule1.ZQryUserGroupisadjust.IsNull=false then ccx_isadjust.Checked := DataModule1.ZQryUserGroupisadjust.Value = 1;


 if DataModule1.ZQryUserGroupisoperasional.IsNull=false then ccx_isoperasional.Checked := DataModule1.ZQryUserGroupisoperasional.Value = 1;
 if DataModule1.ZQryUserGroupislistpenjualan.IsNull=false then ccx_islistpenjualan.Checked := DataModule1.ZQryUserGroupislistpenjualan.Value = 1;
 if DataModule1.ZQryUserGroupislistretur.IsNull=false then ccx_islistretur.Checked := DataModule1.ZQryUserGroupislistretur.Value = 1;
 if DataModule1.ZQryUserGroupislistpembelian.IsNull=false then ccx_islistpembelian.Checked := DataModule1.ZQryUserGroupislistpembelian.Value = 1;
 if DataModule1.ZQryUserGroupislistreturpembelian.IsNull=false then ccx_islistreturpembelian.Checked := DataModule1.ZQryUserGroupislistreturpembelian.Value = 1;

 if DataModule1.ZQryUserGroupisbackup.IsNull=false then ccx_isbackup.Checked := DataModule1.ZQryUserGroupisbackup.Value = 1;
 if DataModule1.ZQryUserGroupisrestore.IsNull=false then ccx_isrestore.Checked := DataModule1.ZQryUserGroupisrestore.Value = 1;

 if DataModule1.ZQryUserGroupischangepassword.IsNull=false then ccx_ischangepassword.Checked := DataModule1.ZQryUserGroupischangepassword.Value = 1;
 if DataModule1.ZQryUserGroupisuser.IsNull=false then ccx_isuser.Checked := DataModule1.ZQryUserGroupisuser.Value = 1;
 if DataModule1.ZQryUserGroupisusergroup.IsNull=false then ccx_isusergroup.Checked := DataModule1.ZQryUserGroupisusergroup.Value = 1;

 if DataModule1.ZQryUserGroupispindahgudang.IsNull=false then ccx_ispindahgudang.Checked := DataModule1.ZQryUserGroupispindahgudang.Value = 1;
 if DataModule1.ZQryUserGroupislistpindahgudang.IsNull=false then ccx_islistpindahgudang.Checked := DataModule1.ZQryUserGroupislistpindahgudang.Value = 1;

 ccx_isitem.SetFocus;
end;

procedure TFrmUserGroup.BtnDelClick(Sender: TObject);
var vusg : string;
    PosRecord: integer;
begin
 vusg := DataModule1.ZQryUserGroupusergroup.AsString;
 if QuestionDialog('Hapus Data User Group '+vusg+' ?')=false then exit;

 if DataModule1.ZConnection1.ExecuteDirect('delete from sparepart.usergroup where IDusergroup='+DataModule1.ZQryUserGroupIDusergroup.AsString) then
 begin
  PosRecord := DataModule1.ZQryUserGroup.RecNo;
  DataModule1.ZQryUserGroup.close;
  DataModule1.ZQryUserGroup.open;
  DataModule1.ZQryUserGroup.RecNo := PosRecord;
  LogInfo(UserName,'Menghapus User Group ' + vusg);
  InfoDialog('User Group ' + vusg + ' berhasil dihapus !');
 end
 else ErrorDialog('User Group ' + vusg + ' gagal dihapus !');
end;

procedure TFrmUserGroup.BtnSaveClick(Sender: TObject);
var visitem, viscustomer, vissales, vissupplier, vispenjualan, visretur, visgolongan: byte;
    vispiutang, vispembelian, visreturpembelian, vishutang, visadjust, visoperasional : byte;
    vislistpenjualan, vislistretur, vislistpembelian, vislistreturpembelian, visbackup : byte;
    visrestore, visuser, visusergroup, vischangepassword, vispindahgudang, vislistpindahgudang : byte;
begin
 if (edt_nama.Text='') then
 begin
  ErrorDialog('Isi dahulu Nama User Group!');
  exit;
 end;
 if (tag=ADD_ACCESS) and (isDataExist('select IDusergroup from sparepart.usergroup where usergroup='+ QuotedStr(edt_nama.Text) )) then
 begin
  ErrorDialog('User Group '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end
 else
 if (tag=EDIT_ACCESS) and (isDataExist('select IDusergroup from sparepart.usergroup where usergroup='+ QuotedStr(edt_nama.Text) + ' and IDusergroup<>' + DataModule1.ZQryUserGroupIDusergroup.AsString )) then
 begin
  ErrorDialog('User Group '+edt_nama.Text+' sudah terdaftar!');
  exit;
 end;

 visitem   := 0; viscustomer:=0; vissales:=0; vissupplier:=0; vispenjualan:=0; visretur:=0;
 vispiutang:= 0; vispembelian:=0; visreturpembelian:=0; vishutang:=0; visadjust:=0; visoperasional:=0;
 vislistpenjualan:=0; vislistretur:=0; vislistpembelian:=0; vislistreturpembelian:=0; visbackup:=0;
 visrestore:=0; visuser:=0; visusergroup:=0; vischangepassword:=0;  vispindahgudang:=0; vislistpindahgudang:=0;
 visgolongan:=0;

 if ccx_isitem.Checked then visitem:=1;
 if ccx_iscustomer.Checked then viscustomer:=1;
 if ccx_issales.Checked then vissales:=1;
 if ccx_issupplier.Checked then vissupplier:=1;
 if ccx_isgolongan.Checked then visgolongan:=1;

 if ccx_ispenjualan.Checked then vispenjualan:=1;
 if ccx_isretur.Checked then visretur:=1;
 if ccx_ispiutang.Checked then vispiutang:=1;

 if ccx_ispembelian.Checked then vispembelian:=1;

 if ccx_isreturpembelian.Checked then visreturpembelian:=1;
 if ccx_ishutang.Checked then vishutang:=1;

 if ccx_isadjust.Checked then visadjust:=1;

 if ccx_isoperasional.Checked then visoperasional:=1;
 if ccx_islistpenjualan.Checked then vislistpenjualan:=1;
 if ccx_islistretur.Checked then vislistretur:=1;
 if ccx_islistpembelian.Checked then vislistpembelian:=1;
 if ccx_islistreturpembelian.Checked then vislistreturpembelian:=1;

 if ccx_isbackup.Checked then visbackup:=1;
 if ccx_isrestore.Checked then visrestore:=1;

 if ccx_ischangepassword.Checked then vischangepassword:=1;
 if ccx_isuser.Checked then visuser:=1;
 if ccx_isusergroup.Checked then visusergroup:=1;

 if ccx_ispindahgudang.Checked then vispindahgudang:=1;
 if ccx_islistpindahgudang.Checked then vislistpindahgudang:=1;

 if tag=ADD_ACCESS then
 begin
   if DataModule1.ZConnection1.ExecuteDirect('insert into sparepart.usergroup (usergroup,isitem,iscustomer,issales,issupplier,isgolongan,ispenjualan,isretur'+
                                             ',ispiutang,ispembelian,isreturpembelian,ishutang,isadjust,isoperasional,islistpenjualan,islistretur,islistpembelian'+
                                             ',islistreturpembelian,isbackup,isrestore,ispindahgudang,islistpindahgudang,isuser,isusergroup,ischangepassword) values (' +
                                                                                                                              QuotedStr(edt_nama.Text) +
                                                                                                                        ',' + IntToStr(visitem) +
                                                                                                                        ',' + IntToStr(viscustomer) +
                                                                                                                        ',' + IntToStr(vissales) +
                                                                                                                        ',' + IntToStr(vissupplier) +
                                                                                                                        ',' + IntToStr(visgolongan) +
                                                                                                                        ',' + IntToStr(vispenjualan) +
                                                                                                                        ',' + IntToStr(visretur) +
                                                                                                                        ',' + IntToStr(vispiutang) +
                                                                                                                        ',' + IntToStr(vispembelian) +
                                                                                                                        ',' + IntToStr(visreturpembelian) +
                                                                                                                        ',' + IntToStr(vishutang) +
                                                                                                                        ',' + IntToStr(visadjust) +
                                                                                                                        ',' + IntToStr(visoperasional) +
                                                                                                                        ',' + IntToStr(vislistpenjualan) +
                                                                                                                        ',' + IntToStr(vislistretur) +
                                                                                                                        ',' + IntToStr(vislistpembelian) +
                                                                                                                        ',' + IntToStr(vislistreturpembelian) +
                                                                                                                        ',' + IntToStr(visbackup) +
                                                                                                                        ',' + IntToStr(visrestore) +
                                                                                                                        ',' + IntToStr(vispindahgudang) +
                                                                                                                        ',' + IntToStr(vislistpindahgudang) +
                                                                                                                        ',' + IntToStr(visuser) +
                                                                                                                        ',' + IntToStr(visusergroup) +
                                                                                                                        ',' + IntToStr(vischangepassword) +
                                                                                                                        ')') then
   begin
    InfoDialog('Tambah User Group ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Insert User Group ' + edt_Nama.Text );
   end
   else ErrorDialog('Tambah User Group ' + edt_Nama.Text + ' Gagal');
 end
 else
 begin
  if DataModule1.ZConnection1.ExecuteDirect('update sparepart.usergroup set '+
                                                                    'usergroup=' + QuotedStr(edt_nama.Text) +
                                                                    ',isitem=' + IntToStr(visitem) +
                                                                    ',iscustomer=' + IntToStr(viscustomer) +
                                                                    ',issales=' + IntToStr(vissales) +
                                                                    ',issupplier=' + IntToStr(vissupplier) +
                                                                    ',isgolongan=' + IntToStr(visgolongan) +
                                                                    ',ispenjualan=' + IntToStr(vispenjualan) +
                                                                    ',isretur=' + IntToStr(visretur) +
                                                                    ',ispiutang=' + IntToStr(vispiutang) +
                                                                    ',ispembelian=' + IntToStr(vispembelian) +
                                                                    ',isreturpembelian=' + IntToStr(visreturpembelian) +
                                                                    ',ishutang=' + IntToStr(vishutang) +
                                                                    ',isadjust=' + IntToStr(visadjust) +
                                                                    ',isoperasional=' + IntToStr(visoperasional) +
                                                                    ',islistpenjualan=' + IntToStr(vislistpenjualan) +
                                                                    ',islistretur=' + IntToStr(vislistretur) +
                                                                    ',islistpembelian=' + IntToStr(vislistpembelian) +
                                                                    ',islistreturpembelian=' + IntToStr(vislistreturpembelian) +
                                                                    ',isbackup=' + IntToStr(visbackup) +
                                                                    ',isrestore=' + IntToStr(visrestore) +
                                                                    ',ispindahgudang=' + IntToStr(vispindahgudang) +
                                                                    ',islistpindahgudang=' + IntToStr(vislistpindahgudang) +
                                                                    ',isuser=' + IntToStr(visuser) +
                                                                    ',isusergroup=' + IntToStr(visusergroup) +
                                                                    ',ischangepassword=' + IntToStr(vischangepassword) +
                                              ' where IDusergroup=' + DataModule1.ZQryUserGroupIDusergroup.AsString) then
  begin
    InfoDialog('Edit User Group ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Edit User Group ' + edt_Nama.Text );
  end
  else errorDialog('Edit User Group ' + edt_Nama.Text + ' gagal');
 end;

 setdisplaycontrol(BROWSE_ACCESS);

 DataModule1.ZQryUserGroup.close;
 DataModule1.ZQryUserGroup.Open;
end;

procedure TFrmUserGroup.BtnCancelClick(Sender: TObject);
begin
 setdisplaycontrol(BROWSE_ACCESS);
end;

end.
