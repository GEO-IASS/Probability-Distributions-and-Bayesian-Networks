%MIHIR KULKARNI
%mihirdha@buffalo.edu


%READING FROMEXCEL FILE
filename = 'E:\Users\mihirdha/university_data.xlsx';
A = xlsread(filename);
strippedA=A(:,3:6);


%EXTRACTING VARIABLES
csScore=A(:,3);
reOverhead=A(:,4);
adminPay=A(:,5);
tuition=A(:,6);
csStudNo=A(:,7);

%MEAN
mu1 = mean(csScore)
mu2 = mean(reOverhead)
mu3 = mean(adminPay)
mu4 = mean(tuition)
%mu5 = mean(csStudNo)
mu=mean(A(:,3:6))


%VARIANCE
var1 = var(csScore)
var2 = var(reOverhead)
var3 = var(adminPay)
var4 = var(tuition)
%mu5 = mean(csStudNo)

%STANDARD DAVIATION
sigma1 = std(csScore)
sigma2 = std(reOverhead)
sigma3 = std(adminPay)
sigma4 = std(tuition)
%mu5 = mean(csStudNo)
sigma=std(A(:,3:6))


%COVARIANCE
cov12 = cov(csScore,reOverhead)
cov13 = cov (csScore,adminPay)
cov14= cov (csScore,tuition)
cov23= cov (reOverhead,adminPay)
cov24= cov (reOverhead,tuition)
cov34= cov (adminPay,tuition)
covariance=cov(A(:,3:6))

format short g;
covarianceMat=[var1 cov12(2,1) cov13(2,1) cov14(2,1); cov12(2,1) var2 cov23(2,1) cov24(2,1);cov13(2,1) cov23(2,1) var3 cov34(2,1);cov14(2,1) cov24(2,1) cov34(2,1) var4]


%CORRELATION
cor12 = corrcoef(csScore,reOverhead)
cor13 = corrcoef (csScore,adminPay)
cor14= corrcoef (csScore,tuition)
cor23= corrcoef (reOverhead,adminPay)
cor24= corrcoef (reOverhead,tuition)
cor34= corrcoef (adminPay,tuition)

correlationMat=[1 cor12(2,1) cor13(2,1) cor14(2,1); cor12(2,1) 1 cor23(2,1) cor24(2,1);cor13(2,1) cor23(2,1) 1 cor34(2,1);cor14(2,1) cor24(2,1) cor34(2,1) 1]


%LOG LIKELIHOOD
logLikelihood=sum(log(normpdf(csScore,mu1,sigma1)))+ sum(log(normpdf(reOverhead,mu2,sigma2)))+sum(log(normpdf(adminPay,mu3,sigma3)))+sum(log(normpdf(tuition,mu4,sigma4)))


%PLOTTING ALL COMBINATIONS OF VARIABLES
scatter(csScore,tuition);
xlabel('csScore');
ylabel('tuition')
figure;
scatter(csScore,reOverhead);
xlabel('csScore');
ylabel('reOverhead')
figure;
scatter(csScore,adminPay);
xlabel('csScore');
ylabel('adminPay')
figure;
scatter(reOverhead,adminPay);
xlabel('reOverhead');
ylabel('adminPay')
figure;
scatter(reOverhead,tuition);
xlabel('reOverhead');
ylabel('tuition')
figure;
scatter(adminPay,tuition);
xlabel('adminPay');
ylabel('tuition')


%OPTIMAL BAYESIAN NETWORK AND IT'S LOG LIKELIHOOD CALCULATION
binaryArray= dec2bin([1:2^16-1]);
cnt=0
BNlogLikelihood=-inf;
for i=1:2^16-1
   candidate=reshape(binaryArray(i,:),[4,4]);
   vec=candidate-'0';
   if (graphisdag(sparse(vec))==1)
      b=vec;
      cnt=cnt+1;
      logLike=0;
      for j=1:4
          j;
          strippedA(:,j);
          mu(j);
          sigma(j);
          if (any(vec(:,j))==0)
              
              logLike=logLike+sum(log(normpdf(strippedA(:,j),mu(j),sigma(j))));
          else
                var_set=find(vec(:,j));
                if(sum(vec(:,j))==1)
                    var_set;
                    new_muN = mu([var_set; j]);
                    new_covN = covariance([var_set; j], [var_set; j]);
                    new_muD = mu(var_set(1));
                    new_covD = sigma(var_set(1));
                    logLike;
                    logLike=logLike+ sum(log(mvnpdf( strippedA(:, [var_set; j]), new_muN, new_covN )))-sum(log( normpdf( strippedA(:, var_set(1)), new_muD, new_covD )));
      
                else
                new_muD = mu(var_set);
                new_covD = covariance(var_set, var_set);
                new_muN = mu([var_set; j]);
                new_covN = covariance([var_set; j], [var_set; j]);
                logLike;
                logLike=logLike+ sum(log(mvnpdf( strippedA(:, [var_set; j]), new_muN, new_covN )))-sum(log( mvnpdf( strippedA(:, var_set), new_muD, new_covD )));
                end
          end
      end
      if (logLike>BNlogLikelihood)
            BNlogLikelihood=logLike;
            BNgraph=vec;
      end
      
   end
end
cnt
BNlogLikelihood
BNgraph

%PLOT DEPENDANCIES
g=biograph(BNgraph)
view(g)


%SAVE VARIABLES IN FILE
UBitName='mihirdha';
personNumber='50168610';
save('output.mat','mu1','mu2','mu3','mu4','var1','var2','var3','var4','sigma1','sigma2','sigma3','sigma4','covarianceMat','correlationMat','logLikelihood','BNgraph','BNlogLikelihood')
