reportextension 50000 "Posted Voucher Ext" extends "Posted Voucher"
{
    RDLCLayout = './rdlc/PostedVoucher.rdl';
    dataset
    {

        add("G/L Entry")
        {
            column(SalesComment; SalesComment)
            {

            }
            column(PurchComm; PurchComment)
            {

            }
        }
        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                SIH: Record "Sales Invoice Header";
                PIH: Record "Purch. Inv. Header";
                SalesComm: Record "Sales Comment Line";
                PurchComm: Record "Purch. Comment Line";

            begin
                clear(SalesComment);
                Clear(PurchComment);
                IF SIH.get("G/L Entry"."Document No.") then begin
                    SalesComm.Reset();
                    SalesComm.SetRange("No.", SIH."No.");
                    IF SalesComm.FindSet() then
                        repeat
                            SalesComment := SalesComment + SalesComm.Comment;
                        until SalesComm.Next() = 0;
                end
                Else
                    IF PIH.get("G/L Entry"."Document No.") then begin
                        PurchComm.Reset();
                        PurchComm.SetRange("No.", PIH."No.");
                        IF PurchComm.FindSet() then
                            repeat
                                PurchComment := PurchComment + ' ' + PurchComm.Comment;
                            until PurchComm.Next() = 0;
                    end;
            end;


        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }


    var
        SalesComment: Text;
        PurchComment: text;
}