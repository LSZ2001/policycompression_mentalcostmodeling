clear all; close all;
base_folder = 'C:\Users\liu_s\policycompression_mentalcostmodeling';
cd(base_folder)
addpath(genpath(base_folder))

datapath = "data\";
alpha = 0.5; 
markersize = 10; linewidth=1.5;


%% Experiment 1 and 2
load(datapath+"iti_bandit_data_oldexp1.mat");
data_exps.exp_ITI = datas.test;
survey_exps.exp_ITI = datas.survey;
load(datapath+"iti_bandit_data_oldexp3.mat");
[datas, exp3_correct_actions] = exp3_get_setsize_corresponding_actions(datas,[2,4,6]);
data_exps.exp_Ns246 = datas.test;
survey_exps.exp_Ns246 = datas.survey;
clear data datas;

experiment = "exp_ITI";
[exp_ITI.mturkIDs, exp_ITI.optimal_sol, exp_ITI.BehavioralStats, exp_ITI.LME, exp_ITI.TTests, exp_ITI.EffectSizeCI, exp_ITI.EffectSizes, exp_ITI.WilcoxonTests] = parse_data(data_exps, survey_exps, experiment);
experiment = "exp_Ns246";
[exp_Ns246.mturkIDs, exp_Ns246.optimal_sol, exp_Ns246.BehavioralStats, exp_Ns246.LME, exp_Ns246.TTests, exp_Ns246.EffectSizeCI, exp_Ns246.EffectSizes, exp_Ns246.WilcoxonTests] = parse_data(data_exps, survey_exps, experiment, exp3_correct_actions);
exps.exp_ITI = exp_ITI; exps.exp_Ns246 = exp_Ns246;
%save("data\exps.mat","exps")

%% Experiment 3
load(datapath + "iti_bandit_data_exp3_old7.mat");
data = datas.test;
survey_exps.exp_Ns267 = datas.survey;
genders = [];
for subj=1:length(data.set_size_2)
    genders = [genders, datas.survey(subj).gender];
end
set_sizes = [2,6,7];
n_tasks = length(set_sizes);
task_names = "set_size_"+set_sizes;

% Check new parse_data function
data_exps.exp_Ns267 = data;
experiment = "exp_Ns267";
[exp_Ns267.mturkIDs, exp_Ns267.optimal_sol, exp_Ns267.BehavioralStats, exp_Ns267.LME, exp_Ns267.TTests, exp_Ns267.EffectSizeCI, exp_Ns267.EffectSizes, exp_Ns267.WilcoxonTests] = parse_data(data_exps, survey_exps, experiment);
exps.exp_Ns267 = exp_Ns267;
%save("data\exps_267.mat","exps_267")


%% Experiment 4
load(datapath+"iti_bandit_data_exp_rewardmag.mat");
datas.train = remove_nonresponsive_trials(datas.train);
datas.test = remove_nonresponsive_trials(datas.test);
data_exps.exp_rewardmag = datas.test;
clear data datas;
experiment = "exp_rewardmag";
[exp_rewardmag.mturkIDs, exp_rewardmag.optimal_sol, exp_rewardmag.BehavioralStats, exp_rewardmag.LME, exp_rewardmag.TTests, exp_rewardmag.EffectSizes, exp_rewardmag.WilcoxonTests] = parse_data_exp_rewardmag(data_exps, experiment);
exps.exp_rewardmag = exp_rewardmag;
%save("data\exps_rewardmag.mat","exps_rewardmag")



%% Merge all experiments
% Color palettes
cond = [0,500,2000];

% ITI equals true ITI plus the feedback time (colored border around image)
exps.exp_ITI.ITI = [0,0.5,2] + 0.3;
exps.exp_Ns246.ITI = [2,2,2] + 0.3;
exps.exp_Ns267.ITI = [2,2,2] + 0.3;

% Experiment 4 true Q(s,a).
n_states=4;
p_state = ones(1,n_states)./n_states;
Q = eye(n_states);
Q1=Q;
Q1(Q1==1) = 0.025.*0.8 + 0.024.*0.2;
Q1(Q1==0) = 0.024;
Q2 = Q;
Q2(Q2==0) = 0.024;
Q2(Q2==1) = 0.024*0.2 + 2.5*0.8;

% Redefining the subjective reward of exp_rewardmag's low reward condition,
% to 75% of the high reward condition (ad hoc). 
diagonalMask = logical(eye(size(Q1)));
Q1(diagonalMask) = 0.75.*diag(Q2);
beta_set_1 = linspace(0,15,500);
beta_set_2 = linspace(0,15,500);
[R1, V1, Pa1, optimal_policy1] = blahut_arimoto(p_state,Q1,beta_set_1);
[R2, V2, Pa2, optimal_policy2] = blahut_arimoto(p_state,Q2,beta_set_2);
exps.exp_rewardmag.optimal_sol.R_grid = exps.exp_rewardmag.optimal_sol.R;
exps.exp_rewardmag.optimal_sol = rmfield(exps.exp_rewardmag.optimal_sol, {'Q','R','V','Pa','optimal_policy'});
exps.exp_rewardmag.optimal_sol.Q.rwdlow = Q1;
exps.exp_rewardmag.optimal_sol.Q.rwdhigh = Q2;
exps.exp_rewardmag.optimal_sol.R.rwdlow = R1;
exps.exp_rewardmag.optimal_sol.R.rwdhigh = R2;
exps.exp_rewardmag.optimal_sol.V.rwdlow = V1;
exps.exp_rewardmag.optimal_sol.V.rwdhigh = V2;
exps.exp_rewardmag.optimal_sol.Pa.rwdlow = Pa1;
exps.exp_rewardmag.optimal_sol.Pa.rwdhigh = Pa2;
exps.exp_rewardmag.optimal_sol.optimal_policy.rwdlow = optimal_policy1;
exps.exp_rewardmag.optimal_sol.optimal_policy.rwdhigh = optimal_policy2;
exps.exp_rewardmag.BehavioralStats.reward = exps.exp_rewardmag.BehavioralStats.reward.*0.5;
exps.exp_rewardmag.LME.complexity_rrmax(:) = log2(4); % Reward maximization; not reward rate maximization
exps.exp_rewardmag.LME.complexity_diff_from_max = exps.exp_rewardmag.BehavioralStats.complexity - exps.exp_rewardmag.LME.complexity_rrmax; % Reward maximization; not reward rate maximization
exps.exp_rewardmag.ITI = [NaN,NaN];
clear exps_old exps_267 exps_rewardmag Q beta_set n_states p_state Q1 Q2 R1 R2 V1 V2 Pa1 Pa2 optimal_policy1 optimal_policy2

