pageextension 50003 "OM Customer List" extends "Customer List"
{
    layout
    {
        addfirst(factboxes) //Go dodava Factboxot desno
        {
            part(OMCustomerSamples; "OM Customer Samples FactBox")
            {
                ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore vo kodot, mora za sekoj part posebno
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        addlast(navigation) //Related menito
        {
            action(OMSampleRequests) //Ja otvara listata na requests za izbraniot customer
            {
                ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore vo kodot, mora za sekoja akcija posebno
                Caption = 'Sample Requests';
                ToolTip = 'View the sample requests for this customer.';
                Image = List;
                RunObject = page "OM Sample Requests";
                RunPageLink = "Customer No." = field("No.");
            }
        }

        addlast(creation) //New Document menito
        {
            action(OMNewSampleRequest) //Kreira nov request za izbraniot customer
            {
                ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore vo kodot, mora za sekoja akcija posebno
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

        addlast(Category_Category5) //Ova go dodadov za New Sample Request da e promoted vo lentata New Document
        {
            actionref(OMNewSampleRequest_Promoted; OMNewSampleRequest)
            {
            }
        }
    }
}