$(document).ready(function(){

  /* Save data to CSV */
function saveData(name, data) {
  var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
      filename: name,
      filedata: data
    }));
}

function downloadCSV(csv, filename) {
  // Retrive csv file from task
  var csvFile = new Blob( [csv], {type: "text/csv"});
  // Download link
  var downloadlink = document.createElement("a");
  // Download link download
  downloadlink.download = filename;
  downloadlink.href = window.URL.createObjectURL(csvFile);
  downloadlink.style.display = 'none';
  document.body.appendChild(downloadlink)
  downloadlink.click()
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

const multiplyArray = (arr, length) =>  Array.from({ length }, () => arr).flat()

  var timeline = [];
  var finish = false;

  /* Obtain consent */
  var consent_block = {
    type: 'external-html',
    url: "consent_exp4.html",
    cont_btn: "start",
    check_fn: check_consent
  };

  /* Practice */
  //var practice_block = create_practice();

  /* Full screen */
  var fullscreen = {
    type: 'fullscreen',
    fullscreen_mode: true
  }

timeline.push(consent_block);
timeline.push(fullscreen);

var num_conditions = 2;
var num_trials_perblock=[60,100,60,100]; // [80,100,80,100]
var iti_shared = 500; //1000;
var time_limit = 1000;

// Stimuli action pairing
var stimuli = [
  'img/frac1.png', 'img/frac2.png', 'img/frac3.png', 'img/frac4.png', 'img/frac5.png', 'img/frac6.png', 'img/frac7.png', 'img/frac8.png', 'img/frac9.png', 'img/frac10.png',
  'img/frac11.png', 'img/frac12.png', 'img/frac13.png', 'img/frac14.png', 'img/frac15.png', 'img/frac16.png', 'img/frac17.png', 'img/frac18.png', 'img/frac19.png', 'img/frac20.png',
  'img/frac21.png', 'img/frac22.png', 'img/frac23.png'
];
stimuli = jsPsych.randomization.repeat(stimuli,1,false);
// For Experiment 2: Make one action the optimal action for 2 states.
  function replaceRandomEntry(array) {
      // Step 1: Randomly select an index to replace
      const indexToReplace = Math.floor(Math.random() * array.length);
      // Step 2: Create a copy of the array and remove the element at the selected index
      const remainingValues = array.filter((_, index) => index !== indexToReplace);
      // Step 3: Randomly select a new value from the remaining values
      const newValueIndex = Math.floor(Math.random() * remainingValues.length);
      const newValue = remainingValues[newValueIndex];
      // Step 4: Replace the original value with the new value
      const newArray = [...array];
      newArray[indexToReplace] = newValue;
      return newArray;
  }
var actions = [49,50,51,52]; //[48,49,50,51,52,53,54,55,56,57];
var correct_actions = actions;
var dollars_per_rewardpoint = 0.005;
var reward_points_conds = jsPsych.randomization.repeat([[0.048,0.05],[0.048,5]],1,false); // Response correct, Safe choice, Response incorrect, no response.
// console.log(correct_actions)
var green = "#04b104";
var light_green = "#b5fbb5";
var gray = "#bcbcbc";
var red = "red";

// Period of 10. 
var stimuli_trials_task1 = [
  { stimuli_trials: stimuli[0], data_trials:{state: 1, test_part:'trials', correct_response:correct_actions[0]}},
  { stimuli_trials: stimuli[1], data_trials:{state: 2, test_part:'trials', correct_response:correct_actions[1]}},
  { stimuli_trials: stimuli[2], data_trials:{state: 3, test_part:'trials', correct_response:correct_actions[2]}},
  { stimuli_trials: stimuli[3], data_trials:{state: 4, test_part:'trials', correct_response:correct_actions[3]}},
];
stimuli_trials_task1 = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_task1,1,false),   1);

