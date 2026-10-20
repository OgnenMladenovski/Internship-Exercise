table 50001 "OM Sample Request Header"
{
    Caption = 'Sample Request Header';
    DataClassification = CustomerContent;
    DrillDownPageId = "OM Sample Requests"; //Otvara lista na requests koi gi ispolnuvaat uslovite od FlowFieldot vo OMCustomer.al
    LookupPageId = "OM Sample Requests"; //Otvara lista na koja shto se izbirat requests

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            //Proverka dali e validen rachno vneseniot broj
            trigger OnValidate()
            var
                SampleRequestSetup: Record "OM Sample Request Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    SampleRequestSetup.Get();
                    NoSeries.TestManual(SampleRequestSetup."Sample Request Nos."); //Pokazhuva Error 
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            //Proverka dali ima linii, dali e blokiran i go zema imeto na kupuvachot
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if ("Customer No." <> xRec."Customer No.") and LinesExist() then
                    Error(CannotChangeCustomerErr, "No.");
                if "Customer No." = '' then begin
                    "Customer Name" := '';
                    exit;
                end;
                Customer.Get("Customer No.");
                CheckCustomerNotBlocked(Customer);
                "Customer Name" := Customer.Name;
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Contact E-mail"; Text[80])
        {
            Caption = 'Contact E-mail';
            DataClassification = CustomerContent;
            ExtendedDataType = "Email";

            //Proverka dali e validna email adresa
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Contact E-mail" <> '' then
                    MailManagement.CheckValidEmailAddress("Contact E-mail");
            end;
        }
        field(5; "Project"; Text[100])
        {
            Caption = 'Project';
            DataClassification = CustomerContent;
        }
        field(6; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Status"; Enum "OM Sample Request Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(9; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("OM Sample Request Line"."Line Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(10; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(11; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Tracking No."; Text[50])
        {
            Caption = 'Tracking No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Shipped Date"; Date)
        {
            Caption = 'Shipped Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    //Proveruva dali ima barem eden red za ovoj request
    procedure LinesExist(): Boolean
    var
        SampleRequestLine: Record "OM Sample Request Line";
    begin
        SampleRequestLine.SetRange("Document No.", "No.");
        exit(not SampleRequestLine.IsEmpty());
    end;

    //Na kreiranje go zema brojot i go postavuva datumot i korisnikot koj go kreiral
    trigger OnInsert()
    var
        SampleRequestSetup: Record "OM Sample Request Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            SampleRequestSetup.Get();
            SampleRequestSetup.TestField("Sample Request Nos.");
            "No. Series" := SampleRequestSetup."Sample Request Nos.";
            if NoSeries.AreRelated(SampleRequestSetup."Sample Request Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
        end;

        "Request Date" := WorkDate();
        "Requested By" := CopyStr(UserId(), 1, MaxStrLen("Requested By"));
    end;

    var
        CannotChangeCustomerErr: Label 'Request %1 has lines. Delete them to change the customer.', Comment = '%1 = Sample request number';
        CustomerBlockedErr: Label 'Customer %1 is blocked. Choose another customer.', Comment = '%1 = Customer number';

    //... Helper funkcija za izbiranje na serija i sleden broj
    procedure AssistEdit(OldSampleRequest: Record "OM Sample Request Header"): Boolean
    var
        SampleRequestSetup: Record "OM Sample Request Setup";
        NoSeries: Codeunit "No. Series";
    begin
        SampleRequestSetup.Get();
        SampleRequestSetup.TestField("Sample Request Nos.");
        if NoSeries.LookupRelatedNoSeries(SampleRequestSetup."Sample Request Nos.", OldSampleRequest."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    //Proverka dali kupuvachot e blokiran
    procedure CheckCustomerNotBlocked(Customer: Record Customer)
    begin
        if Customer.Blocked <> Customer.Blocked::" " then
            Error(CustomerBlockedErr, Customer."No.");
    end;
}