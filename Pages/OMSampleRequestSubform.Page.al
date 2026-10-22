page 50002 "OM Sample Request Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "OM Sample Request Line";
    AutoSplitKey = true; //Avtomatski dodava Line No. na nov red
    DelayedInsert = true; //Se zachuvuva redot samo koga kje e celosno popolnet
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the item number.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the items description.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the unit of measure for that item.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity of the item.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true); //Live update na Total Amount
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price of one unit.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the line amount.';
                }
            }
        }
    }
}