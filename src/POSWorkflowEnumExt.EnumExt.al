enumextension 50100 "PTE POS Workflow EnumExt" extends "NPR POS Workflow"
{
    value(50100; "PTE_ULTIMATEQUESTION")
    {
        Caption = 'PTE_ULTIMATEQUESTION', Locked = true, MaxLength = 20;
        Implementation = "NPR IPOS Workflow" = "PTE POSAction UltimateQuestion";
    }
}