clear all
close all
clc
disp('please enter function number');
funcnum = input('[a number between 1 to 63] => ');
[d , Xmin , Xmax] = DimLU(funcnum);
n = 5;
TMax = 1000;
GF = 1.618;
fi =  GF;
fit = zeros(1,n);
x = unifrnd(-Xmin,Xmax,[n,d]);
xt = zeros(n,d);
xNew = zeros(n,d);
F = zeros(1,TMax);
for i=1:n
    fit(i) = f(x(i,:),funcnum);
end
[~,Best] = min(fit);
[~,Worst] = max(fit);
gBest = x(Best,:);
bWorst = x(Worst,:);

for t=1:TMax
    T = t/TMax;
    F(t) = GF * ( ( fi^T - abs(1-fi)^T ) / sqrt(5) ); % Eq 5
    xAve = sum(fit)/n;
    [FTemp , ITemp] = sort(fit);
    for i2=1:n
        if xAve == FTemp(i)
            mdu = i;
        elseif xAve < FTemp(i)
            mdu = i-1;
        end
    end
    
    xW = max(fit);
    if xAve < xW
       xW = xAve; 
    end
    for i=1:n
        j = randi(n);
        while j==i
            j = randi(n);
        end
        temp = [fit(i),fit(j),xAve];
        temp2 = [i , j , ITemp(mdu)];
        [~, indexes] = sort(temp);
        best = temp2(indexes(1));
        medium = temp2(indexes(2));
        worst = temp2(indexes(3));
%         Update Xi based on equations 1-4
        xt(i,:) = x(medium,:) - x(worst,:); % Eq 4
        xNew(i,:) = (1-F(t))*x(best,:) + rand*F(t)*xt(i); % Eq 6
        % Eq 7
        if f(x(i,:),funcnum) > f(xNew(i,:),funcnum)
            x(i,:) = xNew(i,:);
        end
    end
    for i=1:n
        fit(i) = f(x(i,:),funcnum);
    end
    [~,Best] = min([fit,f(gBest,funcnum)]);
    [~,Worst] = max([fit,f(bWorst,funcnum)]);
    if Best <= n
       gBest = x(Best,:);
    end
    if Worst <= n
        bWorst = x(Worst,:);
    end
    for i=1:n
       xNew(i,:) = x(i,:) + rand*(1/GF)*(gBest - bWorst); % Eq 8
       if f(xNew(i,:),funcnum) < f(x(i,:),funcnum)
           x(i,:) = xNew(i,:);
       end
    end
    disp(['t : ' num2str(t) 'gBest : ' num2str(min([fit,f(gBest,funcnum)]))]);
end