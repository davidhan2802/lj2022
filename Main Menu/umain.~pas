unit umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, RzLabel, frxpngimage, ExtCtrls, ShellApi,
  RzStatus, jpeg;

type
  TFrMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Master1: TMenuItem;
    Item1: TMenuItem;
    Panel1: TPanel;
    RegisterUser1: TMenuItem;
    UbahPassword1: TMenuItem;
    N3: TMenuItem;
    Logout1: TMenuItem;
    mrqstatus: TRzMarqueeStatus;
    N5: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    N1: TMenuItem;
    Customer1: TMenuItem;
    Sales1: TMenuItem;
    N4: TMenuItem;
    Supplier1: TMenuItem;
    Transaction1: TMenuItem;
    InputReturPenjualan1: TMenuItem;
    InputPenjualan1: TMenuItem;
    Reports1: TMenuItem;
    DaftarPenjualan1: TMenuItem;
    DaftarReturPenjualan1: TMenuItem;
    DaftarPembelian1: TMenuItem;
    N6: TMenuItem;
    InputPembelian1: TMenuItem;
    N7: TMenuItem;
    InputReturPembelian1: TMenuItem;
    DaftarReturPembelian1: TMenuItem;
    N8: TMenuItem;
    InputStockAdjustment1: TMenuItem;
    PembayaranPiutang1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    PembayaranHutang1: TMenuItem;
    Keuangan1: TMenuItem;
    Operasional1: TMenuItem;
    Image1: TImage;
    BackUpData2: TMenuItem;
    Label1: TLabel;
    GroupUser1: TMenuItem;
    InputPindahGudang1: TMenuItem;
    N2: TMenuItem;
    DaftarPindahGudang1: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    InputUbahHarga1: TMenuItem;
    DaftarUbahHarga1: TMenuItem;
    RestoreData1: TMenuItem;
    N16: TMenuItem;
    InputOrderPenjualan1: TMenuItem;
    CustomerDiskon1: TMenuItem;
    Merk1: TMenuItem;
    procedure Item1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BackUpData1Click(Sender: TObject);
    procedure RestoreData1Click(Sender: TObject);
    procedure RegisterUser1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure UbahPassword1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Customer1Click(Sender: TObject);
    procedure Sales1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure InputPenjualan1Click(Sender: TObject);
    procedure InputReturPenjualan1Click(Sender: TObject);
    procedure DaftarPenjualan1Click(Sender: TObject);
    procedure DaftarReturPenjualan1Click(Sender: TObject);
    procedure DaftarPembelian1Click(Sender: TObject);
    procedure InputPembelian1Click(Sender: TObject);
    procedure InputReturPembelian1Click(Sender: TObject);
    procedure DaftarReturPembelian1Click(Sender: TObject);
    procedure InputStockAdjustment1Click(Sender: TObject);
    procedure PembayaranPiutang1Click(Sender: TObject);
    procedure PembayaranHutang1Click(Sender: TObject);
    procedure Operasional1Click(Sender: TObject);
    procedure GroupUser1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InputPindahGudang1Click(Sender: TObject);
    procedure DaftarPindahGudang1Click(Sender: TObject);
    procedure InputUbahHarga1Click(Sender: TObject);
    procedure DaftarUbahHarga1Click(Sender: TObject);
    procedure InputOrderPenjualan1Click(Sender: TObject);
    procedure CustomerDiskon1Click(Sender: TObject);
    procedure Merk1Click(Sender: TObject);
  private
    { Private declarations }
    procedure updatemasterkasir;
  public
    { Public declarations }
    procedure TutupMenu;
    procedure display_happy_birthday;
  end;

var
  FrMain: TFrMain;

implementation

uses sparepartfunction, Data, PgFolderDialog, uLogin, productmaster, merkmaster, customermaster, salesmaster, customerdiscmaster, sellmaster, frmSelling, frmSellingOrder, retursellmaster, frmReturJual, buymaster, frmbuying, frmReturBeli, returbuymaster, hutangmaster, operasionalmaster, frmAdjust, piutangmaster, userID, usergroup, change_password,
  suppliermaster, pindahgudang, pindahgudanglist, stockgudang, promodiskon, promodiskonlist, ubahharga, ubahhargalist;

{$R *.dfm}

procedure TFrMain.Item1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmproductmaster=nil then
 application.CreateForm(TFrmproductmaster,Frmproductmaster);
 Frmproductmaster.Align:=alclient;
 Frmproductmaster.Parent:=PANEL1;
 Frmproductmaster.BorderStyle:=bsnone;
 Frmproductmaster.FormShowFirst;
 Frmproductmaster.Show;
