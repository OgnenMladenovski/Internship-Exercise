table 50003 "OM Sample Request Setup"
{
    Caption = 'Sample Request Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Sample Request Nos."; Code[20])
        {
            Caption = 'Sample Request Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(3; "Default Max. Sample Qty."; Decimal)
        {
            Caption = 'Default Max. Sample Qty.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(4; "Max. Requests per Period"; Integer)
        {
            Caption = 'Max. Requests per Period';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(5; "Request Period"; DateFormula)
        {
            Caption = 'Request Period';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}