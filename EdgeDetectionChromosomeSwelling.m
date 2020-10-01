clear
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
sizeA=[29 Inf];
fileID = fopen('D:\DataAnalysis\Chromavision\20190912_Analysis of Emmas U2OS stretching curves\20181113_#009_crosssectionTime\Kymograph.txt','r');
A=fscanf(fileID,formatSpec,sizeA);
A=A';
for i=1:27
    B(:,i)=A(:,i+2)-A(:,i);
end


for k=1:length(B)

     C(1,k)=find(B(k,:)>15,1);
     D=find(B(k,:)<-13,1,'last');
     if isempty(D)
         C(2,k)=C(2,k-1);
     else C(2,k)=D;
     end
end

I=mat2gray(A(1:500,:));
imshow(I')
hold on
plot(C(2,1:500))
plot(C(1,1:500))
hold off

Width=C(2,:)-C(1,:);
figure
plot(Width(1:2000))
ylabel('distance (px)')
xlabel('time (a.u.)')