end;

procedure TFrMain.TutupMenu;
var i : byte;
begin
 for i := 0 to 4 do Master1.Items[i].visible := false;

 for i := 0 to 9 do Transaction1.Items[i].Visible := false;

 Keuangan1.Items[0].Visible := false;

 for i := 0 to 5 do reports1.Items[i].Visible := false;

 Tools1.Items[0].Visible := false;

 for i := 1 to 3 do File1.Items[i].Visible := false;

 File1.Visible         := false;
 Master1.Visible       := false;
 Transaction1.Visible  := false;
 Keuangan1.Visible     := false;
 Reports1.Visible      := false;
 Tools1.Visible        := false;
end;

procedure TFrMain.display_happy_birthday;
begin
 DataModule1.ZQryUtil.Close;
 DataModule1.ZQryUtil.SQL.Text := 'select f_happy_birthday()';
 DataModule1.ZQryUtil.Open;
 mrqstatus.Caption := DataModule1.ZQryUtil.Fields[0].AsString;
 DataModule1.ZQryUtil.Close;
 mrqstatus.Visible := not (mrqstatus.Caption='');
end;

procedure TFrMain.updatemasterkasir;
begin
//
end;

procedure TFrMain.FormShow(Sender: TObject);
begin
 TglSkrg := getnow;

 HeaderTitleRep := 'UD. Lautan Jaya';
 UserRight := 'Administrator';

 Logout1Click(Sender);

 mrqstatus.Caption := namagudang + ' - Login by ' + UserName + ' at ' + formatdatetime('dd/mm/yyyy hh:nn:ss',Tglskrg);

 if isdblocal=false then
  DataModule1.ZConnection1.ExecuteDirect('update product p, ubahhargadet u set p.`hargajual`=u.`hargajualbaru` ' +
  'where p.`IDproduct`=u.`IDproduct` and u.`tglberlaku`=date(now()) and p.`hargajual`<>u.`hargajualbaru`;')
 else updatemasterkasir;
end;

procedure TFrMain.BackUpData1Click(Sender: TObject);
var BackupPath: string;
begin
  ///Backup Database
  if MessageDlg('Backup Data?',mtConfirmation,[mbOk,mbCancel],0) = mrCancel then Exit;

  TUTUPFORM(PANEL1);
  IF FrmFolderDialog=nil then application.CreateForm(TFrmFolderDialog,FrmFolderDialog);
  FrmFolderDialog.isbackup := true;
  FrmFolderDialog.lbl_file.Caption := 'Folder';
//  DM.SQLCon.ExecuteDirect('Flush Tables with Read Lock');

  BackupPath := frmFolderDialog.OpenDialog('BACK UP DATA','.sql');
  if BackupPath = '' then
  begin
   ShowMessage('Proses Backup Database Batal!');
   exit;
  end;
  BackupPath := BackupPath+'\lj ' + FormatDateTime('dd-MM-yyyy hh nn',getNow) + '.sql';

  if ShellExecute(Handle,'open',PChar(vpath + 'MySQLDump.exe'),PChar('-u "metabrain" -p"meta289976" -P 3337 -R -r "' + BackupPath + '" sparepart'),PChar(vpath),SW_HIDE)>32 then
     ShowMessage('Database berhasil dibackup!')
  else ShowMessage('Proses Backup Database gagal!');

//  DM.SQLCon.ExecuteDirect('Unlock Tables');

  //  LogInfo(UserName,' Melakukan Backup Database');
end;

procedure TFrMain.RestoreData1Click(Sender: TObject);
var BackupPath,nmfile: string;
    F : TextFile;
begin
  ///Restore Database
  if MessageDlg('Restore Data?',mtConfirmation,[mbOk,mbCancel],0) = mrCancel then Exit;

  TUTUPFORM(PANEL1);
  IF FrmFolderDialog=nil then application.CreateForm(TFrmFolderDialog,FrmFolderDialog);
  FrmFolderDialog.isbackup := false;
  FrmFolderDialog.lbl_file.Caption := 'File Name';

//  DM.SQLCon.ExecuteDirect('Flush Tables with Read Lock');

  BackupPath := frmFolderDialog.OpenDialog('RESTORE DATA','.sql');
  if BackupPath = '' then
  begin
    Messagedlg('Database tidak dapat direstore!',mterror,[mbOK],0);