% Get LMEs for each Experiment
experiment_names = string(fieldnames(exps));
n_exps = length(experiment_names);
disp("----- Fitted LMEs for each experiment ------");
for exp_idx = 1:n_exps
    experiment = experiment_names(exp_idx);
    [fixed_effects, fixed_effects_names] = fixedEffects(exps.(experiment).LME.lme);
    [random_effects,random_effects_names] = randomEffects(exps.(experiment).LME.lme);
    slope_pvalue = coefTest(exps.(experiment).LME.lme);
    disp(experiment+": slope fixed_coeff="+fixed_effects(2)+", p="+slope_pvalue);

    lme = exps.(experiment).LME.lme;
    subjects = unique(lme.Variables.Subject);
    n_subj = length(subjects);
    subjectIntercepts = fixed_effects(1) + random_effects(1:n_subj);
    subjectSlopes = fixed_effects(2) + random_effects((n_subj+1):end);
    subjectSpecificEffects = table(subjects, subjectIntercepts, subjectSlopes, ...
    'VariableNames', {'Subject', 'RT_Intercept', 'RT_Slope'});
    exps.(experiment).LME.fixedrandomeffects = subjectSpecificEffects;
end

exps_copy = exps;
clear exps;
for exp_idx = 1:n_exps
    experiment = experiment_names(exp_idx);
    exp.ITI = exps_copy.(experiment).ITI; 
    exp.optimal_sol = exps_copy.(experiment).optimal_sol; 
    exp.BehavioralStats = exps_copy.(experiment).BehavioralStats; 
    exp.LME.lme = exps_copy.(experiment).LME.lme;
    exp.LME.fixedrandomeffects = exps_copy.(experiment).LME.fixedrandomeffects;
    exp.LME.fixedrandomeffectsmat = table2array(exps_copy.(experiment).LME.fixedrandomeffects);
    exp.LME.complexity_optimal = exps_copy.(experiment).LME.complexity_rrmax;
    exp.LME.complexity_diff_from_optimal = exps_copy.(experiment).BehavioralStats.complexity - exps_copy.(experiment).LME.complexity_rrmax;
    exp.LME.RT_lme = exps_copy.(experiment).LME.RT_lme;
    exp.LME.RT_lme_theoretical = exps_copy.(experiment).LME.RT_lme_theoretical;
    exps.(experiment) = exp;
end

save("exps_all_rewardmag75perc.mat", "exps")





















