% Convert all fields to column vectors
ref_x        = dataset.ref_x(:);
ref_y        = dataset.ref_y(:);
ref_steering = dataset.ref_steering(:);
lookahead    = dataset.look_ahead(:);
velocity     = dataset.velocity(:);

% Check vector lengths
lengths = [length(ref_x), length(ref_y), length(ref_steering), length(lookahead), length(velocity)]

% Use the minimum length to avoid dimension mismatch
N = min(lengths);

% Trim all signals to the same length
ref_x        = ref_x(1:N);
ref_y        = ref_y(1:N);
ref_steering = ref_steering(1:N);
lookahead    = lookahead(1:N);
velocity     = velocity(1:N);

% Create dataset matrix
dataset_matrix = [ref_x, ref_y, ref_steering, lookahead, velocity];

% Optional: create table with column names
dataset_table = array2table(dataset_matrix, ...
    'VariableNames', {'ref_x', 'ref_y', 'ref_steering', 'lookahead', 'velocity'});

% Optional: save as CSV
writetable(dataset_table, 'ml_dataset.csv');

% Display first rows
head(dataset_table)