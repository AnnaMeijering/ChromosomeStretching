
%% Data: 20200217 exp1&4, 20200218 exp5, 20200219 exp1,2&4

relint=[];
relext=[];

for i=1:5
[RelInt{i} RelExt{i} ExtContribution{i} orderedI{i},IntOrder{i}]=fluorstretchinganalysis();

relint=[relint RelInt{i}];
relext=[relext RelExt{i}];

figure(1)
scatter(RelInt{i},RelExt{i},'filled')
xlabel('Relative H2B-eGFP intensity')
ylabel('Relative extension')
hold on

% figure(2)
% scatter(RelInt{i},ExtContribution{i})
% xlabel('Relative H2B-eGFP intensity')
% ylabel('ExtensionContribution')
% hold on
% 
% figure(3)
% scatter(IntOrder{i},RelExt{i}(orderedI{i}))
% xlabel('Relative H2B-eGFP intensity')
% ylabel('Intensity Order')
% hold on
% 
% figure(4)
% scatter(IntOrder{i},ExtContribution{i}(orderedI{i}))
% xlabel('Relative H2B-eGFP intensity')
% ylabel('Intensity Order')
% hold on

end
[binc,binav,binv,binsem]=calc_meanSEMfromdatacloud(relint,relext,0.1);
errorbar(binav,binv,binsem)