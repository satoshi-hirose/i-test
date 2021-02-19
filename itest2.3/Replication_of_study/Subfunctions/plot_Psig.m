function plot_Psig(ax,type,data,g_0)
current_hold = ax.NextPlot;
if ~exist('g_0','var'); g_0=0.5; end

switch lower(type)
    case 'power'
        image(ax,data*256);
        my_contour(ax,data,0.8,[1 0 0],2);
        set(ax,'YDir','Normal','YTick',10:10:((1-g_0)*100),'YTickLabel',(g_0+0.1):0.1:1,'XTick',10:10:50,'XTickLabel',0.6:0.1:1)
        xlabel(ax,'\slP\rm_{correct+}','FontSize',14,'FontName','Times')
        ylabel(ax,'\sl\gamma','FontSize',18,'FontName','Times')
        axis(ax,[0.5 50.5 0.5 (1-g_0)*100+.5])
        c = colorbar(ax,'Limits',[0 256],'Ticks',(0.1:0.1:1)*256,'TickLabels',0.1:0.1:1);
        set(c.Label,'String','Statistical Power','FontSize',12,'FontName','Times')

    case 'difference'
        if all(data(:)==0)
            image(ax,data);
            c = colorbar(ax,'Ticks',[]);
            colormap(ax,[1 1 1])
        else
        minimum = floor(min(data,[],'all')*10)/10;
        maximum = ceil(max(data,[],'all')*10)/10;
        image(ax,(data-minimum)*100)
        set(ax,'YDir','Normal','YTick',10:10:((1-g_0)*100),'YTickLabel',(g_0+0.1):0.1:1,'XTick',10:10:50,'XTickLabel',0.6:0.1:1);
        xlabel(ax,'\slP\rm_{correct+}','FontSize',14,'FontName','Times')
        ylabel(ax,'\sl\gamma','FontSize',18,'FontName','Times')
        axis(ax,[0.5 50.5 0.5 (1-g_0)*100+.5])
        c = colorbar(ax,'Limits',[0 (maximum-minimum)*100],'Ticks',0:10:((maximum-minimum)*100),'TickLabels',round((minimum:0.1:maximum)*10)/10);
        set(c.Label,'String','Difference of Statistical Power','FontSize',12,'FontName','Times')
        colormap(ax,[[repmat(((1+minimum):0.01:0.99)',1,2) ones(-minimum*100,1)];[1 1 1];[ones(maximum*100,1), repmat((0.99:-0.01:(1-maximum))',1,2)]])
        end
        
    case 'fa'
        image(ax,data*256*4);
        my_contour(ax,data,0.05,[1 0 0],2);
        set(ax,'YDir','Normal','YTick',10:10:(g_0*100),'YTickLabel',0.1:0.1:g_0,'XTick',10:10:50,'XTickLabel',0.6:0.1:1)
        xlabel(ax,'\slP\rm_{correct+}','FontSize',14,'FontName','Times')
        ylabel(ax,'\sl\gamma','FontSize',18,'FontName','Times')
        axis(ax,[0.5 50.5 0.5 g_0*100+.5])
        c = colorbar(ax,'Limits',[0 256],'Ticks',(0.05:0.05:0.25)*256*4,'TickLabels',0.05:0.05:0.25);
        set(c.Label,'String','False Alarm Rate','FontSize',12,'FontName','Times')
    otherwise
        error('type of plot is incorrect')
end
ax.NextPlot=current_hold;
end % end of function

