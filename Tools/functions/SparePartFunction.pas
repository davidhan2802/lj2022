unit SparePartFunction;

interface
Uses Controls, Dialogs, DB, SysUtils, Windows, DateUtils , winsock ,RzCmboBx, RzChkLst, RzLstBox, ZDataset, Classes, PDJDBGridex, ExtCtrls, Math, Variants, StrUtils, DBGrids, Graphics, Forms, ShlObj, ShellApi, frxclass;

procedure PrintAmplop(KodeCust: string);
procedure PrintAmplopSupp(KodeSupp: string);
procedure PrintStruck(NoFaktur: string);
function getParentFolderDir: string;
function f_MustNumber(key:char):char;
function getNewUniqueID(FieldIDName,TblName: String): Cardinal;
function getMySQLDateStr(vDate: TDate): String;
function getData(FieldIDName,TblName: String): String;
function getDataNum(FieldIDName,TblName: String): double;
function IsDataExist(StrSQL: String):boolean;
function getstrtodate(vdatestr : string): TDate;
function getNow: TDateTime;
function GetComputerName: string;
function getComputerIP: string;
function GetDesktopPath: string;
function QuestionDialog(Question: string): boolean;
function WarningDialog(Warning: string): boolean;
function GetWorkDate: TDateTime;
function CheckLoginExists(NmUser,Password: string): string;
function Terbilang(sValue,kurs: string):string;
function GetNomerFormat(TipeNota: string): string;
function GetNomerReset(TipeNota: string): string;
function GetItemIndex(Teks: string; ComboBox: TRzComboBox): integer;
function isGudangEmpty(KodeGudang: string): boolean;
function isNoInventory(KodeBarang: string): Boolean;
function getIndonesianDay(seqday: byte): string;

procedure SetWorkDate(Tanggal: string);
procedure InfoDialog(Info: string);
procedure ErrorDialog(Teks: string);
procedure tutupform(ctl:Twincontrol);
procedure Fill_ComboBox_with_Data_n_ID(vcb: TRzComboBox; stringSQL, strshow, strid :string; IsAddAllItemEntry:boolean=False; IsAddEmptyEntry:boolean=False; vcbIndex:integer=-1);
procedure Fill_CheckListBox_with_Data_n_ID(vclb: TRzCheckList; stringSQL, strshow, strid :string; vclbIndex:integer=-1);
procedure FillComboBox(NmField,NmTabel: string; ComboBox: TRzComboBox;isposted:Boolean = False;orderby: string = '';isAllData:Boolean = False);
procedure FillCListBox(NmField,NmTabel: string; CListBox: TRzCheckList);
procedure RefreshTabel(NmTabel: TZQuery);
procedure ClearTabel(NmTabel: string);
procedure LogInfo(Username,Keterangan: string);
procedure SortArrowGrid(NmTabel: TPDJDBGridEx; FieldLines: integer);
procedure SearchLokasi(ComboBox: TRzComboBox; Versi: String);
procedure IndexCombo(ComboBox: TRzComboBox; Value: String);
procedure GetCompanyProfile;

implementation

uses Data, frmDialog;

procedure PrintAmplop(KodeCust: string);
var nmcust, almt, kota: string;
    FrxMemo: TfrxMemoView;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select nama,if((alamat2 is null)or(alamat2=""),alamat,alamat2),if((kota2 is null)or(kota2=""),kota,kota2) kotaamp from customer where kode='+QuotedStr(KodeCust);
    Open;
    nmcust :=  DataModule1.ZQryFunction.Fields[0].AsString;
    almt   :=  DataModule1.ZQryFunction.Fields[1].AsString;
    kota   :=  DataModule1.ZQryFunction.Fields[2].AsString;
    Close;
  end;
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\amplop.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Nmcustomer'));
  FrxMemo.Memo.Text := nmcust;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('alamat'));
  FrxMemo.Memo.Text := almt;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kota'));
  FrxMemo.Memo.Text := kota;

  DataModule1.frxReport1.ShowReport();

