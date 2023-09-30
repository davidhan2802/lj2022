unit frmDlgGb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, frxpngimage, ExtCtrls, RzPanel, FileCtrl,
  RzFilSys, ComCtrls, RzTreeVw, RzListVw, RzShellCtrls, RzShellDialogs, JPEG;

type
  TfrmGambar = class(TForm)
    PanelGambar: TRzPanel;
    ImgOK: TImage;
    ImgBatal: TImage;
    LblOK: TRzLabel;
    LblBatal: TRzLabel;
    RzPanel1: TRzPanel;
    MsgLbl: TRzLabel;
    RzShellTree1: TRzShellTree;
    ImgList: TRzShellList;
    RzLabel1: TRzLabel;
    RzPanel2: TRzPanel;
    ImgPicture: TImage;
    procedure ImgOKClick(Sender: TObject);
    procedure ImgBatalClick(Sender: TObject);
    procedure ImgListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ImgListClick(Sender: TObject);
  private
    { Private declarations }
  public
    Path: string;
    { Public declarations }
  end;

var
  frmGambar: TfrmGambar;

implementation

{$R *.dfm}

procedure TfrmGambar.ImgOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGambar.ImgBatalClick(Sender: TObject);
begin
  Path := '';
  Close;
end;

procedure TfrmGambar.ImgListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_Down : begin
              if ImgList.ItemIndex < ImgList.Items.Count - 1 then
                ImgList.ItemIndex := ImgList.ItemIndex + 1;
              if LowerCase(ExtractFileExt(ImgList.SelectedItem.FileName)) = '.jpg' then
              begin
                Path := ImgList.SelectedItem.PathName;
                MsgLbl.Caption := Path;
                ImgPicture.Picture.LoadFromFile(Path);
              end;
            end;
  VK_Up   : begin
              if ImgList.ItemIndex > 0 then
                ImgList.ItemIndex := ImgList.ItemIndex - 1;
              if LowerCase(ExtractFileExt(ImgList.SelectedItem.FileName)) = '.jpg' then
              begin
                Path := ImgList.SelectedItem.PathName;
                MsgLbl.Caption := Path;
                ImgPicture.Picture.LoadFromFile(Path);
              end;
            end;
  VK_LEFT : begin
              if ImgList.ItemIndex > 17 then
                ImgList.ItemIndex := ImgList.ItemIndex - 17;
              if LowerCase(ExtractFileExt(ImgList.SelectedItem.FileName)) = '.jpg' then
              begin
                Path := ImgList.SelectedItem.PathName;
                MsgLbl.Caption := Path;
                ImgPicture.Picture.LoadFromFile(Path);
              end;
            end;
  VK_RIGHT: begin
              if ImgList.ItemIndex + 17 < ImgList.Items.Count then
                ImgList.ItemIndex := ImgList.ItemIndex + 17;
              if LowerCase(ExtractFileExt(ImgList.SelectedItem.FileName)) = '.jpg' then
              begin
                Path := ImgList.SelectedItem.PathName;
                MsgLbl.Caption := Path;
                ImgPicture.Picture.LoadFromFile(Path);
              end;
            end;
  end;
end;

procedure TfrmGambar.ImgListClick(Sender: TObject);
begin
  if LowerCase(ExtractFileExt(ImgList.SelectedItem.FileName)) = '.jpg' then
  begin
    Path := ImgList.SelectedItem.PathName;
    MsgLbl.Caption := Path;
    ImgPicture.Picture.LoadFromFile(Path);
  end; 
end;

end.
