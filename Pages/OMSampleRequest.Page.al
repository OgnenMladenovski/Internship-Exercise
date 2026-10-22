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

    actions //6te akcii za menuvanje na statusot na requestot (Submit, Approve, Reject, Mark as Shipped, Cancel, Reopen) + 7ma akcija Print za printanje na requestot
    {
        area(Processing)
        {
            action(Submit)
            {
                Caption = 'Submit';
                ToolTip = 'Submit the request for approval.';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SampleRequestMgt.Submit(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Approve)
            {
                Caption = 'Approve';
                ToolTip = 'Approve the request.';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SampleRequestMgt.Approve(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Reject)
            {
                Caption = 'Reject';
                ToolTip = 'Reject the request with a reason.';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InputDialog: Page "OM Sample Request Input";
                    RejectionReasonLbl: Label 'Rejection Reason';
                begin
                    InputDialog.SetDialogCaption(RejectionReasonLbl);
                    if InputDialog.RunModal() = Action::OK then
                        SampleRequestMgt.Reject(Rec, InputDialog.GetInputValue());
                    CurrPage.Update(false);
                end;
            }

            action(MarkAsShipped)
            {
                Caption = 'Mark as Shipped';
                ToolTip = 'Mark the request as shipped with a tracking number.';
                Image = Shipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InputDialog: Page "OM Sample Request Input";
                    TrackingNoLbl: Label 'Tracking No.';
                begin
                    InputDialog.SetDialogCaption(TrackingNoLbl);
                    if InputDialog.RunModal() = Action::OK then
                        SampleRequestMgt.MarkAsShipped(Rec, CopyStr(InputDialog.GetInputValue(), 1, MaxStrLen(Rec."Tracking No.")));
                    CurrPage.Update(false);
                end;
            }

            action(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Cancel the request.';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SampleRequestMgt.Cancel(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Reopen)
            {
                Caption = 'Reopen';
                ToolTip = 'Reopen the request so it can be changed.';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SampleRequestMgt.Reopen(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(Print)
            {
                Caption = 'Print';
                ToolTip = 'Print the sample request.';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SampleRequest: Record "OM Sample Request Header";
                begin
                    SampleRequest := Rec;
                    SampleRequest.SetRecFilter();
                    SampleRequestMgt.PrintSampleRequests(SampleRequest);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
    end;

    var
        SampleRequestMgt: Codeunit "OM Sample Request Mgt.";
        IsOpen: Boolean;
}