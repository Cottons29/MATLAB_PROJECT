function predictedWord = predict_next_word(net, inputWords, word2idx, idx2word)
       try
           % Replace unknown words with a placeholder
           for i = 1:length(inputWords)
               if ~isKey(word2idx, inputWords{i})
                   warning('Word "%s" not in vocabulary. Using "<unk>".', inputWords{i});
                   inputWords{i} = '<unk>'; % Use a placeholder token
               end
           end

           % Convert words to indices
           testIdx = zeros(length(inputWords), 1); % Column vector [T x 1]
           for i = 1:length(inputWords)
               testIdx(i) = word2idx(inputWords{i});
           end

           % Reshape input for sequenceInputLayer(1): [1 x T], as a sequence
           predictors = reshape(testIdx, [1, length(testIdx)]); % [1 x T]

           % Wrap in a cell array to match the training structure
           predictors = {predictors}; % { [1 x T] }

           % Predict the next word
           predScores = predict(net, predictors); % Obtain output probabilities
           [~, idx] = max(predScores);           % Get index of the highest probability
           predictedWord = idx2word(idx);        % Map index to the corresponding word
       catch e
           fprintf('Error during prediction: %s\n', e.message);
           predictedWord = '[unknown]';          % Fallback if prediction fails
       end
   end