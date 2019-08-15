menu = figure('MenuBar','none','Name','N-back Study','NumberTitle','off');
movegui(menu, 'center');
handles = guidata(gcf);
menuPlay = uicontrol('Style','pushbutton','String', 'Start Trial','Position', [10 10, 300, 60],'callback',{@startgame});
ma = axes('Parent', menu,'position',[0.1 0.22 0.8 0.8]);
imshow([pwd, '\Images\titlescreen.png'],'Parent', ma)

uig = uibuttongroup(menu,'Title','Mode','Position',[0.6 0 0.4 0.25]);
mb1 = uicontrol(uig,'Style','radiobutton','String','Number','Units','normalized','Position',[0.05 0.7 0.5 0.2],'callback',{@modeselect, 1});
mb2 = uicontrol(uig,'Style','radiobutton','String','Character','Units','normalized','Position',[0.05 0.4 0.5 0.2],'callback',{@modeselect, -1});
mb3 = uicontrol(uig,'Style','radiobutton','String','Combined','Units','normalized','Position',[0.05 0.1 0.5 0.2],'callback',{@modeselect, 2});

mb4 = uicontrol('Style','text','String','Subject ID: ','Position',[20 75 60 20]);
mb5 = uicontrol('Style','edit','Position',[80 80 30 20],'callback',{@subjnum});


global mrk;
global currpos;
global mode;
global sn;
global canKey;
canKey = 1;
mrk = zeros(1200,2);
currpos = 1;
mode = 1;

function subjnum(obj,~)
global sn;
sn = get(obj,'String');
sn = str2double(sn);
end

function modeselect(~,~,cmode)
global mode;
mode = cmode;
end

function keyrec(~, event)
global mrk;
global currpos;
global canKey;
i = 0;
while (mrk(currpos+i,2) ~= 0)
i = i + 1;
end
if(canKey == 0)
mrk(currpos+i,2) = event.Key;
canKey = 1;
end
end

function startgame (~, ~)
global mode;
global sn;
global fig;
global currpos;
global mrk;

if(isempty(sn))
sn = "NA";
end
mkdir(strcat('Subject',int2str(sn)));

fig = figure('MenuBar','none','Name','N-back Study','NumberTitle','off','color','black');
set(fig, 'Position', get(0, 'Screensize'),'KeyPressFcn', @keyrec);
movegui(fig, 'center');

