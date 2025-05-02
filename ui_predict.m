function ui_predict(net, word2idx, idx2word)
    f = figure('Name', 'Next Word Predictor', 'Position', [500, 300, 400, 200]);

    uicontrol('Style', 'text', 'Position', [30 140 340 30], ...
        'String', 'Enter 3 words (space-separated):', 'FontSize', 10);

    inputBox = uicontrol('Style', 'edit', 'Position', [30 110 340 30], ...
        'FontSize', 12);

    resultLabel = uicontrol('Style', 'text', 'Position', [30 10 340 50], ...
        'FontSize', 12, 'ForegroundColor', 'blue');

    uicontrol('Style', 'pushbutton', 'String', 'Predict Next Word', ...
        'Position', [140 70 120 25], 'Callback', @(src, event) predictCallback());

    function predictCallback()
        inputText = strtrim(inputBox.String);
        words = split(lower(inputText));
        if numel(words) ~= 3
            resultLabel.String = '❌ Please enter exactly 3 words.';
            return;
        end
        try
            predWord = predict_next_word(net, words, word2idx, idx2word);
            resultLabel.String = ['✅ Predicted next word: ', predWord];
        catch e
            resultLabel.String = '❌ Prediction failed. Check input.';
            fprintf('Error: %s\n', e.message);  % Log error to console
        end
    end
end