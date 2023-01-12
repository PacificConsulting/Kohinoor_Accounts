tableextension 50000 "Gen Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Payment Category"; Option)
        {
            Caption = 'Payment Category';
            OptionMembers = " ",Regular,Advance;
            //OptionCaption = ''', Regular, Advance';

        }
    }

    var

}