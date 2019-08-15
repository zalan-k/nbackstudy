%% Translates the numeric values into clear text
% trr = 2D array containing the translated information, with length =
% number of succesful trial images shown
% data = 2D array containing the raw numeric task data, either from the
% 'mrk' variable in case of interrupted trial or the 'SubjectTrialLog' in
% case of a finished trial.
function trr = CheatSheet(data)
tr = strings(length(data),1);
norm = 0;
for i=1:(length(data))
if data(i,1) ~= 0
norm = norm + 1;
switch data(i,1)
    case 16
        tr(i,1) = '0-back target';
    case 48
        tr(i,1) = '2-back target';
    case 64
        tr(i,1) = '2-back non target';
    case 80
        tr(i,1) = '3-back target';
    case 96 
        tr(i,1) = '3-back non target';
    otherwise
        tr(i,1) = 'ERROR';
end
end
end
trr = strings(norm,1);
for i=1:length(trr)
trr(i,1) = tr(i,1);
end
end