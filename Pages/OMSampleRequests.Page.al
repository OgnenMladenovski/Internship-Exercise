page 50000 "OM Sample Requests"
{
    Caption = 'Sample Requests';
    PageType = List;
    SourceTable = "OM Sample Request Header";
    CardPageId = "OM Sample Request";
    UsageCategory = Lists; //So ova mozhe da se prebaruva na search bar
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Requests)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the request number.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the customers number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the request date.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the request.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the total amount of the request.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                Caption = 'Print';
                ToolTip = 'Print the selected sample requests.';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SampleRequest: Record "OM Sample Request Header";
                    SampleRequestMgt: Codeunit "OM Sample Request Mgt.";
                begin
                    CurrPage.SetSelectionFilter(SampleRequest); //Gi zema site selektirani requesti
                    SampleRequestMgt.PrintSampleRequests(SampleRequest);
                end;
            }
        }
    }
}