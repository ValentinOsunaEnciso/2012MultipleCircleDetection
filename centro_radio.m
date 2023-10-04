%esta funcion toma como entrada 3 puntos
%y regresa el centro y el radio de la circunferencia que los contiene
%Fernando Wario Vazquez
%abril de 2009

function [x0,y0,r] = centro_radio(pi,pj,pk)
%calcula las coordenadas del centro para x
A=[(pj(1)^2+pj(2)^2-(pi(1)^2+pi(2)^2)), 2*(pj(2)-pi(2));
   (pk(1)^2+pk(2)^2-(pi(1)^2+pi(2)^2)), 2*(pk(2)-pi(2))];

x0=det(A)/(4*(((pj(1)-pi(1))*(pk(2)-pi(2)))-((pk(1)-pi(1))*(pj(2)-pi(2)))));
x0=fix(x0);

%calcula las coordenadas del centro para y
B=[2*(pj(1)-pi(1)), (pj(1)^2+pj(2)^2-(pi(1)^2+pi(2)^2));
   2*(pk(1)-pi(1)), (pk(1)^2+pk(2)^2-(pi(1)^2+pi(2)^2))];

y0=det(B)/(4*(((pj(1)-pi(1))*(pk(2)-pi(2)))-((pk(1)-pi(1))*(pj(2)-pi(2)))));
y0=fix(y0);

%calcula el radio
r=sqrt((pk(1)-x0)^2+(pk(2)-y0)^2);
r=fix(r);