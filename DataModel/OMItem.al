tableextension 50000 "OM Item" extends Item
{
    fields
    {
        field(50000; "OM Sample Allowed"; Boolean)
        {
            Caption = 'Sample Allowed';
            DataClassification = CustomerContent;
        }
        field(50001; "OM Max. Sample Qty."; Decimal)
        {
            Caption = 'Max. Sample Qty.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}