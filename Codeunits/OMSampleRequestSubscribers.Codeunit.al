codeunit 50001 "OM Sample Request Subscribers"
{
    //R14 - Item ne moze da se izbrishe ako e na Open, Pending Approval ili Approved request
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure ItemOnBeforeDelete(var Rec: Record Item)
    var
        SampleRequestLine: Record "OM Sample Request Line";
        SampleRequestHeader: Record "OM Sample Request Header";
        ItemOnRequestErr: Label 'Item %1 cannot be deleted because it is on sample request %2. Cancel or ship the request first.', Comment = '%1 = Item number, %2 = Sample request number';
    begin
        if Rec.IsTemporary() then
            exit;

        SampleRequestLine.SetRange("Item No.", Rec."No.");
        if SampleRequestLine.FindSet() then
            repeat
                SampleRequestHeader.Get(SampleRequestLine."Document No.");
                if SampleRequestHeader.Status in [SampleRequestHeader.Status::Open, SampleRequestHeader.Status::"Pending Approval", SampleRequestHeader.Status::Approved] then
                    Error(ItemOnRequestErr, Rec."No.", SampleRequestHeader."No.");
            until SampleRequestLine.Next() = 0;
    end;

    //R14 - Customer ne moze da se izbrishe ako ima Open, Pending Approval ili Approved request
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure CustomerOnBeforeDelete(var Rec: Record Customer)
    var
        SampleRequestHeader: Record "OM Sample Request Header";
        CustomerOnRequestErr: Label 'Customer %1 cannot be deleted because it is on sample request %2. Cancel or ship the request first.', Comment = '%1 = Customer number, %2 = Sample request number';
    begin
        if Rec.IsTemporary() then
            exit;

        SampleRequestHeader.SetRange("Customer No.", Rec."No.");
        SampleRequestHeader.SetFilter(Status, '%1|%2|%3', SampleRequestHeader.Status::Open, SampleRequestHeader.Status::"Pending Approval", SampleRequestHeader.Status::Approved);
        if SampleRequestHeader.FindFirst() then
            Error(CustomerOnRequestErr, Rec."No.", SampleRequestHeader."No.");
    end;
}