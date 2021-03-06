function plotVehicles(posHist, tout, start, finish)
%% Arranging Data
% find number of vehicles
n = length(posHist.signals.dimensions);

% regularity of marked points 
div = 20;

% number of samples
p = length(tout);
% ... of which are divisible by div
q = floor(tout(end)/div);

% establish matrices
posHist1 = zeros(2,p);
posHist2 = zeros(2,p);
z        = zeros(1,p);
mark1    = zeros(2,q);
mark2    = zeros(2,q);

% loop over time, return each vehicle's position history
j = 1;
for i = 1:p
    posHist1(:,i) = posHist.signals.values(:,1,i);
    posHist2(:,i) = posHist.signals.values(:,2,i);
    
    % index of tout divisible by div
    if (~mod(tout(i),div))
        mark1(:,j) = posHist1(:, i);
        mark2(:,j) = posHist2(:, i);
        j = j + 1;
    end
end

% desired paths
start  = start(:,:,1);
finish = finish(:,:,1);

% limits of linspace
xMin = min(posHist1(1,:));
xMax = max(posHist1(1,:));
if (max(posHist2(1,:)) > xMax)
    xMax = max(posHist2(1,:));
end
xRef = linspace(xMin,xMax);

% establish matrices
c = zeros(1,n);
m = zeros(1,n);
yRef = zeros(n,length(xRef));
zRef = zeros(1,length(xRef));

%equation of line
for i = 1:n
    m(1,i) = (finish(2,i)-start(2,i))/(finish(1,i)-start(1,i));
    c(1,i) = start(2,i) - m(1,i)*start(1,i);
    yRef(i,:) = m(1,i)*xRef + c(1,i);
end
%% Plotting
% Setup
close all;
grid on;
hold on;

% Vehicle 1
plot3(posHist1(1,:), posHist1(2,:),z, 'r', 'DisplayName','Vehicle 1');
plot(mark1(1,:), mark1(2,:), 'xr', 'DisplayName','20 Second Intervals');
plot3(xRef,yRef(1,:),zRef,'--r', 'DisplayName','Desired Path 1');

% Vehicle 2
plot3(posHist2(1,:), posHist2(2,:),z, 'k', 'DisplayName','Vehicle 2');
plot(mark2(1,:), mark2(2,:), 'xk', 'DisplayName','20 Second Intervals');
plot3(xRef,yRef(2,:),zRef,'--k', 'DisplayName','Desired Path 2');

legend('Location','bestoutside');
hold off

            
end