var stimuli_trials_task2 = [
    { stimuli_trials: stimuli[4], data_trials:{state: 1, test_part:'trials', correct_response:correct_actions[0]}},
    { stimuli_trials: stimuli[5], data_trials:{state: 2, test_part:'trials', correct_response:correct_actions[1]}},
    { stimuli_trials: stimuli[6], data_trials:{state: 3, test_part:'trials', correct_response:correct_actions[2]}},
    { stimuli_trials: stimuli[7], data_trials:{state: 4, test_part:'trials', correct_response:correct_actions[3]}},
  ];
stimuli_trials_task2 = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_task2,1,false),   1);
var stimuli_trials_task = [stimuli_trials_task1,stimuli_trials_task2];
var keys_html = '<b>"1","2","3","4"</b>'; //'<b>"1","2",...,"8","9","0"</b>'
var key_choices = ['1', '2', '3', '4']; //['1', '2', '3', '4', '5', '6', '7', '8','9','0']

// Let subjects check if their keyboard presses can be recorded.
function input_check(key_choice){
  var input_check_page = {
    type: 'html-keyboard-response',
    stimulus: '<p>To check if your keyboard presses can be successfully recorded, <br> please press the number key <b>"'+key_choice+'"</b> to proceed.</p> If you can\'t proceed, you won\'t be able to complete this study.',
    choices: [key_choice],  
  };
  return input_check_page
}
for (var i=0; i<key_choices.length; i++) {
  var input_check_page = input_check(key_choices[i])
  timeline.push(input_check_page)
}



// Instantiate variables
var num_blocks = 2;  // 3 train, 3 test
var totalPracticeBlocks = 1;
var pointsInTestBlocks = 0;
var total_reward = 0;

