codeunit 50000 "OM Sample Request Mgt."
{
    //Limitot na odobruvanje na request za sample za korisnikot sto e logiran vo momentot
    local procedure GetApprovalLimit(): Decimal
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then
            exit(UserSetup."OM Sample Approval Limit");
        exit(0);
    end;

    //Promena na status na requestot za sample
    local procedure SetStatus(var SampleRequest: Record "OM Sample Request Header"; NewStatus: Enum "OM Sample Request Status")
    var
        OldStatus: Enum "OM Sample Request Status";
    begin
        OldStatus := SampleRequest.Status;
        SampleRequest.Status := NewStatus;
        SampleRequest.Modify(true);
        OnAfterStatusChanged(SampleRequest, OldStatus, NewStatus);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterStatusChanged(var SampleRequest: Record "OM Sample Request Header"; OldStatus: Enum "OM Sample Request Status"; NewStatus: Enum "OM Sample Request Status")
    begin
    end;

    //Kreira nov request za sample za odreden customer
    procedure CreateForCustomer(Customer: Record Customer)
    var
        SampleRequest: Record "OM Sample Request Header";
    begin
        SampleRequest.Init();
        SampleRequest.Validate("Customer No.", Customer."No.");
        SampleRequest.Insert(true);
        Page.Run(Page::"OM Sample Request", SampleRequest); //Ja otvara kartichkata na requestot za sample
    end;

    //Go podnesuva requestot (So proverka na R1, R4, R5 i R6)
    procedure Submit(var SampleRequest: Record "OM Sample Request Header")
    var
        Customer: Record Customer;
        SampleRequestSetup: Record "OM Sample Request Setup";
        OtherSampleRequest: Record "OM Sample Request Header";
        FromDate: Date;
        NoLinesErr: Label 'Add at least one line before you submit.';
        TooManyRequestsErr: Label 'Customer already has %1 requests since %2. Wait or cancel an older request.', Comment = '%1 = Number of requests, %2 = Start date';
    begin
        SampleRequest.TestField(Status, SampleRequest.Status::Open);

        //R1 - Proverka dali customerot e blokiran so funkcijata od Header
        Customer.Get(SampleRequest."Customer No.");
        SampleRequest.CheckCustomerNotBlocked(Customer);

        //R4 - Proverka dali ima barem eden line so funkcijata od Header
        if not SampleRequest.LinesExist() then
            Error(NoLinesErr);

        //R5 - Proverka dali kupuvachot go nadminal limitot na requests vo dadeniot period
        SampleRequestSetup.Get();
        if SampleRequestSetup."Max. Requests per Period" <> 0 then begin
            FromDate := CalcDate(SampleRequestSetup."Request Period", WorkDate());
            OtherSampleRequest.SetRange("Customer No.", SampleRequest."Customer No.");
            OtherSampleRequest.SetRange("Request Date", FromDate, WorkDate());
            OtherSampleRequest.SetFilter("No.", '<>%1', SampleRequest."No.");
            OtherSampleRequest.SetFilter(Status, '<>%1&<>%2', OtherSampleRequest.Status::Rejected, OtherSampleRequest.Status::Cancelled);
            if OtherSampleRequest.Count() >= SampleRequestSetup."Max. Requests per Period" then
                Error(TooManyRequestsErr, OtherSampleRequest.Count(), FromDate);
        end;

        //R6 - Proverka dali totalnata suma na requestot e pod limitot za odobruvanje
        SampleRequest.CalcFields("Total Amount");
        if SampleRequest."Total Amount" <= GetApprovalLimit() then begin
            SampleRequest."Approved By" := CopyStr(UserId(), 1, MaxStrLen(SampleRequest."Approved By"));
            SampleRequest."Approved Date" := WorkDate(); //Vo Headerot se barashe da se popolni on Approval
            SetStatus(SampleRequest, SampleRequest.Status::Approved); //Statusot e Approved i Approved By se popolnuva so momentalniot korisnik
        end else
            SetStatus(SampleRequest, SampleRequest.Status::"Pending Approval");
    end;

    //Odobruvanje na requestot (So proverka na R7)
    procedure Approve(var SampleRequest: Record "OM Sample Request Header")
    var
        OwnRequestErr: Label 'You cannot approve your own request. Ask another user to approve it.';
        LimitTooLowErr: Label 'The amount is above your approval limit. Ask a user with a higher limit.';
    begin
        //R7 - Proverka dali requestot ima status Pending Approval
        SampleRequest.TestField(Status, SampleRequest.Status::"Pending Approval");
        //R7 - Proverka dali korisnikot sto go odobrava ne e istiot koj go kreiral requestot
        if SampleRequest."Requested By" = UpperCase(UserId()) then
            Error(OwnRequestErr);
        SampleRequest.CalcFields("Total Amount");
        //R7 - Proverka dali momentalniot korisnik ima dovolno visok limit za odobruvanje
        if SampleRequest."Total Amount" > GetApprovalLimit() then
            Error(LimitTooLowErr);

        SampleRequest."Approved By" := CopyStr(UserId(), 1, MaxStrLen(SampleRequest."Approved By"));
        SampleRequest."Approved Date" := WorkDate();
        SetStatus(SampleRequest, SampleRequest.Status::Approved);
    end;

    //Odbivanje na requestot (So proverka na R7 i R8)
    procedure Reject(var SampleRequest: Record "OM Sample Request Header"; RejectionReason: Text[250])
    var
        OwnRequestErr: Label 'You cannot reject your own request. Ask another user to reject it.';
        LimitTooLowErr: Label 'The amount is above your approval limit. Ask a user with a higher limit.';
        ReasonRequiredErr: Label 'Enter a rejection reason.';
    begin
        //R7 - Proverka dali requestot ima status Pending Approval
        SampleRequest.TestField(Status, SampleRequest.Status::"Pending Approval");
        //R7 - Proverka dali korisnikot sto go odobrava ne e istiot koj go kreiral requestot
        if SampleRequest."Requested By" = UpperCase(UserId()) then
            Error(OwnRequestErr);
        SampleRequest.CalcFields("Total Amount");
        //R7 - Proverka dali momentalniot korisnik ima dovolno visok limit za odobruvanje
        if SampleRequest."Total Amount" > GetApprovalLimit() then
            Error(LimitTooLowErr);
        //R8 - Proverka dali e vnesena prichina za odbivanje
        if RejectionReason = '' then
            Error(ReasonRequiredErr);

        SampleRequest."Rejection Reason" := RejectionReason; //Postavuvanje na prichina za odbivanje
        SetStatus(SampleRequest, SampleRequest.Status::Rejected);
    end;

    //Oznachuvanje na requestot kako ispraten (So proverka na R9)
    procedure MarkAsShipped(var SampleRequest: Record "OM Sample Request Header"; TrackingNo: Text[50])
    var
        TrackingNoRequiredErr: Label 'Enter a tracking number.';
    begin
        //R9 - Samo Approved requests mozhat da se shipped
        SampleRequest.TestField(Status, SampleRequest.Status::Approved);
        //R9 - Tracking No. e required
        if TrackingNo = '' then
            Error(TrackingNoRequiredErr);

        SampleRequest."Tracking No." := TrackingNo;
        //R9 - Shipping date se postavuva na Work date
        SampleRequest."Shipped Date" := WorkDate();
        SetStatus(SampleRequest, SampleRequest.Status::Shipped);
    end;

    //Otkazhuvanje na requestot (So proverka na R10)
    procedure Cancel(var SampleRequest: Record "OM Sample Request Header")
    var
        CannotCancelErr: Label 'This request cannot be cancelled, because it isn''t Open, Pending Approval or Approved.';
        CancelQst: Label 'Cancel this request?';
    begin
        //R10 - Samo Open, Pending Approval i Approved mozhat da se otkazhat
        if not (SampleRequest.Status in [SampleRequest.Status::Open, SampleRequest.Status::"Pending Approval", SampleRequest.Status::Approved]) then
            Error(CannotCancelErr);
        //R10 - Potvrda od korisnikot
        if not Confirm(CancelQst) then
            exit;

        SetStatus(SampleRequest, SampleRequest.Status::Cancelled);
    end;

    //Reotvoranje na requestot (So proverka na R11)
    procedure Reopen(var SampleRequest: Record "OM Sample Request Header")
    var
        CannotReopenErr: Label 'This request cannot be reopened, because it isn''t Pending Approval, Approved or Rejected.';
    begin
        //R11 - Samo Pending Approval, Approved i Rejected mozhat povtorno da se otvorat
        if not (SampleRequest.Status in [SampleRequest.Status::"Pending Approval", SampleRequest.Status::Approved, SampleRequest.Status::Rejected]) then
            Error(CannotReopenErr);

        //R11 - Se brishat Approved By i Approved Date
        SampleRequest."Approved By" := '';
        SampleRequest."Approved Date" := 0D;
        SetStatus(SampleRequest, SampleRequest.Status::Open);
    end;

    //Go izvrshuva reportot za requestot
    procedure PrintSampleRequests(var SampleRequest: Record "OM Sample Request Header")
    begin
        Report.Run(Report::"OM Sample Request", true, false, SampleRequest);
    end;
}