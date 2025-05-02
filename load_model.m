function net = load_model(filename)
    if nargin < 1
        filename = 'data/net.mat';
    end
    if isfile(filename)
        loaded = load(filename, 'net');
        net = loaded.net;
        fprintf("Model loaded from %s\n", filename);
    else
        error("No trained model found at %s", filename);
    end
end