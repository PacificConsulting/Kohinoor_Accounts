codeunit 50000 "Account Codeunit Event"
{
    trigger OnRun()
    begin
        //CU included 12,80,90
    end;

    //START***************CU 12**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnCodeOnAfterCheckTemplate', '', false, false)]
    local procedure OnCodeOnAfterCheckTemplate(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenNarration: Record 18550;
    begin

        IF (GenJnlLine."Journal Template Name" = 'BANKPYMTV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'BANKRCPTV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'CASHPYMTV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'CASHRCPT') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'CASHRCPTV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'CONTRAV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'GENERAL') And (GenJnlLine.Amount <> 0) then begin
            // GenNarration.Reset();
            // GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            // if not GenNarration.FindFirst() then
            IF GenJnlLine.Comment = '' then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'JOURNALV') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;
        IF (GenJnlLine."Journal Template Name" = 'PAYMENT') And (GenJnlLine.Amount <> 0) then begin
            GenNarration.Reset();
            GenNarration.SetRange("Document No.", GenJnlLine."Document No.");
            if not GenNarration.FindFirst() then
                Error('Line Narration is Mandatory for current document No. %1', GenJnlLine."Document No.");
        end;

    end;

    //END***************CU 12****************************

    //START***************CU 80**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        SalesCommentLine: Record 44;
        salesLine: record 37;
    begin
        // SalesLine.reset;
        // Salesline.Setrange("Document No.", SalesHeader."No.");
        // Salesline.SetFilter(Amount, '<>%1', 0);
        // IF not Salesline.IsEmpty then begin
        //     SalesCommentLine.Reset();
        //     SalesCommentLine.SetRange("No.", SalesHeader."No.");
        //     if not SalesCommentLine.FindFirst() then
        //         Error('Comment is Mandatory for current Docuemnt No. %1 ', SalesHeader."No.");
        // end;
    end;
    //END***************CU 80****************************

    //START***************CU 90**************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        PurchCommentLine: Record 43;
        PurchLine: Record 39;
    begin
        // PurchLine.reset;
        // PurchLine.Setrange("Document No.", PurchaseHeader."No.");
        // PurchLine.SetFilter(Amount, '<>%1', 0);
        // IF not PurchLine.IsEmpty then begin
        //     PurchCommentLine.Reset();
        //     PurchCommentLine.SetRange("No.", PurchaseHeader."No.");
        //     If not PurchCommentLine.FindFirst() then
        //         Error('Comment is Mandatory for current Docuemnt No. %1 ', PurchaseHeader."No.");
        // end;
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