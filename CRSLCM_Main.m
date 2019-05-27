%% This is the Matlab code for CRSLCM using on a widely used real IR sequence. 
%% It has been successfully tested using Matlab R2016b.

%% Created by Saed Moradi on Jan. 25, 2019, modified by Jinhui Han on May 27, 2019.

%% The corresponding paper: J. Han, S. Moradi, I. Faramarzi, C. Liu, H.
% Zhang, and Q. Zhao, "Infrared small target detection based on
% core-reserve-surrounding local contrast", IEEE Geosci. Remote Sensing
% Lett., 2019

clear all
close all
clc




r=[170 170 170 170 170 170 170 170 171 171 171 171 171 171 171 171     172 172 172 172 172 172 172 172     173 173 173 173 173 173 173 173     174 174 174 174 174 174 174 174     175 175 175 175 175 175 175 175     176 176 176 176 176 176 176 176     177 177 177 177 177 177 177 177];
c=[195 196 197 198 199 200 201 202 195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202     195 196 197 198 199 200 201 202];

%% read image
img_name='1.bmp';
img_orig=imread(img_name);
img=double(img_orig);
figure;imshow(img,[])

%% Gaussian filtering for core layer
gauss_krl=[1 2 1;2 4 2; 1 2 1];
gauss_krl=gauss_krl/16;
I_core=imfilter(img,gauss_krl,'replicate');

%% The average of 9 maximal pixels for each cell of the surrounding layer
I11=zeros(size(img,1),size(img,2),9);
I12=zeros(size(img,1),size(img,2),9);
I13=zeros(size(img,1),size(img,2),9);
I14=zeros(size(img,1),size(img,2),9);
I15=zeros(size(img,1),size(img,2),9);
I16=zeros(size(img,1),size(img,2),9);
I17=zeros(size(img,1),size(img,2),9);
I18=zeros(size(img,1),size(img,2),9);

m91=zeros(27);
m92=zeros(27);
m93=zeros(27);
m94=zeros(27);
m95=zeros(27);
m96=zeros(27);
m97=zeros(27);
m98=zeros(27);
m91(1:9,1:9)=1;
m92(1:9,10:18)=1;
m93(1:9,19:27)=1;
m94(10:18,19:27)=1;
m95(19:27,19:27)=1;
m96(19:27,10:18)=1;
m97(19:27,1:9)=1;
m98(10:18,1:9)=1;


for i=1:9
I11(:,:,i)=ordfilt2(img,82-i,m91);
I12(:,:,i)=ordfilt2(img,82-i,m92);
I13(:,:,i)=ordfilt2(img,82-i,m93);
I14(:,:,i)=ordfilt2(img,82-i,m94);
I15(:,:,i)=ordfilt2(img,82-i,m95);
I16(:,:,i)=ordfilt2(img,82-i,m96);
I17(:,:,i)=ordfilt2(img,82-i,m97);
I18(:,:,i)=ordfilt2(img,82-i,m98);

end

I_mean_1=mean(I11,3);
I_mean_2=mean(I12,3);
I_mean_3=mean(I13,3);
I_mean_4=mean(I14,3);
I_mean_5=mean(I15,3);
I_mean_6=mean(I16,3);
I_mean_7=mean(I17,3);
I_mean_8=mean(I18,3);

temp=zeros(size(img,1),size(img,2),8);
temp(:,:,1)=I_mean_1;
temp(:,:,2)=I_mean_2;
temp(:,:,3)=I_mean_3;
temp(:,:,4)=I_mean_4;
temp(:,:,5)=I_mean_5;
temp(:,:,6)=I_mean_6;
temp(:,:,7)=I_mean_7;
temp(:,:,8)=I_mean_8;

%% the max value of the eight cells will be taken as the final surrounding value
I_mean_out=max(temp,[],3);

%% CRSLCM Calculation
out=((I_core.^2)./I_mean_out)-I_core;

%% Non-negative constraint
tt=out>0;
out=double(tt).*out;

%% show the calculation result
figure;imshow(out,[])
figure;mesh(out)