% Plot pressure temporal series
% Example of files: 
% Numerical: dam_kleefsman_lo0p0300_dt1p2e-03_tana_g0p0100_pressure.txt
% Experimental: dam_kleefsman_experimental.txt

close all
clear
tic

%%%%%%%%%%%%%%%%%%%%%%%(USER)%%%%%%%%%%%%%%%%%%%%%%%%
% Save Figures (no = 0, yes = 1)
figSave = 0;
% Particle distance (m)
lo = [0.03,0.015,0.0075];
% Time step (s)
dt = [0.0012,0.0006,0.0003];
% Sensor (P1 - P8)
sp = 1;
% Graph Options
if strcmp(version('-release'),'2016a')
    font_size = 16;
    leg_font_size = 16;
    marker_size = 6.0;
else
    font_size = 20;
    leg_font_size = 20;
    marker_size = 7.55;
end
line_width_exp = 1;
line_width_mps = 3.5;
% Color scale ('lines', 'parula', 'gray')
color_lines = 'parula';
% Plot limits
xi = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];
xf = [6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00];
yi = [0, 0, 0, 0, 0, 0, 0, 0];
yf = [25, 20, 15, 10, 5, 5, 5, 5];
%%%%%%%%%%%%%%%%%%%%%%%(USER)%%%%%%%%%%%%%%%%%%%%%%%%

nFiles = length(lo);
% Color of lines
% Exclude 3 last colors from parula or gray scale
nColors = nFiles + 1;
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
% mark = ['*';'o';'d';'^';'s'];
mark = ['s';'^';'d'];
% Line style
lineStyle = ['- ';'-.';'--'];

fig = figure();

% Read experimental file
file_exp = dir('dam_kleefsman_experimental.txt');
EXP = dlmread(file_exp.name,'', 1, 0);

% Folder of plots
if figSave == 1
    folder = 'pressure_figures';
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    fig_name_prefix = [folder '/' file_exp.name(1:end-17)];
end

hold on
% Loop on each files
for ff=1:nFiles
    
    lo_str = num2str(lo(ff),'%.4f');
    lo_str(2) = 'p';

    dt_str = num2str(dt(ff),'%.1e');
    dt_str(2) = 'p';

    dt_aux = ['_dt' dt_str];

    % Read numerical file
    file_mps = dir(['dam_kleefsman_lo' lo_str dt_aux '_tana_g0p0100_pressure.txt']);
    file_mps.name
    MPS = dlmread(file_mps.name,'', 1, 0);

    % Plot numerical data
    plot(MPS(1:1:end,1),MPS(1:1:end,sp+1)/1000,'Color',...
    colors(nColors-ff+1,:),'LineWidth',line_width_mps - ff);
end

% Plot experimtnal data
plot(EXP(:,1),EXP(:,sp+1)/1000,'-','Color',...
    colors(1,:),'LineWidth',line_width_exp);

% Axes properties
xlim([xi(sp) xf(sp)]);
ylim([yi(sp) yf(sp)]);
set(gca,'FontSize',font_size);

xlabel('Time (s)','Interpreter','LaTex', 'FontSize',font_size);
ylabel('Pressure (kPa)','Interpreter','LaTex', 'FontSize',font_size);

set(gca,'FontSize',font_size);
% title(['Dam breaking Kleefsman - P ' num2str(sp)]);
if length(lo) >= 3
    leg1 = legend(['MPS $l_0$ = ' num2str(lo(1),'%.4f') ' m'], ...
        ['MPS $l_0$ = ' num2str(lo(2),'%.4f') ' m'],...
        ['MPS $l_0$ = ' num2str(lo(3),'%.4f') ' m' ],...
        'Experimental','Location','east');
    set(leg1,'Interpreter','Latex');
end
box on

if figSave == 1
    fig_name = [fig_name_prefix '_tana_g0p0100_sens' num2str(sp)];
%     print(fig_name , '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%     saveas(gcf, fig_name, 'fig');
    saveas(gcf, fig_name, 'jpeg');
    print(fig_name , '-dmeta');
    close all
end

clear
toc
