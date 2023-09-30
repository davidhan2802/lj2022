unit usergroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Mask, RzEdit, ExtCtrls, ComCtrls,
  AdvSmoothButton, RzLabel, RzPanel, ESDBGrids, RzDTP, RzCmboBx, RzButton,
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
    ccx_ispenjualan: TRzCheckBox;
    ccx_iscustomer: TRzCheckBox;
    ccx_isretur: TRzCheckBox;
    ccx_ispemassage: TRzCheckBox;
    RzGroupBox2: TRzGroupBox;
    ccx_isadjust: TRzCheckBox;
    RzGroupBox3: TRzGroupBox;
    ccx_islistpenjualan: TRzCheckBox;
    ccx_islistpayment: TRzCheckBox;
    ccx_isitem: TRzCheckBox;
    ccx_islistretur: TRzCheckBox;
    pnl_usergroup: TRzPanel;
    lbl_caption: TRzLabel;
    ccx_isprintcustomer: TRzCheckBox;
    ccx_isprintlistitem: TRzCheckBox;
    ccx_isprintlistitemstockcard: TRzCheckBox;
    ccx_isprintlistpenjualan: TRzCheckBox;
    ccx_isprintfakturpenjualan: TRzCheckBox;
    ccx_isprintfakturretur: TRzCheckBox;
    ccx_iscancelpenjualan: TRzCheckBox;
    ccx_iscancelretur: TRzCheckBox;
    ccx_isprintfakturadjust: TRzCheckBox;
    ccx_iscanceladjust: TRzCheckBox;
    RzGroupBox4: TRzGroupBox;
    ccx_isuser: TRzCheckBox;
    ccx_isusergroup: TRzCheckBox;
    ccx_ischangepassword: TRzCheckBox;
    pnl_accusergroup: TRzPanel;
    lbl_accusergroup: TRzLabel;
    ccx_iscancellistpayment: TRzCheckBox;
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

 ccx_iscustomer.Checked := False;
 ccx_ispemassage.Checked := False;
 ccx_ispenjualan.Checked := False;
 ccx_isprintcustomer.Checked := False;
 ccx_isretur.Checked := False;

 ccx_isadjust.Checked := False;
 ccx_iscanceladjust.Checked := False;
 ccx_isitem.Checked := False;
 ccx_isprintfakturadjust.Checked := False;
 ccx_isprintlistitem.Checked := False;
 ccx_isprintlistitemstockcard.Checked := False;

 ccx_iscancelpenjualan.Checked := False;
 ccx_iscancelretur.Checked := False;
 ccx_iscancellistpayment.Checked := False;
 ccx_islistpayment.Checked := False;
 ccx_islistpenjualan.Checked := False;
 ccx_islistretur.Checked := False;
 ccx_isprintfakturpenjualan.Checked := False;
 ccx_isprintfakturretur.Checked := False;
 ccx_isprintlistpenjualan.Checked := False;

 ccx_ischangepassword.Checked := False;
 ccx_isuser.Checked := False;
 ccx_isusergroup.Checked := False;

 edt_nama.SetFocus;
end;

