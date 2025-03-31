codeunit 50100 "PTE POSAction UltimateQuestion" implements "NPR IPOS Workflow"
{
    procedure Register(WorkflowConfig: codeunit "NPR POS Workflow Config")
    var
        Question: Label 'What is the answer to life, the universe and everything?';
        Correct: Label 'Correct';
        Wrong: Label 'Wrong';
        MinValueName: Label 'Minimum Value';
        MinValueDescription: Label 'Minimum value accepted as an answer';
        MaxValueName: Label 'Maximum Value';
        MaxValueDescription: Label 'Maximum value accepted as an answer';
        ActionDesc: Label 'Ask the user for the answer to the biggest question of them all.';
    begin
        // BC Translations will be available in the frontend
        WorkflowConfig.AddLabel('question', Question);
        WorkflowConfig.AddLabel('correct', Correct);
        WorkflowConfig.AddLabel('wrong', Wrong);

        // Parameters are configurable when setting up POS buttons and will be available in both frontend JS and backend AL code when executing button clicks.
        WorkflowConfig.AddIntegerParameter('minimumValue', 1, MinValueName, MinValueDescription);
        WorkflowConfig.AddIntegerParameter('maximumValue', 100, MaxValueName, MaxValueDescription);

        WorkflowConfig.AddActionDescription(ActionDesc);
        WorkflowConfig.AddJavascript(GetActionJS());
    end;

    procedure RunWorkflow(Step: Text;
                          Context: codeunit "NPR POS JSON Helper";
                          FrontEnd: codeunit "NPR POS Front End Management";
                          Sale: codeunit "NPR POS Sale";
                          SaleLine: codeunit "NPR POS Sale Line";
                          PaymentLine: codeunit "NPR POS Payment Line";
                          Setup: codeunit "NPR POS Setup")
    var
        response: JsonObject;
    begin
        case Step of
            'validateAnswer':
                begin
                    response.Add('success', Context.GetInteger('answer') = 42);
                    FrontEnd.WorkflowResponse(response);
                end;
        end;
    end;

    local procedure GetActionJS(): Text
    begin
        // The javascript file for the action is automatically minified and embedded in the codeunit by our VSCode extension via the magic string below: 
        // https://marketplace.visualstudio.com/items?itemName=NaviPartner.np-retail-workflow-language-support 
        exit(
            //###NPR_INJECT_FROM_FILE:POSActionUltimateQuestion.js###
            'const main=async({workflow:n,popup:s,captions:a})=>{const e=await s.numpad(a.question),t=await n.respond("validateAnswer",{answer:e});await s.message(t.success?a.correct:a.wrong)};'
        );
    end;
}