pageextension 50001 "OM User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("OM Sample Approval Limit"; Rec."OM Sample Approval Limit")
            {
                ApplicationArea = All; //Na page extension ne mozhe da se dodade ova pogore vo kodot, mora za sekoj field posebno
                ToolTip = 'Specifies the highest sample request amount the user can approve.';
            }
        }
    }
}