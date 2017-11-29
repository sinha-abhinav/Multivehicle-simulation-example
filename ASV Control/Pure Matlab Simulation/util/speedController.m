%% Speed Controller
function ASV = speedController(ASV, uRef)
    % Gain Values
    Kp = 60;
    Ki = 2;
    KSat = 60;

    % Absolute Velocity
    absVel = sign(ASV.u)*sqrt((ASV.u*cosd(ASV.Yaw))^2 ...
             + (ASV.v*sind(ASV.Yaw))^2);
    
    % Calculate Error
    % proportional
    err = absVel - uRef;
    
    % integral
    speed_int_hold = ASV.speed_int;
    ASV.speed_int = ASV.speed_int + err;
    
    % Speed command w saturation [-KSat,KSat]
    ASV.speedCommand = - Kp*err - Ki*ASV.speed_int;
    if(abs(ASV.speedCommand) >= KSat)
        ASV.speedCommand = KSat*sign(ASV.speedCommand); 
        ASV.speed_int = speed_int_hold;
    end
    
    % Squared output (maintain sign)
    ASV.speedCommand = abs(ASV.speedCommand)*ASV.speedCommand;
    
    % Plotting Variable
    ASV.speedCommand_plot(ASV.counter) = ASV.speedCommand;
end
