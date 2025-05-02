function net = train_model(X, Y, vocabSize)
    % Define the network layers to accept word indices
    layers = [
        sequenceInputLayer(1)
        wordEmbeddingLayer(100, vocabSize)
        bilstmLayer(100, 'OutputMode', 'last')  % BiLSTM instead of regular LSTM
        fullyConnectedLayer(vocabSize)
        softmaxLayer
        classificationLayer
    ];
    
    % Convert X to the correct sequence format for training
    X_seq = cell(size(X));
    for i = 1:length(X)
        X_seq{i} = reshape(X{i}, 1, []);  % Reshape each input to 1xT for T time steps
    end
    
    % Convert Y to categorical and explicitly include all classes in the vocabulary
    Y_cat = categorical(Y, 1:vocabSize); % Specify all possible classes [1:vocabSize]

    % Training options configuration
    options = trainingOptions('adam', ...
        'MaxEpochs', 50, ...
        'MiniBatchSize', 16, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', 1, ...
        'Plots', 'training-progress');

%    using gpu for trining

%    options = trainingOptions('adam', ...
%            'MaxEpochs', 30, ...
%            'MiniBatchSize', 16, ...
%            'Shuffle', 'every-epoch', ...
%            'Verbose', 1, ...
%            'Plots', 'training-progress', ...
%            'ExecutionEnvironment', 'gpu');

    % Train the network
    net = trainNetwork(X_seq, Y_cat, layers, options);
end