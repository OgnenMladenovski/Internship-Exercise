page 50005 "OM Sample Request Input" //Pop-up za vnes na Rejection Reason (kaj Reject) i Tracking No. (kaj Mark as Shipped)
{
    Caption = 'Enter Value';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(InputValue; InputValue)
            {
                Caption = 'Value';
                ToolTip = 'Specifies the value to enter.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Caption := DialogCaption;
    end;

    var
        InputValue: Text[250];
        DialogCaption: Text;

    procedure SetDialogCaption(NewDialogCaption: Text)
    begin
        DialogCaption := NewDialogCaption;
    end;

    procedure GetInputValue(): Text[250]
    begin
        exit(InputValue);
    end;
}