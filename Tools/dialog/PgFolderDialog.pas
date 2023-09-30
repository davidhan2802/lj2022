unit PgFolderDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzBckgnd, StdCtrls, RzLabel, ComCtrls, RzTreeVw, RzFilSys,
  RzCmboBx, RzShellCtrls, RzListVw, AdvSmoothButton, Mask, RzEdit,
  ShlObj, ActiveX, ShellCtrls, frxpngimage, ExtCtrls, RzPanel;

type
  TFrmFolderDialog = class(TForm)
    LblCaption: TRzLabel;
    TxtFileName: TRzEdit;
    lbl_file: TRzLabel;
    ShellComboBox1: TShellComboBox;
    ShellListView1: TShellListView;
    ShellTreeView1: TShellTreeView;
    RzPanel3: TRzPanel;
    ImgOK: TImage;
    ImgBatal: TImage;
    lbledit: TRzLabel;
    RzLabel5: TRzLabel;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    BtnDesktop: TAdvSmoothButton;
    BtnMyDoc: TAdvSmoothButton;
    BtnMyComp: TAdvSmoothButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnDesktopClick(Sender: TObject);
    procedure BtnMyDocClick(Sender: TObject);
    procedure BtnMyCompClick(Sender: TObject);
    procedure ImgOKClick(Sender: TObject);
    procedure ImgBatalClick(Sender: TObject);
    procedure ShellListView1AddFolder(Sender: TObject;
      AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ShellListView1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OpenFileName: String;
    FileTypes: string;
    { Private declarations }
  public
    isbackup : boolean;
    function OpenDialog(OpnCaption, OpnFileType: string): TFileName;
    function SaveDialog(SvCaption, SvFileType: string): TFileName;

    { Public declarations }
  end;

var
  FrmFolderDialog: TFrmFolderDialog;

implementation

uses Math;

{$R *.dfm}


function TFrmFolderDialog.OpenDialog(OpnCaption, OpnFileType: string): TFileName;
begin
  OpenFileName := '';
  LblCaption.Caption := OpnCaption;
  FileTypes := OpnFileType;
  ShowModal;
  Result := OpenFileName;
end;

function TFrmFolderDialog.SaveDialog(SvCaption, SvFileType: String): TFileName;
begin
  OpenFileName := '';
  LblCaption.Caption := SvCaption;
  FileTypes := SvFileType;
  ShowModal;
  Result := OpenFileName;
end;

procedure TFrmFolderDialog.FormCreate(Sender: TObject);
begin
  frmFolderDialog.Caption := Application.Title;
  FileTypes := '.';
end;

procedure TFrmFolderDialog.BtnDesktopClick(Sender: TObject);
begin
  ShellComboBox1.Root := 'rfDesktop';
  TxtFileName.Text := '';
end;

procedure TFrmFolderDialog.BtnMyDocClick(Sender: TObject);
begin
  ShellComboBox1.Root := 'rfPersonal';
end;

procedure TFrmFolderDialog.BtnMyCompClick(Sender: TObject);
begin
  ShellComboBox1.Root := 'rfMyComputer';
end;

procedure TFrmFolderDialog.ImgOKClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFolderDialog.ImgBatalClick(Sender: TObject);
begin
  OpenFileName := '';
  TxtFileName.Text := '';
  Close;
end;

procedure TFrmFolderDialog.ShellListView1AddFolder(Sender: TObject;
  AFolder: TShellFolder; var CanAdd: Boolean);
begin
  CanAdd := AFolder.IsFolder or (AnsiPos(FileTypes,AFolder.DisplayName) > 0);
end;

procedure TFrmFolderDialog.ShellListView1Click(Sender: TObject);
begin
  if isbackup and ShellListView1.SelectedFolder.IsFolder then
  begin
    OpenFileName := ShellListView1.SelectedFolder.PathName;
    TxtFileName.Text := OpenFileName;
  end;

  if (isbackup=false) and (not ShellListView1.SelectedFolder.IsFolder) then
  begin
    OpenFileName := ShellListView1.SelectedFolder.PathName;
    TxtFileName.Text := ExtractFileName(ShellListView1.SelectedFolder.PathName);
  end;
end;


procedure TFrmFolderDialog.FormShow(Sender: TObject);
begin
  OpenFileName := '';
  TxtFileName.Text := '';

end;

end.
