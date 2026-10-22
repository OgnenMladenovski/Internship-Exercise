page 50004 "OM Customer Samples FactBox"
{
    Caption = 'Customer Samples';
    PageType = CardPart;
    SourceTable = Customer;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            field("OM Open Sample Requests"; Rec."OM Open Sample Requests")
            {
                ToolTip = 'Specifies the number of OPEN, PENDING APPROVAL and APPROVED sample requests.';
            }
            field("OM Shipped Sample Requests"; Rec."OM Shipped Sample Requests")
            {
                ToolTip = 'Specifies the number of SHIPPED sample requests.';
            }
        }
    }
}