page 50000 "Posted Purch Inv Data Update"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata 122 = rm, tabledata 380 = rm, tabledata "Vendor Ledger Entry" = rm;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                    TableRelation = "Purch. Inv. Header"."No.";
                    trigger OnValidate()
                    var
                        PurchInvHeader: Record 122;
                    begin
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", "Document No");
                        if PurchInvHeader.FindFirst() then begin
                            OldVendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";
                            OldDocumentDate := PurchInvHeader."Document Date";
                        end;
                    end;
                }
                field("Old Vendor Invoice No."; OldVendorInvoiceNo)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Old Document Date"; OldDocumentDate)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("New Vendor Invoice No."; NewVendorInvoiceNo)
                {
                    ApplicationArea = all;
                }
                field("New Document Date"; NewDocumentDate)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        PurchInvHeader: Record 122;
                    begin
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", "Document No");
                        if PurchInvHeader.FindFirst() then begin
                            IF PurchInvHeader."Posting Date" < NewDocumentDate then
                                Error('You can not add new document date greater then invoice posting date %1', PurchInvHeader."Posting Date");

                        end;
                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Data Update")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                trigger OnAction()
                begin
                    IF Not Confirm('Do you want to update the data', true) then
                        exit;

                    if "Document No" = '' then
                        Error('Please select the New Document No.');
                    IF NewDocumentDate = 0D then
                        Error('Please select the New Document Date');
                    if NewVendorInvoiceNo = '' then
                        Error('New Vendor Invoice No. should not be blank');

                    DataUpdate();
                    Message('Data Updated Successfully.....');
                    ClearData();


                end;
            }
        }
    }
    procedure ClearData()
    Begin
        Clear("Document No");
        Clear(NewDocumentDate);
        Clear(NewVendorInvoiceNo);
        Clear(OldDocumentDate);
        Clear(OldVendorInvoiceNo);
    End;

    procedure DataUpdate()
    Begin
        PurchInvoiceHeader.Reset();
        PurchInvoiceHeader.SetRange("No.", "Document No");
        if PurchInvoiceHeader.FindFirst() then begin
            PurchInvoiceHeader."Vendor Invoice No." := NewVendorInvoiceNo;
            PurchInvoiceHeader."Document Date" := NewDocumentDate;
            PurchInvoiceHeader.Modify();
        end;

        // Due Date Update on Purch Inv and vend Ledger and Detailed Vend Ledger Entry. 
        if (PurchInvoiceHeader."Payment Terms Code" <> '') and (PurchInvoiceHeader."Document Date" <> 0D) then begin
            PaymentTerms.Get(PurchInvoiceHeader."Payment Terms Code");
            PurchInvoiceHeader."Due Date" := CalcDate(PaymentTerms."Due Date Calculation", PurchInvoiceHeader."Document Date");
            PurchInvoiceHeader."Pmt. Discount Date" := CalcDate(PaymentTerms."Discount Date Calculation", PurchInvoiceHeader."Document Date");
            PurchInvoiceHeader."Payment Discount %" := PaymentTerms."Discount %";
            PurchInvoiceHeader.Modify();
        end else begin
            PurchInvoiceHeader.Validate("Due Date", PurchInvoiceHeader."Document Date");
            PurchInvoiceHeader.Validate("Pmt. Discount Date", 0D);
            PurchInvoiceHeader.Validate("Payment Discount %", 0);
            PurchInvoiceHeader.Modify();
        end;

        VendorLedEntry.Reset();
        VendorLedEntry.SetRange("Document No.", "Document No");
        if VendorLedEntry.FindFirst() then begin
            VendorLedEntry."External Document No." := NewVendorInvoiceNo;
            VendorLedEntry."Document Date" := NewDocumentDate;
            VendorLedEntry."Due Date" := PurchInvoiceHeader."Due Date";
            VendorLedEntry.Modify();
        End;
        DetailedVLE.Reset();
        DetailedVLE.SetRange("Document No.", "Document No");
        IF DetailedVLE.FindFirst() then begin
            DetailedVLE."Initial Entry Due Date" := PurchInvoiceHeader."Due Date";
            DetailedVLE.Modify();
        end;

    End;

    var
        "Document No": Code[20];
        OldVendorInvoiceNo: Code[35];
        OldDocumentDate: Date;
        NewVendorInvoiceNo: Code[35];
        NewDocumentDate: Date;
        PurchInvoiceHeader: Record 122;
        VendorLedEntry: Record "Vendor Ledger Entry";
        PaymentTerms: Record "Payment Terms";
        DetailedVLE: record "Detailed Vendor Ledg. Entry";
        DialogBox: Dialog;
}