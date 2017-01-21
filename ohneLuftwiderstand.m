function [y,landing]= schieferWurfOhneLuftwiderstand(x, alpha, v , g, h)
    y = -(g/(2*(v.*v)*(cos(alpha)*cos(alpha))))*(x.*x)+tan(alpha).*x+h;
    negativs = find(y<0);
    landing = negativs(1);
    y(negativs)=0;

