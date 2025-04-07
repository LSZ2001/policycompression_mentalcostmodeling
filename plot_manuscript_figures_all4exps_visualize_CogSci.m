clear all; close all;
base_folder = 'C:\Users\liu_s\policycompression_mentalcostmodeling';
cd(base_folder)
addpath(genpath(base_folder))


% Figure and font default setting
set(0,'units','inches');
Inch_SS = get(0,'screensize');
set(0,'units','pixels');
figsize = get(0, 'ScreenSize');
Res = figsize(3)./Inch_SS(3);
set(groot, 'DefaultAxesTickDir', 'out', 'DefaultAxesTickDirMode', 'manual');
fontsize=12;
set(groot,'DefaultAxesFontName','Arial','DefaultAxesFontSize',fontsize);
set(groot,'DefaultLegendFontSize',fontsize-2,'DefaultLegendFontSizeMode','manual')
markersize = 10; linewidth=1.5;

% paths
figformat = "svg";
figpath = "figures\"; %"newplots\"
datapath = "data\";
lba_folder = "lba_models\";
png_dpi = 500;

% Color palettes
cmap = brewermap(9, 'Set1');
cmap(1:3,:) = cmap([1,3,2],:);
cmap(6,:) = [];
cmap_subj = brewermap(200, 'Set1');
cmap_exp3 = brewermap(12, 'Set2');
cmap_exp3 = cmap_exp3([2,1,3,4,5,6,9,7,8,10,11,12],:);
load("exps_all_rewardmag75perc.mat")

%% Fig. 1 CogSci(excluding Figure 1A)
figspecs = [0 0 figsize(3)*0.6 figsize(4)];
Figure1_CogSci(exps, figspecs, cmap);
exportgraphics(gcf,figpath+'Fig1_CogSci_partial.pdf',"ContentType","vector");

%% Figure 3 CogSci: Complexity to RT relationship, and all LME fit plots.
figspecs = [0 0 800 600];
experiment_names = ["exp_ITI","exp_Ns246","exp_Ns267","exp_rewardmag"];
FigureS3_CogSci_simple(experiment_names, exps, cmap, cmap_exp3, figspecs)
exportgraphics(gcf,figpath+'Fig3_CogSci.pdf',"ContentType","vector");







%% Cohen's d helper function
extractFirstColumn(exp1.CohensD)
function outputStruct = extractFirstColumn(inputStruct)
    % Initialize the output struct
    outputStruct = struct();
    
    % Get the fieldnames of the input struct
    fields = fieldnames(inputStruct);
    
    % Loop through each field
    for i = 1:numel(fields)
        fieldName = fields{i};
        % Extract the first column of the 3x2 cell and convert it to a 1x3 vector
        outputStruct.(fieldName) = cell2mat(inputStruct.(fieldName)(:, 1))';
    end
end


%% Helper functions


%% Figure 1 CogSci
function [] = Figure1_CogSci(exps, figspecs, cmap)
    markersize = 20; linewidth=1.5;
    feedback_duration = 0.3; 
    cond = [0,500,2000];
    exp1_R = exps.exp_ITI.optimal_sol.R;
    exp1_V = exps.exp_ITI.optimal_sol.V;
    RT_intercept = 0.3; RT_slope = 0.45;
    exp1_RT = exp1_R .* RT_slope + RT_intercept;
    exp1_rewardrate = zeros(length(exp1_R), length(cond));
    for c=1:length(cond)
        exp1_rewardrate(:,c) = exp1_V ./ (exp1_RT + feedback_duration + cond(c)./1000);
    end

    % Figures
    figure("Position", figspecs)
    tiledlayout(6,2, 'Padding', 'loose', 'TileSpacing', 'compact'); 
    ttl_position_shift = -0.18;
    ttl_fontsize = 10;

    nexttile(1,[2,1]); hold on;
    plot(exp1_R, exp1_V, "k-","MarkerSize", markersize, "LineWidth", linewidth)
    xlabel("Policy complexity (bits)")
    ylabel("Trial-averaged reward")
    xticks(0:0.5:2)
    xlim([0 2])
    yticks(0.3:0.2:1)
    ylim([0.3,0.8])
    ttl = title('D', "Fontsize", ttl_fontsize);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = ttl_position_shift-0.02; % use negative values (ie, -0.1) to move further left
    ttl.Position(2) = 1.05; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left'; 
    
    nexttile(5,[2,1]); hold on;
    plot(exp1_R, exp1_RT, "k-","MarkerSize", markersize, "LineWidth", linewidth)
    xlabel("Policy complexity (bits)")
    ylabel("RT (s)")
    xticks(0:0.5:2)
    xlim([0 2])
    yticks(0:0.5:1.5)
    ylim([0,Inf])
    ttl = title('E', "Fontsize", ttl_fontsize);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = ttl_position_shift-0.02; % use negative values (ie, -0.1) to move further left
    ttl.Position(2) = 1.05; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left'; 
    
    nexttile(9,[2,1]); hold on;
    for c=1:length(cond)
        plot(exp1_R, normalize(exp1_rewardrate(:,c),"range",[0,1]),"-","Color", cmap(c,:), "MarkerSize", markersize, "LineWidth", linewidth)
        [max_rr, max_rr_idx] = max(exp1_rewardrate(:,c));
        max_rr_complexity = exp1_R(max_rr_idx);
        plot([max_rr_complexity,max_rr_complexity],[0,1], "-","Color", [cmap(c,:),0.3], "MarkerSize", markersize, "LineWidth", linewidth,"HandleVisibility","off")
    end
    xlabel("Policy complexity (bits)")
    ylabel({" ","Time-avg. reward (/s), ","normalized"})
    xticks(0:0.5:2)
    xlim([0 2])
    yticks(0:0.25:1)
    ylim([0,1])
    h_leg = legend("ITI = 0s","ITI = 0.5s","ITI = 2s", "location","southwest");
    h_leg.BoxFace.ColorType='truecoloralpha';
    h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
    ttl = title('F', "Fontsize", ttl_fontsize);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = ttl_position_shift-0.02; % use negative values (ie, -0.1) to move further left
    ttl.Position(2) = 1.05; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left'; 