end;

procedure PrintAmplopSupp(KodeSupp: string);
var nmsupp, almt, kota: string;
    FrxMemo: TfrxMemoView;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select nama,if((alamat2 is null)or(alamat2=""),alamat,alamat2),if((kota2 is null)or(kota2=""),kota,kota2) kotaamp from supplier where kode='+QuotedStr(KodeSupp);
    Open;
    nmsupp :=  DataModule1.ZQryFunction.Fields[0].AsString;
    almt   :=  DataModule1.ZQryFunction.Fields[1].AsString;
    kota   :=  DataModule1.ZQryFunction.Fields[2].AsString;
    Close;
  end;
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\amplop.fr3');

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Nmcustomer'));
  FrxMemo.Memo.Text := nmsupp;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('alamat'));
  FrxMemo.Memo.Text := almt;

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kota'));
  FrxMemo.Memo.Text := kota;

  DataModule1.frxReport1.ShowReport();

end;

procedure PrintStruck(NoFaktur: string);
var
  FrxMemo: TfrxMemoView;
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.*,b.alamat,b.kota,dayofweek(a.Tanggal) hari from sellmaster a left join customer b');
    SQL.Add('on a.kodecustomer = b.kode');
    SQL.Add('where a.faktur = ''' + NoFaktur + '''');
    Open;
  end;
  DataModule1.frxReport1.LoadFromFile(vpath+'Report\fakturpenjualan.fr3');
{  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Judul'));
  FrxMemo.Memo.Text := frmUtama.TxtJudul.Caption; }
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('idpromo'));
  if DataModule1.ZQryFunction.FieldByName('kodepromo').Isnull then FrxMemo.Memo.Text := ''
  else if DataModule1.ZQryFunction.FieldByName('kodepromo').AsString='P1' then FrxMemo.Memo.Text := 'DS'
  else if DataModule1.ZQryFunction.FieldByName('kodepromo').AsString='P2' then FrxMemo.Memo.Text := 'KW';

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NoNota'));
  FrxMemo.Memo.Text := leftstr(DataModule1.ZQryFunction.FieldByName('Faktur').AsString,length(DataModule1.ZQryFunction.FieldByName('Faktur').AsString)-4)+'/'+rightstr(DataModule1.ZQryFunction.FieldByName('Faktur').AsString,4);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TglNota'));
  FrxMemo.Memo.Text := 'Semarang, '+getIndonesianDay(DataModule1.ZQryFunction.FieldByName('hari').AsInteger)+', '+FormatDateTime('dd-mm-yyyy',DataModule1.ZQryFunction.FieldByName('Tanggal').AsDateTime);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kodesales'));
  FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('kodesales').AsString;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kodecust'));
  FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('kodecustomer').AsString;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('NmCustomer'));
  FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('Customer').AsString;
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('kotaCustomer'));
  FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('kota').AsString;
  if DataModule1.ZQryFunction.FieldByName('Pembayaran').AsString = 'TUNAI' then
  begin
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('AlmCustomer'));
    FrxMemo.Memo.Text := '';
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TempoHari'));
    FrxMemo.Memo.Text := '-';
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TempoNota'));
    FrxMemo.Memo.Text := '-';
  end
  else
  begin
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('AlmCustomer'));
    FrxMemo.Memo.Text := DataModule1.ZQryFunction.FieldByName('Alamat').AsString;
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TempoHari'));
//    FrxMemo.Memo.Text := inttostr(daysbetween(DataModule1.ZQryFunction.FieldByName('Tanggal').AsDateTime,DataModule1.ZQryFunction.FieldByName('tgljatuhtempo').AsDateTime)-1)+' Hari';
    FrxMemo.Memo.Text := '30 Hari';
    FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('TempoNota'));
    FrxMemo.Memo.Text := FormatDateTime('dd-mm-yyyy',DataModule1.ZQryFunction.FieldByName('tgljatuhtempo').AsDateTime);
  end;

  ///Isi FormCustomer dengan DetailCustomer

  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('delete from formsell where ipv='+ Quotedstr(ipcomp) );
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Add('insert into formsell');
    SQL.Add('(nama,quantity,satuan,harga,diskon,diskon2,diskonrp,subtotal,vsubtotal,idstts,merk,tipe,kategori,kode,ipv)');
    SQL.Add('select nama,quantity,satuan,hargajual,diskon,diskon2,diskonrp,subtotal,vsubtotal,idstts,merk,tipe,kategori,kode,'+Quotedstr(ipcomp)+' from selldetail');
    SQL.Add('where faktur = "' + NoFaktur + '" order by kode');
    ExecSQL;
  end;

  DataModule1.ZQryFormSell.close;
  DataModule1.ZQryFormSell.SQL.Text := 'select * from formsell where ipv='+ Quotedstr(ipcomp) + ' order by kode ';
  DataModule1.ZQryFormSell.open;

{smentara ditutup  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemSubTotal'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryFunction.FieldByName('SubTotal').AsCurrency);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemDiscount'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryFunction.FieldByName('DiskonRp').AsCurrency);
}
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemGrandTotal'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryFunction.FieldByName('GrandTotal').AsCurrency);

  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('terbilang'));
  FrxMemo.Memo.Text := terbilang(DataModule1.ZQryFunction.FieldByName('GrandTotal').AsString,'Rupiah');

{  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemBayar'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryFunction.FieldByName('Bayar').AsCurrency);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('ItemKembalian'));
  FrxMemo.Memo.Text := FormatCurr('Rp ###,##0',DataModule1.ZQryFunction.FieldByName('Kembali').AsCurrency);
  FrxMemo := TfrxMemoView(DataModule1.frxReport1.FindObject('Kasir'));
  FrxMemo.Memo.Text := 'Kasir : ' + frmUtama.UserName;
}
  DataModule1.frxReport1.ShowReport();

  DataModule1.ZQryFormSell.close;
end;

function getParentFolderDir:string;
var i: integer;
    path : string;
begin
  path := ExtractFilePath(Application.exename);
  i:=length(path);
  path := copy(path,0,i-1);
  i:=length(path);
  while path[i]<>'\' do dec(i);
  delete(path,i+1,length(path));
  getParentFolderDir:=path;
end;

function GetDesktopPath: string;
var
  buf: array[0..MAX_PATH] of char;
  pidList: PItemIDList;
begin
  Result := 'No Desktop Folder found.';
  SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, pidList);
  if (pidList <> nil) then
    if (SHGetPathFromIDList(pidList, buf)) then
      Result := buf;
end;

function f_MustNumber(key:char):char;
begin
  if key in ['0'..'9',',','.',#8] then
    f_MustNumber:=key
  else
  begin
    MessageDlg('Masukkan input dalam bilangan angka (0-9) dengan benar...',mtError,[mbOK],0);
    f_MustNumber:=#0;
  end;
end;

function getNewUniqueID(FieldIDName,TblName: String): Cardinal;
begin
   if DataModule1.ZQrySearch.Active then DataModule1.ZQrySearch.Close;
   DataModule1.ZQrySearch.SQL.Clear;
   DataModule1.ZQrySearch.SQL.Text := 'select Max('+ FieldIDName +')+1 as NewID from '+ TblName;
   DataModule1.ZQrySearch.Open;

   if DataModule1.ZQrySearch.Fields[0].IsNull then
    result:= 0
   else
    result:= DataModule1.ZQrySearch.Fields[0].AsInteger;

   DataModule1.ZQrySearch.Close;
end;

function getMySQLDateStr(vDate: TDate): String;
begin
 Result:= FormatDateTime('yyyy-mm-dd',vDate);
end;

function getData(FieldIDName,TblName: String): String;
begin
   if DataModule1.ZQrySearch.Active then DataModule1.ZQrySearch.Close;
   DataModule1.ZQrySearch.SQL.Clear;
   DataModule1.ZQrySearch.SQL.Text := 'select '+ FieldIDName +' from '+ TblName;
   DataModule1.ZQrySearch.Open;

   if DataModule1.ZQrySearch.Fields[0].IsNull then
    result:= ''
   else
    result:= DataModule1.ZQrySearch.Fields[0].AsString;

   DataModule1.ZQrySearch.Close;
end;

function getDataNum(FieldIDName,TblName: String): double;
begin
   if DataModule1.ZQrySearch.Active then DataModule1.ZQrySearch.Close;
   DataModule1.ZQrySearch.SQL.Clear;
   DataModule1.ZQrySearch.SQL.Text := 'select '+ FieldIDName +' from '+ TblName;
   DataModule1.ZQrySearch.Open;

   if (DataModule1.ZQrySearch.IsEmpty) or (DataModule1.ZQrySearch.Fields[0].IsNull) then
    result:= 0
   else
    result:= DataModule1.ZQrySearch.Fields[0].AsFloat;

   DataModule1.ZQrySearch.Close;
end;

function IsDataExist(StrSQL: String):boolean;
begin
 with DataModule1.ZQrySearch do
 begin
  Close;
  SQL.Clear;
  SQL.Text:=StrSQL;
  Open;
  result:= not IsEmpty;
  Close;
 end;
end;

function getstrtodate(vdatestr : string): TDate;
var DateFmtSeparator: Char;
    DateFmtStr: String[20];
begin
  DateFmtSeparator:= DateSeparator;
  DateFmtStr:= shortdateformat;

  DateSeparator := '-';
  shortdateformat:='dd/mm/yyyy';

  result := strtodate(vdatestr);

  DateSeparator := DateFmtSeparator;
  shortdateformat:=DateFmtStr;
end;

function getNow: TDateTime;
var DateFmtSeparator: Char;
    DateFmtStr: String[20];
begin
  DateFmtSeparator:= DateSeparator;
  DateFmtStr:= shortdateformat;

  DateSeparator := '-';
  shortdateformat:='dd/mm/yyyy';

  with DataModule1.ZQrySearch do
  begin
   Close;
   SQL.Clear;
   SQL.Text:='select DATE_FORMAT(Now(),"%d-%m-%Y %T")';
   Open;

   result:= StrToDateTime(Fields[0].AsString);

   Close;
  end;

  DateSeparator := DateFmtSeparator;
  shortdateformat:=DateFmtStr;
end;

function GetComputerName: string;
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
end;

function getComputerIP: string;
var
  ss : array[0..128] of char;
  p : PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup(2, WSAData);

  {Get the computer name}
  GetHostName(@ss, 128);
  p := GetHostByName(@ss);
  {Get the IpAddress}
  result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);

  WSACleanup;
end;

function QuestionDialog(Question: string): boolean;
begin
  frmMessage.MsgQuestion(Question);
  frmMessage.ShowModal;
  Result := frmMessage.MsgValues;
end;

function WarningDialog(Warning: string): boolean;
begin
  frmMessage.MsgWarning(Warning);
  frmMessage.ShowModal;
  Result := frmMessage.MsgValues;
end;

function GetWorkDate: TDateTime;
var
  List: TStringList;
  Day,Month,Year: Word;
begin
  List := TStringList.Create;
  List.LoadFromFile(ConfigPath);
  Day := StrToInt(Copy(List.Strings[1],9,2));
  Month := StrToInt(Copy(List.Strings[1],6,2));
  Year := StrToInt(Copy(List.Strings[1],1,4));
  Result := EncodeDate(Year,Month,Day);
  List.Destroy;
end;

function CheckLoginExists(NmUser,Password: string): string;
begin
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from user');
    SQL.Add('where username = ' + QuotedStr(NmUser));
    SQL.Add('and password = ' + QuotedStr(Password));
    Open;
    if IsEmpty then
      Result := ''
    else
      Result := FieldValues['usergroup'];
  end;
end;

function Terbilang(sValue,kurs: string):string;
const
  Angka : array [1..20] of string =
          ('', 'Satu', 'Dua', 'Tiga', 'Empat',
           'Lima', 'Enam', 'Tujuh', 'Delapan',
           'Sembilan', 'Sepuluh', 'Sebelas',
           'Duabelas', 'Tigabelas', 'Empatbelas',
           'Limabelas', 'Enambelas', 'Tujuhbelas',
           'Delapanbelas', 'Sembilanbelas');
  sPattern: string = '000000000000000000000';
                    //123456789012345
var
  S : string;
  Satu, Dua, Tiga, Belas, Gabung, Kata: string;
  Sen, Sen1, Sen2: string;
  Hitung : integer;
  One, Two, Three: integer;

begin
  One    := 1;
  Two    := 2;
  Three  := 3;
  Hitung := 0;
  Kata   := '';
  S := copy(sPattern, 1, length(sPattern) - length(trim(sValue))) + sValue;
  Sen1 := Copy(S, 20, 1);
  Sen2 := Copy(S, 21, 1);
  Sen  := Sen1 + Sen2;
  while Hitung < 7 do
  begin
    Satu := Copy(S, One, 1);
    Dua  := Copy(S, Two, 1);
    Tiga := Copy(S, Three, 1);
    Gabung := Satu + Dua + Tiga;

    if StrToInt(Satu) = 1 then
       Kata := Kata + 'seratus '
    else
       if StrToInt(Satu) > 1 Then
          Kata := Kata + Angka[StrToInt(satu)+1] + ' ratus ';

    if StrToInt(Dua) = 1 then
    begin
      Belas := Dua + Tiga;
      Kata := Kata + Angka[StrToInt(Belas)+1];
    end
    else
       if StrToInt(Dua) > 1 Then
          Kata := Kata + Angka[StrToInt(Dua)+1] + ' puluh ' +
                  Angka[StrToInt(Tiga)+1]
    else
       if (StrToInt(Dua) = 0) and (StrToInt(Tiga) > 0) Then
          begin
            if ((Hitung = 5) and (Gabung = '001')) or
               ((Hitung = 5) and (Gabung = '  1')) then
               Kata := Kata + 'seribu '
            else
               Kata := Kata + Angka[StrToInt(Tiga)+1];
          end;

    if (hitung = 1) and (StrToInt(Gabung) > 0) then
       Kata := Kata + ' bilyun '
    else
    if (hitung = 2) and (StrToInt(Gabung) > 0) then
       Kata := Kata + ' trilyun '
    else
      if (hitung = 3) and (StrToInt(Gabung) > 0) then
         Kata := Kata + ' milyar '
      else
         if (Hitung = 4) and (StrToInt(Gabung) > 0) then
            Kata := Kata + ' juta '
      else
         if (Hitung = 5) and (StrToInt(Gabung) > 0) then
         begin
           if (Gabung = '001') or (Gabung = '  1') then
              Kata := Kata + ''
           else
              Kata := Kata + ' ribu ';
         end;
    Hitung := Hitung + 1;
    One    := One + 3;
    Two    := Two + 3;
    Three  := Three + 3;
  end;

  if length(Kata) > 1 then Kata := Kata + ' '+kurs+' ' else

  if (StrToInt(Sen) > 0) and (StrToInt(Sen) < 20) then
     begin
       if StrToInt(Sen) < 10 then Sen := Copy(Sen, 2, 1);
       Kata := Kata + Angka[StrToInt(Sen)+1] + ' sen';
     end
  else
     if StrToInt(Sen) > 19 then
        Kata := Kata + Angka[StrToInt(Sen1)+1] + 'puluh ' +
                Angka[StrToInt(Sen2)+1] + ' sen';
  Result := Kata;
end;

function GetNomerFormat(TipeNota: string): string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  if not FileExists(ConfigPath) then
  begin
    Result := '';
    Exit;
  end;
  List.LoadFromFile(ConfigPath);
  if TipeNota = 'BKM' then
  begin
    Result := Trim(Copy(List.Strings[4],8,200));
  end
  else
  if TipeNota = 'BKK' then
  begin
    Result := Trim(Copy(List.Strings[8],8,200));
  end
  else
  if TipeNota = 'Jual' then
  begin
    Result := Trim(Copy(List.Strings[12],8,200));
  end
  else
  if TipeNota = 'ReturJual' then
  begin
    Result := Trim(Copy(List.Strings[16],8,200));
  end
  else
  if TipeNota = 'ReturBeli' then
  begin
    Result := Trim(Copy(List.Strings[20],8,200));
  end;
  List.Destroy;
end;

function GetNomerReset(TipeNota: string): string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  List.LoadFromFile(ConfigPath);
  if TipeNota = 'BKM' then
  begin
    Result := Trim(Copy(List.Strings[5],8,200));
  end
  else
  if TipeNota = 'BKK' then
  begin
    Result := Trim(Copy(List.Strings[9],8,200));
  end
  else
  if TipeNota = 'Jual' then
  begin
    Result := Trim(Copy(List.Strings[13],8,200));
  end
  else
  if TipeNota = 'ReturJual' then
  begin
    Result := Trim(Copy(List.Strings[17],8,200));
  end
  else
  if TipeNota = 'ReturBeli' then
  begin
    Result := Trim(Copy(List.Strings[21],8,200));
  end;
  List.Destroy;
end;

function GetItemIndex(Teks: string; ComboBox: TRzComboBox): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to ComboBox.Items.Count - 1 do
  begin
    if ComboBox.Items.Strings[i] = Teks then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function isGudangEmpty(KodeGudang: string): boolean;
begin
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from inventory');
    SQL.Add('where kodegudang = ' + QuotedStr(KodeGudang) );
    Open;
    if IsEmpty then
      Result := False
    else
      Result := True;
  end;
end;

function isNoInventory(KodeBarang: string): Boolean;
begin
  with DataModule1.ZQrySearch do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from inventory');
    SQL.Add('where kodebrg = ' + QuotedStr(KodeBarang) );
    Open;
    if IsEmpty then
      Result := False
    else
      Result := True;
  end;
end;

function getIndonesianDay(seqday: byte): string;
begin
 case seqday of
 1 : Result := 'Minggu';
 2 : Result := 'Senin';
 3 : Result := 'Selasa';
 4 : Result := 'Rabu';
 5 : Result := 'Kamis';
 6 : Result := 'Jumat';
 7 : Result := 'Sabtu';
 end;
end;

procedure SetWorkDate(Tanggal: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  if not FileExists(ConfigPath) then
  begin
    List.Add('[Working Date]');
    List.Add(Tanggal);
    List.Add('');
    List.Add('[Nota Bukti Kas Masuk]');
    List.Add('format=');
    List.Add('reset=');
    List.Add('');
    List.Add('[Nota Bukti Kas Keluar]');
    List.Add('format=');
    List.Add('reset=');
    List.Add('');
    List.Add('[Nota Penjualan]');
    List.Add('format=');
    List.Add('reset=');
    List.Add('');
    List.Add('[Nota Retur Penjualan]');
    List.Add('format=');
    List.Add('reset=');
    List.Add('');
    List.Add('[Nota Retur Pembelian]');
    List.Add('format=');
    List.Add('reset=');
    List.Add('');
    List.SaveToFile(ConfigPath);
  end
  else
  begin
    List.Strings[1] := Tanggal;
    List.SaveToFile(ConfigPath);
  end;
  List.Destroy;
end;

procedure InfoDialog(Info: string);
begin
  frmMessage.MsgInfo(Info);
  frmMessage.ShowModal;
end;

procedure ErrorDialog(Teks: string);
begin
  frmMessage.MsgError(Teks);
  frmMessage.ShowModal;
end;

procedure tutupform(ctl:Twincontrol);
var i:integer;
begin
 for i:=0 to application.ComponentCount - 1 do
 begin
  if (application.Components[i] is Tform)and((application.Components[i] as Tform).Parent=ctl)and((application.Components[i] as Tform).visible) then
     (application.Components[i] as Tform).Close;
 end;
end;

procedure Fill_ComboBox_with_Data_n_ID(vcb: TRzComboBox; stringSQL, strshow, strid :string; IsAddAllItemEntry:boolean=False; IsAddEmptyEntry:boolean=False; vcbIndex:integer=-1);
begin
 if DataModule1.ZQryList.Active then DataModule1.ZQryList.Close;
 DataModule1.ZQryList.SQL.Clear;
 DataModule1.ZQryList.SQL.Add(stringSQL);
 DataModule1.ZQryList.Open;

 vcb.Clear;
 if (not DataModule1.ZQryList.IsEmpty)and(IsAddEmptyEntry) then vcb.Items.AddObject('', TObject(-1002));
 if (not DataModule1.ZQryList.IsEmpty)and(IsAddAllItemEntry) then vcb.Items.AddObject(ALL_ITEM_VAL, TObject(-1001));

 while not DataModule1.ZQryList.Eof do
 begin
  vcb.Items.AddObject(DataModule1.ZQryList.FieldByName(strshow).DisplayText,TOBject(DataModule1.ZQryList.FieldByName(strid).AsInteger));
  DataModule1.ZQryList.Next;
 end;
 DataModule1.ZQryList.Close;
 if vcb.Items.Count>0 then vcb.ItemIndex:=vcbIndex;
end;

procedure Fill_CheckListBox_with_Data_n_ID(vclb: TRzCheckList; stringSQL, strshow, strid :string; vclbIndex:integer=-1);
begin
 if DataModule1.ZQryList.Active then DataModule1.ZQryList.Close;
 DataModule1.ZQryList.SQL.Clear;
 DataModule1.ZQryList.SQL.Add(stringSQL);
 DataModule1.ZQryList.Open;

 vclb.Clear;
 while not DataModule1.ZQryList.Eof do
 begin
  vclb.Items.AddObject(DataModule1.ZQryList.FieldByName(strshow).DisplayText,TOBject(DataModule1.ZQryList.FieldByName(strid).AsInteger));
  DataModule1.ZQryList.Next;
 end;
 DataModule1.ZQryList.Close;
 if vclb.Items.Count>0 then vclb.ItemIndex:=vclbIndex;
end;


procedure FillComboBox(NmField,NmTabel: string; ComboBox: TRzComboBox;isposted:Boolean = False;orderby: string = '';isAllData:Boolean = False);
begin
  ComboBox.Items.Clear;
  with DataModule1.ZQryList do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select ' + NmField + ' from ' + NmTabel);
    if isposted = True then
      SQL.Add('where isposted = 1');
    if orderby='' then SQL.Add('order by ' + NmField)
    else SQL.Add('order by ' + orderby);
    Open;
    if not IsEmpty then First;
    if not IsEmpty and isAllData then ComboBox.Items.Add('-ALL-');
    While not Eof do
    begin
      ComboBox.Items.Add(Fields[0].AsString);
      Next;
    end;
    Close;
  end;
end;

procedure FillCListBox(NmField,NmTabel: string; CListBox: TRzCheckList);
begin
  CListBox.Items.Clear;
  with DataModule1.ZQryList do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select ' + NmField + ' from ' + NmTabel);
    SQL.Add('order by ' + NmField);
    Open;
    if not IsEmpty then
    First;
    While not Eof do
    begin
      CListBox.Items.Add(Fields[0].AsString);
      Next;
    end;
    Close;
  end;
end;

procedure RefreshTabel(NmTabel: TZQuery);
begin
  with NmTabel do
  begin
    Close;
    Open;
  end;
end;

procedure ClearTabel(NmTabel: string);
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    if NmTabel <> 'operasional' then
      SQL.Add('delete from ' + NmTabel)
    else
      SQL.Add('delete from operasional where kategori <> ''' + 'SALDO AWAL' + '''');
    ExecSQL;
  end;
end;

procedure LogInfo(UserName,Keterangan: string);
begin
  with DataModule1.ZQryFunction do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into loginfo');
    SQL.Add('(tanggal,waktu,username,computername,keterangan) values');
    SQL.Add('(' + QuotedStr(FormatDateTime('yyyy-MM-dd',Now)) + ',');
    SQL.Add(QuotedStr(FormatDateTime('hh:nn:ss',Now)) + ',');
    SQL.Add(QuotedStr(UserName) + ',');
    SQL.Add(QuotedStr(GetComputerName) + ',');
    SQL.Add(QuotedStr(Keterangan) + ')');
    ExecSQL;
  end;
end;

procedure SortArrowGrid(NmTabel: TPDJDBGridEx; FieldLines: integer);
var
  i: integer;
  Field,Sorted: string;
begin
  Field := Copy(ConfigINI.Strings[FieldLines],Pos('=',ConfigINI.Strings[FieldLines])+1,250);
  Sorted := Copy(ConfigINI.Strings[FieldLines + 1],Pos('=',ConfigINI.Strings[FieldLines + 1])+1,250);
  for i := 0 to NmTabel.Columns.Count - 1 do
  begin
    if NmTabel.PDJDBGridExColumn[i].FieldName = Field then
    begin
      NmTabel.OnTitleClick(NmTabel.PDJDBGridExColumn[i]);
      if (Sorted = '') and (NmTabel.PDJDBGridExColumn[i].SortArrow = saDown) then
        NmTabel.OnTitleClick(NmTabel.PDJDBGridExColumn[i])
      else
      if (Sorted <> '') and (NmTabel.PDJDBGridExColumn[i].SortArrow = saUp) then
        NmTabel.OnTitleClick(NmTabel.PDJDBGridExColumn[i]);
    end;
  end;
end;

procedure SearchLokasi(ComboBox: TRzComboBox; Versi: String);
begin
  ComboBox.Items.Clear;
  ComboBox.Items.Add('Semua (Toko & Gudang)');
  if Versi <> 'Spare Part Inventory Basic' then
  begin
    ComboBox.Items.Add('Toko');
    ComboBox.Items.Add('Semua Gudang');
  end;
end;

procedure IndexCombo(ComboBox: TRzComboBox; Value: String);
begin
  ComboBox.ItemIndex := ComboBox.Items.IndexOf(Value);
end;

procedure GetCompanyProfile;
{var
  List: TStringList; }
begin
{  List := TStringList.Create;
  List.LoadFromFile(ConfigPath);
  with fMain do
  begin
    AdminTxtCabang.Text := Trim(Copy(List.Strings[4],AnsiPos('=',List.Strings[4])+1,250));
    AdminTxtIP.Text := Trim(Copy(List.Strings[5],AnsiPos('=',List.Strings[5])+1,250));
    AdminTxtAlm1.Text := Trim(Copy(List.Strings[6],AnsiPos('=',List.Strings[6])+1,250));
    AdminTxtAlm2.Text := Trim(Copy(List.Strings[7],AnsiPos('=',List.Strings[7])+1,250));
    AdminTxtTelp.Text := Trim(Copy(List.Strings[8],AnsiPos('=',List.Strings[8])+1,250));
    AdminTxtFax.Text := Trim(Copy(List.Strings[9],AnsiPos('=',List.Strings[9])+1,250));
    AdminTxtKota.Text := Trim(Copy(List.Strings[10],AnsiPos('=',List.Strings[10])+1,250));
    AdminTxtWilayah.Text := Trim(Copy(List.Strings[11],AnsiPos('=',List.Strings[11])+1,250));
  end;
  List.Destroy;   }
end;

end.

