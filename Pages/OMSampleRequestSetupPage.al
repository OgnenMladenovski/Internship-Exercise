page 50003 "OM Sample Request Setup"
{
    Caption = 'Sample Request Setup';
    PageType = Card;
    SourceTable = "OM Sample Request Setup";
    UsageCategory = Administration; //Se naogja vo prebaruvanjeto pod kategorija Administration 
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Sample Request Nos."; Rec."Sample Request Nos.")
                {
                    ToolTip = 'Specifies the number series for sample requests.';
                }
                field("Default Max. Sample Qty."; Rec."Default Max. Sample Qty.")
                {
                    ToolTip = 'Specifies the default maximum sample quantity.';
                }
                field("Max. Requests per Period"; Rec."Max. Requests per Period")
                {
                    ToolTip = 'Specifies the maximum number of requests per customer in the period.';
                }
                field("Request Period"; Rec."Request Period")
                {
                    ToolTip = 'Specifies the period for counting requests.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}