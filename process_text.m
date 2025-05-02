function [ngramMap, predictedNextWord] = process_text(filepath, inputWord)
    % Load text file
    text = fileread(filepath);

    % Convert to lowercase and remove punctuation
    text = lower(regexprep(text, '[^a-zA-Z ]', ''));

    % Tokenize (split into words)
    words = split(text);
    words(cellfun(@isempty, words)) = [];  % Remove empty strings

    n = 2;  % For bigrams
    ngrams = strings(length(words)-n+1, 1);
    for i = 1:length(ngrams)
        ngrams(i) = strjoin(words(i:i+n-1));
    end
    [uniqueNgrams, ~, idx] = unique(ngrams);
    counts = accumarray(idx, 1);
    ngramMap = containers.Map(uniqueNgrams, counts);

    if nargin < 2
        inputWord = 'the';  % Default input word
    end
    
    candidates = keys(ngramMap);
    scores = values(ngramMap);

    nextWords = {};
    frequencies = [];

    for i = 1:length(candidates)
        parts = split(candidates{i});
        if strcmp(parts{1}, inputWord)
            nextWords{end+1} = parts{2};
            frequencies(end+1) = scores{i};
        end
    end

    if isempty(frequencies)
        predictedNextWord = '[unknown]';
    else
        [~, idx] = max(frequencies);
        predictedNextWord = nextWords{idx};
    end
end