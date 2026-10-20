tableextension 50002 "OM Customer" extends Customer
{
    fields
    {
        field(50000; "OM Open Sample Requests"; Integer)
        {
            Caption = 'Open Sample Requests';
            FieldClass = FlowField;
            CalcFormula = count("OM Sample Request Header" where("Customer No." = field("No."), Status = filter(Open | "Pending Approval" | Approved)));
            Editable = false;
        }
        field(50001; "OM Shipped Sample Requests"; Integer)
        {
            Caption = 'Shipped Sample Requests';
            FieldClass = FlowField;
            CalcFormula = count("OM Sample Request Header" where("Customer No." = field("No."), Status = const(Shipped)));
            Editable = false;
        }
    }
}