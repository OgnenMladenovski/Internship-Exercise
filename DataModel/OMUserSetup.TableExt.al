tableextension 50001 "OM User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "OM Sample Approval Limit"; Decimal)
        {
            Caption = 'Sample Approval Limit';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}