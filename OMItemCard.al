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
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item can be sent as a sample.';
                }
                field("OM Max. Sample Qty."; Rec."OM Max. Sample Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum sample quantity. 0 means the setup default is used.';
                }
            }
        }
    }
}