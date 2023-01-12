codeunit 50000 "Account Codeunit Event"
{
    trigger OnRun()
    begin
        //CU included 12,80,90
    end;

    //START***************CU 12**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeRunWithCheck', '', false, false)]
    local procedure OnBeforeRunWithCheck(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalLine2: Record "Gen. Journal Line");
    var
        GenNarration: Record 18550;
    begin
        IF GenJournalLine."Journal Template Name" = 'BANKPYMTV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'BANKRCPTV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'CASHPYMTV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'CASHRCPT' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'CASHRCPTV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'CONTRAV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'GENERAL' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'JOURNALV' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
        IF GenJournalLine."Journal Template Name" = 'PAYMENT' then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJournalLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJournalLine."Document No.");
        end;
    end;
    //END***************CU 12****************************

    //START***************CU 80**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        SalesCommentLine: Record 44;
    begin
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        if not SalesCommentLine.FindFirst() then
            Error('Comment is Mandatory for current Docuemnt No. %1 ', SalesHeader."No.");
    end;
    //END***************CU 80****************************

    //START***************CU 90**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        PurchCommentLine: Record 43;
    begin
        PurchCommentLine.Reset();
        PurchCommentLine.SetRange("No.", PurchaseHeader."No.");
        If not PurchCommentLine.FindFirst() then
            Error('Comment is Mandatory for current Docuemnt No. %1 ', PurchaseHeader."No.");
    end;
    //END*****************CU 90***************************

    //START***************CU 91**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var PurchaseHeader: Record "Purchase Header")
    begin
          IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            Message('Please check whether to apply Advance Payment on this Purchase Invoice');
    end;
    //END*****************CU 91***************************
}