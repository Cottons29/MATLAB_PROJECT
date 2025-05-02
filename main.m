clear; clc;

% Define save paths for the model and word maps
modelFolder = 'model';
modelFile = fullfile(modelFolder, 'net.mat');
wordMapFile = fullfile(modelFolder, 'word_maps.mat');

% Check if the model folder exists, if not, create it
if ~isfolder(modelFolder)
    mkdir(modelFolder);
    fprintf("Created folder: '%s'\n", modelFolder);
end

% Load or train model
if isfile(modelFile)
    net = load_model(modelFile);
    load(wordMapFile, "word2idx", "idx2word");
else
    fprintf("Training model...\n");
    try
        textData = fileread("data/sample.txt");
        fprintf("Loaded text from 'data/sample.txt'.\n");
    catch
        fprintf("Error: Could not read 'data/sample.txt'. Please place the file in the correct directory.\n");
        return;
    end
    
    % Preprocessing, training, and saving the model
    [tokens, word2idx, idx2word, X, Y] = preprocess(textData, 3);
    net = train_model(X, Y, length(word2idx));
    save_model(net, modelFile);
    save(wordMapFile, "word2idx", "idx2word");
    fprintf("Model and word maps saved in '%s'.\n", modelFolder);
end

% Start the UI to interact with the project
ui_predict(net, word2idx, idx2word);