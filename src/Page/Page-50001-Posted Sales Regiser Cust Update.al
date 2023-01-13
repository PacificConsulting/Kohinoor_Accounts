page 50001 "Posted Sales GST Update"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata 112 = rm, tabledata "Detailed GST Ledger Entry" = rm;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                    TableRelation = "Sales Invoice Header"."No.";
                    trigger OnValidate()
                    var
                        SaleInvHeader: Record 112;
                        Cust: Record Customer;
                    begin
                        SaleInvHeader.Reset();
                        SaleInvHeader.SetRange("No.", "Document No");
                        if SaleInvHeader.FindFirst() then begin
                            CustomerNo := SaleInvHeader."Sell-to Customer No.";
                            PostingDate := SalesInvHeader."Posting Date";
                            if Cust.get(SaleInvHeader."Sell-to Customer No.") then begin
                                GSTRegNo := Cust."GST Registration No.";
                                GSTCustType := Cust."GST Customer Type";
                            end;
                            IF Cust."GST Customer Type" = Cust."GST Customer Type"::Registered then
                                VisibleField := true
                            else
                                VisibleField := false;

                        end;
                        NewDate := CalcDate('<1M>', SaleInvHeader."Posting Date");
                        IF Today > NewDate then
                            Error('You can not update the data beacuse this invoice is more than 30 days old');
                    end;

                }
                field("Customer No."; CustomerNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GST Registration No."; GSTRegNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GST Customer Type"; GSTCustType)
                {
                    ApplicationArea = all;
                    Editable = false;
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
                Visible = VisibleField;
                trigger OnAction()
                begin
                    IF Not Confirm('Do you want to update the data', true) then
                        exit;


                    IF "Document No" = '' then
                        Error('Please select the New Document No.');


                    DataUpdate();
                    Message('Data Updated Successfully.....');



                end;
            }
        }
    }
    procedure DataUpdate()
    begin
        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("No.", "Document No");
        IF SalesInvHeader.FindFirst() then begin
            IF Customer.get(SalesInvHeader."Sell-to Customer No.") then;
            SalesInvHeader."Nature of Supply" := SalesInvHeader."Nature of Supply"::B2B;
            SalesInvHeader."GST Customer Type" := Customer."GST Customer Type";
            SalesInvHeader.Modify();
        end;

        DGLE.Reset();
        DGLE.SetRange("Document No.", "Document No");
        if DGLE.FindSet() then
            repeat
                DGLE."GST Customer Type" := Customer."GST Customer Type";
                DGLE."Buyer/Seller Reg. No." := Customer."GST Registration No.";
                DGLE.Modify();
            until DGLE.Next() = 0;
    end;

    trigger OnAfterGetRecord()
    var
        cust: Record 18;
    begin
        IF Cust."GST Customer Type" = Cust."GST Customer Type"::Registered then
            VisibleField := true
        else
            VisibleField := false;
    end;

    trigger OnOpenPage()
    begin
        VisibleField := true;
    end;

    var
        "Document No": Code[20];
        CustomerNo: Code[20];
        GSTRegNo: code[20];
        GSTCustType: Option " ",Registered,Unregistered,Export,"Deemed Export",Exempted;
        VisibleField: Boolean;
        GSTType: Enum "GST Customer Type";
        DGLE: Record "Detailed GST Ledger Entry";
        SalesInvHeader: Record 112;
        Customer: Record 18;
        NewDate: Date;
        PostingDate: Date;
}