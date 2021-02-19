function my_contour(ax,datamatrix,height,linecolor,linewidth)
if ~exist('linewidth','var'); linewidth = 2; end
if ~exist('linecolor','var'); linecolor = [1 0 0]; end
current_hold = ax.NextPlot;
hold(ax,'on')
data = sign(datamatrix-height);
data(data==0) = -1; % avoid error when some value exactly at height
[vertlinepos(1,:),vertlinepos(2,:)]  = ind2sub(size(data(:,2:end)),find(data(:,2:end).*data(:,1:(end-1))<0));
plot(ax,[vertlinepos(2,:)+0.5;vertlinepos(2,:)+0.5],[vertlinepos(1,:)-0.5;vertlinepos(1,:)+0.5],'Color',linecolor,'LineWidth',linewidth)

[horzlinepos(1,:),horzlinepos(2,:)]  = ind2sub(size(data(2:end,:)),find(data(2:end,:).*data(1:(end-1),:)<0));
plot(ax,[horzlinepos(2,:)-0.5;horzlinepos(2,:)+0.5],[horzlinepos(1,:)+0.5;horzlinepos(1,:)+0.5],'Color',linecolor,'LineWidth',linewidth)

ax.NextPlot=current_hold;