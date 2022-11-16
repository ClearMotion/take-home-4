%% Parameters

mb = 1000;    %mass of the body
mw = 100;     %mass of the wheel
k =  30000;   %spring coefficient
b =  2000;    %damping coefficent
kr = 150000; %coefficient of the tire (treated as a spring)

%% quarter car dynamics

% Initial values
zb = 0.00;  % body height (relative to steady state)
zw = 0;  % wheel height (relative to steady state)
zbv = 0; % body velocity
zwv = 0; % wheel vertical velocity
f  = 0;  % active force

% Simulation paramters
ts = 0.005;
N = 1000; % Number of steps

% Road input
r = zeros(N,1);
r(500:end) = 0.01;

% Pre-allocate state vector for simulation
x = zeros(N,4);
x(1,:) = [zb, zbv, zw, zwv];
t = (0:N-1)*ts;
%% Simulating

for ct = 2:N
    zb_  = zb  + ts*(zbv);    
    zbv_ = zbv + ts*(f - k*(zb-zw) - b*(zbv-zwv))/mb;
    zw_  = zw  + ts*(zwv);
    zwv_ = zwv + ts*(-f + k*(zb-zw) + b*(zbv-zwv)  - kr*(zw - r(ct)))/mw;
    
    zb  = zb_;
    zbv = zbv_;
    zw  = zw_;
    zwv = zwv_;

    x(ct,:) = [zb, zbv, zw, zwv];
end

%% Show the results

subplot(211)
plot(t, [r, x(:,1), x(:,3)])
xlabel('time (sec)')
ylabel('height (m)')
legend('road', 'body', 'wheel')
title('vertical displacement')
ylim([-0.005 0.025])
grid minor

subplot(212)
plot(t, [gradient(x(:,2)) gradient(x(:,4))]/ts)
xlabel('time (sec)')
ylabel('acceleration (m/s^2)')
legend('body', 'wheel')
title('vertical acceleration')
grid minor
