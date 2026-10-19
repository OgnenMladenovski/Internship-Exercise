codeunit 50000 "OM Sample Request Mgt."
{
    procedure CreateForCustomer(Customer: Record Customer)
    var
        SampleRequest: Record "OM Sample Request Header";
    begin
        SampleRequest.Init();
        SampleRequest.Validate("Customer No.", Customer."No.");
        SampleRequest.Insert(true);
        Page.Run(Page::"OM Sample Request", SampleRequest);
    end;
}