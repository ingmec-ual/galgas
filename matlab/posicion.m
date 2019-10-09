function [pp]=posicion(cg,c2n,c3n,c4n,c5n,c6n)
%compara vectores y calcula posicion en que se encuentra%
%cg vector deformaciones medidas por las galgas en uE%
cgn=(cg/max(abs(cg)));  %vector normalizado%

%encuentro el valor mas cercano a 0%
%comparo valores galgas con caso 2%
xxxs=norm(cn2-cgn)^2;

vp2=power(vm2,2);
vc2=sum(vp2);
if(vc2==0);
    pp=2;   %posicion peso caso 2%
else
    %comparo valores galgas con caso 3%
    vm3=minus(c3n,cgn);
    vp3=power(vm3,2);
    vc3=sum(vp3);
    
    if(vc3==0);
        pp=3;   %posicion peso caso 3%
    else 
        %comparo valores galgas con caso 4%
        vm4=minus(c4n,cgn);
        vp4=power(vm4,2);
        vc4=sum(vp4);
        
        if(vc4==0);
           pp=4;    %posicion peso caso 4%
        else
            %comparo valores galgas con caso 5%
            vm5=minus(c5n,cgn);
            vp5=power(vm5,2);
            vc5=sum(vp5);
            
            if(vc5==0);
                pp=5;   %posicion peso caso 5%
            else
                %comparo valores galgas con caso 6%
                vm6=minus(c6n,cgn);
                vp6=power(vm6,2);
                vc6=sum(vp6);
                
                if(vc6==0);
                    pp=6;   %posicion peso caso 6%
                else
                    if(vc2<vc3);
                       vm=vc2;
                    else
                       vm=vc3;
                    end
                    if(vc4<vm);
                        vm=vc4;
                    end
                    if(vc5<vm);
                        vm=vc5;
                    end
                    if(vc6<vm);
                        vm=vc6;
                    end
                    
                    if(vm==vc2);
                        pp=2;    %posicion peso caso 2%
                    end
                    if(vm==vc3);
                        pp=3;    %posicion peso caso 3%
                    end
                    if(vm==vc4);
                        pp=4;    %posicion peso caso 4%
                    end
                    if(vm==vc5);
                        pp=5;    %posicion peso caso 5%
                    end
                    if(vm==vc6);
                        pp=6;    %posicion peso caso 6%
                    end
                        
                end
            end
        end
    end
end

end
