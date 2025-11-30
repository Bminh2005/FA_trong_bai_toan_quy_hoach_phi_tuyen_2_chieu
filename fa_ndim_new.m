
% -------- Start the Firefly Algorithm (FA) main loop ------------------ %  
n=20;                   % Population size (number of fireflies)
alpha=1.0;              % Randomness strength 0--1 (highly random)
beta0=1.0;              % Attractiveness constant
gamma=0.01;             % Absorption coefficient
theta=0.97;             % Randomness reduction factor theta=10^(-5/tMax) 
d=2;                   % Number of dimensions
tMax=300;               % Maximum number of iterations
Lb=-2*ones(1,d);       % Lower bounds/limits
Ub=2*ones(1,d);        % Upper bounds/limits
e = 0.00000000001;
% Generating the initial locations of n fireflies
for i=1:n,
   ns(i,:)=Lb+(Ub-Lb).*rand(1,d);         % Randomization
   Lightn(i)=cost(ns(i,:));               % Evaluate objectives
end

%%%%%%%%%%%%%%%%% Start the iterations (main loop) %%%%%%%%%%%%%%%%%%%%%%%
for k=1:tMax, 
 disp(k);
 alpha=alpha*theta;     % Reduce alpha by a factor theta
 scale=abs(Ub-Lb);      % Scale of the optimization problem
% Two loops over all the n fireflies
for i=1:n,
    disp(i);
    for j=1:n,
      % Evaluate the objective values of current solutions
      Lightn(i)=cost(ns(i,:));           % Call the objective
      % Update moves
      if Lightn(i)>=Lightn(j),           % Brighter/more attractive
         r=sqrt(sum((ns(i,:)-ns(j,:)).^2));
         beta=beta0*exp(-gamma*r.^2);    % Attractiveness
         steps=alpha.*(rand(1,d)-0.5).*scale;
      % The FA equation for updating position vectors
         ns(i,:)=ns(i,:)+beta*(ns(j,:)-ns(i,:))+steps;
         if ns(i,1).^2 + ns(i,2).^2 > 4, %ensure constrain x^2 + y^2 <= 4
             ns(i,:) = ns(i,:)./norm(ns(i,:)).*2;
         end
         x = ns(:,1);
         y = ns(:,2);
      end
       
   end % end for j
end % end for i

% Check if the new solutions/locations are within limits/bounds
ns=findlimits(n,ns,Lb,Ub);
%% Rank fireflies by their light intensity/objectives
[Lightn,Index]=sort(Lightn);
nsol_tmp=ns;
for i=1:n,
 ns(i,:)=nsol_tmp(Index(i),:);
end
%% Find the current best solution and display outputs
fbest=Lightn(1), nbest=ns(1,:)
% Vẽ biểu đồ các điểm
if ismember(k, [1, 50, 100, 150, 200, 250, 300]),
figure(1);
cla;
hold on;
c = 1:n;  
scatter(x, y, 30, c, 'o', 'filled'); 
colormap(lines(10));
colorbar;        % 'o' là marker hình tròn
xlabel('X');
title(sprintf('k = %d,\n nbest = [%.2f, %2f]\nfbest = %f', k, nbest(1,1), nbest(1,2), fbest));


% 2. Vẽ điểm (1, 2)
p_x = 1;
p_y = 2;
% Sử dụng 'r*' để đánh dấu điểm bằng dấu sao màu đỏ lớn
plot(p_x, p_y, 'r*', 'MarkerSize', 5, 'LineWidth', 2); 
text(p_x + 0.1, p_y + 0.1, '(1, 2)', 'Color', 'r'); % Ghi chú điểm

% 3. Vẽ Đường tròn tâm O(0, 0) bán kính R = 2
R = 2; % Định nghĩa bán kính R

% 1. Tạo vector góc theta
theta_c = linspace(0, 2*pi, 100); 
% 2. Tham số hóa tọa độ X và Y
x_c = R * cos(theta_c);
y_c = R * sin(theta_c);
plot(x_c, y_c, 'k--', 'LineWidth', 1.5);
axis equal;
hold off;
pause(10);
end
end % End of the main FA loop (up to tMax)

% Make sure that new fireflies are within the bounds/limits
function [ns]=findlimits(n,ns,Lb,Ub)
for i=1:n,
  nsol_tmp=ns(i,:);
  % Apply the lower bound
  I=nsol_tmp<Lb;  nsol_tmp(I)=Lb(I);
  % Apply the upper bounds
  J=nsol_tmp>Ub;  nsol_tmp(J)=Ub(J);
  % Update this new move
  ns(i,:)=nsol_tmp;
end
end

%% Define the objective function or cost function
function z=cost(x)
% The modified sphere function: z=sum_{i=1}^D (x_i-1)^2
z=(x(1,1)-1).^2 + (x(1,2)-2).^2; % The global minimum fmin=0 at (1,2) if no constrain
% -----------------------------------------------------------------------%
end
