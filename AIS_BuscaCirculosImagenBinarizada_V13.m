%%%%Artificial Inmune Systems-Aplicacion deteccion de circulos.
%%%%Ingeniero Jose Valentin Osuna Enciso, Abril,Mayo,2009
%%%%%Maestria en Ciencias en Ingenieria en Electronica y Computacion, CUCEI.
clear all
format long
%Carga imagen,convierte a escala de grises,saca su tamaño,saca bordes, 
%guarda posicion de pixeles validos:
DB=imread('wheel.jpg');DB2=DB;DB=rgb2gray(DB);
%Ya funciona con db08 con parametro de hipermutacion 0.3 con 100 individuos,con db14 muevo el parametro de hipermutacion a 0.6,0.7,aun con el 
%mismo numero de individuos;funciona:tsuru1,luna1,db08,db14,luna1,circulo2,circulo3,circulo4,pelota1,circulo6,circulo9,circulo8.
[filas columnas]=size(DB);
[DBBordes t]=edge(DB,'canny',.1);DBBordes2=DBBordes;ind3=1;
for ind1=1:filas
    for ind2=1:columnas
        if DBBordes(ind1,ind2)==1
            XY(ind3,1)=ind1;XY(ind3,2)=ind2; ind3=ind3+1;
        end
    end
end
%%%%%%%%%%%%%%%%%Aqui empieza AIS:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=cadeia(100,66,0,0,0); %9 variables pi1,pi2,pi3,pj1,pj2,pj3,pk1,pk2,pk3.V5: 3 variables, p1,p2,p3
gen = 400; n = size(V,1); pm = 0.01; per = 0.0; fat = .1;
pma = pm; itpm = gen; pmr = 0.9;
vpm = []; vfx = []; vmfit = []; errorminimo=ones(1,gen);errorminimo(1,2)=0.2;%valfx = .1; 
[N,L] = size(V); it = 0; elmismomejor=1;    [tamP empty]=size(XY);
%%%%%%%%%%%%%%%%%%%%Aqui va el while%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
while (it<gen && ((errorminimo(1,it+1))>=-.3))&& (elmismomejor<9)%(errorminimo(it+1)~=errorminimo(it+2))%Con el tercer &&,checo que no este estacionado.
    %Calcula tamaño de matrix de posicion de pixeles P:
    pi1 = decodeCirc(V(:,1:22),tamP-1); pi2 = decodeCirc(V(:,23:44),tamP-1); pi3 = decodeCirc(V(:,45:66),tamP-1);
    T = []; cs = [];
    for ind1=1:n
        [x0(ind1) y0(ind1) r(ind1)]=centro_radio([XY(pi1(ind1),1) XY(pi1(ind1),2)],[XY(pi2(ind1),1) XY(pi2(ind1),2)],[XY(pi3(ind1),1) XY(pi3(ind1),2)]); 
        if (r(ind1)<.6*filas)&&(r(ind1)<.6*columnas)&&(r(ind1)>.1*columnas)%||(r(ind1)<.2*columnas)%
            puntos=circunferencia(x0(ind1),y0(ind1),r(ind1));
        else
            puntos=circunferencia(5,5,2);
        end
        [fi co]=size(puntos);       
        fit1(ind1)=fi;
        if (((y0(ind1)+r(ind1))<=columnas)&&((y0(ind1)-r(ind1))>=0)&&((x0(ind1)+r(ind1))<=filas)&&((x0(ind1)-r(ind1))>=0))           
            for ind3=1:1:fi
                if puntos(ind3,1) > 2 && puntos(ind3,2) > 2    %Se asegura que los dos sean positivos.                
                    if (puntos(ind3,1)+2) > filas || (puntos(ind3,2)+2) > columnas %Revisa que no salgan de la imagen original.                   
                    fit1(ind1)=fit1(ind1); %Puntos fuera de la imagen, no se evalua.
                    else
                      ind4=0;
%                     for ind4=-2:1:2
                        if DBBordes((puntos(ind3,1)+ind4),(puntos(ind3,2)+ind4 ))==1
                            fit1(ind1)=fit1(ind1)-1;
                        end
