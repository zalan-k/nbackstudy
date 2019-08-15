%x = linspace(0, 300);
%y = cumsum(rand(size(x)));
%figure(1)
%plot(x, y)
%hold on
%patch([0 100 100 0], [max(ylim) max(ylim) 0 0], 'r','FaceAlpha',0.3)
%patch([100 200 200 100], [max(ylim) max(ylim) 0 0], 'g')
%patch([200 300 300 200], [max(ylim) max(ylim) 0 0], 'b')
%plot(x, y, 'k', 'LineWidth',1.5)
%hold off
fig = figure('MenuBar','none','Name','N-back Study','NumberTitle','off');
set(fig, 'Position', get(0, 'Screensize'), 'KeyPressFcn', @keyrec);

global a;
global currpos
currpos  = 1;
a = zeros(1000,1);

dispic();

function keyrec(~, event)
global a;
global currpos;
if (a(currpos,1) == 0)
a(currpos,1) = event.Key;
end
end

function dispic()
global currpos;
for i=1:10
imshow([pwd,'\Images\pause.png']);
pause(1.5)
currpos = currpos + 1;
end
end