for (j=0; j<num_conditions; j++) {

    (function(cond) {   
        var cond_temp = cond;
        var reward_points = reward_points_conds[cond_temp];

        var stimuli_trials = stimuli_trials_task[cond_temp];
        if(reward_points[1]<1){
            var correct_color_name = "light green";
            var correct_color = light_green;
            var incorrect_color_name = "gray";
            var incorrect_color = gray;
            var correct_statement = 'For each image, pressing some number key(s) would <b>more likely</b> yield <b style="color:'+correct_color+'">+'+Number(reward_points[1]*dollars_per_rewardpoint*100)+'¢</b>.'
            var incorrect_statement = '<br>Pressing all other number key(s) would <b>more likely</b> yield <b style="color:'+incorrect_color+'">+'+Number(reward_points[0]*dollars_per_rewardpoint*100)+'¢</b>.'
            var incorrect_border = '<p> If your key press yielded <b style="color:'+incorrect_color+'">+'+Number(reward_points[0]*dollars_per_rewardpoint*100)+'¢</b>, a <b style="color:'+incorrect_color+'">'+incorrect_color_name+' border</b> will appear around the image, like this:</p>';

            var task2_correct_color = green;
        } else {
            var correct_color_name = "dark green";
            var correct_color = green;
            var incorrect_color_name = "gray";
            var incorrect_color = gray;
            var correct_statement = 'For each image, pressing some number key(s) would <b>more likely</b> yield <b style="color:'+correct_color+'">+'+Number(reward_points[1]*dollars_per_rewardpoint*100)+'¢</b>.'
            var incorrect_statement = '<br>Pressing all other number key(s) would <b>more likely</b> yield <b style="color:'+incorrect_color+'">+'+Number(reward_points[0]*dollars_per_rewardpoint*100)+'¢</b>.'
            var incorrect_border = '<p> If your key press yielded <b style="color:'+incorrect_color+'">+'+Number(reward_points[0]*dollars_per_rewardpoint*100)+'¢</b>, a <b style="color:'+incorrect_color+'">'+incorrect_color_name+' border</b> will appear around the image, like this:</p>';

            var task2_correct_color = light_green;
          }

        var k = 0;
        images_html = '<p>';
        while (k < actions.length) {
        images_html = images_html + ' <img src= '+stimuli_trials[k]['stimuli_trials']+' style="width:150px; height:150px;">';
        k++;
        }
        images_html += '</p>';

        if(cond_temp==0){
        var instructions_task = {
            type: 'instructions',
            pages: [
            // Welcome (page 1)
            '<p class="center-content"><b>Welcome to our study! </p>' +
            '<p class="center-content">In this study, you will earn <b style="color:'+green+'">$2</b> plus a bonus of <b style="color:'+green+'">$0-2</b> depending on your performance!</b></p>' +
            '<p class="center-content">This study should take you about <b>12 minutes</b> in total. </p>' +
            '<p class="center-content">Press "Next" to view the instructions.</p>',
            // Instructions (page 2)
            '<p> This study consists of <b>'+num_conditions+' short tasks</b>.</p>'+
            '<p> In <b>Task 1</b>, you will press number keys on your keyboard: '+keys_html+', for different images on the screen.</p>' +
            '<p> On each trial, you will see one image such as these:</p>' + images_html+
            '<p> For each image, pressing some number key(s) is <b>more likely</b> to reward you <b style="color:#32CD32">cents (¢)</b> (delivered as bonus pay) than others.</p>',

            '<p>'+correct_statement+incorrect_statement+
            '<br> <i>Note: the above numbers are <b>cents (¢)</b>, not dollars!</i>'+
            '<p> On each trial, the reward earned is always one of these two values above.' +
            '<p><i>(Task 2 will be similar to Task 1, except that different images are used, and the rewards given are different: '+
            '<b style="color:'+task2_correct_color+'">+'+Number(reward_points_conds[1-cond_temp][1]*dollars_per_rewardpoint*100)+'¢</b> and <b style="color:'+incorrect_color+'">+'+Number(reward_points_conds[1-cond_temp][0]*dollars_per_rewardpoint*100)+'¢</b> respectively.)</i></p>',

            //Instructions (page 6)
            '<p> If your key press yielded <b style="color:'+correct_color+'">+'+Number(reward_points[1]*dollars_per_rewardpoint*100)+'¢</b>, a <b style="color:'+correct_color+'">'+correct_color_name+' border</b> will appear around the image, like this: </p>' +
            '<p> <img src= '+stimuli[0]+' style="border:14px solid '+correct_color+'; width:150px; height:150px;"></p>'+
            incorrect_border+
            '<p> <img src= '+stimuli[0]+' style="border:14px solid '+incorrect_color+'; width:150px; height:150px;"> </p>',
        
            '<p> Your <b>goal</b> is to <b>get as much reward as possible.</b></p>'+
            '<p> The task contains <b>'+num_trials_perblock[1]+' trials.</b>'+
            '<br> Now that you know the total number of trials in this task, <br> please go back and reexamine <b>the bonus pay (in cents) you can get per trial!</b></p>'+
            '<p> You can spend at most <b style="color:red">'+Number(time_limit/1000)+' second</b> per trial. You must respond with a key press before then. <br> Otherwise, you lose <b style="color:red">-0.5¢</b>  for that trial.', 
            
            
            '<p>Your total bonus pay $$ for the entire study is <b style="color:'+green+'">the sum of the bonus pay earned across Tasks 1 and 2</b>, rounded to the nearest cent.'+
            '<br> Your base pay is always ensured, and the total bonus pay itself is always positive.'+
            '<p> Don\'t worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how much <b>reward</b> you earn.</p> '+
            '<p> However, there is one exception: if you fail to respond within <b style="color:red">'+Number(time_limit/1000)+' second</b> for more than <b>50 trials</b> in this task, <br> We will reject your submission based on insufficient engagement. <br> Hence, please try your best to <b>respond to every trial in time</b>, all the way until the end!',

            '<p style="color:black"> Click "Next" to go through a <b>practice block</b> with fewer trials. </p> <p>Practice blocks have no bearing on your bonus payment. Use them as a chance to develop your key-pressing strategy.</p>',
        
            ],
            show_clickable_nav: true,
            allow_backward: true,
            show_page_number: true
        };
        } else {
            var instructions_task = {
                type: 'instructions',
                pages: [
                '<p> Congratulations, you have completed <b>Task '+(cond_temp)+' out of '+num_conditions+'</b>!</p> <p>You will now start <b>Task '+ (cond_temp+1)+'</b>.</p>'+
                '<p> In <b>Task '+(cond_temp+1)+'</b>, you will press numbers on your keyboard: '+keys_html+', for a new set of different images on the screen.</p>' +
                '<p> On each trial, you will see one of the following images:</p>' +
                images_html+
                '<p> For each image, pressing some number key(s) is <b>more likely</b> to reward you <b style="color:#32CD32">cents (¢)</b> (delivered as bonus pay) than others.</p>',

                '<p> Unlike Task 1, in <b>Task 2</b>: '+correct_statement+incorrect_statement+
                '<br> <i>Note: the above numbers are <b>cents (¢)</b>, not dollars!</i>'+
                '<p> On each trial, the reward yielded is always one of these two values above.',

                //Instructions (page 6)
                '<p> If your key press yielded <b style="color:'+correct_color+'">+'+Number(reward_points[1]*dollars_per_rewardpoint*100)+'¢</b>, a <b style="color:'+correct_color+'">'+correct_color_name+' border</b> will appear around the image, like this: </p>' +
                '<p> <img src= '+stimuli[4]+' style="border:14px solid '+correct_color+'; width:150px; height:150px;"></p>'+
                incorrect_border+
                '<p> <img src= '+stimuli[4]+' style="border:14px solid '+incorrect_color+'; width:150px; height:150px;"> </p>',
    
                '<p> Everything else from <b>Task '+(cond_temp)+'</b> carries over to <b>Task '+(cond_temp+1)+'</b>: </p>'+
                '<p> Your <b>goal</b> is to <b>get as much reward as possible.</b></p>'+
                '<p> The task contains <b>'+num_trials_perblock[num_blocks+1]+' trials.</b>'+
                '<br> Now that you know the total number of trials in this task, <br> please go back and reexamine <b>the bonus pay (in cents) you can get per trial!</b></p>',
                '<p> You can spend at most <b style="color:red">'+Number(time_limit/1000)+' second</b> per trial. You must respond with a key press before then. <br> Otherwise, you lose <b style="color:red">-0.5¢</b> for that trial.', 
            
                '<p>Your total bonus pay $$ for the entire study is <b style="color:'+green+'">the sum of the bonus cents earned across Tasks 1 and 2</b>, rounded to the nearest cent.'+
                '<p> Don\'t worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how much <b>reward</b> you earn.</p> '+
                '<p> However, there is one exception: if you fail to respond within <b style="color:red">'+Number(time_limit/1000)+' second</b> for more than 50 trials in this task, <br> We will reject your submission based on insufficient engagement. <br> Hence, please try your best to <b>respond to every trial in time</b>, all the way until the end!'+    
                 '<p style="color:black"> Click "Next" to go through a <b>practice block</b> with fewer trials. Practice blocks have no bearing on your bonus payment.</p>',
                ],
                show_clickable_nav: true,
                allow_backward: true,
                show_page_number: true
            };

        }
        
        console.log('instructions loaded')
        timeline.push(instructions_task);


        // TRIALS BLOCK // 
        function timerDisplay() {
          if(pointsInBlock>=0){
            return '<p style="position:fixed; top:27%; left:43.5%"> Bonus so far: <b style="color:'+green+'">+'+Math.round(100000*pointsInBlock)/1000+'¢</b></p>'
          } else {
            return '<p style="position:fixed; top:27%; left:43.5%"> Bonus so far: <b style="color:'+red+'">-'+Number(-Math.round(100000*pointsInBlock)/1000)+'¢</b></p>'
          }        
        }

        var currentBlock = 0;

        for (i = 0; i < num_blocks; i++) {
            var pointsInBlock = 0;
            var total_rt = 0;
            var num_trials = num_trials_perblock[currentBlock+cond*num_blocks];
            var stimuli_trials_block = jsPsych.randomization.repeat(stimuli_trials,Math.ceil(num_trials/stimuli_trials.length),false);
            currentBlock++;

            // Immediately-Invoked Function Expression (IIFE)
            (function(blockNumber, stimuliTrialsBlock, cond, num_trials_temp) {
            var cond_temp = cond;

            var start_block = {
                type: 'html-button-response',
                stimulus: function() {
                if (blockNumber>totalPracticeBlocks) {
                    return ['<p class="center-content">In this <b>proper experiment</b>,</p> <p>you will complete <b>'+num_trials_temp+'</b> trials.</p>'];
                } else {
                    return ['<p class="center-content">In this <b>practice block</b>,</p> <p>you will complete <b>'+num_trials_temp+'</b> trials.</p>'];
                }
                },
                choices: ['Next'],
                on_start: function() {
                },
                on_finish: function() {
                    pointsInBlock = 0;
                    blockStartTime = Date.now(); // Start timing the block
                },
            };

            timeline.push(start_block);

            var trial = {
                type: 'image-keyboard-response',
                stimulus: jsPsych.timelineVariable('stimuli_trials'),
                timeline_variables: stimuli_trials,
                choices: key_choices,
                trial_duration: time_limit,
                data: jsPsych.timelineVariable('data_trials'),
                prompt: function() { return timerDisplay(); },
                on_load: function(){
                //updateRewardDisplay();
                },
                on_finish: function(data) {
                    //updateProgressBar();
                    trial_node_id = jsPsych.currentTimelineNodeID();
                    data.correct = Number(data.key_press == data.correct_response);
                    var reward_random = Math.random();
                    if(data.correct==1){ // high prob of receiving reward
                      if(reward_random<0.8){
                        data.rewarded = reward_points[1]
                      } else{
                        data.rewarded = reward_points[0]
                      }
                    } else if (data.key_press.length==0) { // did not respond in time
                        data.correct = 0
                        data.rewarded = - 0.005/dollars_per_rewardpoint;
                    } else { // no reward
                      data.rewarded = reward_points[0]
                      // if(reward_random<0.8){ // low prob of receiving reward
                      //   data.rewarded = reward_points[0]
                      // } else{
                      //   data.rewarded = reward_points[1]
                      // }
                    }

                    // if(Number(data.key_press == data.correct_response)){
                    // data.correct = 1;
                    // data.rewarded = reward_points[1]*data.correct * (Math.random()<0.75) + (!data.correct) * (Math.random()<0.25); // stochastic rewards
                    // //data.rewarded = reward_points[1];
                    // } else {
                    // data.correct = 0;
                    // data.rewarded = reward_points[1]*data.correct * (Math.random()<0.75) + (!data.correct) * (Math.random()<0.25); // stochastic rewards
                    // //data.rewarded = reward_points[0];
                    // }
                    rt = data.rt;
                    total_rt = +total_rt + +rt;
                    pointsInBlock = pointsInBlock + (data.rewarded*dollars_per_rewardpoint);
                    console.log(data.key_press)
                    console.log(data.rewarded)
                }
            };

            var feedback = {
                type: 'html-keyboard-response',
                stimulus: function(){
                var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                var feedback_img = prev_trial.select('stimulus').values[0];
                var feedback = prev_trial.select('key_press').values[0];
                //console.log(prev_trial.select('rewarded').values[0])
                if (prev_trial.select('rewarded').values[0]==reward_points[1]){
                    return  '<img src="' + feedback_img + '" style="border:14px solid '+correct_color+';">';
                } else if(prev_trial.select('key_press').values[0].length==0){
                    return '<img src="' + feedback_img + '" style="border:14px solid '+red+';">';
                }else {
                    return '<img src="' + feedback_img + '" style="border:14px solid '+incorrect_color+';">';
                } 
                },
                trial_duration: 500,
                prompt: function() { return timerDisplay(); },
                choices: jsPsych.NO_KEYS,
                on_load: function() {
                //updateRewardDisplay();
                },
                on_finish: function(data){
                total_rt = +total_rt + +500;
                }
            };

            var fixation = {
                type: 'html-keyboard-response',
                stimulus: function(){
                    var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                    var prev_trial_reward_cents = prev_trial.select('rewarded').values[0]*dollars_per_rewardpoint * 100;
                    if(prev_trial_reward_cents>=0){
                        return '<p style="font-size:40px;"> <b style="color:'+green+'">+'+Math.round(1000*prev_trial_reward_cents)/1000+'¢</b></p>'
                      } else {
                        return '<p style="font-size:40px;"> <b style="color:'+red+'">-'+Number(-Math.round(1000*prev_trial_reward_cents)/1000)+'¢</b></p>'
                      }  
                },
                prompt: function() {
                var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                if(prev_trial.select('key_press').values[0].length>0){
                    return timerDisplay();
                } else {
                    return timerDisplay() + '<p><b style="color:red; font-size:30px;"> Too slow! </b></p>'
                }
                },
                choices: jsPsych.NO_KEYS,
                trial_duration: function(){
                  var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                  var prev_trial_rt = prev_trial.select('rt').values[0];
                  if(prev_trial_rt.length==0){ // Subject failed to respond in time
                    return iti_shared;
                  } else { // Make up to make each trial last (time_limit + 500 + iti_shared) ms
                    return iti_shared + time_limit-prev_trial_rt;
                  }
                },
                data: function(){
                  var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                  var prev_trial_rt = prev_trial.select('rt').values[0];
                  if(prev_trial_rt.length==0){ // Subject failed to respond in time
                    var fixation_time = iti_shared;
                  } else { // Make up to make each trial last (time_limit + 500 + iti_shared) ms
                    var fixation_time = iti_shared + time_limit-prev_trial_rt;
                  }
                  return {trial_iti: fixation_time, is_practice: Number(blockNumber<=totalPracticeBlocks)}
                },
                on_load: function() {
                //updateRewardDisplay();
                },
                on_finish: function(data){
                total_rt = +total_rt + +jsPsych.data.get().last(1).select('trial_iti').values;
                data.total_rt = total_rt;
                data.block = blockNumber + cond_temp*num_blocks;
                data.correct_actions = correct_actions;
                data.reward_correct = Number(reward_points[1]);

                var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
                if(blockNumber>totalPracticeBlocks){ // count bonus reward in dollars in test blocks
                  total_reward = total_reward + prev_trial.select('rewarded').values[0]*dollars_per_rewardpoint;             
                }
                data.total_reward = Number(total_reward);
                //updateProgressBar();

                var prev_trial_rt = prev_trial.select('rt').values[0];
                console.log("RT: "+prev_trial_rt)
                }
            }

            var block = {
                timeline: [trial, feedback, fixation],
                timeline_variables: stimuliTrialsBlock,
                randomize_order: true,
                loop_function: function(data){
                return false;

                }
            };


        var end_block = {
            type: 'html-button-response',
            stimulus: function(){
            if(blockNumber==totalPracticeBlocks){
              if(pointsInBlock>=0){
                return ['<p class="center-content">You have completed the practice block!</p>' 
                  + '<p> If this were the actual experiment, your bonus gained for the block was <b style="color:#32CD32">+' + Math.round(1000*pointsInBlock)/10 + '¢</b>.' 
                  + '<p> &nbsp; </p>'
                  + '<p class="center-content"> You will now proceed to the <b>proper experiment</b>, where your key presses determine your bonus payment.</p>' 
                  + '<p class="center-content">  Click "Next" to begin the experiment.</p>']
              } else {
                return ['<p class="center-content">You have completed the practice block!</p>' 
                  + '<p> If this were the actual experiment, your bonus gained for the block was <b style="color:red">-' + Math.round(-1000*pointsInBlock)/10 + '¢</b>.' 
                  + '<p> &nbsp; </p>'
                  + '<p class="center-content"> You will now proceed to the <b>proper experiment</b>, where your key presses determine your bonus payment.</p>' 
                  + '<p class="center-content">  Click "Next" to begin the experiment.</p>']
              }
            } else {
              if(pointsInBlock>=0){
                return ['<p class="center-content">You have completed a block!</p> <p> Your bonus gained for the block was <b  style="color:#32CD32">+' + Math.round(1000*pointsInBlock)/10 + '¢</b>.</p><p>This amount will be added to your final bonus pay.</p>']
              } else {
                return ['<p class="center-content">You have completed a block!</p> <p> Your bonus gained for the block was <b  style="color:red">-' + Math.round(-1000*pointsInBlock)/10 + '¢</b>.</p><p>This amount will be added to your final bonus pay.</p>']
              }
            }
            },
            choices: ["Next"],
        };

        timeline.push(block);
        timeline.push(end_block);

        })(i+1, stimuli_trials_block, cond_temp, num_trials);
        } // Loop through practice and proper blocks

    })(j)// loop through Tasks
}