%% Helper functions
function [mturkIDs, optimal_sol, BehavioralStats, LME, TTests, CohensD_CIs, CohensD, WilcoxonTests] = parse_data(data_exps, survey_exps, experiment,exp3_correct_actions)
    if(nargin==3)
        exp3_correct_actions = NaN;
        
    end
    TTests = struct();
    CohensD = struct();
    WilcoxonTests = struct();

    data = data_exps.(experiment);
    survey = survey_exps.(experiment);
    feedback_duration = 0.3; % in seconds
    
    switch experiment
        case "exp_ITI"
            Q = eye(4).*0.5+0.25;
            n_subj = length(data);
            cond = unique(data(1).cond); % ITI conditions
        case "exp_Ns246"
            set_sizes = [2,4,6];
            cond = [2000];
            n_tasks = length(set_sizes);
            task_names = "set_size_"+set_sizes;
            datas = data;
            n_subj = length(data.(task_names(1)));
        case "exp_Ns267"
            set_sizes = [2,6,7];
            cond = [2000];
            n_tasks = length(set_sizes);
            task_names = "set_size_"+set_sizes;
            datas = data;
            n_subj = length(data.(task_names(1)));
    end

    reward_count = zeros(n_subj,3);
    cond_entropy = zeros(n_subj,3); % H(A|S)
    repeat_actions = zeros(n_subj,3); % Measure of perserverance
    mturkIDs = [];
    if(~contains(experiment,"Ns"))
        for s = 1:n_subj
            mturkIDs = [mturkIDs; convertCharsToStrings(data(s).ID)];
            for c = 1:length(cond)
                idx = data(s).cond == cond(c);
                state = data(s).s(idx);
                action = data(s).a(idx);
                acc = data(s).acc(idx);
                r = data(s).r(idx);
                rt = data(s).rt(idx);
                tt = data(s).tt(idx); % total time of the block
                n_trials(s,c) = length(state);
                accuracy(s,c) = nanmean(acc);
                reward(s,c) = nanmean(r);
                reward_count(s,c) = sum(r);
                reward_rate(s,c) = reward_count(s,c)/tt(end);
                complexity(s,c) = mutual_information(round(state),round(action),0.1)./log(2);
                response_time(s,c) = nanmean(rt./1000); % RT in seconds
                cond_entropy(s,c) = condEntropy(round(action), round(state));
                repeat_actions(s,c) = nanmean(action(1:end-1) == action(2:end));
                first_cond(s) = data(s).first_cond;
            end
            if(experiment=="exp2") % Record which two states share the same correct action
                correct_actions(s,:) = data(s).correct_action;
            end
        end
    else % Experiment 3
        for task = 1:n_tasks
            task_name = task_names(task);
            data = datas.(task_name);
            for s = 1:n_subj
                if(task==1)
                    mturkIDs = [mturkIDs; convertCharsToStrings(data(s).ID)];
                end
                iti_2_idx = data(s).cond == cond(end);
                for c = 1:length(cond)
                    idx = data(s).cond == cond(c);
                    state = data(s).s(idx);
                    action = data(s).a(idx);
                    acc = data(s).acc(idx);
                    r = data(s).r(idx);
                    rt = data(s).rt(idx);
                    tt = data(s).tt(idx); % total time of the block
        
                    % Dimensions are: [subject, set size].
                    n_trials(s,task) = length(state);
                    accuracy(s,task) = nanmean(acc);
                    reward(s,task) = nanmean(r);
                    reward_count(s,task) = sum(r);
                    reward_rate(s,task) = reward_count(s,task)/tt(end);
                    complexity(s,task) = mutual_information(round(state),round(action),0.1)./log(2); 
                    response_time(s,task) = nanmean(rt./1000); % RT in seconds
                    cond_entropy(s,task) = condEntropy(round(action), round(state));
                    repeat_actions(s,task) = nanmean(action(1:end-1) == action(2:end));
                end
            end
        end
    end
    BehavioralStats.n_trials = n_trials;
    BehavioralStats.accuracy=accuracy;
    BehavioralStats.reward=reward;
    BehavioralStats.reward_rate=reward_rate;
    BehavioralStats.complexity=complexity;
    BehavioralStats.response_time=response_time;
    BehavioralStats.cond_entropy=cond_entropy;    
    BehavioralStats.repeat_actions=repeat_actions;
    if(experiment=="exp2")
        BehavioralStats.correct_actions = correct_actions;
    end

    
    % Compute Cohen's D
    CohensD_complexity = cell(3,2); % ITI_cond
    CohensD_response_time = cell(3,2); % ITI_cond
    CohensD_perc_reward = cell(3,2); % ITI_cond
    CohensD_reward_rate = cell(3,2); % ITI_cond
    CohensD_cond_entropy = cell(3,2);
    CohensD_repeat_actions = cell(3,2);
    ITI_pairs = [1,2; 2,3; 1,3];
    for iti_idx=1:length(ITI_pairs)
        CohensD_complexity(iti_idx,:) = table2cell(meanEffectSize(complexity(:,ITI_pairs(iti_idx,1)),complexity(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_response_time(iti_idx,:) = table2cell(meanEffectSize(response_time(:,ITI_pairs(iti_idx,1)),response_time(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_reward_rate(iti_idx,:) = table2cell(meanEffectSize(reward_rate(:,ITI_pairs(iti_idx,1)),reward_rate(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_cond_entropy(iti_idx,:) = table2cell(meanEffectSize(cond_entropy(:,ITI_pairs(iti_idx,1)),cond_entropy(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_repeat_actions(iti_idx,:) = table2cell(meanEffectSize(repeat_actions(:,ITI_pairs(iti_idx,1)),repeat_actions(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
    end
    CohensD.complexity = CohensD_complexity;
    CohensD.response_time = CohensD_response_time;
    CohensD.cond_entropy = CohensD_cond_entropy;
    CohensD.repeat_actions = CohensD_repeat_actions;
    CohensD.reward_rate = CohensD_reward_rate;
    
    [~,TTests.complexity(1),TTestsCI.complexity(:,1),~] = ttest(complexity(:,1), complexity(:,2), "Tail","left");
    [~,TTests.complexity(2),TTestsCI.complexity(:,2),~] = ttest(complexity(:,2), complexity(:,3), "Tail","left");
    [~,TTests.complexity(3),TTestsCI.complexity(:,3),~] = ttest(complexity(:,1), complexity(:,3), "Tail","left");
    [~,TTests.response_time(1),TTestsCI.response_time(:,1),~] = ttest(response_time(:,1), response_time(:,2), "Tail","left");
    [~,TTests.response_time(2),TTestsCI.response_time(:,2),~] = ttest(response_time(:,2), response_time(:,3), "Tail","left");
    [~,TTests.response_time(3),TTestsCI.response_time(:,3),~] = ttest(response_time(:,1), response_time(:,3), "Tail","left");
    [~,TTests.cond_entropy(1),TTestsCI.cond_entropy(:,1),~] = ttest(cond_entropy(:,2), cond_entropy(:,1), "Tail","left");
    [~,TTests.cond_entropy(2),TTestsCI.cond_entropy(:,2),~] = ttest(cond_entropy(:,3), cond_entropy(:,2), "Tail","left");
    [~,TTests.cond_entropy(3),TTestsCI.cond_entropy(:,3),~] = ttest(cond_entropy(:,3), cond_entropy(:,1), "Tail","left");
    [~,TTests.repeat_actions(1),TTestsCI.repeat_actions(:,1),~] = ttest(repeat_actions(:,2), repeat_actions(:,1), "Tail","left");
    [~,TTests.repeat_actions(2),TTestsCI.repeat_actions(:,2),~] = ttest(repeat_actions(:,3), repeat_actions(:,2), "Tail","left");
    [~,TTests.repeat_actions(3),TTestsCI.repeat_actions(:,3),~] = ttest(repeat_actions(:,3), repeat_actions(:,1), "Tail","left");
    [~,TTests.reward_rate(1),TTestsCI.reward_rate(:,1),~] = ttest(reward_rate(:,2), reward_rate(:,1), "Tail","left");
    [~,TTests.reward_rate(2),TTestsCI.reward_rate(:,2),~] = ttest(reward_rate(:,3), reward_rate(:,2), "Tail","left");
    [~,TTests.reward_rate(3),TTestsCI.reward_rate(:,3),~] = ttest(reward_rate(:,3), reward_rate(:,1), "Tail","left");
    
    WilcoxonTests.complexity(1) = signrank(complexity(:,1), complexity(:,2), "Tail","left");
    WilcoxonTests.complexity(2) = signrank(complexity(:,2), complexity(:,3), "Tail","left");
    WilcoxonTests.complexity(3) = signrank(complexity(:,1), complexity(:,3), "Tail","left");
    WilcoxonTests.response_time(1) = signrank(response_time(:,1), response_time(:,2), "Tail","left");
    WilcoxonTests.response_time(2) = signrank(response_time(:,2), response_time(:,3), "Tail","left");
    WilcoxonTests.response_time(3) = signrank(response_time(:,1), response_time(:,3), "Tail","left");
    WilcoxonTests.cond_entropy(1) = signrank(cond_entropy(:,2), cond_entropy(:,1), "Tail","left");
    WilcoxonTests.cond_entropy(2) = signrank(cond_entropy(:,3), cond_entropy(:,2), "Tail","left");
    WilcoxonTests.cond_entropy(3) = signrank(cond_entropy(:,3), cond_entropy(:,1), "Tail","left");
    WilcoxonTests.repeat_actions(1) = signrank(repeat_actions(:,2), repeat_actions(:,1), "Tail","left");
    WilcoxonTests.repeat_actions(2) = signrank(repeat_actions(:,3), repeat_actions(:,2), "Tail","left");
    WilcoxonTests.repeat_actions(3) = signrank(repeat_actions(:,3), repeat_actions(:,1), "Tail","left");
    WilcoxonTests.reward_rate(1) = signrank(reward_rate(:,2), reward_rate(:,1), "Tail","left");
    WilcoxonTests.reward_rate(2) = signrank(reward_rate(:,3), reward_rate(:,2), "Tail","left");
    WilcoxonTests.reward_rate(3) = signrank(reward_rate(:,3), reward_rate(:,1), "Tail","left");
    
    % Perceived difficulty
    T0 = table(mturkIDs,complexity,'VariableNames',["ID","policy_complexity"]);
    T1 = struct2table(survey); 
    T1 = table(table2array(T1(:,1)),table2array(T1(:,4)),'VariableNames',["ID","difficulty"]);
    T = innerjoin(T0,T1);
    if(experiment=="exp_ITI")
        difficulties = cell2mat(table2array(T(:,3)));
    else
        difficulties = table2array(T(:,3));
    end
    BehavioralStats.difficulties=difficulties;
    [h,TTests.difficulty(1),TTestsCI.difficulty(:,1),~] = ttest(difficulties(:,1), difficulties(:,2), "Tail","left");
    [h,TTests.difficulty(2),TTestsCI.difficulty(:,2),~] = ttest(difficulties(:,2), difficulties(:,3), "Tail","left");
    [h,TTests.difficulty(3),TTestsCI.difficulty(:,3),~] = ttest(difficulties(:,1), difficulties(:,3), "Tail","left");
    WilcoxonTests.difficulty(1) = signrank(difficulties(:,1), difficulties(:,2), "Tail","left");
    WilcoxonTests.difficulty(2) = signrank(difficulties(:,2), difficulties(:,3), "Tail","left");
    WilcoxonTests.difficulty(3) = signrank(difficulties(:,1), difficulties(:,3), "Tail","left");
    for iti_idx=1:length(ITI_pairs)
        CohensD_difficulties(iti_idx,:) = table2cell(meanEffectSize(difficulties(:,ITI_pairs(iti_idx,1)),difficulties(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
    end
    CohensD.difficulties=CohensD_difficulties;

    
    % Theoretical curves assuming linear RTH
    n_tot = 50;
    beta_set = linspace(0.1,15,n_tot);
    if(~contains(experiment,"Ns"))
        p_state = [0.25 0.25 0.25 0.25];
        optimal_sol.Q = Q;
        optimal_sol.p_state = p_state;
        [optimal_sol.R, optimal_sol.V, optimal_sol.Pa, optimal_sol.optimal_policy] = blahut_arimoto(p_state,Q,beta_set);
        R = optimal_sol.R; V=optimal_sol.V;

            % P(A|S) for Experiment 2
            P_a_given_s = zeros(n_subj,4,length(cond),4); % subj, states, conds, actions
            for subj=1:n_subj
                for state=1:4
                    s_idx = find(data(subj).s==state);
                    subj_thisstateoccurrences = data(subj).s(s_idx);
                    subj_actions_giventhisstate = data(subj).a(s_idx);
                    for c = 1:length(cond)
                        cond_idx = find(data(subj).cond(s_idx) == cond(c));
                        states = subj_thisstateoccurrences(cond_idx);
                        actions = subj_actions_giventhisstate(cond_idx);
                        [N,~] = histcounts(actions,0.5:1:4.5);
                        P_a_given_s(subj, state, c, :) = N./sum(N);
                    end
                end
            end
            BehavioralStats.P_a_given_s = P_a_given_s;

    else
        P_a_given_s = nan(n_subj,max(set_sizes),length(cond),max(set_sizes)); % subj, states, conds, actions
        Q_full = normalize(eye(max(set_sizes)), 'range', [0.25 0.75]);
        
        for set_size_idx = 1:length(set_sizes)
            set_size = set_sizes(set_size_idx);
            task_name = task_names(set_size_idx);
            p_state = ones(1,set_size)./set_size;
            p_states.(task_name) = p_state;
            Q = Q_full(1:set_size,:);
            Qs.(task_name) = Q;
            % initialize variables
            [R.(task_name),V.(task_name),Pa.(task_name), optimal_policy.(task_name)] = blahut_arimoto(p_state,Q,beta_set);
            % P(A|S) for Experiment 3
            data = datas.(task_name);
            for subj=1:n_subj
                for state=1:set_size
                    s_idx = find(data(subj).s==state);
                    actions = data(subj).a(s_idx);
                    [N,~] = histcounts(actions,0.5:1:(max(set_sizes)+.5));
                    P_a_given_s(subj, state, set_size_idx, :) = N./sum(N);
                end
            end
        end
        optimal_sol.Q = Qs; optimal_sol.p_state = p_states; optimal_sol.R = R; optimal_sol.V = V; optimal_sol.Pa = Pa; optimal_sol.optimal_policy = optimal_policy;
        BehavioralStats.P_a_given_s = P_a_given_s;
    end


    if(experiment=="exp2")
        for s=1:n_subj
            % [Subject, iti_condition].
            a_perserv(s) = mode(data(s).correct_action, 2);
            for c=1:length(cond)
                % [Subject, iti_condition, the 2 states where a_perserv is suboptimal].
                states_where_a_perserv_suboptimal(s,c,:) = find(data(s).correct_action~=a_perserv(s));
                P_a_perserv_given_suboptimal_s(s,c,:) =  P_a_given_s(s,states_where_a_perserv_suboptimal(s,c,:),c,a_perserv(s));
                P_a_perserv_given_optimal_s(s,c,:) =  P_a_given_s(s,setdiff(1:4, squeeze(states_where_a_perserv_suboptimal(s,c,:))),c,a_perserv(s));
            end
        end
        % Average over p(a_perserv | s) for the two states s
        % where a_perserv is suboptimal. 
        P_a_perserv_given_suboptimal_s_mean = mean(P_a_perserv_given_suboptimal_s,3);
        BehavioralStats.SuboptimalA = P_a_perserv_given_suboptimal_s_mean;
        for iti_idx=1:length(ITI_pairs)
            CohensD_SuboptimalA(iti_idx,:) = table2cell(meanEffectSize(P_a_perserv_given_suboptimal_s_mean(:,ITI_pairs(iti_idx,1)), P_a_perserv_given_suboptimal_s_mean(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        end
        CohensD.SuboptimalA = CohensD_SuboptimalA;
        [~,TTests.SuboptimalA(1),TTestsCI.SuboptimalA(:,1),~] = ttest(P_a_perserv_given_suboptimal_s_mean(:,2), P_a_perserv_given_suboptimal_s_mean(:,1), "Tail","left");
        [~,TTests.SuboptimalA(2),TTestsCI.SuboptimalA(:,2),~] = ttest(P_a_perserv_given_suboptimal_s_mean(:,3), P_a_perserv_given_suboptimal_s_mean(:,2), "Tail","left");
        [~,TTests.SuboptimalA(3),TTestsCI.SuboptimalA(:,3),~] = ttest(P_a_perserv_given_suboptimal_s_mean(:,3), P_a_perserv_given_suboptimal_s_mean(:,1), "Tail","left");
        WilcoxonTests.SuboptimalA(1) = signrank(P_a_perserv_given_suboptimal_s_mean(:,2),P_a_perserv_given_suboptimal_s_mean(:,1), "Tail","left");
        WilcoxonTests.SuboptimalA(2) = signrank(P_a_perserv_given_suboptimal_s_mean(:,3),P_a_perserv_given_suboptimal_s_mean(:,2), "Tail","left");
        WilcoxonTests.SuboptimalA(3) = signrank(P_a_perserv_given_suboptimal_s_mean(:,3),P_a_perserv_given_suboptimal_s_mean(:,1), "Tail","left");
    end


        
    %% LME fitting

    % Flattening arrays
    complexity_flat = complexity(:); 
    response_time_flat = response_time(:);
    [complexity_sorted, complexity_sorted_idx] = sort(complexity_flat);
    response_time_sorted = response_time_flat(complexity_sorted_idx);
    LME.complexity_sorted = complexity_sorted;
    LME.response_time_sorted = response_time_sorted;
    LME.complexity_sorted_idx = complexity_sorted_idx;
    if(~contains(experiment,"Ns"))
        subject_id = repmat(1:n_subj, 1, length(cond))';
    else
        subject_id = repmat(1:n_subj, 1, length(set_sizes))';
    end

    tbl = table(subject_id,complexity_flat,response_time_flat,'VariableNames',{'Subject','PolicyComplexity','RT'});
    lme = fitlme(tbl,'RT ~ PolicyComplexity + (1|Subject) + (PolicyComplexity-1|Subject)');
    LME.lme = lme;
    LME.tbl = tbl;

    % STD of random effects
    [~,~,stats] = randomEffects(lme,'Alpha',0.01);
    q = dataset2cell(stats(1:n_subj,4));
    w = dataset2cell(stats((n_subj+1):end,4));
    LME.random_effects_intercept_std = std(cell2mat(q(2:end)));
    LME.random_effects_complexity_std = std(cell2mat(w(2:end)));
    
    % RT_predictions vs. RT_true
    RT_lme = predict(lme); % Return 1SD, instead of 95% CI. 
    RT_lme_sorted = RT_lme(complexity_sorted_idx);
    LME.RT_lme = RT_lme;
    LME.RT_lme_sorted = RT_lme_sorted;

    % Counterfactual RT at different policy complexity levels
    if(~contains(experiment,"Ns"))
        complexity_rrmax = zeros(n_subj, length(cond));
        RT_lme_theoretical = zeros(n_subj, length(R));
        for subj=1:n_subj
            tbl_new = table(repmat(subj,1,length(R))',R,'VariableNames',{'Subject','PolicyComplexity'});
            rt_lme_theoretical = predict(lme, tbl_new);
            RT_lme_theoretical(subj,:)=rt_lme_theoretical;
            for c=1:length(cond)
                rr = V ./ (rt_lme_theoretical + cond(c)/1000 + feedback_duration);
                [max_rr, max_rr_complexity] = max(rr);
                complexity_rrmax(subj,c) = R(max_rr_complexity);
            end
        end
        LME.RT_lme_theoretical = RT_lme_theoretical;
    else
        complexity_rrmax = zeros(n_subj, length(set_sizes));
        %RT_lme_theoreticals = zeros(n_subj, length(R.(task_names(end))));
        for set_size_idx=1:length(set_sizes)
            RT_lme_theoreticals = zeros(n_subj, length(R.(task_names(end))));
            for subj=1:n_subj
                set_size = set_sizes(set_size_idx);
                task_name = task_names(set_size_idx);
                tbl_new = table(repmat(subj,1,length(R.(task_name)))',R.(task_name),'VariableNames',{'Subject','PolicyComplexity'});
                RT_lme_theoretical = predict(lme, tbl_new);
                RT_lme_theoreticals(subj,:)=RT_lme_theoretical;
                rr = V.(task_name) ./ (RT_lme_theoretical + cond/1000 + feedback_duration);
                [max_rr, max_rr_complexity] = max(rr);
                complexity_rrmax(subj,set_size_idx) = R.(task_name)(max_rr_complexity);
            end
            LME.RT_lme_theoretical.("set_size_"+set_size) = RT_lme_theoreticals;
        end
        %LME.RT_lme_theoretical = RT_lme_theoreticals;
    end
    LME.complexity_rrmax = complexity_rrmax;
    rhos_subj = zeros(n_subj,1);

    difficulty_subj = 1;
    for subj=1:n_subj
        if(experiment=="exp_ITI" && ~isempty(cell2mat(table2array(T(subj,3))))) % In Experiment 1, one subject did not have difficulty data.
            rhos_subj(subj) = corr(complexity(subj,:)', difficulties(difficulty_subj,:)',"Type", "Spearman");
            difficulty_subj = difficulty_subj + 1;
        else
            rhos_subj(subj) = corr(complexity(subj,:)', difficulties(subj,:)',"Type", "Spearman");
        end
    end
    BehavioralStats.complexity_difficulty_spearman = rhos_subj;
    CohensD.complexity_difficulty_spearman_ispositive = table2cell(meanEffectSize(rhos_subj,Effect="cohen"));
    [~,TTests.complexity_difficulty_spearman_ispositive,TTestsCI.complexity_difficulty_spearman_ispositive,~] = ttest(rhos_subj,0, "Tail","right");
    WilcoxonTests.complexity_difficulty_spearman_ispositive = signrank(rhos_subj,0, "Tail","right");
        

    % Leftward complexity bias
    complexity_diff_from_rrmax = complexity-complexity_rrmax;
    LME.complexity_diff_from_rrmax=complexity_diff_from_rrmax;
    for c=1:3
        %CohensD_complexity_lessthan_rrmax(c,:) = table2cell(meanEffectSize(complexity(:,c),complexity_rrmax(:,c),Effect="cohen", Paired=true)); % cliff's delta instead of Cohen's d, because we will use nonparametric test
        CohensD_complexity_lessthan_rrmax(c,:) = table2cell(meanEffectSize(complexity(:,c),complexity_rrmax(:,c),Effect="cliff", Paired=true)); % cliff's delta instead of Cohen's d, because we will use nonparametric test
    end
    CohensD.complexity_lessthan_rrmax = CohensD_complexity_lessthan_rrmax;
    [~,TTests.complexity_lessthan_rrmax(1),TTestsCI.complexity_lessthan_rrmax(:,1)] = ttest(complexity(:,1), complexity_rrmax(:,1), "Tail","left");
    [~,TTests.complexity_lessthan_rrmax(2),TTestsCI.complexity_lessthan_rrmax(:,2)] = ttest(complexity(:,2), complexity_rrmax(:,2), "Tail","left");
    [~,TTests.complexity_lessthan_rrmax(3),TTestsCI.complexity_lessthan_rrmax(:,3)] = ttest(complexity(:,3), complexity_rrmax(:,3), "Tail","left");
    WilcoxonTests.complexity_lessthan_rrmax(1) = signrank(complexity(:,1), complexity_rrmax(:,1),"Tail","left");
    WilcoxonTests.complexity_lessthan_rrmax(2) = signrank(complexity(:,2), complexity_rrmax(:,2),"Tail","left");
    WilcoxonTests.complexity_lessthan_rrmax(3) = signrank(complexity(:,3), complexity_rrmax(:,3),"Tail","left");

    % Two subgroups analysis of RT and policy complexity
    switch experiment
        case "exp_ITI"
            thres = -1;
            % Use ITI=2 to separate into 2 groups
            lowcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))<thres);
            highcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))>=thres);
        case "exp_Ns246"
            thres = -0.9;
            % Use ITI=9.5 to separate into 2 groups
            lowcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))<thres);
            highcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))>=thres);
        case "exp_Ns267"
            thres = -0.9;
            % Use ITI=9.5 to separate into 2 groups
            lowcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))<thres);
            highcomplexity_group_subjidx = find(squeeze(complexity(:,3)-complexity_rrmax(:,3))>=thres);

    end
    complexity_group_subjidx = {lowcomplexity_group_subjidx, highcomplexity_group_subjidx};
    for iti_idx=1:length(ITI_pairs)
        CohensD_complexity_low_complexity(iti_idx,:) = table2cell(meanEffectSize(complexity(lowcomplexity_group_subjidx,ITI_pairs(iti_idx,1)),complexity(lowcomplexity_group_subjidx,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_response_time_low_complexity(iti_idx,:) = table2cell(meanEffectSize(response_time(lowcomplexity_group_subjidx,ITI_pairs(iti_idx,1)),response_time(lowcomplexity_group_subjidx,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_complexity_high_complexity(iti_idx,:) = table2cell(meanEffectSize(complexity(highcomplexity_group_subjidx,ITI_pairs(iti_idx,1)),complexity(highcomplexity_group_subjidx,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_response_time_high_complexity(iti_idx,:) = table2cell(meanEffectSize(response_time(highcomplexity_group_subjidx,ITI_pairs(iti_idx,1)),response_time(highcomplexity_group_subjidx,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
    end
    CohensD.complexity_low_complexity = CohensD_complexity_low_complexity;
    CohensD.response_time_low_complexity = CohensD_response_time_low_complexity;
    CohensD.complexity_high_complexity = CohensD_complexity_high_complexity;
    CohensD.response_time_high_complexity = CohensD_response_time_high_complexity;

    [~,TTests.complexity_lowcomplexity(1),TTestsCI.complexity_lowcomplexity(:,1)] = ttest(complexity(lowcomplexity_group_subjidx,1), complexity(lowcomplexity_group_subjidx,2),"Tail","left");
    [~,TTests.complexity_lowcomplexity(2),TTestsCI.complexity_lowcomplexity(:,2)] = ttest(complexity(lowcomplexity_group_subjidx,2), complexity(lowcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.complexity_lowcomplexity(3),TTestsCI.complexity_lowcomplexity(:,3)] = ttest(complexity(lowcomplexity_group_subjidx,1), complexity(lowcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.response_time_lowcomplexity(1),TTestsCI.response_time_lowcomplexity(:,1)] = ttest(response_time(lowcomplexity_group_subjidx,1), response_time(lowcomplexity_group_subjidx,2),"Tail","left");
    [~,TTests.response_time_lowcomplexity(2),TTestsCI.response_time_lowcomplexity(:,2)] = ttest(response_time(lowcomplexity_group_subjidx,2), response_time(lowcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.response_time_lowcomplexity(3),TTestsCI.response_time_lowcomplexity(:,3)] = ttest(response_time(lowcomplexity_group_subjidx,1), response_time(lowcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.complexity_lowcomplexity(1) = signrank(complexity(lowcomplexity_group_subjidx,1), complexity(lowcomplexity_group_subjidx,2),"Tail","left");
    WilcoxonTests.complexity_lowcomplexity(2) = signrank(complexity(lowcomplexity_group_subjidx,2), complexity(lowcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.complexity_lowcomplexity(3) = signrank(complexity(lowcomplexity_group_subjidx,1), complexity(lowcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.response_time_lowcomplexity(1) = signrank(response_time(lowcomplexity_group_subjidx,1), response_time(lowcomplexity_group_subjidx,2),"Tail","left");
    WilcoxonTests.response_time_lowcomplexity(2) = signrank(response_time(lowcomplexity_group_subjidx,2), response_time(lowcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.response_time_lowcomplexity(3) = signrank(response_time(lowcomplexity_group_subjidx,1), response_time(lowcomplexity_group_subjidx,3),"Tail","left");

    [~,TTests.complexity_highcomplexity(1),TTestsCI.complexity_highcomplexity(:,1)] = ttest(complexity(highcomplexity_group_subjidx,1), complexity(highcomplexity_group_subjidx,2),"Tail","left");
    [~,TTests.complexity_highcomplexity(2),TTestsCI.complexity_highcomplexity(:,2)] = ttest(complexity(highcomplexity_group_subjidx,2), complexity(highcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.complexity_highcomplexity(3),TTestsCI.complexity_highcomplexity(:,3)] = ttest(complexity(highcomplexity_group_subjidx,1), complexity(highcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.response_time_highcomplexity(1),TTestsCI.response_time_highcomplexity(:,1)] = ttest(response_time(highcomplexity_group_subjidx,1), response_time(highcomplexity_group_subjidx,2),"Tail","left");
    [~,TTests.response_time_highcomplexity(2),TTestsCI.response_time_highcomplexity(:,2)] = ttest(response_time(highcomplexity_group_subjidx,2), response_time(highcomplexity_group_subjidx,3),"Tail","left");
    [~,TTests.response_time_highcomplexity(3),TTestsCI.response_time_highcomplexity(:,3)] = ttest(response_time(highcomplexity_group_subjidx,1), response_time(highcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.complexity_highcomplexity(1) = signrank(complexity(highcomplexity_group_subjidx,1), complexity(highcomplexity_group_subjidx,2),"Tail","left");
    WilcoxonTests.complexity_highcomplexity(2) = signrank(complexity(highcomplexity_group_subjidx,2), complexity(highcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.complexity_highcomplexity(3) = signrank(complexity(highcomplexity_group_subjidx,1), complexity(highcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.response_time_highcomplexity(1) = signrank(response_time(highcomplexity_group_subjidx,1), response_time(highcomplexity_group_subjidx,2),"Tail","left");
    WilcoxonTests.response_time_highcomplexity(2) = signrank(response_time(highcomplexity_group_subjidx,2), response_time(highcomplexity_group_subjidx,3),"Tail","left");
    WilcoxonTests.response_time_highcomplexity(3) = signrank(response_time(highcomplexity_group_subjidx,1), response_time(highcomplexity_group_subjidx,3),"Tail","left");



    LME.complexity_group_subjidx=complexity_group_subjidx;

    % Counterbalanced trial design
    if(~contains(experiment,"Ns"))  
        rewards_phase = cell(length(cond),1);
        for c=1:length(cond)
            for phase=1:8
                for subj=1:n_subj
                    idx = find(data(subj).cond==cond(c));
                    subj_r = data(subj).r(idx);
                    reward_phase(subj,phase) = mean(subj_r(phase:8:end));
                end
            end
            rewards_phase{c} = reward_phase;
            CohensD.undesired_cycle_effects = table2cell(meanEffectSize(reward_phase(:,1), reward_phase(:,end), Effect="cohen", Paired=true));
            [~,TTests.undesired_cycle_effects,TTestsCI.undesired_cycle_effects] = ttest(reward_phase(:,1), reward_phase(:,end), "Tail","left");
            WilcoxonTests.undesired_cycle_effects = signrank(reward_phase(:,1), reward_phase(:,end), "Tail","left");
        end
    else
        rewards_phase = cell(length(set_sizes),1);
        periods = [2*4,4*2,6*2];
        for set_size_idx = 1:length(set_sizes)
            period = periods(set_size_idx);
            data = datas.(task_names(set_size_idx));
            for phase=1:period
                for subj=1:n_subj
                    subj_r = data(subj).r;
                    reward_phase(subj,phase) = mean(subj_r(phase:period:end));
                end
            end
            rewards_phase{set_size_idx} = reward_phase;
            CohensD.undesired_cycle_effects = table2cell(meanEffectSize(reward_phase(:,1), reward_phase(:,end), Effect="cohen", Paired=true));
            [~,TTests.undesired_cycle_effects(set_size_idx),TTestsCI.undesired_cycle_effects(:,set_size_idx)] = ttest(reward_phase(:,1), reward_phase(:,end), "Tail","left");
            WilcoxonTests.undesired_cycle_effects(set_size_idx) = signrank(reward_phase(:,1), reward_phase(:,end), "Tail","left");
        end
    end
    BehavioralStats.rewards_phase = rewards_phase;

    % Cohen's d--only return the point estimate
    CohensD_new = struct();
    CohensD_CIs = struct();
    fields = fieldnames(CohensD);
    for i = 1:numel(fields)
        fieldName = fields{i};
        % Extract the first column of the 3x2 cell and convert it to a 1x3 vector
        CohensD_new.(fieldName) = cell2mat(CohensD.(fieldName)(:, 1))';
        CohensD_CIs.(fieldName) = cell2mat(CohensD.(fieldName)(:, 2))';
    end
    CohensD = CohensD_new;
end


function [mturkIDs, optimal_sol, BehavioralStats, LME, TTests, CohensD, WilcoxonTests] = parse_data_exp_rewardmag(data_exps, experiment)
    TTests = struct();
    CohensD = struct();
    WilcoxonTests = struct();

    data = data_exps.(experiment);
    feedback_duration = 0.3; % in seconds
    
    switch experiment
        case "exp_rewardmag"
            n_states = 4;
            n_actions = n_states;
            p_state = ones(1,n_states)./n_states;
            Q = 0.25+eye(n_states).*0.5;
            n_subj = length(data);
            cond = unique(data(1).cond); % ITI conditions
    end

    reward_count = zeros(n_subj,2);
    cond_entropy = zeros(n_subj,2); % H(A|S)
    repeat_actions = zeros(n_subj,2); % Measure of perserverance
    mturkIDs = [];
    for s = 1:n_subj
        mturkIDs = [mturkIDs; convertCharsToStrings(data(s).ID)];
        for c = 1:length(cond)
            idx = find(data(s).cond == cond(c));
            state = data(s).s(idx);
            action = data(s).a(idx);
            acc = data(s).acc(idx);
            r = data(s).r(idx);
            rt = data(s).rt(idx);
            tt = data(s).tt(idx); % total time of the block
            n_trials(s,c) = length(state);
            accuracy(s,c) = nanmean(acc);
            reward(s,c) = nanmean(r);
            reward_count(s,c) = sum(r);
            reward_rate(s,c) = reward_count(s,c)/tt(end);
            complexity(s,c) = mutual_information(round(state),round(action),0.1)./log(2);
            response_time(s,c) = nanmean(rt./1000); % RT in seconds
            cond_entropy(s,c) = condEntropy(round(action), round(state));
            repeat_actions(s,c) = nanmean(action(1:end-1) == action(2:end));
            first_cond(s) = data(s).first_cond;
        end
    end
    BehavioralStats.n_trials = n_trials;
    BehavioralStats.accuracy=accuracy;
    BehavioralStats.reward=reward;
    BehavioralStats.reward_rate=reward_rate;
    BehavioralStats.complexity=complexity;
    BehavioralStats.response_time=response_time;
    BehavioralStats.cond_entropy=cond_entropy;    
    BehavioralStats.repeat_actions=repeat_actions;
    BehavioralStats.cond = cond;
    
    % Compute Cohen's D
    CohensD_complexity = cell(3,2); % ITI_cond
    CohensD_response_time = cell(3,2); % ITI_cond
    CohensD_perc_reward = cell(3,2); % ITI_cond
    CohensD_reward_rate = cell(3,2); % ITI_cond
    CohensD_cond_entropy = cell(3,2);
    CohensD_repeat_actions = cell(3,2);
    ITI_pairs = [1,2; NaN, NaN];
    for iti_idx=1
        CohensD_complexity(iti_idx,:) = table2cell(meanEffectSize(complexity(:,ITI_pairs(iti_idx,1)),complexity(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_response_time(iti_idx,:) = table2cell(meanEffectSize(response_time(:,ITI_pairs(iti_idx,1)),response_time(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_reward_rate(iti_idx,:) = table2cell(meanEffectSize(reward_rate(:,ITI_pairs(iti_idx,1)),reward_rate(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_cond_entropy(iti_idx,:) = table2cell(meanEffectSize(cond_entropy(:,ITI_pairs(iti_idx,1)),cond_entropy(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
        CohensD_repeat_actions(iti_idx,:) = table2cell(meanEffectSize(repeat_actions(:,ITI_pairs(iti_idx,1)),repeat_actions(:,ITI_pairs(iti_idx,2)),Effect="cohen", Paired=true));
    end
    CohensD.complexity = CohensD_complexity;
    CohensD.response_time = CohensD_response_time;
    CohensD.cond_entropy = CohensD_cond_entropy;
    CohensD.repeat_actions = CohensD_repeat_actions;
    CohensD.reward_rate = CohensD_reward_rate;
    
    [~,TTests.complexity(1),TTestsCI.complexity(:,1),~] = ttest(complexity(:,1), complexity(:,2), "Tail","left");
    [~,TTests.response_time(1),TTestsCI.response_time(:,1),~] = ttest(response_time(:,1), response_time(:,2), "Tail","left");
    [~,TTests.cond_entropy(1),TTestsCI.cond_entropy(:,1),~] = ttest(cond_entropy(:,2), cond_entropy(:,1), "Tail","left");
    [~,TTests.repeat_actions(1),TTestsCI.repeat_actions(:,1),~] = ttest(repeat_actions(:,2), repeat_actions(:,1), "Tail","left");
    [~,TTests.reward_rate(1),TTestsCI.reward_rate(:,1),~] = ttest(reward_rate(:,2), reward_rate(:,1), "Tail","left");
    
    WilcoxonTests.complexity(1) = signrank(complexity(:,1), complexity(:,2), "Tail","left");
    WilcoxonTests.response_time(1) = signrank(response_time(:,1), response_time(:,2), "Tail","left");
    WilcoxonTests.cond_entropy(1) = signrank(cond_entropy(:,2), cond_entropy(:,1), "Tail","left");
    WilcoxonTests.repeat_actions(1) = signrank(repeat_actions(:,2), repeat_actions(:,1), "Tail","left");
    WilcoxonTests.reward_rate(1) = signrank(reward_rate(:,2), reward_rate(:,1), "Tail","left");
   
    
    % Theoretical curves assuming linear RTH
    n_tot = 50;
    beta_set = linspace(0.1,15,n_tot);
    optimal_sol.Q = Q;
    optimal_sol.p_state = p_state;
    [optimal_sol.R, optimal_sol.V, optimal_sol.Pa, optimal_sol.optimal_policy] = blahut_arimoto(p_state,Q,beta_set);
    R = optimal_sol.R; V=optimal_sol.V;

    % P(A|S) for Experiment 2
    P_a_given_s = zeros(n_subj,n_states,length(cond),n_actions); % subj, states, conds, actions
    for subj=1:n_subj
        for state=1:n_states
            s_idx = find(data(subj).s==state);
            subj_thisstateoccurrences = data(subj).s(s_idx);
            subj_actions_giventhisstate = data(subj).a(s_idx);
            for c = 1:length(cond)
                cond_idx = find(data(subj).cond(s_idx) == cond(c));
                states = subj_thisstateoccurrences(cond_idx);
                actions = subj_actions_giventhisstate(cond_idx);
                [N,~] = histcounts(actions,0.5:1:(n_actions+0.5));
                P_a_given_s(subj, state, c, :) = N./sum(N);
            end
        end
    end
    BehavioralStats.P_a_given_s = P_a_given_s;


    %% LME fitting

    % Flattening arrays
    complexity_flat = complexity(:); 
    response_time_flat = response_time(:);
    [complexity_sorted, complexity_sorted_idx] = sort(complexity_flat);
    response_time_sorted = response_time_flat(complexity_sorted_idx);
    LME.complexity_sorted = complexity_sorted;
    LME.response_time_sorted = response_time_sorted;
    LME.complexity_sorted_idx = complexity_sorted_idx;
    if(experiment~="exp3")
        subject_id = repmat(1:n_subj, 1, length(cond))';
    else
        subject_id = repmat(1:n_subj, 1, length(set_sizes))';
    end

    tbl = table(subject_id,complexity_flat,response_time_flat,'VariableNames',{'Subject','PolicyComplexity','RT'});
    lme = fitlme(tbl,'RT ~ PolicyComplexity + (1|Subject) + (PolicyComplexity-1|Subject)');
    LME.lme = lme;
    LME.tbl = tbl;

    % STD of random effects
    [~,~,stats] = randomEffects(lme,'Alpha',0.01);
    q = dataset2cell(stats(1:n_subj,4));
    w = dataset2cell(stats((n_subj+1):end,4));
    LME.random_effects_intercept_std = std(cell2mat(q(2:end)));
    LME.random_effects_complexity_std = std(cell2mat(w(2:end)));
    
    % RT_predictions vs. RT_true
    RT_lme = predict(lme); % Return 1SD, instead of 95% CI. 
    RT_lme_sorted = RT_lme(complexity_sorted_idx);
    LME.RT_lme = RT_lme;
    LME.RT_lme_sorted = RT_lme_sorted;

    % Counterfactual RT at different policy complexity levels
    complexity_rrmax = zeros(n_subj, length(cond));
    RT_lme_theoretical = zeros(n_subj, length(R));
    for subj=1:n_subj
        tbl_new = table(repmat(subj,1,length(R))',R,'VariableNames',{'Subject','PolicyComplexity'});
        rt_lme_theoretical = predict(lme, tbl_new);
        RT_lme_theoretical(subj,:)=rt_lme_theoretical;
        for c=1:length(cond)
            rr = V ./ (rt_lme_theoretical + cond(c)/1000 + feedback_duration);
            [max_rr, max_rr_complexity] = max(rr);
            complexity_rrmax(subj,c) = R(max_rr_complexity);
        end
    end
    LME.RT_lme_theoretical = RT_lme_theoretical;
    LME.complexity_rrmax = complexity_rrmax;
    rhos_subj = zeros(n_subj,1);



end