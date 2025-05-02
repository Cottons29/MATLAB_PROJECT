function [tokens, word2idx, idx2word, X, Y] = preprocess(text, contextSize)
       % Replace punctuation (.,!?) with a space to avoid word boundary issues
       text = lower(regexprep(text, '[^a-zA-Z ]', ' ')); % Replace non-alphabetic with space
       
       % Tokenize by splitting on whitespace
       tokens = split(text);
       tokens = tokens(~cellfun(@isempty, tokens)); % Remove empty tokens

       % Create vocabulary
       uniqueTokens = sort(unique(tokens)); % Keep token indices consistent
       word2idx = containers.Map(uniqueTokens, 1:length(uniqueTokens));
       idx2word = containers.Map(1:length(uniqueTokens), uniqueTokens);

       % Create context windows (X) and labels (Y)
       X = {};
       Y = [];
       for i = 1:length(tokens) - contextSize
           sequence = zeros(contextSize, 1); % Column vector
           for j = 1:contextSize
               sequence(j) = word2idx(tokens{i + j - 1});
           end
           X{end+1} = sequence;
           Y(end+1) = word2idx(tokens{i + contextSize});
       end

       % Convert inputs and labels to double precision
       X = cellfun(@double, X, 'UniformOutput', false);
       Y = double(Y);
   end