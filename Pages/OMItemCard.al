pageextension 50000 "OM Item Card" extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group(OMSamples)
            {
                Caption = 'Samples';

                field("OM Sample Allowed"; Rec."OM Sample Allowed")
                {
                    ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore vo kodot, mora za sekoj field posebno
                    ToolTip = 'Specifies if the item can be sent as a sample.';
                }
                field("OM Max. Sample Qty."; Rec."OM Max. Sample Qty.")
                {
                    ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore, mora za sekoj field posebno
                    ToolTip = 'Specifies the maximum sample quantity.';
                }
            }
        }
    }
}