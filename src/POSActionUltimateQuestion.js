const main = async ({ workflow, popup, captions }) => {
  const input = await popup.numpad(captions.question);

  const validationResult = await workflow.respond("validateAnswer", {
    answer: input,
  });

  await popup.message(
    validationResult.success ? captions.correct : captions.wrong
  );
};
