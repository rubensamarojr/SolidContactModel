% Plot motion temporal series
% Example of files: 
% Numerical: box_barcarolo_lo1p0e-02_dt1p0e-03_g0p010_tana_motion.txt
% Experimental: box_barcarolo_ldx100_rzcg.txt

close all
clear
tic

%%%%%%%%%%%%%%%%%%%%%%%(USER)%%%%%%%%%%%%%%%%%%%%%%%%
% Save Figures (no = 0, yes = 1)
figSave = 0;
% Particle distance (m)
lo = [0.04,0.02,0.01];
% Time step (s)
dt = 0.001;
% Pos (X=1, Y=2, RZ=3)
sp = 1;
% Shift MPS graph
x_shift = 0.5;
y0 = [0.25,0,0];
% Graph Options
if strcmp(version('-release'),'2016a')
    font_size = 24;
    leg_font_size = 20;
    marker_size = 6.0;
else
    font_size = 20;
    leg_font_size = 20;
    marker_size = 7.55;
end
% font_size = 20;
line_width = 1.5;
% marker_size = 7.5;
% Color scale ('lines', 'parula', 'gray')
color_lines = 'parula';
% Background image limits
xmin = [0.00, 0.00, 0.00]; xmax = [4.0, 4.0, 4.0];
ymin = [0.00, -2.60, -110]; ymax = [0.28, 0.00, 0.00];
% Plot limits
xi = [0.00, 0.00, 0.00]; xf = [4.00, 4.00, 4.00];
yi = [0.00, -2.60, -110]; yf = [0.28, 0.00, 0.00];
%%%%%%%%%%%%%%%%%%%%%%%(USER)%%%%%%%%%%%%%%%%%%%%%%%%

dt_str = num2str(dt,'%.1e');
dt_str(2) = 'p';

% Color of lines
% Exclude 3 last colors from parula or gray scale
nColors = 7;
if (strcmp(color_lines,'parula') || strcmp(color_lines,'gray'))
    eval(['color_lines_aux = ' color_lines ';']);
    color_lines_aux = color_lines_aux(1:end-3,:);
    totalColors = length(color_lines_aux);
    step = int32(totalColors/(nColors-1));
    colors = color_lines_aux(1:step:end,:);
    colors = [colors; color_lines_aux(end,:)];
else
    eval(['colors = ' color_lines '(nColors);']);
end

% Markers
mark = [' -o';' -+';' -v';'-.o';'-.+';'-.v';'-.s'];

% Files
% Folder of plots
if figSave == 1
    folder = 'motion_figures';
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
end

