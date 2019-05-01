clear ; close all;
origin = pwd;
uiwait(msgbox("Select your raw data"));
try
%load in the data
[file, path] = uigetfile('*.txt','multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

if class(file) == 'char'
    file = {file};
end

uiwait(msgbox("Select the destination directory for split keystroke data. Should be keystroke/Splitdata"))
mainfolder = uigetdir;
cd(mainfolder);


for i = 1:length(file)
        KEYS = importdata(strcat(path,file{i}));
        EXkeys = extractBetween(KEYS(1:end), 11, 22);
        EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.S'); 

    TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight
    MINS = floor(TIMES_sec/60); %rounds down to the minute >> makes this into minutes past midnight
    start = min(MINS);
    finish = max(MINS);
    breaks=zeros(1,4);
    if ismember(MINS(1)+32, MINS) > 0
        [LIA1,LOCB1]= ismember(MINS(1)+32,MINS);
        unpert1=(KEYS(1:LOCB1));
    elseif ismember(MINS(1)+33, MINS) > 0
        [LIA1,LOCB1]= ismember(MINS(1)+33,MINS);
        unpert1=(KEYS(1:LOCB1));
    elseif ismember(MINS(1)+35, MINS) > 0
        [LIA1,LOCB1]= ismember(MINS(1)+34,MINS);
        unpert1=(KEYS(1:LOCB1));
    end
    if ismember(MINS(LOCB1)+30, MINS) > 0
        [LIA2,LOCB2]=ismember(MINS(LOCB1)+30,MINS);
        unpert2=(KEYS(LOCB1:LOCB2));
    elseif ismember(MINS(LOCB1)+33, MINS) > 0
        [LIA2,LOCB2]=ismember(MINS(LOCB1)+33,MINS);
        unpert2=(KEYS(LOCB1:LOCB2));
    elseif ismember(MINS(LOCB1)+35, MINS) > 0
        [LIA2,LOCB2]=ismember(MINS(LOCB1)+35,MINS);
        unpert2=(KEYS(LOCB1:LOCB2));
    end
    if ismember(MINS(LOCB2)+32, MINS) > 0
        [LIA3,LOCB3]=ismember(MINS(LOCB2)+32,MINS);
        pert1=(KEYS(LOCB2:LOCB3));
    elseif ismember(MINS(LOCB2)+34, MINS) > 0
        [LIA3,LOCB3]=ismember(MINS(LOCB2)+34,MINS);
        pert1=(KEYS(LOCB2:LOCB3));
    elseif ismember(MINS(LOCB2)+36, MINS) > 0
        [LIA3,LOCB3]=ismember(MINS(LOCB2)+36,MINS);
        pert1=(KEYS(LOCB2:LOCB3));
    end
    if ismember(MINS(LOCB3)+32, MINS) > 0
        [LIA4,LOCB4]=ismember(MINS(LOCB3)+32,MINS);
        pert2=(KEYS(LOCB3:LOCB4));
    elseif ismember(MINS(LOCB3)+34, MINS) > 0
        [LIA4,LOCB4]=ismember(MINS(LOCB3)+34,MINS);
        pert2=(KEYS(LOCB3:LOCB4));
    elseif ismember(MINS(LOCB3)+36, MINS) > 0
        [LIA4,LOCB4]=ismember(MINS(LOCB3)+36,MINS);
        pert2=(KEYS(LOCB3:LOCB4));
    end    
    recover=KEYS(LOCB4:length(MINS));

        %     
%     for n=4:length(MINS)-1
%         if MINS(n+1)-MINS(n) >= 3
%             if ismember(MINS(n)+7, MINS) > 0    
%              [LIA,LOCB]=ismember(MINS(n)+7, MINS);
%              n = LOCB;
%                  if breaks(1)==0
%                      breaks(1)=LOCB;
%                 elseif breaks(2) == 0
%                         breaks(2) = LOCB;
%                 elseif breaks(3) == 0
%                         breaks(3) = LOCB;
%                 elseif breaks(4) == 0
%                         breaks(4) = LOCB;
%                 end
%             elseif ismember(MINS(n)+8, MINS) > 0
%              [LIA,LOCB]=ismember(MINS(n)+8, MINS);
%              n = LOCB;
%                 if breaks(1)==0
%                      breaks(1)=LOCB;
%                 elseif breaks(2) == 0
%                         breaks(2) = LOCB;
%                 elseif breaks(3) == 0
%                         breaks(3) = LOCB;
%                 elseif breaks(4) == 0
%                         breaks(4) = LOCB;
%                 end
%             elseif ismember(MINS(n)+9, MINS) > 0
%               [LIA,LOCB]=ismember(MINS(n)+7, MINS);
%               n = LOCB;
%                 if breaks(1)==0
%                  breaks(1)=LOCB;
%                 elseif breaks(2) == 0
%                         breaks(2) = LOCB;
%                 elseif breaks(3) == 0
%                         breaks(3) = LOCB;
%                 elseif breaks(4) == 0
%                         breaks(4) = LOCB;
%                 end
%             end
%         end
%     end


%         unpert1=KEYS(1:breaks(1));
%         unpert2=KEYS(breaks(1):breaks(2));
%         pert1=KEYS(breaks(2):breaks(3));
%         pert2=KEYS(breaks(3):breaks(4));
%         recover=KEYS(breaks(4):length(KEYS));
%      
%             end5=n+10;
%             recover=KEYS(1:end4);
%         elseif MINS(n+1)-MINS(n) >= 3
%             end4=n+10;
%             pert2=KEYS(1:end4);
%         elseif MINS(n+1)-MINS(n) >= 3 
%             end3=n+10;
%             pert1=KEYS(1:end3);
%         elseif MINS(n+1)-MINS(n) >= 3
%             end2=n+10;
%             unpert2=KEYS(1:end2);
%         elseif MINS(n+1)-MINS(n) >= 3
%             end1 = n+10;
%             unpert1=KEYS(1:end1);
%         end
   
        UP1 = table(unpert1);
        UP2 = table(unpert2);
        P1 = table(pert1);
        P2 = table(pert2);
        Rec = table(recover);
        
        writetable(UP1,strcat(mainfolder, '/',file{i}(1:end-4),'_keysplit_UP1.txt')); %end-4 gets rid of the .txt
        writetable(UP2,strcat(mainfolder, '/',file{i}(1:end-4),'_keysplit_UP2.txt'));
        writetable(P1,strcat(mainfolder, '/', file{i}(1:end-4),'_keysplit_P1.txt'));
        writetable(P2,strcat(mainfolder,'/', file{i}(1:end-4),'_keysplit_P2.txt'));
        writetable(Rec,strcat(mainfolder, '/', file{i}(1:end-4),'_keysplit_REC.txt'));
end       
cd(origin);