procedure TFrmUserGroup.BtnEditClick(Sender: TObject);
begin
 setdisplaycontrol(EDIT_ACCESS);

 edt_nama.Enabled := false;
 edt_nama.Text:='';

 ccx_iscustomer.Checked := False;
 ccx_ispemassage.Checked := False;
 ccx_ispenjualan.Checked := False;
 ccx_isprintcustomer.Checked := False;
 ccx_isretur.Checked := False;

 ccx_isadjust.Checked := False;
 ccx_iscanceladjust.Checked := False;
 ccx_isitem.Checked := False;
 ccx_isprintfakturadjust.Checked := False;
 ccx_isprintlistitem.Checked := False;
 ccx_isprintlistitemstockcard.Checked := False;

 ccx_iscancelpenjualan.Checked := False;
 ccx_iscancelretur.Checked := False;
 ccx_iscancellistpayment.Checked := False;
 ccx_islistpayment.Checked := False;
 ccx_islistpenjualan.Checked := False;
 ccx_islistretur.Checked := False;
 ccx_isprintfakturpenjualan.Checked := False;
 ccx_isprintfakturretur.Checked := False;
 ccx_isprintlistpenjualan.Checked := False;

 ccx_ischangepassword.Checked := False;
 ccx_isuser.Checked := False;
 ccx_isusergroup.Checked := False;

 if DataModule1.ZQryUserGroupusergroup.IsNull=false then edt_nama.Text := DataModule1.ZQryUserGroupusergroup.Value;

 if DataModule1.ZQryUserGroupiscustomer.IsNull=false then ccx_iscustomer.Checked := DataModule1.ZQryUserGroupiscustomer.Value = 1;
 if DataModule1.ZQryUserGroupispemassage.IsNull=false then ccx_ispemassage.Checked := DataModule1.ZQryUserGroupispemassage.Value = 1;
 if DataModule1.ZQryUserGroupispenjualan.IsNull=false then ccx_ispenjualan.Checked := DataModule1.ZQryUserGroupispenjualan.Value = 1;
 if DataModule1.ZQryUserGroupisprintcustomer.IsNull=false then ccx_isprintcustomer.Checked := DataModule1.ZQryUserGroupisprintcustomer.Value = 1;

 if DataModule1.ZQryUserGroupisretur.IsNull=false then ccx_isretur.Checked := DataModule1.ZQryUserGroupisretur.Value = 1;
 if DataModule1.ZQryUserGroupisadjust.IsNull=false then ccx_isadjust.Checked := DataModule1.ZQryUserGroupisadjust.Value = 1;
 if DataModule1.ZQryUserGroupiscanceladjust.IsNull=false then ccx_iscanceladjust.Checked := DataModule1.ZQryUserGroupiscanceladjust.Value = 1;


 if DataModule1.ZQryUserGroupisitem.IsNull=false then ccx_isitem.Checked := DataModule1.ZQryUserGroupisitem.Value = 1;
 if DataModule1.ZQryUserGroupisprintfakturadjust.IsNull=false then ccx_isprintfakturadjust.Checked := DataModule1.ZQryUserGroupisprintfakturadjust.Value = 1;
 if DataModule1.ZQryUserGroupisprintlistitem.IsNull=false then ccx_isprintlistitem.Checked := DataModule1.ZQryUserGroupisprintlistitem.Value = 1;
 if DataModule1.ZQryUserGroupisprintlistitemstockcard.IsNull=false then ccx_isprintlistitemstockcard.Checked := DataModule1.ZQryUserGroupisprintlistitemstockcard.Value = 1;

 if DataModule1.ZQryUserGroupiscancelpenjualan.IsNull=false then ccx_iscancelpenjualan.Checked := DataModule1.ZQryUserGroupiscancelpenjualan.Value = 1;
 if DataModule1.ZQryUserGroupiscancelretur.IsNull=false then ccx_iscancelretur.Checked := DataModule1.ZQryUserGroupiscancelretur.Value = 1;
 if DataModule1.ZQryUserGroupiscancellistpayment.IsNull=false then ccx_iscancellistpayment.Checked := DataModule1.ZQryUserGroupiscancellistpayment.Value = 1;
 if DataModule1.ZQryUserGroupislistpayment.IsNull=false then ccx_islistpayment.Checked := DataModule1.ZQryUserGroupislistpayment.Value = 1;
 if DataModule1.ZQryUserGroupislistpenjualan.IsNull=false then ccx_islistpenjualan.Checked := DataModule1.ZQryUserGroupislistpenjualan.Value = 1;
 if DataModule1.ZQryUserGroupislistretur.IsNull=false then ccx_islistretur.Checked := DataModule1.ZQryUserGroupislistretur.Value = 1;
 if DataModule1.ZQryUserGroupisprintfakturpenjualan.IsNull=false then ccx_isprintfakturpenjualan.Checked := DataModule1.ZQryUserGroupisprintfakturpenjualan.Value = 1;
 if DataModule1.ZQryUserGroupisprintfakturretur.IsNull=false then ccx_isprintfakturretur.Checked := DataModule1.ZQryUserGroupisprintfakturretur.Value = 1;
 if DataModule1.ZQryUserGroupisprintlistpenjualan.IsNull=false then ccx_isprintlistpenjualan.Checked := DataModule1.ZQryUserGroupisprintlistpenjualan.Value = 1;

 if DataModule1.ZQryUserGroupischangepassword.IsNull=false then ccx_ischangepassword.Checked := DataModule1.ZQryUserGroupischangepassword.Value = 1;
 if DataModule1.ZQryUserGroupisuser.IsNull=false then ccx_isuser.Checked := DataModule1.ZQryUserGroupisuser.Value = 1;
 if DataModule1.ZQryUserGroupisusergroup.IsNull=false then ccx_isusergroup.Checked := DataModule1.ZQryUserGroupisusergroup.Value = 1;

 ccx_ispenjualan.SetFocus;
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
var vispenjualan, viscustomer, visretur, vispemassage, visitem, visadjust, viscanceladjust : byte;
    vislistpenjualan, vislistretur, vislistpayment, visuser, visusergroup, vischangepassword, visprintcustomer : byte;
    visprintfakturretur, viscancelretur, visprintlistpenjualan, visprintfakturpenjualan, viscancelpenjualan : byte;
    visprintlistitem, visprintlistitemstockcard, visprintlistpayment, viscancellistpayment, visprintfakturadjust : byte;
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

 vispenjualan:=0; viscustomer:=0; visretur:=0; vispemassage:=0; visitem:=0; visadjust:=0; viscanceladjust:=0;
 vislistpenjualan:=0; vislistretur:=0; vislistpayment:=0; visuser:=0; visusergroup:=0; vischangepassword:=0; visprintcustomer:=0;
 visprintfakturretur:=0; viscancelretur:=0; visprintlistpenjualan:=0; visprintfakturpenjualan:=0; viscancelpenjualan:=0;
 visprintlistitem:=0; visprintlistitemstockcard:=0; visprintlistpayment:=0; viscancellistpayment:=0; visprintfakturadjust:=0;

 if ccx_iscustomer.Checked then viscustomer:=1;
 if ccx_ispemassage.Checked then vispemassage:=1;
 if ccx_ispenjualan.Checked then vispenjualan:=1;
 if ccx_isprintcustomer.Checked then visprintcustomer:=1;
 if ccx_isretur.Checked then visretur:=1;

 if ccx_isadjust.Checked then visadjust:=1;
 if ccx_iscanceladjust.Checked then viscanceladjust:=1;
 if ccx_isitem.Checked then visitem:=1;
 if ccx_isprintfakturadjust.Checked then visprintfakturadjust:=1;
 if ccx_isprintlistitem.Checked then visprintlistitem:=1;
 if ccx_isprintlistitemstockcard.Checked then visprintlistitemstockcard:=1;

 if ccx_iscancelpenjualan.Checked then viscancelpenjualan:=1;
 if ccx_iscancelretur.Checked then viscancelretur:=1;
 if ccx_iscancellistpayment.Checked then viscancellistpayment:=1;
 if ccx_islistpayment.Checked then vislistpayment:=1;
 if ccx_islistpenjualan.Checked then vislistpenjualan:=1;
 if ccx_islistretur.Checked then vislistretur:=1;
 if ccx_isprintfakturpenjualan.Checked then visprintfakturpenjualan:=1;
 if ccx_isprintfakturretur.Checked then visprintfakturretur:=1;
 if ccx_isprintlistpenjualan.Checked then visprintlistpenjualan:=1;

 if ccx_ischangepassword.Checked then vischangepassword:=1;
 if ccx_isuser.Checked then visuser:=1;
 if ccx_isusergroup.Checked then visusergroup:=1;

 if tag=ADD_ACCESS then
 begin
   if DataModule1.ZConnection1.ExecuteDirect('insert into sparepart.usergroup (usergroup, ispenjualan, iscustomer, isretur, ispemassage, isitem, isadjust, iscanceladjust' +
                            ',islistpenjualan, islistretur, islistpayment, isuser, isusergroup, ischangepassword, isprintcustomer' +
                            ',isprintfakturretur, iscancelretur, isprintlistpenjualan, isprintfakturpenjualan, iscancelpenjualan' +
                            ',isprintlistitem, isprintlistitemstockcard, isprintlistpayment, iscancellistpayment, isprintfakturadjust) values (' +

                                                                                                                              QuotedStr(edt_nama.Text) +
                                                                                                                        ',' + IntToStr(vispenjualan) +
                                                                                                                        ',' + IntToStr(viscustomer) +
                                                                                                                        ',' + IntToStr(visretur) +
                                                                                                                        ',' + IntToStr(vispemassage) +
                                                                                                                        ',' + IntToStr(visitem) +
                                                                                                                        ',' + IntToStr(visadjust) +
                                                                                                                        ',' + IntToStr(viscanceladjust) +
                                                                                                                        ',' + IntToStr(vislistpenjualan) +
                                                                                                                        ',' + IntToStr(vislistretur) +
                                                                                                                        ',' + IntToStr(vislistpayment) +
                                                                                                                        ',' + IntToStr(visuser) +
                                                                                                                        ',' + IntToStr(visusergroup) +
                                                                                                                        ',' + IntToStr(vischangepassword) +
                                                                                                                        ',' + IntToStr(visprintcustomer) +
                                                                                                                        ',' + IntToStr(visprintfakturretur) +
                                                                                                                        ',' + IntToStr(viscancelretur) +
                                                                                                                        ',' + IntToStr(visprintlistpenjualan) +
                                                                                                                        ',' + IntToStr(visprintfakturpenjualan) +
                                                                                                                        ',' + IntToStr(viscancelpenjualan) +
                                                                                                                        ',' + IntToStr(visprintlistitem) +
                                                                                                                        ',' + IntToStr(visprintlistitemstockcard) +
                                                                                                                        ',' + IntToStr(visprintlistpayment) +
                                                                                                                        ',' + IntToStr(viscancellistpayment) +
                                                                                                                        ',' + IntToStr(visprintfakturadjust) +
                                                                                                                        ')') then
   begin
    InfoDialog('Tambah User Group ' + edt_Nama.Text + ' berhasil');
    LogInfo(UserName,'Insert User Group ' + edt_Nama.Text );
   end
   else ErrorDialog('Tambah User Group ' + edt_Nama.Text + ' Gagal');
 end
 else
 begin
  if DataModule1.ZConnection1.ExecuteDirect('update sparepart.usergroup set usergroup=' + QuotedStr(edt_nama.Text) +
                                                                    ',ispenjualan=' + IntToStr(vispenjualan) +
                                                                    ',iscustomer=' + IntToStr(viscustomer) +
                                                                    ',isretur=' + IntToStr(visretur) +
                                                                    ',ispemassage=' + IntToStr(vispemassage) +
                                                                    ',isitem=' + IntToStr(visitem) +
                                                                    ',isadjust=' + IntToStr(visadjust) +
                                                                    ',iscanceladjust=' + IntToStr(viscanceladjust) +
                                                                    ',islistpenjualan=' + IntToStr(vislistpenjualan) +
                                                                    ',islistretur=' + IntToStr(vislistretur) +
                                                                    ',islistpayment=' + IntToStr(vislistpayment) +
                                                                    ',isuser=' + IntToStr(visuser) +
                                                                    ',isusergroup=' + IntToStr(visusergroup) +
                                                                    ',ischangepassword=' + IntToStr(vischangepassword) +
                                                                    ',isprintcustomer=' + IntToStr(visprintcustomer) +
                                                                    ',isprintfakturretur=' + IntToStr(visprintfakturretur) +
                                                                    ',iscancelretur=' + IntToStr(viscancelretur) +
                                                                    ',isprintlistpenjualan=' + IntToStr(visprintlistpenjualan) +
                                                                    ',isprintfakturpenjualan=' + IntToStr(visprintfakturpenjualan) +
                                                                    ',iscancelpenjualan=' + IntToStr(viscancelpenjualan) +
                                                                    ',isprintlistitem=' + IntToStr(visprintlistitem) +
                                                                    ',isprintlistitemstockcard=' + IntToStr(visprintlistitemstockcard) +
                                                                    ',isprintlistpayment=' + IntToStr(visprintlistpayment) +
                                                                    ',iscancellistpayment=' + IntToStr(viscancellistpayment) +
                                                                    ',isprintfakturadjust=' + IntToStr(visprintfakturadjust) +
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