// Define redirect link for Qualtrics and add Turk variables
var turkInfo = jsPsych.turk.turkInfo();

// Add MTurk info to CSV
jsPsych.data.addProperties({
  assignmentID: turkInfo.assignmentId
});
jsPsych.data.addProperties({
  mturkID: turkInfo.workerId
});
jsPsych.data.addProperties({
  hitID: turkInfo.hitId
});


// End of all blocks //
var end_all_blocks = {
  type: 'html-button-response',
  stimulus: '<p class="center-content"> <b>And...that was the last block!</b></p>' +
  '<p class="center-content"> On the next pages, we will ask some demographic questions and save your data. Then the study is complete!</p>',

      // '<p class="center-content"> On the next page, we will ask you some demographic questions.</p>' +
      // '<p class="center-content"> Then we will ask for your strategy and feedback, before saving your data!</p>',
      choices: ['Next'],
};

var demographics = {
  timeline: [demographic_age, demographic_gender],
  repetitions: 1
};

var survey_strategy = {
  type: "survey-text",
  questions: [{prompt: 'What is your strategy across different tasks?', value: 'Strategy', rows: 10, required: true}],
};

var survey_feedback = {
  type: "survey-text",
  questions: [{prompt: 'Please let us know if you have any feedback for our experiment.', value: 'Feedback', rows: 10, required: false}],
};

