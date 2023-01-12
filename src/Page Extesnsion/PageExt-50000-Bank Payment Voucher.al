pageextension 50000 "Bank Payment Voucher Ext" extends "Bank Payment Voucher"
{
    layout
    {
        addafter("TCS Nature of Collection")
        {
            field("Payment Category"; Rec."Payment Category")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Payment Category");
                IF rec."Payment Category" = rec."Payment Category"::Advance then begin
                    Message('Please check whether Tds is applicable for this Payment or Not. If yes then please deduct TDS on this entry.');
                end
            end;
        }
    }

    var
        myInt: Integer;
}