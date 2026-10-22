report 50000 "OM Sample Request"
{
    Caption = 'Sample Request';
    DefaultRenderingLayout = RDLCLayout; //Napomenato e da se koristi RDLC layout

    dataset
    {
        dataitem(Header; "OM Sample Request Header")
        {
            RequestFilterFields = "No.", "Customer No.";

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(RequestNo; "No.")
            {
            }
            column(RequestDate; Format("Request Date"))
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(ContactEmail; "Contact E-mail")
            {
            }

            dataitem(Line; "OM Sample Request Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(ItemNo; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitOfMeasure; "Unit of Measure Code")
                {
                }
            }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './Reports/Layout/OMSampleRequest.rdl';
        }
    }

    labels
    {
        ReportTitleLabel = 'Sample Request';
        RequestNoLabel = 'Request No.';
        RequestDateLabel = 'Request Date';
        CustomerLabel = 'Customer';
        ContactEmailLabel = 'Contact E-mail';
        ItemNoLabel = 'Item No.';
        DescriptionLabel = 'Description';
        QuantityLabel = 'Quantity';
        UnitOfMeasureLabel = 'Unit of Measure';
    }
}