pp = [0; 2; 3];
bb = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;];
bb = bb(randperm(length(bb)));
listpp = zeros(27*abs(mode),2);
for i=1:(9*abs(mode))
pp = pp(randperm(length(pp)));
listpp(3*i-2,1) = pp(1,1);
listpp(3*i-1,1) = pp(2,1);
listpp(3*i,1) = pp(3,1);
listpp(3*i-2,2) = bb(i,1);
listpp(3*i-1,2) = bb(i,1);
listpp(3*i,2) = bb(i,1);
end
newName = 'SubjectTrialData';
S.(newName) = listpp;
save([pwd, '\Subject',int2str(sn),'\',newName,'.mat'], '-struct', 'S')

for i =1:length(listpp)
switch listpp(currpos,1)
    case 2
        twoback(currpos,listpp);
        currpos = currpos + 1;
    case 3
        threeback(currpos,listpp);
        currpos = currpos + 1;
    otherwise
        zeroback(currpos,listpp);
        currpos = currpos + 1;
end
end
newName = 'SubjectTrialLog';
S.(newName) = mrk;
save([pwd, '\Subject',int2str(sn),'\',newName,'.mat'], '-struct', 'S')
end

function twoback (currpos,listpp)
global mode;
global mrk;
global canKey;
% Setup of the target character / number
ia = axes('Parent', gcf);
rn = randi(10);
tc = [pwd, '\Images\char', int2str(rn),'.png'];
tn = [pwd, '\Images\numb', int2str(rn),'.png'];
ntn = strings(9,1);
ntc = strings(9,1);

% Setup of non-target character / number
p = 0;
for i=1:10
if (i ~= rn)
ntn(i-p,1) = [pwd, '\Images\numb', int2str(i),'.png'];
ntc(i-p,1) = [pwd, '\Images\char', int2str(i),'.png'];
else
p = 1;
end
end

% Instructions
imshow([pwd,'\Images\2bi.png'], 'Parent', ia);
set(gcf, 'Position', get(0, 'Screensize'));
pause(2);

% 2-back test
for i=1:20
rng = randi(10);
canKey = 0;
if (rng > 3)
    mrk(20*currpos - 20 + i,1) = 64;
    switch mode
        case 1
        imshow(ntn(randi(9),1), 'Parent', ia) 
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Non-target number'); %%
        case -1
        imshow(ntc(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Non-target character'); %%
        otherwise
        if (listpp(currpos,2) == 1)
        imshow(ntn(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Non-target choice numb'); %%
        else (listpp(currpos,2) == 2)
        imshow(ntc(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Non-target choice char'); %%
        end
    end
else
    mrk(20*currpos - 20 + i,1) = 48;
    switch mode
        case 1
        imshow(tn, 'Parent', ia) 
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Target number'); %%
        case -1
        imshow(tc, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Target character'); %%
        otherwise
        a = rndi(2);
        if (a == 2)
        imshow(tn, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));
        disp('Target choice numb'); %%
        else
        imshow(tc, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));  
        disp('Target choice char'); %%
        end
    end
end

% Intermission
pause(0.5);
imshow([pwd,'\Images\pause.png'], 'Parent', ia)                                
set(gcf, 'Position', get(0, 'Screensize'));
pause(1.5);
if (mrk(20*currpos - 20 + i,2) == 0)
mrk(20*currpos - 20 + i,2) = -1;
end
end

% Endscreen
imshow([pwd,'\Images\end.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(1);

% Break time
imshow([pwd,'\Images\pause.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(20);
end

function threeback (currpos,listpp)
global mode;
global mrk;
global canKey;
% Setup of the target character / number
ia = axes('Parent', gcf);
rn = randi(10);
tc = [pwd, '\Images\char', int2str(rn),'.png'];
tn = [pwd, '\Images\numb', int2str(rn),'.png'];
ntn = strings(9,1);
ntc = strings(9,1);

% Setup of non-target character / number
p = 0;
for i=1:10
if (i ~= rn)
ntn(i-p,1) = [pwd, '\Images\numb', int2str(i),'.png'];
ntc(i-p,1) = [pwd, '\Images\char', int2str(i),'.png'];
else
p = 1;
end
end

% Instructions
imshow([pwd,'\Images\3bi.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(2);

% 3-back test
for i=1:20
canKey = 0;
rng = randi(10);
if (rng > 3)
    mrk(20*currpos - 20 + i,1) = 96;
    switch mode
        case 1
        imshow(ntn(randi(9),1), 'Parent', ia) 
        set(gcf, 'Position', get(0, 'Screensize'));
        case -1
        imshow(ntc(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        otherwise
        if (listpp(currpos,2) == 1)
        imshow(ntn(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        else (listpp(currpos,2) == 2)
        imshow(ntc(randi(9),1), 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));   
        end
    end
else
    mrk(20*currpos - 20 + i,1) = 80;
    switch mode
        case 1
        imshow(tn, 'Parent', ia) 
        set(gcf, 'Position', get(0, 'Screensize'));
        case -1
        imshow(tc, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));
        otherwise
        a = rndi(2);
        if (a == 2)
        imshow(tn, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));
        else
        imshow(tc, 'Parent', ia)
        set(gcf, 'Position', get(0, 'Screensize'));   
        end
    end
end

% Intermission
pause(0.5);
imshow([pwd,'\Images\pause.png'], 'Parent', ia)                                
set(gcf, 'Position', get(0, 'Screensize'));
pause(1.5);
if (mrk(20*currpos - 20 + i,2) == 0)
mrk(20*currpos - 20 + i,2) = -1;
end
end

% Endscreen
imshow([pwd,'\Images\end.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(1);

% Break time
imshow([pwd,'\Images\pause.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(20);
end

function zeroback (currpos,listpp)
global mode;
global mrk;
global canKey;
% Setup of the target character / number
ia = axes('Parent', gcf);
rn = randi(10);
tc = [pwd, '\Images\char', int2str(rn),'.png'];
tn = [pwd, '\Images\numb', int2str(rn),'.png'];

% Instructions
imshow([pwd,'\Images\0bi.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(2);

% 0-back test
for i=1:20
canKey = 0;
mrk(20*currpos - 20 + i,1) = 16;
    switch mode
        case 1
        imshow(tn, 'Parent', ia) 
        set(gcf, 'Position', get(0, 'Screensize'));
        case -1
        imshow(tc, 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        otherwise
        if (listpp(currpos,2) == 1)
        imshow(tn, 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));
        else (listpp(currpos,2) == 2)
        imshow(tc, 'Parent', ia);
        set(gcf, 'Position', get(0, 'Screensize'));   
        end
    end

% Intermission
pause(0.5);
imshow([pwd,'\Images\pause.png'], 'Parent', ia)                                
set(gcf, 'Position', get(0, 'Screensize'));
pause(1.5);
if (mrk(20*currpos - 20 + i,2) == 0)
mrk(20*currpos - 20 + i,2) = -1;
end
end

% Endscreen
imshow([pwd,'\Images\end.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(1);

% Break time
imshow([pwd,'\Images\pause.png'], 'Parent', ia)
set(gcf, 'Position', get(0, 'Screensize'));
pause(20);
end