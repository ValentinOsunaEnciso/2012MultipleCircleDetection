%funcion para generar los puntos que forman un circulo en una imagen
%un punto por pixel (solo valores enteros)
%Felipe

function puntos = circunferencia(x0, y0, r)

%el primer punto se toma sobre el eje y
x = 0;
y = r;
p0 = 1-r;

cont = 1;

%en la columna 1 los valores de x
puntos(cont, 1) = x;
%en la columna 2 los valores de y
puntos(cont, 2) = y;

cont = cont + 1;
%%%%%%%%%%%%%%%%%%% PRIMER OCTANTE %%%%%%%%%%%%%%%%
while 2*y > 2*x
    if p0 < 0
        x = x + 1;
        puntos(cont, 1) = x;
        puntos(cont, 2) = y;
        p0 = p0 + (2*x) + 1;
    else
        x = x + 1;
        y = y - 1;
        puntos(cont, 1) = x;
        puntos(cont, 2) = y;
        p0 = p0 + (2*x) + 1 - (2*y);
    end
    cont = cont + 1;
end

%%%%%%%%%%%%%% COMPLETAR CUADRANTE %%%%%%%%%%%%%%%
% se invierten los valores del primer octante y 
% por simetría se completa un cuadrante
cont = cont - 2;

for i = length(puntos) + 1:(2*length(puntos)) - 1
    puntos(i, 1) = puntos(cont, 2);
    puntos(i, 2) = puntos(cont, 1);
    cont = cont - 1;
end

%%%%%%%%%%%% CUADRANTES RESTANTES %%%%%%%%%%%%%%%%
pts = length(puntos);

for i = 1:pts
    puntos(i+pts, 1) = puntos(i,1) * -1;
    puntos(i+pts, 2) = puntos(i,2);
end

for i = 1:pts
    puntos(i+(pts*2), 1) = puntos(i,1) * -1;
    puntos(i+(pts*2), 2) = puntos(i,2) * -1;
end

for i = 1:pts
    puntos(i+(pts*3), 1) = puntos(i,1);
    puntos(i+(pts*3), 2) = puntos(i,2) * -1;
end

%desplaza el centro del circulo
puntos(:,1) = puntos(:,1) + x0;
puntos(:,2) = puntos(:,2) + y0; 