//    DM.SQLCon.ExecuteDirect('Unlock Tables');
    Exit;
  end;

  Datamodule1.ZConnection1.ExecuteDirect('Drop database '+dbname+'tes');
  Datamodule1.ZConnection1.ExecuteDirect('create database '+dbname+'tes');

  nmfile := vpath + 'rlj.bat';
  AssignFile(F,nmfile);
  Rewrite(F);
  Writeln(F,'MySQL.exe -u "metabrain" -p"meta289976" -P 3337 '+dbname+'tes < "' + BackupPath + '"');
  CloseFile(F);

  if ShellExecute(Handle,'open',PChar(nmfile),PChar(''),PChar(vpath),SW_HIDE)>32 then
  begin
   Datamodule1.ZConnection1.ExecuteDirect('Drop database '+dbname);
   Datamodule1.ZConnection1.ExecuteDirect('create database '+dbname);

   nmfile := vpath + 'rlj.bat';
   AssignFile(F,nmfile);
   Rewrite(F);
   Writeln(F,'MySQL.exe -u "metabrain" -p"meta289976" -P 3337 '+dbname+' < "' + BackupPath + '"');
   CloseFile(F);

   if ShellExecute(Handle,'open',PChar(nmfile),PChar(''),PChar(vpath),SW_HIDE)>32 then
      ShowMessage('Database berhasil di-restore!');
  end
  else ShowMessage('Proses Restore Database gagal!');

//    DM.SQLCon.ExecuteDirect('Unlock Tables');

//  LogInfo(UserName,'Melakukan Restore Database');
end;

procedure TFrMain.RegisterUser1Click(Sender: TObject);
begin

 TUTUPFORM(PANEL1);
 IF FrmUserID=nil then
 application.CreateForm(TFrmUserID,FrmUserID);
 FrmUserID.Align:=alclient;
 FrmUserID.Parent:=PANEL1;
 FrmUserID.BorderStyle:=bsnone;
 FrmUserID.FormShowFirst;
 FrmUserID.Show;
end;

procedure TFrMain.Logout1Click(Sender: TObject);
begin

 TutupMenu;

 TUTUPFORM(PANEL1);

 FLogin.Showmodal;
end;

procedure TFrMain.UbahPassword1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmchangepasswd=nil then
 application.CreateForm(TFrmchangepasswd,Frmchangepasswd);
 Frmchangepasswd.Align:=alclient;
 Frmchangepasswd.Parent:=PANEL1;
 Frmchangepasswd.BorderStyle:=bsnone;
 Frmchangepasswd.FormShowFirst;
 Frmchangepasswd.Show;
end;

procedure TFrMain.Exit1Click(Sender: TObject);
begin
 close;
end;

procedure TFrMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 TUTUPFORM(PANEL1);

// if (Datamodule1.ZConnection1.Port=3337)and(questiondialog('Synchronize Data?')) then Datamodule1.exportexternal;
end;

procedure TFrMain.Customer1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmcustomermaster=nil then
 application.CreateForm(TFrmcustomermaster,Frmcustomermaster);
 Frmcustomermaster.Align:=alclient;
 Frmcustomermaster.Parent:=PANEL1;
 Frmcustomermaster.BorderStyle:=bsnone;
 Frmcustomermaster.FormShowFirst;
 Frmcustomermaster.Show;

end;

procedure TFrMain.Sales1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmsalesmaster=nil then
 application.CreateForm(TFrmsalesmaster,Frmsalesmaster);
 Frmsalesmaster.Align:=alclient;
 Frmsalesmaster.Parent:=PANEL1;
 Frmsalesmaster.BorderStyle:=bsnone;
 Frmsalesmaster.FormShowFirst;
 Frmsalesmaster.Show;

end;

procedure TFrMain.Supplier1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmsuppliermaster=nil then
 application.CreateForm(TFrmsuppliermaster,Frmsuppliermaster);
 Frmsuppliermaster.Align:=alclient;
 Frmsuppliermaster.Parent:=PANEL1;
 Frmsuppliermaster.BorderStyle:=bsnone;
 Frmsuppliermaster.FormShowFirst;
 Frmsuppliermaster.Show;

end;

procedure TFrMain.InputPenjualan1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmSell=nil then
 application.CreateForm(TfrmSell,frmSell);
 frmSell.SellLblCaption.Caption := 'Tambah Penjualan';
 frmSell.Align:=alclient;
 frmSell.Parent:=PANEL1;
 frmSell.BorderStyle:=bsnone;
 frmSell.Show;

