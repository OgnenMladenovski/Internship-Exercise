enum 50000 "OM Sample Request Status"
{
    Extensible = true;
    Caption = 'Sample Request Status';

    value(0; "Open")
    {
        Caption = 'Open';
    }
    value(1; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(2; "Approved")
    {
        Caption = 'Approved';
    }
    value(3; "Rejected")
    {
        Caption = 'Rejected';
    }
    value(4; "Shipped")
    {
        Caption = 'Shipped';
    }
    value(5; "Cancelled")
    {
        Caption = 'Cancelled';
    }
}