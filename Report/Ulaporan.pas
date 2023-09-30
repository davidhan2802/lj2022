unit Ulaporan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzButton, RzCmboBx, RzLabel,
  ExtCtrls, RzPanel, Dateutils, DB, strutils, DBCtrls, RzDBCmbo, RzRadChk,
  frxClass, frxPreview, frxExportXLS, frxExportText;

type
  TFrmreport = class(TForm)
    pnl_choosereport: TRzPanel;
    RzLabel1: TRzLabel;
    cbreport: TRzComboBox;
    pnl_AccessReport: TRzPanel;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    RzBitBtn3: TRzBitBtn;
    RzBitBtn4: TRzBitBtn;
    RzBitBtn5: TRzBitBtn;
    RzBitBtn6: TRzBitBtn;
    edtPageNum: TRzEdit;
    RzBitBtn8: TRzBitBtn;
    EdtZoom: TRzEdit;
    RzBitBtn9: TRzBitBtn;
    frxPreview1: TfrxPreview;
    GB_Filter: TRzGroupBox;
    RzLabel4: TRzLabel;
    cb_gudang: TRzComboBox;
    RzLabel5: TRzLabel;
    cb_kode: TRzComboBox;
    cb_nama: TRzComboBox;
    RzLabel6: TRzLabel;
    cb_nama_group: TRzComboBox;
    cb_kode_group: TRzComboBox;
    RzBitBtn7: TRzBitBtn;
    lbl_periode: TRzLabel;
    DT_Start: TRzDateTimeEdit;
    lbl_sd: TRzLabel;
    DT_End: TRzDateTimeEdit;
    pnl_preview: TRzPanel;
    BTNPREVIEW: TRzBitBtn;
    btn_filtering: TRzBitBtn;
    frxXLSExport1: TfrxXLSExport;
    RzBitBtn10: TRzBitBtn;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    procedure BTNPREVIEWClick(Sender: TObject);
    procedure RzBitBtn5Click(Sender: TObject);
    procedure RzBitBtn6Click(Sender: TObject);
    procedure RzBitBtn4Click(Sender: TObject);
    procedure RzBitBtn3Click(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure RzBitBtn9Click(Sender: TObject);
    procedure RzBitBtn8Click(Sender: TObject);
    procedure frxPreview1PageChanged(Sender: TfrxPreview; PageNo: Integer);
    procedure cbreportChange(Sender: TObject);
    procedure cb_kodeChange(Sender: TObject);
    procedure cb_namaChange(Sender: TObject);
    procedure RzBitBtn7Click(Sender: TObject);
    procedure btn_filteringClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzBitBtn10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormShowFirst;

  end;

var
  Frmreport: TFrmreport;

implementation

uses SparePartFunction, data;

{$R *.dfm}

procedure TFrmreport.BTNPREVIEWClick(Sender: TObject);
begin
 frxPreview1.Zoom := 100.00;

 case cbReport.ItemIndex of
 end;

 GB_Filter.Visible:=false;
end;

procedure TFrmreport.RzBitBtn5Click(Sender: TObject);
begin
  frxPreview1.Next;
end;

procedure TFrmreport.RzBitBtn6Click(Sender: TObject);
begin
 frxPreview1.Last;
end;

procedure TFrmreport.RzBitBtn4Click(Sender: TObject);
begin
  frxPreview1.Prior;
end;

procedure TFrmreport.RzBitBtn3Click(Sender: TObject);
begin
   frxPreview1.First;
end;

procedure TFrmreport.RzBitBtn2Click(Sender: TObject);
begin
   frxPreview1.Zoom := frxPreview1.Zoom-0.2;

 EdtZoom.Text := FloatToStr(frxPreview1.Zoom*100)+'%';
end;

procedure TFrmreport.RzBitBtn1Click(Sender: TObject);
begin
  frxPreview1.Zoom := frxPreview1.Zoom+0.2;

 EdtZoom.Text := FloatToStr(frxPreview1.Zoom*100)+'%';
end;

procedure TFrmreport.RzBitBtn9Click(Sender: TObject);
begin
 frxPreview1.Print;
end;

procedure TFrmreport.RzBitBtn8Click(Sender: TObject);
begin
 frxPreview1.Export(frxXLSExport1);
end;

procedure TFrmreport.frxPreview1PageChanged(Sender: TfrxPreview;
  PageNo: Integer);
begin
  edtPageNum.Text := inttostr(PageNo);
 EdtZoom.Text := floatToStr(frxPreview1.Zoom*100)+'%';
{ RzStatusPane1.Caption := 'Halaman ke '+inttostr(PageNo)+
  ' dari '+inttostr(frxPreview1.AllPages)+' halaman'; }
end;

procedure TFrmreport.FormShowFirst;
var thism: TDate;
begin

 thism:= getNow;
 DT_Start.Date:= thism;
 DT_End.Date:= thism;

 cbreport.ItemIndex:=0;
 cbreportchange(cbreport);
end;

procedure TFrmreport.cbreportChange(Sender: TObject);
begin
 lbl_periode.Caption := 'Periode';
 lbl_sd.Caption      := 's/d';

 DT_start.Enabled:=true;
 DT_Start.Visible:=true;
 DT_End.Visible:=true;
 lbl_sd.visible:=true;


 pnl_AccessReport.Enabled:=cbreport.ItemIndex>-1;

 btn_Filtering.Visible:=false;
 GB_Filter.Visible:=false;

 lbl_periode.Visible:=true;
 DT_Start.Visible:=true;

 case cbReport.ItemIndex of
 4: btn_Filtering.Visible:=true;
 5: begin
     lbl_periode.Visible:=false;
     DT_Start.Visible:=false;

     btn_Filtering.Visible:=true;
    end;
 8,10,12: begin
      DT_start.Date:=strtodate('01/02/2011');
      DT_start.Enabled:=false;
      lbl_periode.Caption := 'Start';
      lbl_sd.Caption      := 'On';

     end;
 end;

end;

procedure TFrmreport.cb_kodeChange(Sender: TObject);
begin
 cb_nama.ItemIndex:= cb_kode.ItemIndex;
end;

procedure TFrmreport.cb_namaChange(Sender: TObject);
begin
 cb_kode.ItemIndex:= cb_nama.ItemIndex;
end;

procedure TFrmreport.cb_productgroup_change;
begin
end;

procedure TFrmreport.RzBitBtn7Click(Sender: TObject);
begin
 GB_Filter.Visible:=false;
end;

procedure TFrmreport.btn_filteringClick(Sender: TObject);
begin
 GB_Filter.Visible:=true;

end;

procedure TFrmreport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if DataModule1.frxReport1.Preview=frxPreview1 then frxPreview1.Clear;
end;

procedure TFrmreport.RzBitBtn10Click(Sender: TObject);
begin
// frxPreview1.Export(frxTXTExport1);
 frxPreview1.Export(frxSimpleTextExport1);
end;

end.