// Save data //
var save_data = {
  type: "survey-text",
  questions: [{prompt: 'Please input your MTurk Worker ID so that we can pay you the appropriate bonus. Your ID will not be shared with anyone outside of our research team. Your data will now be saved.', value: 'Worker ID'}],
  on_finish: function(data) {
  var responses = JSON.parse(data.responses);
  var subject_id = responses.Q0;
  console.log(subject_id)
  //saveData("test_save.csv", jsPsych.data.get().csv());
  saveData(turkInfo.workerId, jsPsych.data.get().csv());
  },
};

// End of experiment //
var end_experiment = {
  type: 'instructions',
  pages: [
    '<p class="center-content"> <b>Thank you for participating in our study!</b></p>' +
    '<p class="center-content"> <b>Please wait on this page for 1 minute while your data saves.</b></p>'+
    '<p class="center-content"> Your bonus will be applied after your data (including the survey) has been processed and your HIT has been approved. </p>'+
    '<p class="center-content"> <b style="color:red">YOU MUST DO THE SURVEY TO BE PAID.</b></p>'+
    '<p class="center-content"> Please email shuzeliu@g.harvard.edu with any additional questions or concerns. Please click "Next"...You will be redirected to the survey!</p>'
    ],
  show_clickable_nav: true,
  allow_backward: false,
  show_page_number: false,
  on_finish: function(data) {
    window.location.href = "https://harvard.az1.qualtrics.com/jfe/form/SV_1FH00f53vMlHn3o?&workerId=" + turkInfo.workerId + "&assignmentId=" + turkInfo.assignmentId + "&hitId=" + turkInfo.hitId;
  },
};


timeline.push(end_all_blocks)
timeline.push(demographics)
timeline.push(survey_strategy)
timeline.push(survey_feedback)
timeline.push(save_data);
timeline.push(end_experiment);


function startExperiment(){
  jsPsych.init({
    timeline: timeline,
    //show_progress_bar: true,
    auto_update_progress_bar: false,
  })
};


jsPsych.pluginAPI.preloadImages(stimuli, function () {startExperiment();});
console.log("Images preloaded.");

})
