function save_model(net, filepath)
    % Save the trained network to the specified filepath
    save(filepath, 'net');
    fprintf('Saved model to: %s\n', filepath);
end