%% 6/25/19 Testing ApEn on shim
% eventually want to test on HRV too

%6/26/19: just working on subj29; run ApEN on x, y, z acc data, put into file.
%(do we want angular vel too? is ApEn run on acceleration data or other?
%should i filter first? 

%7/9/19: change to approximateEntropy function
%7/11/19: added SampEn

clear all;
close;

datafolder = 'C:/Users/Spaceexplorers/Documents/GitHub/spaceflight-adaptation/data';
subj = uipickfiles('filterspec',datafolder);
% will allow choosing by subj first to make more general for later

%for pc (maybe??): change indexing to files(f).name
files = dir(fullfile(subj{1},'*.csv'));

%files = ls(fullfile(subj{1}, '*.csv'));
%files = sort(files);

%for mac: change indexing to files{f}
% f = ls([subj{1} '/' '*.csv']);
% filelist = strsplit(f);
% files = filelist(~cellfun('isempty',filelist));

newdir = 'ApEn';
mkdir([subj{1} '/' newdir]);

trialnames = ["UP1" "UP2" "P1" "P2" "Rec"]';
apenx = [];
apeny = [];
apenz = [];
sampenx = [];
sampeny = [];
sampenz = [];

%**change file size manually for now
for f = 1:20
        %just do x,y,z first
        
        %for pc
        data = importdata([subj{1} '/' files(f).name]);
        
        %for mac
       % data = importdata(files(f).name);
       
        t = data(1:end,1);
        x = data(1:end,2);
        [mx,ix] = max(x);         %remove the potential outlier (find a better way)
        x(ix) = [];
        y = data(1:end,3);
        [my,iy] = max(y);
        y(iy) = [];
        z = data(1:end,4);
        [mz,iz] = max(z);
        z(iz) = [];
        %r vector?

        % Optional to use these: currently set to .2 b/c this is default
        % for matlab apen func
        radx = std(x)*.20;
        rady = std(y)*.20;
        radz = std(z)*.20;
        
        edim = 2; % optional change embedding dim

        %old approx, takes too long
%         apenx = approx_entropy(2,radx,x);
%         apeny = approx_entropy(2,rady,y);
%         apenz = approx_entropy(2,radz,z);

        %new Apen >> *NOTE: does not produce quite the same values as
        %above; values are slightly larger 
        apenx = [apenx approximateEntropy(x)];
        apeny = [apeny approximateEntropy(y)];
        apenz = [apenz approximateEntropy(z)];
        
        %sampen
        sampenx = [sampenx SampEn(2,radx,x)];
        sampeny = [sampeny SampEn(2,rady,y)];
        sampenz = [sampenz SampEn(2,radz,z)];
        
        
        if mod(f,5) == 0
            apenx = apenx';
            apeny = apeny';
            apenz = apenz';
            sampenx = sampenx';
            sampeny = sampeny';
            sampenz = sampenz';
            Tunsorted = table(trialnames,apenx,apeny,apenz,sampenx, sampeny, sampenz);
            %sort
            T = Tunsorted;
            T(1,2:7) = Tunsorted(4,2:7);
            T(2,2:7) = Tunsorted(5,2:7);
            T(3,2:7) = Tunsorted(1,2:7);
            T(4,2:7) = Tunsorted(2,2:7);
            T(5,2:7) = Tunsorted(3,2:7);
            
            %plot
            
            %writetable(T,fullfile(subj,[files{f}(end-10:end-4) '_apen.csv']));
            writetable(T,fullfile(subj{1},newdir,[files(f).name(1:end-4) '_apen.csv']));
            apenx = [];
            apeny = [];
            apenz = [];
            sampenx = [];
            sampeny = [];
            sampenz = [];

        end
end