%                     end
                    end
                end
            end
        end
        fit1(ind1)=fit1(ind1)/fi;%Originalmente es fit1(ind1)=(fit1(ind1)/fi);
    end
    [a ind]=sort(fit1); %Ordeno de menor a mayor los rendimientos obtenidos.
    [valP1 valP2 valP3]=ordenaconmisindices(x0,y0,r,ind); %Ordeno tambien los mejores centros y radios.
    %%%%%%%%%%%%Termino el calculo de los errores:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fx = a(end-n+1:end);% n best individuals (maximization)
    % Reproduction
    [T,pcs] = reprod(n,fat,N,ind,V,T);
    % Hypermutation
    M = rand(size(T,1),L) <= 0.2;%0.1,0.2,0.05,.7
    T = T - 2 .* (T.*M) + M;
    T(pcs,:) = V(fliplr(ind(end-n+1:end)),:);
    %%%%%%%Busco los valores minimos:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pi1 = decodeCirc(T(:,1:22),tamP-1); pi2 = decodeCirc(T(:,23:44),tamP-1); pi3 = decodeCirc(T(:,45:66),tamP-1);pcs=[0 pcs];
    for ind1=1:size(T,1)
        [x0(ind1) y0(ind1) r(ind1)]=centro_radio([XY(pi1(ind1),1) XY(pi1(ind1),2)],[XY(pi2(ind1),1) XY(pi2(ind1),2)],[XY(pi3(ind1),1) XY(pi3(ind1),2)]);      
        if (r(ind1)<.6*filas)&&(r(ind1)<.6*columnas)&&(r(ind1)>.1*columnas)%(r(ind1)<.2*filas)||(r(ind1)<.2*columnas)%&&(r(ind1)>100)
            puntos2=circunferencia(x0(ind1),y0(ind1),r(ind1));
        else
            puntos2=circunferencia(5,5,2);
        end
        [fil col]=size(puntos2);  
        fit2(ind1)=fil;
        if (((y0(ind1)+r(ind1))<=columnas)&&((y0(ind1)-r(ind1))>=0)&&((x0(ind1)+r(ind1))<=filas)&&((x0(ind1)-r(ind1))>=0))           
            for ind3=1:1:fil
                if puntos2(ind3,1) > 2 && puntos2(ind3,2) > 2    %Se asegura que los dos sean positivos.                
                    if (puntos2(ind3,1)+2) > filas || (puntos2(ind3,2)+2) > columnas %Revisa que no salgan de la imagen original.                   
                    fit2(ind1)=fit2(ind1); %Puntos fuera de la imagen, no se evalua.
                    else
                      ind4=0;
%                     for ind4=-2:1:2
                        if DBBordes((puntos2(ind3,1)+ind4),(puntos2(ind3,2)+ind4 ))==1
                            fit2(ind1)=fit2(ind1)-1;
                        end
%                     end
                    end
                end
            end
        end
        fit2(ind1)=fit2(ind1)/fil;%Original es  fit2(ind1)=(fit2(ind1)/fil)
    end
    for ind1=1:n,     %Va buscando el minimo por bloques.
        [out(ind1),bcs(ind1)] = min(fit2(pcs(ind1)+1:pcs(ind1+1)));		% Problema minimizacion del error
        bcs(ind1) = bcs(ind1) + pcs(ind1);
    end;
    V(fliplr(ind(end-n+1:end)),:) = T(bcs,:);
    % Editing (Repertoire shift)
    nedit = round(per*N);
    V(ind(1:nedit),:) = cadeia(nedit,L,0,0,0);
    pm = pmcont(pm,pma,pmr,it,itpm); valfx = max(fx);%max(fx)
    errorminimo(1,it+1)=min(fx);%errorminimo=abs(errorminimo);
    disp(sprintf('valfx minimo= %d',errorminimo(1,it+1)));%Para revisar cuando puedo salir.
    vpm = [vpm pm]; vfx = [vfx valfx]; vmfit = [vmfit mean(fit2)];
    it=it+1;
    %%%%Reviso que no este estacionado, si es asi, incremento un contador
    %%%%de estacionamiento de valor:
    if (it>1)&&(errorminimo(1,it)==errorminimo(1,it-1))
        elmismomejor=elmismomejor+1;
    end
end; % end while
toc
DBBordes2=mat2gray(DBBordes);
imshow(DB2),title('Antes'),figure
for ind5=1:1
x0=valP1(ind5);y0=valP2(ind5);r=valP3(ind5);
puntosf=circunferencia(x0,y0,r);
[fi co]=size(puntosf);
for ind1=1:fi
    if (puntosf(ind1,1)>0)&&(puntosf(ind1,2)>0)
        DB2(puntosf(ind1,2),puntosf(ind1,1),1)=254;
        DB2(puntosf(ind1,2),puntosf(ind1,1),2)=0;
        DB2(puntosf(ind1,2),puntosf(ind1,1),3)=0;
        DBBordes2(puntosf(ind1,2),puntosf(ind1,1))=0.5;
    end
end
disp(sprintf('Numero de generaciones = %d',it));
end
imshow(DB2),title('Despues color'),figure
imshow(DBBordes2),title('Despues gris')