function sentence = predict_sentence(net, startWords, word2idx, idx2word, numWords, temperature)
    if nargin < 6, temperature = 1.0; end % Default temperature
    contextSize = 3;
    words = lower(startWords(:)');
    for i = 1:(numWords - contextSize)
        if any(~isKey(word2idx, words(end-2:end)))
            break;
        end
        inputIdx = [word2idx(words{end-2}), word2idx(words{end-1}), word2idx(words{end})];
        inputIdx = reshape(double(inputIdx), 1, []);
        % Get probabilities instead of class
        preds = predict(net, inputIdx);
        preds = preds .^ (1/temperature); % adjust with temperature
        preds = preds / sum(preds);
        % Randomly sample from preds instead of argmax
        predIdxNum = randsample(1:numel(preds), 1, true, preds);
        predWord = idx2word(predIdxNum);
        if strcmp(predWord, '<end>'), break; end
        words{end+1} = predWord;
    end
    % Clean up sentence for punctuation/capitalization if desired
    sentence = strjoin(words, ' ');
    sentence = [upper(sentence(1)), sentence(2:end)]; % Capitalize first letter
end