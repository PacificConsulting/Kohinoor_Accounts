page 50000 "Posted Purch Inv Data Update"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata 122 = rm;

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
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    IF NewDocumentDate = 0D then
                        Error('Please select the New Document Date');
                    if NewVendorInvoiceNo = '' then
                        Error('New Vendor Invoice No. should not be blank');

                    PurchInvoiceHeader.Reset();
                    PurchInvoiceHeader.SetRange("No.", "Document No");
                    if PurchInvoiceHeader.FindFirst() then begin
                        PurchInvoiceHeader."Vendor Invoice No." := NewVendorInvoiceNo;
                        PurchInvoiceHeader."Document Date" := NewDocumentDate;
                        PurchInvoiceHeader.Modify();
                    end;
                    VendorLedEntry.Reset();
                    VendorLedEntry.SetRange("Document No.", "Document No");
                    if VendorLedEntry.FindFirst() then begin
                        VendorLedEntry."External Document No." := NewVendorInvoiceNo;
                        VendorLedEntry."Document Date" := NewDocumentDate;
                        VendorLedEntry.Modify();
                    End;
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

    var
        "Document No": Code[20];
        OldVendorInvoiceNo: Code[35];
        OldDocumentDate: Date;
        NewVendorInvoiceNo: Code[35];
        NewDocumentDate: Date;
        PurchInvoiceHeader: Record 122;
        VendorLedEntry: Record "Vendor Ledger Entry";
}