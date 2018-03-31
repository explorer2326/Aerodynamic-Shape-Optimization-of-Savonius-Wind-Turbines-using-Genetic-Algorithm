for casenumber = 1:91
    angle = 2*casenumber - 2;
    timestep = 1978+2*casenumber;
%CHANGE FLUENT JOURNAL FILE
% Read txt into cell A
fid2 = fopen('D:\THESIS\lever arm & driving force\nodebased.jou','r');%Location of journal file
i = 1;
tline = fgetl(fid2);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid2);
    A{i} = tline;
end
fclose(fid2);
% Change cell A
% Modify input path
formatSpec1 = '(cx-gui-do cx-set-text-entry "Select File*Text" "optimal without deflector-1-0%d.cas")';
A{2} = sprintf(formatSpec1,timestep);
% Modify output path
formatSpec2 = '(cx-gui-do cx-set-text-entry "Select File*Text" "Facearea-Optwithoutdeflector%d")';
A{30} = sprintf(formatSpec2,angle);
% Write cell A into txt
journalname = sprintf('journal%d.jou', angle);
fid2 = fopen(journalname, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid2,'%s', A{i});
        break
    else
        fprintf(fid2,'%s\r\n', A{i});
    end
end
angle = num2str(angle);
%RUN FLUENT
eval(['!"D:\ANSYS16\ANSYS Inc\v161\fluent\ntbin\win64\fluent.exe" fluent 2d -g -hidden -i D:\THESIS\Ctangent\journal',angle,'.jou'])
end