end;

procedure TFrMain.InputReturPenjualan1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmRtrJual=nil then
 application.CreateForm(TfrmRtrJual,frmRtrJual);
 frmRtrJual.Align:=alclient;
 frmRtrJual.Parent:=PANEL1;
 frmRtrJual.BorderStyle:=bsnone;
 frmRtrJual.Show;

end;

procedure TFrMain.DaftarPenjualan1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmsellmaster=nil then
 application.CreateForm(TFrmsellmaster,Frmsellmaster);
 Frmsellmaster.Align:=alclient;
 Frmsellmaster.Parent:=PANEL1;
 Frmsellmaster.BorderStyle:=bsnone;
 Frmsellmaster.FormShowFirst;
 Frmsellmaster.Show;

end;

procedure TFrMain.DaftarReturPenjualan1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF FrmRtrJualmaster=nil then
 application.CreateForm(TFrmRtrJualmaster,FrmRtrJualmaster);
 FrmRtrJualmaster.Align:=alclient;
 FrmRtrJualmaster.Parent:=PANEL1;
 FrmRtrJualmaster.BorderStyle:=bsnone;
 FrmRtrJualmaster.FormShowFirst;
 FrmRtrJualmaster.Show;

end;

procedure TFrMain.DaftarPembelian1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmbuymaster=nil then
 application.CreateForm(TFrmbuymaster,Frmbuymaster);
 Frmbuymaster.Align:=alclient;
 Frmbuymaster.Parent:=PANEL1;
 Frmbuymaster.BorderStyle:=bsnone;
 Frmbuymaster.FormShowFirst;
 Frmbuymaster.Show;

end;

procedure TFrMain.InputPembelian1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmBuy=nil then
 application.CreateForm(TfrmBuy,frmBuy);
 frmBuy.Align:=alclient;
 frmBuy.Parent:=PANEL1;
 frmBuy.BorderStyle:=bsnone;
 frmBuy.SellLblCaption.Caption := 'Input Pembelian';
 Frmbuy.FormShowFirst;
 frmBuy.Show;

end;

procedure TFrMain.InputReturPembelian1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmRtrBeli=nil then
 application.CreateForm(TfrmRtrBeli,frmRtrBeli);
 frmRtrBeli.Align:=alclient;
 frmRtrBeli.Parent:=PANEL1;
 frmRtrBeli.BorderStyle:=bsnone;
 frmRtrBeli.Show;

end;

procedure TFrMain.DaftarReturPembelian1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF FrmRtrBeliMaster=nil then
 application.CreateForm(TFrmRtrBeliMaster,FrmRtrBeliMaster);
 FrmRtrBeliMaster.Align:=alclient;
 FrmRtrBeliMaster.Parent:=PANEL1;
 FrmRtrBeliMaster.BorderStyle:=bsnone;
 FrmRtrBeliMaster.FormShowFirst;
 FrmRtrBeliMaster.Show;

end;

procedure TFrMain.InputStockAdjustment1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmadj=nil then
 application.CreateForm(Tfrmadj,frmadj);
 frmadj.Align:=alclient;
 frmadj.Parent:=PANEL1;
 frmadj.BorderStyle:=bsnone;
 frmadj.Show;
end;

procedure TFrMain.PembayaranPiutang1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmpiutangmaster=nil then
 application.CreateForm(Tfrmpiutangmaster,frmpiutangmaster);
 frmpiutangmaster.Align:=alclient;
 frmpiutangmaster.Parent:=PANEL1;
 frmpiutangmaster.BorderStyle:=bsnone;
 frmpiutangmaster.Show;
 frmpiutangmaster.FormShowFirst;
end;

procedure TFrMain.PembayaranHutang1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmhutangmaster=nil then
 application.CreateForm(Tfrmhutangmaster,frmhutangmaster);
 frmhutangmaster.Align:=alclient;
 frmhutangmaster.Parent:=PANEL1;
 frmhutangmaster.BorderStyle:=bsnone;
 frmhutangmaster.Show;
 frmhutangmaster.FormShowFirst;
end;

procedure TFrMain.Operasional1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmoperasionalmaster=nil then
 application.CreateForm(Tfrmoperasionalmaster,frmoperasionalmaster);
 frmoperasionalmaster.Align:=alclient;
 frmoperasionalmaster.Parent:=PANEL1;
 frmoperasionalmaster.BorderStyle:=bsnone;
 frmoperasionalmaster.FormShowFirst;
 frmoperasionalmaster.Show;
