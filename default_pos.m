function default_pos(a, base, shoulder, elbow, gripper)

    baseRead=readVoltage(a, 'A2');
    %baseAng= baseRead*270/3.3

    if(baseRead <1.65)
        while(baseRead < 1.65)
            baseLeft(base);
            disp('default left');
            baseRead = readVoltage(a, 'A2') ;
            disp(baseRead);
        end
    elseif(baseRead >1.65)
        while(baseRead >1.65)
            baseRight(base);
            disp('default right');
            baseRead = readVoltage(a, 'A2');
            disp(baseRead);
        end
    else 

    end
end
    