%% Xcg
if sp == 1
    fig = figure();
    hold on
    
    % Barcarolo results
    file_barc = dir('box_barcarolo_ldx100_xcg.txt');
    BARC = dlmread(file_barc.name,'', 1, 0);
    
    % MPS results
    for ll = 1:length(lo)
        
        lo_str = num2str(lo(ll),'%.1e');
        lo_str(2) = 'p';
        file_mps = dir(['box_barcarolo_lo' lo_str '_dt' dt_str '_g0p010_tana_motion.txt']);
        MPS = dlmread(file_mps.name,'', 1, 0);

        y_shift = MPS(1,sp+1) - y0(sp);        
        plot(MPS(:,1)-x_shift,MPS(:,sp+1)-y_shift,'Color',colors(ll,:),...
            'LineWidth',line_width);
    end
    for ee = 1:4
        plot(BARC(:,1),BARC(:,ee+1),mark(ee+ll,:),'Color',colors(ee+ll,:));
    end

    xlim([xi(sp) xf(sp)]);
    ylim([yi(sp) yf(sp)]);
    
    L = 1;
    leg1 = legend(['MPS $L/l_0$ = ' num2str(L/lo(1))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(2))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(3))],...
        'Riemman-SPH $L/l_0$ = 100','$\delta$-SPH $L/l_0$ = 100',...
        'Explicit ISPH-DF $L/l_0$ = 100','FVPM $L/l_0$ = 100',...
        'Location','southwest');
    set(leg1,'Interpreter','LaTex');
    set(gca,'FontSize',font_size-10);
    ylabel('$\it x$ (m)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
    xlabel('Time (s)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
%     title(' Rigid Box Barcarolo Horizontal Motion');
    box on
    
    if figSave == 1
        fig_name_prefix = [folder '/' file_mps.name(1:end-11)];
        fig_name = [fig_name_prefix '_Xcg'];
%         print(fig_name , '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%         saveas(gcf, fig_name, 'fig');
        saveas(gcf, fig_name, 'jpeg');
        print(fig_name , '-dmeta');
        close all
    end
end

%% Ycg
if sp == 2
    fig = figure();
    hold on
    
    file_barc = dir('box_barcarolo_ldx100_ycg.txt');
    BARC = dlmread(file_barc.name,'', 1, 0);
    
    for ll = 1:length(lo)
        
        lo_str = num2str(lo(ll),'%.1e');
        lo_str(2) = 'p';
        file_mps = dir(['box_barcarolo_lo' lo_str '_dt' dt_str '_g0p010_tana_motion.txt']);
        MPS = dlmread(file_mps.name,'', 1, 0);

        y_shift = MPS(1,sp+1) - y0(sp);        
        plot(MPS(:,1)-x_shift,MPS(:,sp+1)-y_shift,'Color',colors(ll,:),'LineWidth',line_width);
    end
    for ee = 1:4
        plot(BARC(:,1),BARC(:,ee+1),mark(ee+ll,:),'Color',colors(ee+ll,:));
    end

    xlim([xi(sp) xf(sp)]);
    ylim([yi(sp) yf(sp)]);
    
    L = 1;
    leg1 = legend(['MPS $L/l_0$ = ' num2str(L/lo(1))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(2))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(3))],...
        'Riemman-SPH $L/l_0$ = 100','$\delta$-SPH $L/l_0$ = 100',...
        'Explicit ISPH-DF $L/l_0$ = 100','FVPM $L/l_0$ = 100',...
        'Location','southwest');
    set(leg1,'Interpreter','LaTex');
    set(gca,'FontSize',font_size-10);
    ylabel('$\it y$ (m)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
    xlabel('Time (s)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
%     title(' Rigid Box Barcarolo Vertical Motion');
    box on
    
    if figSave == 1
        fig_name_prefix = [folder '/' file_mps.name(1:end-11)];
        fig_name = [fig_name_prefix '_Ycg'];
%         print(fig_name , '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%         saveas(gcf, fig_name, 'fig');
        saveas(gcf, fig_name, 'jpeg');
        print(fig_name , '-dmeta');
        close all
    end
end

%% Rollcg
if sp == 3
    fig = figure();
    hold on
    
    % Barcarolo results
    file_barc = dir('box_barcarolo_ldx100_rzcg.txt');
    BARC = dlmread(file_barc.name,'', 1, 0);
    
    % MPS results
    for ll = 1:length(lo)
        
        lo_str = num2str(lo(ll),'%.1e');
        lo_str(2) = 'p';
        file_mps = dir(['box_barcarolo_lo' lo_str '_dt' dt_str '_g0p010_tana_motion.txt']);
        MPS = dlmread(file_mps.name,'', 1, 0);
        
        plot(MPS(:,1)-x_shift,rad2deg(MPS(:,sp+1+3)),'Color',colors(ll,:),'LineWidth',line_width);
    end
    for ee = 1:4
        plot(BARC(:,1),BARC(:,ee+1),mark(ee+ll,:),'Color',colors(ee+ll,:));
    end

    xlim([xi(sp) xf(sp)]);
    ylim([yi(sp) yf(sp)]);
    
    L = 1;
    leg1 = legend(['MPS $L/l_0$ = ' num2str(L/lo(1))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(2))],...
        ['MPS $L/l_0$ = ' num2str(L/lo(3))],...
        'Riemman-SPH $L/l_0$ = 100','$\delta$-SPH $L/l_0$ = 100',...
        'Explicit ISPH-DF $L/l_0$ = 100','FVPM $L/l_0$ = 100');
    set(leg1,'Interpreter','LaTex');
	set(gca,'FontSize',font_size-10);
    ylabel('Theta (deg)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
    xlabel('Time (s)','Interpreter','LaTex','fontname','Times New Roman','FontSize',font_size-6);
%     title(' Rigid Box Barcarolo Roll Motion');
    box on
    
    if figSave == 1
        fig_name_prefix = [folder '/' file_mps.name(1:end-11)];
        fig_name = [fig_name_prefix '_RZcg'];
%         print(fig_name , '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%         saveas(gcf, fig_name, 'fig');
        saveas(gcf, fig_name, 'jpeg');
        print(fig_name , '-dmeta');
        close all
    end
end

clear
toc
