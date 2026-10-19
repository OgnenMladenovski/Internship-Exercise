pageextension 50002 "OM Customer Card" extends "Customer Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part(OMCustomerSamples; "OM Customer Samples FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action(OMSampleRequests)
            {
                ApplicationArea = All;
                Caption = 'Sample Requests';
                ToolTip = 'View the sample requests for this customer.';
                Image = List;
                RunObject = page "OM Sample Requests";
                RunPageLink = "Customer No." = field("No.");
            }
        }
        addlast(creation)
        {
            action(OMNewSampleRequest)
            {
                ApplicationArea = All;
                Caption = 'New Sample Request';
                ToolTip = 'Create a new sample request for this customer.';
                Image = NewDocument;

                trigger OnAction()
                var
                    SampleRequestMgt: Codeunit "OM Sample Request Mgt.";
                begin
                    SampleRequestMgt.CreateForCustomer(Rec);
                end;
            }
        }
    }
}