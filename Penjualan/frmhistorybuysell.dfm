object frmHistoryBS: TfrmHistoryBS
  Left = 172
  Top = 214
  BorderStyle = bsSingle
  Caption = 'frmHistoryBS'
  ClientHeight = 223
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Georgia'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PanelProd: TRzPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 223
    Align = alClient
    BorderOuter = fsFlatBold
    Color = clLime
    TabOrder = 0
    DesignSize = (
      790
      221)
    object HistBuyDBGrid: TPDJDBGridEx
      Left = 14
      Top = 19
      Width = 763
      Height = 190
      Anchors = [akLeft, akTop, akRight]
      DataSource = DSHistBuy
      FixedColor = 8454143
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Georgia'
      TitleFont.Style = [fsBold]
      WordWrap = True
      Rows.RowsMark = True
      Rows.RowsMarkColor = 12910591
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Tanggal'
          Title.Alignment = taCenter
          Title.Caption = 'Tgl. Beli'
          Width = 95
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'faktur'
          Title.Alignment = taCenter
          Title.Caption = 'No. Faktur'
          Width = 111
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'quantity'
          Title.Alignment = taCenter
          Title.Caption = 'Qty'
          Width = 44
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'harganondiskon'
          Title.Alignment = taCenter
          Title.Caption = 'Harga Beli'
          Width = 95
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'diskon'
          Title.Alignment = taCenter
          Title.Caption = 'Disc (%)'
          Width = 65
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'hargabeli'
          Title.Alignment = taCenter
          Title.Caption = 'Netto'
          Width = 107
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'supplier'
          Title.Alignment = taCenter
          Title.Caption = 'Supplier'
          Width = 205
          Visible = True
          Max = 100
          Min = 0
        end>
    end
    object HistSellDBGrid: TPDJDBGridEx
      Left = 14
      Top = 19
      Width = 763
      Height = 190
      Anchors = [akLeft, akTop, akRight]
      DataSource = DSHistSell
      FixedColor = 8454143
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Georgia'
      TitleFont.Style = [fsBold]
      WordWrap = True
      Rows.RowsMark = True
      Rows.RowsMarkColor = 12910591
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Tanggal'
          Title.Alignment = taCenter
          Title.Caption = 'Tgl. Jual'
          Width = 95
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'faktur'
          Title.Alignment = taCenter
          Title.Caption = 'No. Faktur'
          Width = 111
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'quantity'
          Title.Alignment = taCenter
          Title.Caption = 'Qty'
          Width = 44
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'hargajual'
          Title.Alignment = taCenter
          Title.Caption = 'Harga Jual'
          Width = 95
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'diskon'
          Title.Alignment = taCenter
          Title.Caption = 'Disc (%)'
          Width = 62
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'netto'
          Title.Alignment = taCenter
          Title.Caption = 'Netto'
          Width = 100
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'hargabeli'
          Title.Alignment = taCenter
          Title.Caption = 'HPP'
          Width = 90
          Visible = True
          Max = 100
          Min = 0
        end
        item
          Expanded = False
          FieldName = 'sales'
          Title.Alignment = taCenter
          Title.Caption = 'Sales'
          Width = 125
          Visible = True
          Max = 100
          Min = 0
        end>
    end
  end
  object ZQryhistorybuy: TZReadOnlyQuery
    Connection = DataModule1.ZConnection1
    SQL.Strings = (
      
        'select b.Tanggal,a.faktur,a.quantity,a.harganondiskon,a.diskon,a' +
        '.hargabeli,concat('#39'['#39',b.kodesupplier,'#39'] '#39',b.supplier) supplier '
      'from buydetail a left join buymaster b on a.faktur = b.faktur '
      'order by b.Tanggal desc, b.waktu desc limit 6 ')
    ParamCheck = False
    Params = <>
    Left = 128
    Top = 8
    object ZQryhistorybuyTanggal: TDateField
      FieldName = 'Tanggal'
    end
    object ZQryhistorybuyfaktur: TStringField
      FieldName = 'faktur'
      Size = 50
    end
    object ZQryhistorybuyquantity: TFloatField
      FieldName = 'quantity'
      ReadOnly = True
      DisplayFormat = '###,##0'
    end
    object ZQryhistorybuyharganondiskon: TFloatField
      FieldName = 'harganondiskon'
      DisplayFormat = '###,##0'
    end
    object ZQryhistorybuydiskon: TFloatField
      FieldName = 'diskon'
    end
    object ZQryhistorybuyhargabeli: TFloatField
      FieldName = 'hargabeli'
      DisplayFormat = '###,##0'
    end
    object ZQryhistorybuysupplier: TStringField
      FieldName = 'supplier'
      ReadOnly = True
      Size = 123
    end
  end
  object DSHistBuy: TDataSource
    DataSet = ZQryhistorybuy
    Left = 176
    Top = 8
  end
  object ZQryhistorysell: TZReadOnlyQuery
    Connection = DataModule1.ZConnection1
    SQL.Strings = (
      
        'select b.Tanggal,a.faktur,a.quantity,a.hargajual,a.diskon,a.harg' +
        'ajual-round(a.hargajual*a.diskon*0.01) netto,hargabeli,concat('#39'[' +
        #39',b.kodesales,'#39'] '#39',b.namasales) sales '
      'from selldetail a left join sellmaster b on a.faktur = b.faktur '
      'order by b.Tanggal desc, b.waktu desc limit 6 ')
    ParamCheck = False
    Params = <>
    Left = 240
    Top = 8
    object ZQryhistorysellTanggal: TDateField
      FieldName = 'Tanggal'
    end
    object ZQryhistorysellfaktur: TStringField
      FieldName = 'faktur'
      Size = 50
    end
    object ZQryhistorysellquantity: TIntegerField
      FieldName = 'quantity'
      DisplayFormat = '###,##0'
    end
    object ZQryhistorysellhargajual: TFloatField
      FieldName = 'hargajual'
      DisplayFormat = '###,##0'
    end
    object ZQryhistoryselldiskon: TFloatField
      FieldName = 'diskon'
    end
    object ZQryhistorysellnetto: TFloatField
      FieldName = 'netto'
      ReadOnly = True
      DisplayFormat = '###,##0'
    end
    object ZQryhistorysellhargabeli: TFloatField
      FieldName = 'hargabeli'
      DisplayFormat = '###,##0'
    end
    object ZQryhistorysellsales: TStringField
      FieldName = 'sales'
      ReadOnly = True
      Size = 123
    end
  end
  object DSHistSell: TDataSource
    DataSet = ZQryhistorysell
    Left = 272
    Top = 8
  end
end
