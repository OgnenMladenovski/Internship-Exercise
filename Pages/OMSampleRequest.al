page 50001 "OM Sample Request"
{
    Caption = 'Sample Request';
    PageType = Document;
    SourceTable = "OM Sample Request Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsOpen;

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the request number.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the customers number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("Contact E-mail"; Rec."Contact E-mail")
                {
                    ToolTip = 'Specifies the contact e-mail of the customer.';
                }
                field(Project; Rec.Project)
                {
                    ToolTip = 'Specifies the project.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the request date.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the request.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies who created the request.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the total amount of the request.';
                }
            }
            part(Lines; "OM Sample Request Subform")
            {
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both; //Za total amount da se update-va i pri insert i pri delete na linija
                Editable = IsOpen;
            }
            group(Approval)
            {
                Caption = 'Approval';
                Editable = false;

                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies who approved the request.';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the date of approval.';
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ToolTip = 'Specifies the reason for rejection.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                Editable = false;

                field("Tracking No."; Rec."Tracking No.")
                {
                    ToolTip = 'Specifies the tracking number for the shipment.';
                }
                field("Shipped Date"; Rec."Shipped Date")
                {
                    ToolTip = 'Specifies the date when the request was shipped.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
    end;

    var
        IsOpen: Boolean;
}