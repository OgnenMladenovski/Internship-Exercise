table 50002 "OM Sample Request Line"
{
    Caption = 'Sample Request Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "OM Sample Request Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item where("OM Sample Allowed" = const(true), Blocked = const(false));

            //Koga se izbira artikl se kopira: opis, edinica i cena i se proveruva kolichinata
            trigger OnValidate()
            var
                Item: Record Item;
                ItemNotAllowedErr: Label 'Item %1 is not allowed for samples or is blocked. Choose another item.', Comment = '%1 = Item number';
            begin
                TestStatusOpen();
                Item.Get("Item No.");
                //R2 - Artiklot mora da e Simple Allowed i da ne e blokiran
                if (not Item."OM Sample Allowed") or Item.Blocked then
                    Error(ItemNotAllowedErr, "Item No.");
                Description := Item.Description;
                "Unit of Measure Code" := Item."Base Unit of Measure";
                "Unit Price" := Item."Unit Price";
                "Line Amount" := 0;
                if Quantity <> 0 then
                    Validate(Quantity);
            end;
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            MinValue = 0;

            //Proverka dali kolichinata e validna i go presmetuva iznosot
            trigger OnValidate()
            var
                Item: Record Item;
                SampleRequestSetup: Record "OM Sample Request Setup";
                MaxQuantity: Decimal;
            begin
                TestStatusOpen();
                TestField("Item No.");
                Item.Get("Item No.");
                //R3 - Proverka dali kolichinata e validna i go presmetuva iznosot
                MaxQuantity := Item."OM Max. Sample Qty.";
                if MaxQuantity = 0 then begin
                    SampleRequestSetup.Get();
                    MaxQuantity := SampleRequestSetup."Default Max. Sample Qty.";
                end;
                if (Quantity <= 0) or (Quantity > MaxQuantity) then
                    Error(QuantityErr, MaxQuantity);
                "Line Amount" := Quantity * "Unit Price";
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }
        field(8; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount";
        }
    }

    //R12 - Liniite mozhat da se dodavaat, menuvaat i brishat samo ako requestot e Open
    trigger OnInsert()
    begin
        TestStatusOpen();
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;

    //Ja povikuva proverkata od Header za requestot na ovaa linija
    local procedure TestStatusOpen()
    var
        SampleRequestHeader: Record "OM Sample Request Header";
    begin
        SampleRequestHeader.Get("Document No.");
        SampleRequestHeader.TestStatusOpen();
    end;

    var
        QuantityErr: Label 'Quantity must be above 0 and at most %1.', Comment = '%1 = Maximum sample quantity';
}