end


%% Figure S3: All experiment behavioral and LME results.
function [] = FigureS3(experiments_stats, cmap, cmap_exp3, figspecs)
    figure('Position', figspecs);
    tiledlayout(3,6, 'Padding', 'none', 'TileSpacing', 'tight'); 
    ttl_fontsize = 10; ttl_position_xshift = -0.3; ttl_position_yshift = 1.05;
    for exp=1:3
        experiment = "exp"+exp;
        experiment_stats = experiments_stats.(experiment);
        markersize = 20; linewidth=1.5;
        if(experiment ~= "exp3")
            cond = [0,500,2000]./1000;
        else 
            cmap = cmap_exp3;
            cond = [2,4,6];
        end
    
        reward = experiment_stats.BehavioralStats.reward;
        complexity = experiment_stats.BehavioralStats.complexity;
        response_time = experiment_stats.BehavioralStats.response_time;
        V = experiment_stats.optimal_sol.V;
        R = experiment_stats.optimal_sol.R;
        response_time_flat = response_time(:);
        RT_lme = experiment_stats.LME.RT_lme;
        RT_lme_theoretical = experiment_stats.LME.RT_lme_theoretical;
        complexity_rrmax = experiment_stats.LME.complexity_rrmax;
        n_subj = length(complexity);
    
    
        % Reward matrix Q(s,a)
        reward_mat_fontsize=8;
        ax=nexttile; hold on;
        switch experiment
            case "exp1"
                num_states = 4;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                text_offset = -0.25;
            case "exp2"
                num_states = 4;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                Q(2,:) = [0.75,0.25,0.25,0.25];
                text_offset = -0.25;
            case "exp3"
                num_states = 6;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                text_offset = -0.36;
        end
        Q_flat = Q';
        Q_str = num2str(Q_flat(:));
        ax.XAxis.FontSize = reward_mat_fontsize; ax.YAxis.FontSize = reward_mat_fontsize;
        [X Y]=meshgrid(1:num_states,1:num_states);
        string = mat2cell(Q_str,ones(num_states*num_states,1));
        imagesc(zeros(num_states),'AlphaData',0)
        text(Y(:)+text_offset,flipud(X(:)),string,'HorizontalAlignment','left', 'fontsize',reward_mat_fontsize)
        grid = .5:1:(num_states+0.5);
        grid1 = [grid;grid];
        grid2 = repmat([.5;(num_states+0.5)],1,length(grid));
        plot(grid1,grid2,'k')
        plot(grid2,grid1,'k')
        set(gca,'TickLength',[0,0])
        set(gca,'xaxisLocation','top')
        xlim([0.5, num_states+0.5])
        ylim([0.5, num_states+0.5])
        xticks(1:num_states)
        yticks(1:num_states)
        xticklabels("A_"+[1:num_states])
        yticklabels("S_"+[num_states:-1:1])
        if(experiment=="exp1")
            ttl = title('A', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift+0.2; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        end
        ylabel({"\bfExperiment "+exp+"\rm"}, 'FontSize', ttl_fontsize)
    
    
    
        % reward vs complexity
        ax=nexttile;
        hold on;
        for c=1:length(cond)
            plot(ax,complexity(:,c),reward(:,c),'.','MarkerSize',markersize-5, "Color", cmap(c,:))
            if(experiment=="exp3")
                plot(ax,R.("set_size_"+cond(c)),V.("set_size_"+cond(c)),'-','LineWidth', linewidth, "Color", cmap(c,:), "HandleVisibility","off")
            end
        end
        if(experiment~="exp3")
            xmax = 2;
            plot(ax,R, V,'k', 'LineWidth', linewidth);
        else 
            xmax = 2.5;
        end
        xticks(0:0.5:xmax)
        xticklabels(0:0.5:xmax)
        xtickangle(0)
        yticks(0:0.25:1)
        xlim([0,log2(num_states)])
        ylim([0,1])
        ylabel('Trial-avg. reward')
        if(experiment=="exp1")
            h_leg=legend('ITI = 0s','ITI = 0.5s','ITI = 2s', 'Location', "southeast");
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');

            ttl = title('B', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        elseif(experiment=="exp3")
            xlabel('Policy complexity (bits)')
            h_leg=legend('Set size = 2','Set size = 4','Set size = 6', 'Location', "southeast");
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
        end
        if(experiment=="exp3")
            xlabel('Policy complexity (bits)')
        end
    
    
    
        % RT vs. complexity
        nexttile; hold on;
        complexity_flat = complexity(:); 
        response_time_flat = response_time(:);
        [complexity_sorted, complexity_sorted_idx] = sort(complexity_flat);
        response_time_sorted = response_time_flat(complexity_sorted_idx);
        for c=1:length(cond)
            plot(complexity(:,c), response_time(:,c),".", 'MarkerSize',markersize-5, "Color", cmap(c,:), 'HandleVisibility','off')
        end
        if(experiment=="exp3")
            xlabel("Policy complexity (bits)")
        end
        ylabel("Response time (s)")
        if(experiment=="exp1")
            ttl = title('C', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        end
    
    
        % LME predicted RT vs. human actual RT
        nexttile; hold on;
        for c=1:length(cond)
            plot(response_time_flat(((c-1)*n_subj+1):(c*n_subj)), RT_lme(((c-1)*n_subj+1):(c*n_subj)), ".", "MarkerSize",markersize*0.6, 'Color', cmap(c,:));
        end
        max_RT = max(response_time_flat)*1.05;
        plot([0,max(2,max_RT)],[0,max(2,max_RT)],"k:", "LineWidth",linewidth)
        xlim([0,max(2,max_RT)])
        ylim([0,max(2,max_RT)])
        if(experiment=="exp3")
            xlabel("RT (s)")
        elseif(experiment=="exp1")
            ttl = title('D', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        end
        ylabel("RT_{pred} (s)")
    
    
        % All the fitted linear RTH curves
        nexttile;
        if(experiment~="exp3")
            plot(repmat(R', n_subj,1)', RT_lme_theoretical','-','LineWidth',linewidth,'Color', [0,0,0,0.1]);
        else
            plot(repmat(R.("set_size_6")', n_subj,1)', RT_lme_theoretical.set_size_6','-','LineWidth',linewidth,'Color', [0,0,0,0.1]);
        end
        yticks(0:0.5:2)
        xticks(0:0.5:2)
        ylim([0,min(2,max_RT)])
        xlim([0,2])
        ylabel("RT_{pred} (s)")
        set(gca,'box','off')
        if(experiment=="exp1")
            ttl = title('E', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        elseif(experiment=="exp3")
            xlabel("Policy complexity (bits)")
        end
    
        % Leftward bias
        nexttile; hold on
        switch experiment
            case "exp1"
                bin_min=-2; 
                bin_max = 2;
                bin_width = 0.05;
                ymax = 0.3;
            case "exp2"
                bin_min=-1;
                bin_max = 1.5;
                bin_width = 0.05;
                ymax = 0.7;
            case "exp3"
                bin_min=-3;
                bin_max = 1;
                bin_width = 0.1;
                ymax = 0.15;
        end
        for c=1:length(cond)
            histogram(complexity(:,c)-complexity_rrmax(:,c), bin_min:bin_width:bin_max, "Normalization","probability", "FaceColor", cmap(c,:), 'EdgeColor','none')
            xticks(bin_min:1:bin_max)
            xlim([bin_min,bin_max])
            plot([0,0],[0,ymax], ":","Color",[0,0,0,1], "LineWidth", linewidth);
            ylim([0,ymax])
        end
        if(experiment=="exp3")
            xlabel("I(S;A), opt-emp (bits)")
        elseif(experiment=="exp1")
            ttl = title('F', "Fontsize", ttl_fontsize);
            ttl.Units = 'Normalize'; 
            ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            ttl.HorizontalAlignment = 'left'; 
        end
        ylabel("Relative Frequency")
        set(gca,'box','off')
    end


end



%%
function [] = FigureS3_CogSci_simple(experiment_names, experiments_stats, cmap_exp1, cmap_exp3, figspecs)
    figure('Position', figspecs);
    n_rows = 3; n_cols = 4;
    tiledlayout(n_rows,n_cols, 'Padding', 'compact', 'TileSpacing', 'tight'); 
    ttl_fontsize = 10; ttl_position_xshift = -0.3; ttl_position_yshift = 1.05;
    n_exps = length(experiment_names);
    for exp=1:n_exps
        experiment = experiment_names(exp);
        experiment_stats = experiments_stats.(experiment);
        markersize = 20; linewidth=1.5;
        if(contains(experiment,"ITI"))
            cmap = cmap_exp1;
            cond = [0,500,2000]./1000;
        elseif(contains(experiment,"Ns246")) 
            cmap = cmap_exp3;
            cond = [2,4,6];
        elseif(contains(experiment,"Ns267")) 
            cmap = [cmap_exp3([1,3],:); cmap_exp1(4,:)];
            cond = [2,6,7];
        elseif(contains(experiment,"rewardmag")) 
            cmap = cmap_exp3([4,5],:);
            cond = ["low","high"];
        end
    
        reward = experiment_stats.BehavioralStats.reward;
        complexity = experiment_stats.BehavioralStats.complexity;
        response_time = experiment_stats.BehavioralStats.response_time;
        V = experiment_stats.optimal_sol.V;
        R = experiment_stats.optimal_sol.R;
        response_time_flat = response_time(:);
        RT_lme = experiment_stats.LME.RT_lme;
        RT_lme_theoretical = experiment_stats.LME.RT_lme_theoretical;
        complexity_rrmax = experiment_stats.LME.complexity_optimal;
        n_subj = length(complexity);
    
    
        % Reward matrix Q(s,a)
        reward_mat_fontsize=8;
        %ax=nexttile; hold on;
        switch experiment
            case "exp_ITI"
                num_states = 4;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                text_offset = -0.25;
            case "exp_Ns246"
                num_states = 6;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                text_offset = -0.36;
            case "exp_Ns267"
                num_states = 7;
                Q = normalize(eye(num_states), 'range', [0.25 0.75]);
                text_offset = -0.43;
            case "exp_rewardmag"
                num_states = 4;
                Q = normalize(eye(num_states), 'range', [0.024,2.0048]);
                text_offset = -0.4;
        end
    
        markersize_new = 10;
        % reward vs complexity
        ax=nexttile(exp);
        hold on;
        for c=1:length(cond)
            % plot(ax,complexity(:,c),reward(:,c),'.','MarkerSize',markersize_new, "Color", cmap(c,:))
            mean_reward = mean(reward(:,c));
            mean_complexity = mean(complexity(:,c));
            std_reward = std(reward(:,c));  %./sqrt(n_subj);
            std_complexity = std(complexity(:,c)); %./sqrt(n_subj);

            errorbar(mean_complexity, mean_reward,std_reward,std_reward,std_complexity,std_complexity ,'.','MarkerSize',markersize_new*1.5,'LineWidth',linewidth*0.5,"Capsize",0,"Color", cmap(c,:))
            if(contains(experiment, "Ns"))
                plot(ax,R.("set_size_"+cond(c)),V.("set_size_"+cond(c)),'-','LineWidth', linewidth, "Color", cmap(c,:), "HandleVisibility","off")
            elseif(contains(experiment, "rewardmag"))
                if(cond(c)=="low")
                    Q1=eye(num_states);
                    Q1(Q1==1) = 0.025.*0.8 + 0.024.*0.2;
                    Q1(Q1==0) = 0.024;
                    plot(ax,R.("rwd"+cond(c)),mean(mean(Q1)).*ones(length(R.("rwd"+cond(c))),1),'-','LineWidth', linewidth, "Color", cmap(c,:), "HandleVisibility","off")
                    plot(ax,R.("rwd"+cond(c)),V.("rwd"+cond(c)),'--','LineWidth', linewidth, "Color", cmap(c,:), "HandleVisibility","off")
                else
                    plot(ax,R.("rwd"+cond(c)),V.("rwd"+cond(c)),'-','LineWidth', linewidth, "Color", cmap(c,:), "HandleVisibility","off")
                end
            end
        end
        if(~contains(experiment, "Ns"))
            xmax = 2;
            if(contains(experiment, "ITI"))
                plot(ax,R, V,'k', 'LineWidth', linewidth);
            end
        else
            xmax = 3;
        end
        xticks(0:0.5:xmax)
        xticklabels(0:0.5:xmax)
        xtickangle(0)
        yticks(0:0.25:1)
        xlim([0,log2(num_states)])
        ylim([0,1])
        % ylabel({"\bf"+strrep(experiment, "_", "\_")+"\rm",'Trial-avg. reward'})
        xlabel('I(S;A) (bits)')
        title("Experiment "+exp)
        if(experiment=="exp_ITI")
            h_leg=legend('ITI = 0s','ITI = 0.5s','ITI = 2s', 'Location', "southeast", "fontsize",9);
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
            ylabel("Trial-avg. reward")
        elseif(experiment=="exp_Ns246")
            h_leg=legend('Set size = 2','Set size = 4','Set size = 6', 'Location', "southeast", "fontsize",9);
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
        elseif(experiment=="exp_Ns267")
            h_leg=legend('Set size = 2','Set size = 6','Set size = 7', 'Location', "southeast", "fontsize",9);
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
        end
        if(experiment=="exp_rewardmag")
            yticks(0:0.5:2.1)
            xlim([0,2])
            ylim([0,2.1])
            h_leg=legend('Reward low','Reward high', 'Location', "southeast", "fontsize",9);
            h_leg.BoxFace.ColorType='truecoloralpha';
            h_leg.BoxFace.ColorData=uint8(255*[1 1 1 0.75]');
        end
        h_leg.ItemTokenSize(1) = 15;
        
    
    
        ax=nexttile(exp+n_cols); hold on;
        [se,m] = wse(complexity);
        errorbar(ax,1:length(cond),m,se,'.-','MarkerSize',markersize_new,'LineWidth',linewidth,'Color','k')
        ylim([0.1,0.7])
        yticks(0.1:0.2:0.7)
        xlim([1-0.5, length(cond)+0.5])
        if(experiment=="exp_ITI")
            xticks(1:length(cond));
            xticklabels(cond);
            ylabel('I(S;A) (bits)');
            % ttl = title('B', "Fontsize", ttl_fontsize);
            % ttl.Units = 'Normalize'; 
            % ttl.Position(1) = ttl_position_xshift; % use negative values (ie, -0.1) to move further left
            % ttl.Position(2) = ttl_position_yshift; % use negative values (ie, -0.1) to move further left
            % ttl.HorizontalAlignment = 'left'; 
            xlabel('ITI (s)')
        elseif(contains(experiment,"Ns"))
            xticks(1:length(cond));
            xticklabels(cond);
            xlabel('Set size')
        elseif(experiment=="exp_rewardmag")
            xticks(1:length(cond));
            xticklabels(["low","high"]);
            xlabel('Reward magnitude')
        end
    
        % Leftward bias
        nexttile(exp+2*n_cols); hold on
        switch experiment
            case "exp_ITI"
                bin_min=-2; 
                bin_max = 2;
                bin_width = 0.05;
                ymax = 0.3;
            case "exp_Ns246"
                bin_min=-3;
                bin_max = 1;
                bin_width = 0.1;
                ymax = 0.15;
            case "exp_Ns267"
                bin_min=-3;
                bin_max = 1;
                bin_width = 0.1;
                ymax = 0.15;
            case "exp_rewardmag"
                bin_min=-2; 
                bin_max = 0.01;
                bin_width = 0.05;
                ymax = 0.3;
        end
        for c=1:length(cond)
            histogram(complexity(:,c)-complexity_rrmax(:,c), bin_min:bin_width:bin_max, "Normalization","probability", "FaceColor", cmap(c,:), 'EdgeColor','none')
            xticks(bin_min:1:bin_max)
            xlim([bin_min,bin_max])
            plot([0,0],[0,ymax], ":","Color",[0,0,0,1], "LineWidth", linewidth);
            ylim([0,ymax])
        end
        %if(contains(experiment,"rewardmag"))
        xlabel("I(S;A), emp - opt (bits)")
        if(experiment=="exp_ITI")
            ylabel("Relative Frequency");
        end
        set(gca,'box','off')
    end


end