end;

procedure TFrMain.GroupUser1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF FrmUserGroup=nil then
 application.CreateForm(TFrmUserGroup,FrmUserGroup);
 FrmUserGroup.Align:=alclient;
 FrmUserGroup.Parent:=PANEL1;
 FrmUserGroup.BorderStyle:=bsnone;
 FrmUserGroup.FormShowFirst;
 FrmUserGroup.Show;

end;

procedure TFrMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
// if frmsell<>nil then frmsell.FormKeyPress(Sender,Key);
end;

procedure TFrMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
// if frmsell<>nil then frmsell.FormKeyDown(Sender,Key,Shift);
end;

procedure TFrMain.InputPindahGudang1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF FrmPindahGudang=nil then
 application.CreateForm(TFrmPindahGudang,FrmPindahGudang);
 FrmPindahGudang.Align:=alclient;
 FrmPindahGudang.Parent:=PANEL1;
 FrmPindahGudang.BorderStyle:=bsnone;
 FrmPindahGudang.tagacc := ADD_ACCESS;
 FrmPindahGudang.Show;

end;

procedure TFrMain.DaftarPindahGudang1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF FrmPindahGudanglist=nil then
 application.CreateForm(TFrmPindahGudanglist,FrmPindahGudanglist);
 FrmPindahGudanglist.Align:=alclient;
 FrmPindahGudanglist.Parent:=PANEL1;
 FrmPindahGudanglist.BorderStyle:=bsnone;
 FrmPindahGudanglist.FormShowFirst;
 FrmPindahGudanglist.Show;

end;

{procedure TFrMain.LoadDataFromGudangPusat1Click(Sender: TObject);
var vnmfile : string;
begin
 if OpenDialog1.Execute then
 begin
  vnmfile :=  stringreplace(OpenDialog1.FileName,'\','/',[rfReplaceAll,rfIgnorecase]);
  if Datamodule1.ZConnection1.ExecuteDirect('LOAD DATA INFILE "'+vnmfile+'" INTO TABLE inventoryimp;') then
  infodialog('Proses Loading Data From Gudang Pusat selesai.');
 end;
end;  }

procedure TFrMain.InputUbahHarga1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmubahharga=nil then
 application.CreateForm(TFrmubahharga,Frmubahharga);
 Frmubahharga.Align:=alclient;
 Frmubahharga.Parent:=PANEL1;
 Frmubahharga.BorderStyle:=bsnone;
 Frmubahharga.tagacc := ADD_ACCESS;
 Frmubahharga.Show;
end;

procedure TFrMain.DaftarUbahHarga1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmubahhargalist=nil then
 application.CreateForm(TFrmubahhargalist,Frmubahhargalist);
 Frmubahhargalist.Align:=alclient;
 Frmubahhargalist.Parent:=PANEL1;
 Frmubahhargalist.BorderStyle:=bsnone;
 Frmubahhargalist.FormShowFirst;
 Frmubahhargalist.Show;

end;

procedure TFrMain.InputOrderPenjualan1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF frmSellOrder=nil then
 application.CreateForm(TfrmSellOrder,frmSellOrder);
 frmSellOrder.Align:=alclient;
 frmSellOrder.Parent:=PANEL1;
 frmSellOrder.BorderStyle:=bsnone;
 frmSellOrder.Show;

end;

procedure TFrMain.CustomerDiskon1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmcustomerdiscmaster=nil then
 application.CreateForm(TFrmcustomerdiscmaster,Frmcustomerdiscmaster);
 Frmcustomerdiscmaster.Align:=alclient;
 Frmcustomerdiscmaster.Parent:=PANEL1;
 Frmcustomerdiscmaster.BorderStyle:=bsnone;
 Frmcustomerdiscmaster.FormShowFirst;
 Frmcustomerdiscmaster.Show;

end;

procedure TFrMain.Merk1Click(Sender: TObject);
begin
 TUTUPFORM(PANEL1);
 IF Frmmerkmaster=nil then
 application.CreateForm(TFrmmerkmaster,Frmmerkmaster);
 Frmmerkmaster.Align:=alclient;
 Frmmerkmaster.Parent:=PANEL1;
 Frmmerkmaster.BorderStyle:=bsnone;
 Frmmerkmaster.FormShowFirst;
 Frmmerkmaster.Show;

end;

end.
