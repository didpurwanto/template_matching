function [ra]=compute_angle(M,N)
%calculate angles
r=0;x=1;objnum=size(M,1);
angle=zeros(objnum,1);
for j=1
    r=r+1;
    for i=1:objnum
        A=M(i,1)-N(i,1);
        B=M(i,2)-N(i,2);
        if A>0 && B>0
            angle(x,1)=90+atand(A/B);
            x=x+1;
        else if A<0 && B>0
                angle(x,1)=90+atand(A/B);
                x=x+1;
            else if A<0 && B<0
                    angle(x,1)=270+atand(A/B);
                    x=x+1;
                else if A>0 && B<0
                        angle(x,1)=270+atand(A/B);
                        x=x+1;
                    else if A>0 && B==0
                            angle(x,1)=0;
                            x=x+1;
                        else if A<0 && B==0
                                angle(x,1)=180;
                                x=x+1;
                            else if A==0 && B>0
                                    angle(x,1)=90;
                                    x=x+1;
                                else if A==0 && B<0
                                        angle(x,1)=270;
                                        x=x+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

deg=45;
for i=1:objnum
        if(angle(i,1)>=0 && angle(i,1)<=45)
            ra(i,1)=1;
        end
        if(angle(i,1)>45 && angle(i,1)<=90)
            ra(i,1)=2;
        end
        if(angle(i,1)>90 && angle(i,1)<=135)
            ra(i,1)=3;
        end
        if(angle(i,1)>135 && angle(i,1)<=180)
            ra(i,1)=4;
        end
        if(angle(i,1)>180 && angle(i,1)<=225)
            ra(i,1)=5;
        end
        if(angle(i,1)>225 && angle(i,1)<=270)
            ra(i,1)=6;
        end
        if(angle(i,1)>270 && angle(i,1)<=315)
            ra(i,1)=7;
        end
        if(angle(i,1)>315 && angle(i,1)<=360)
            ra(i,1)=8;
        end
end


end