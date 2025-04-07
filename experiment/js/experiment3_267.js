$(document).ready(function(){// ITI policy complexity

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

  var timeline = [];
  var finish = false;

/* Obtain consent */
var check_consent = function(elem) {
	if ($('#consent_checkbox').is(':checked')) { return true; }
	else {
		alert("If you wish to participate, you must check the box.");
		return false;
	}
	return false;
};

var consent_block = {
    type: 'external-html',
    url: "consent_exp3.html",
    cont_btn: "start",
    check_fn: check_consent
  };

  /* Full screen */
  var fullscreen = {
    type: 'fullscreen',
    fullscreen_mode: true
  }
timeline.push(consent_block);
timeline.push(fullscreen);


// Period of 8. 
var stimuli = [
  'img/frac1.png', 'img/frac2.png', 'img/frac3.png', 'img/frac4.png', 'img/frac5.png', 'img/frac6.png', 'img/frac7.png', 'img/frac8.png', 'img/frac9.png', 'img/frac10.png',
  'img/frac11.png', 'img/frac12.png', 'img/frac13.png', 'img/frac14.png', 'img/frac15.png', 'img/frac16.png', 'img/frac17.png', 'img/frac18.png', 'img/frac19.png', 'img/frac20.png',
  'img/frac21.png',
];
var stimuli_trials_two_raw = [
  { stimuli_trials: 'img/frac19.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
  { stimuli_trials: 'img/frac20.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
  ];
var stimuli_trials_five_raw = [
  { stimuli_trials: 'img/frac1.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
  { stimuli_trials: 'img/frac2.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
  { stimuli_trials: 'img/frac3.png', data_trials:{state: 3, test_part:'trials', correct_response:51}},
  { stimuli_trials: 'img/frac4.png', data_trials:{state: 4, test_part:'trials', correct_response:52}},
  { stimuli_trials: 'img/frac5.png', data_trials:{state: 5, test_part:'trials', correct_response:53}},
  ];
var stimuli_trials_six_raw = [
  { stimuli_trials: 'img/frac6.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
  { stimuli_trials: 'img/frac7.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
  { stimuli_trials: 'img/frac8.png', data_trials:{state: 3, test_part:'trials', correct_response:51}},
  { stimuli_trials: 'img/frac9.png', data_trials:{state: 4, test_part:'trials', correct_response:52}},
  { stimuli_trials: 'img/frac10.png', data_trials:{state: 5, test_part:'trials', correct_response:53}},
  { stimuli_trials: 'img/frac11.png', data_trials:{state: 6, test_part:'trials', correct_response:54}},
  ];
var stimuli_trials_seven_raw = [
  { stimuli_trials: 'img/frac12.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
  { stimuli_trials: 'img/frac13.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
  { stimuli_trials: 'img/frac14.png', data_trials:{state: 3, test_part:'trials', correct_response:51}},
  { stimuli_trials: 'img/frac15.png', data_trials:{state: 4, test_part:'trials', correct_response:52}},
  { stimuli_trials: 'img/frac16.png', data_trials:{state: 5, test_part:'trials', correct_response:53}},
  { stimuli_trials: 'img/frac17.png', data_trials:{state: 6, test_part:'trials', correct_response:54}},
  { stimuli_trials: 'img/frac18.png', data_trials:{state: 7, test_part:'trials', correct_response:55}},
  ];
// Randomly generate subsets of stimuli for each set size: 3,4,5,6,7. 
const multiplyArray = (arr, length) =>  Array.from({ length }, () => arr).flat()
var stimuli_trials_two = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_two_raw,1,false),   4);
var stimuli_trials_five = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_five_raw,1,false),   2);
var stimuli_trials_six = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_six_raw,1,false), 2)
var stimuli_trials_seven = multiplyArray(jsPsych.randomization.repeat(stimuli_trials_seven_raw,1,false), 2)
var stimuli_trials_agg = {'2': stimuli_trials_two, '5': stimuli_trials_five, '6': stimuli_trials_six, '7': stimuli_trials_seven, };

var superblock_order = jsPsych.randomization.repeat([2,6,7],1,false);
console.log(superblock_order)

// Instantiate variables
  var num_superblocks = superblock_order.length;
  var block_durations = multiplyArray([60,60,60,3*60], num_superblocks).map(function(element) {return element * 1000;});
  //var block_durations = multiplyArray([3,3,3,6], num_superblocks).map(function(element) {return element * 1000;}); // debug
  var isPracticeBlock = multiplyArray([true, true, true, false], num_superblocks);
  var iti = multiplyArray([0,500,2000,2000], num_superblocks);
  //var iti = multiplyArray([0,0,0,0], num_superblocks);
  console.log(block_durations)
  console.log(iti)
  console.log(isPracticeBlock)

// TRIALS BLOCK // 
  var currentBlock;
  var pointsInBlock;
  var timeLeftInBlock;
  var stimuli_trials;
  var images_html;
  var absolute_block_idx =-1;


  for (j=0; j<num_superblocks; j++) {
    // Immediately-Invoked Function Expression (IIFE)
    (function(superblock_temp,j_temp) {

      function timerDisplay() {
        var div_html = '<div id="timer" style="position: fixed; bottom: 5%; right: 40%; width: 20px; height: 100%; background-color: #E33434; border: 2px solid red;"></div>';
        div_html += '<div id="reward-bar" style="position: fixed; bottom: 5%; right: 35%; width: 20px; background-color: #4CAF50; border: 2px solid green;"></div>'; // Reward bar
        return div_html
      }
    
        currentBlock = 0;

        currentblock_setsize = superblock_temp[j_temp];
        num_blocks_thistask = 4;

        stimuli_trials = stimuli_trials_agg[currentblock_setsize];
        if(superblock_temp[j_temp]==5){
          key_choices = ['1', '2', '3', '4', '5'];
          keys_html = '<b>"1","2","3","4", or "5",</b>';
          keys_html_trial = '<p style="position: fixed; top: 25%; left: 43%;"><b>Allowable keys: 1-5</b></p>';
        } else if (superblock_temp[j_temp]==6){
            key_choices = ['1', '2', '3', '4', '5', '6'];
            keys_html = '<b>"1","2","3","4","5", or "6",</b>';
            keys_html_trial = '<p style="position: fixed; top: 25%; left: 43%;"><b>Allowable keys: 1-6</b></p>';
        } else if (superblock_temp[j_temp]==7){
          key_choices = ['1', '2', '3', '4', '5', '6', '7'];
          keys_html = '<b>"1","2","3","4","5","6", or "7",</b>';
          keys_html_trial = '<p style="position: fixed; top: 25%; left: 43%;"><b>Allowable keys: 1-7</b></p>';
        } else if (superblock_temp[j_temp]==2){
          key_choices = ['1', '2'];
          keys_html = '<b>"1" or "2",</b>';
          keys_html_trial = '<p style="position: fixed; top: 25%; left: 43%;"><b>Allowable keys: 1-2</b></p>';
        }

        var k = 0;
        images_html = '<p>';
        while (k < currentblock_setsize) {
          images_html = images_html + ' <img src= '+stimuli_trials[k]['stimuli_trials']+' style="width:150px; height:150px;">';
          k++;
        }
        images_html += '</p>';

        if(j_temp==0){
          var instructions_superblock = {
              type: 'instructions',
              pages: [
              // Welcome (page 1)
              '<p class="center-content"><b>Welcome to our study! </p>' +
              '<p class="center-content">In this study, you will earn <b style="color:#32CD32">$5</b> plus a bonus of <b style="color:#32CD32">$1-2</b> depending on your performance!</b></p>' +
              '<p class="center-content">The whole study should take you about <b>30 minutes</b> in total, which includes a short survey at the end of the experiment. </p>' +
              '<p class="center-content">Press "Next" to view the instructions.</p>',
              // Instructions (page 2)
              '<p> This study consists of <b>'+num_superblocks+' short tasks</b>.</p>'+
              '<p> In <b>Task 1</b>, you will press numbers on your keyboard: '+keys_html+' for different images on the screen.</p>' +
              '<p> On each trial, you will see one image such as these:</p>' +
              images_html+
              '<p> For each image, pressing some number keys is <b>more likely</b> to give you <b style="color:#32CD32">reward</b> than others.</p>' +
              '<p><i>(In <b>Task 2 and 3</b>, which you will complete after <b>Task 1</b>, there will be new sets of images to learn)</i></p>',
              //Instructions (page 6)
              '<p> If your key press yielded <b style="color:#32CD32">1 reward point</b>, a <b style="color:#32CD32">green border</b> will appear around the image, like this: </p>' +
              '<p> <img src= img/frac1.png style="border:14px solid green; width:150px; height:150px;"></p>'+
              '<p> If your key press did not yield reward points, a <b style="color:#bcbcbc">gray border</b> will appear around the image, like this:</p>'+
              '<p> <img src= img/frac1.png style="border:14px solid #bcbcbc; width:150px; height:150px;"> </p>',
          
              '<p> Your <b>goal</b> in each task is to <b>get as many reward points as possible.</b></p>'+
              '<p> Again, for each <b style="color:#32CD32">green border</b>, you will be rewarded <b style="color:#32CD32">1 point</b>. For each <b style="color:#bcbcbc">gray border</b>, you will not receive or lose reward points.'+
              '<p> &nbsp; </p>'+
              '<p> Each task contains one block, lasting <b>3 minutes</b>.' + 
              '<p> Once you respond to a trial, the next trial will show up with some unavoidable <b style="color:red">time delay</b>. </p>'+
              '<p> <b>As long as there is time left in the block, more trials will show up.</b></p>' + 
              '<p>Your bonus pay $$ will depend on the reward points you get in each block, relative to the maximum possible for that block.</p>',
          
              '<p> <img src= img/display.png style="float: right; height:400px;"> </p>'+
              '<p> The right figure shows the typical display of a trial.</p>'+
              '<p> There is the <b>image</b>, the <b style="color:red">time left</b> in this block, and <b style="color:#32CD32">reward gained</b> in this block.</p>'+
              '<p> The <b style="color:#32CD32">reward gained</b> bar height is scaled to the <b style="color:green">maximum reward possible</b> for this block, to give you motivation!</p>'+
              '<p> You can use them to keep track of how well you are doing.</b>',
             
              '<p> Now let us talk more about intertrial <b style="color:red">time delay</b>, which differs across blocks.</p>'+
              '<p> The time delay of a block can be either <b>0s, 0.5s, or 2s</b>. We will tell you before starting each block.</p>'+
              '<p> In each 3-minute block, <b style="color:red">the faster you are, the more trials you can complete.</b></p>'+
              '<p> However, <b style="color:red"> the longer the time delay, the fewer trials you can complete in 3 minutes.</b></p>'+
              '<p> Therefore, think about how to get as many <b style="color:#32CD32">green borders/rewards</b> as possible!</p>'+
              '<p> &nbsp; </p>' +
              "<p> In other words, <b style='color:red'>sometimes it can make sense to complete as many trials as possible, even if you do not get every border green.</b></p><p> Don't worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how much <b>reward</b> you earn.</p>",

              '<p style="color:black"> Click "Next" to go through 3 <b>practice blocks</b> with different <b style="color:red">time delays</b>, but with shorter block durations.</p>' +
              '<p>Use them as a chance to learn which number keys are more likely to give reward for each image, as well as <b>how fast you want to be</b>.</p>' + 
              '<p> &nbsp; </p>' +
              '<p><i>The relationship between number keys and rewards for each image will <b>stay the same</b> within each task.</i></p>'+
              '<p>Practice blocks have no bearing on your bonus payment.</p>',
              ],
              show_clickable_nav: true,
              allow_backward: true,
              show_page_number: true
          };
          timeline.push(instructions_superblock)

      } else{
          var instructions_superblock = {
              type: 'instructions',
              pages: [
              '<p> Congratulations, you have completed <b>Task '+(j_temp)+' out of '+num_superblocks+'</b>!</p> <p>You will now start <b>Task '+ (j_temp+1)+'</b>.</p>'+
              '<p> In <b>Task '+(j_temp+1)+'</b>, you will press numbers on your keyboard: '+keys_html+' for a new set of different images on the screen.</p>' +
              '<p> On each trial, you will see one image such as these:</p>' +
              images_html+
              '<p> For each image, pressing some number keys would <b>more likely</b> give you <b style="color:#32CD32">rewards</b> than others.</p>',
              //Instructions (page 6)

              '<p> Everything else from <b>Task '+(j_temp)+'</b> carries over to <b>Task '+(j_temp+1)+'</b>: </p>'+
              '<p> Your <b>goal</b> is to <b>get as many reward points as possible.</b></p>'+
              '<p> For each <b style="color:#32CD32">green border</b>, you will be rewarded <b style="color:#32CD32">1 point</b>. For each <b style="color:#bcbcbc">gray border</b>, you will not receive or lose reward points.'+
              '<p> &nbsp; </p>'+
              '<p> The task has <b>1 block</b>, lasting <b>3 minutes</b>.' + 
              '<p style="color:black"> Click "Next" to go through 3 <b>practice blocks</b> with different <b style="color:red">time delays</b>, but with shorter block durations.</p>'+
              '<p>Use them as a chance to learn which number keys are more likely to give reward for each image, as well as <b>how fast you want to be</b>.</p>'+
              '<p>Practice blocks have no bearing on your bonus payment.</p>',
              ],
              show_clickable_nav: true,
              allow_backward: true,
              show_page_number: true
          };
        timeline.push(instructions_superblock)
      }


    for (i = 0; i < num_blocks_thistask; i++) {
        // Immediately-Invoked Function Expression (IIFE)
        (function(superblock_temp,j_temp) {
          var current_setsize = currentblock_setsize;
          
          currentBlock++;
          absolute_block_idx++;
          var absolute_block_idx_sub = absolute_block_idx+1;
          var total_rt = 0;
          var interval = iti[absolute_block_idx];
          var is_practice_block = isPracticeBlock[absolute_block_idx];
          var next_is_practice_block = isPracticeBlock[Math.min(absolute_block_idx+1, isPracticeBlock.length-1)];
          if((current_setsize==7) && is_practice_block) {
            var block_duration = block_durations[absolute_block_idx]+15*1000; // add 15s to training blocks for set size 7
          } else {
            var block_duration = block_durations[absolute_block_idx]
          }
          var blockDurationSeconds = Math.round(block_duration/1000); // Block duration in seconds

                // Function to update the reward display on the screen
                function updateRewardDisplay() {
                    var max_rewards_block
                    if(interval==0) {
                    max_rewards_block = blockDurationSeconds*(2*1.5);
                    } else if (interval==500) {
                    max_rewards_block = blockDurationSeconds*(1*2);
                    } else {
                    max_rewards_block = blockDurationSeconds*(0.3*2);
                    }
                    //var barscale = 5/4;
                    var rewardElement = document.getElementById('reward-bar');
                    if (rewardElement) {
                        var heightPercent = Math.min(1, Math.max(0, pointsInBlock/max_rewards_block)) * 90; // Ensure height is between 0% and 100%
                        rewardElement.style.height = heightPercent + '%';
                    }
                }

                // Function to start the block timer
                function startBlockTimer() {
                    timeLeftInBlock = blockDurationSeconds;
                    var timerInterval = setInterval(function() {
                        timeLeftInBlock--;
                        updateTimerDisplay();
                        updateRewardDisplay();
                        if (timeLeftInBlock <= 0) {
                            clearInterval(timerInterval); // Stop the timer
                        }
                    }, 1000); // Update every second
                }
        
                // Function to update the timer display on the screen
                function updateTimerDisplay() {
                    // Assuming you have an element with ID 'timer' to display the countdown
                    var timerElement = document.getElementById('timer');
                    if (timerElement) {
                        var heightPercent = 100 * (timeLeftInBlock / blockDurationSeconds) * 0.9;
                        timerElement.style.height = heightPercent + '%';
                    }
                }
        
        var start_block = {
            type: 'html-button-response',
            stimulus: function() {
            if (!is_practice_block) {
                return ['<p class="center-content">In the <b>proper block</b>, after you respond to a trial: </p>There will be a time delay of <b style="color:#FF0000">' + (Math.round(interval / 100) / 10).toString() + ' sec</b> before the next trial shows up.</p>'];
            } else {
                return ['<p class="center-content">In this <b>practice block</b>, after you respond to a trial: </p>There will be a time delay of <b style="color:#FF0000">' + (Math.round(interval / 100) / 10).toString() + ' sec</b> before the next trial shows up.</p>'];
            }
            },
            choices: ['Next'],
            on_start: function() {
            },
            on_finish: function() {
                pointsInBlock = 0;
                blockStartTime = Date.now(); // Start timing the block
                // Start the next block
                startBlockTimer();
            },
        };

        timeline.push(start_block);

        var trial = {
            type: 'image-keyboard-response',
            stimulus: jsPsych.timelineVariable('stimuli_trials'),
            timeline_variables: stimuli_trials,
            choices: key_choices,
            data: jsPsych.timelineVariable('data_trials'),
            prompt: timerDisplay()+keys_html_trial,
            on_load: function(){
            updateTimerDisplay();
            updateRewardDisplay();
            },
            on_finish: function(data) {
                trial_node_id = jsPsych.currentTimelineNodeID();
                data.correct = data.key_press == data.correct_response;
                data.rewarded = data.correct * (Math.random()<0.75) + (!data.correct) * (Math.random()<0.25); // stochastic rewards
                rt = data.rt;
                total_rt = +total_rt + +rt;
                pointsInBlock = pointsInBlock + data.rewarded;
            }
        };

        var feedback = {
            type: 'html-keyboard-response',
            stimulus: function(){
            var prev_trial = jsPsych.data.getDataByTimelineNode(trial_node_id);
            var feedback_img = prev_trial.select('stimulus').values[0];
            var feedback = prev_trial.select('key_press').values[0];
            if (prev_trial.select('rewarded').values[0]){
                return  '<img src="' + feedback_img + '" style="border:14px solid green;">';
            }else{
                return '<img src="' + feedback_img + '" style="border:14px solid #bcbcbc;">';
            }
            },
            trial_duration: 300,
            prompt: timerDisplay()+keys_html_trial,
            choices: jsPsych.NO_KEYS,
            on_load: function() {
            updateTimerDisplay();
            updateRewardDisplay();
            },
            on_finish: function(data){
            total_rt = +total_rt + +300;
            }
        };

        var fixation = {
            type: 'html-keyboard-response',
            stimulus: '<div style="font-size:60px;">+</div>',
            prompt: timerDisplay()+keys_html_trial,
            choices: jsPsych.NO_KEYS,
            trial_duration: interval,
            data: {trial_duration: interval},
            on_load: function() {
            updateTimerDisplay();
            updateRewardDisplay();
            },
            on_finish: function(data){
            total_rt = +total_rt + +jsPsych.data.get().last(1).select('trial_duration').values;
            data.total_rt = total_rt;
            data.block = absolute_block_idx_sub;
            data.setsize = current_setsize;
            data.is_practice_block = is_practice_block;
            }
        }
        var block = {
            timeline: [trial, feedback, fixation],
            timeline_variables: stimuli_trials,
            randomize_order: true,
            loop_function: function(data){
            if(jsPsych.data.get().last(1).select('total_rt').values<block_duration){
                console.log(jsPsych.data.get().last(1).select('total_rt').values)
                return true;
            } else {
                console.log(jsPsych.data.get().last(1).select('total_rt').values)
                total_rt = +total_rt - +jsPsych.data.get().last(1).select('total_rt').values;
                return false;
            }
            }
        };

        var end_block = {
            type: 'html-button-response',
            stimulus: function(){
            if(is_practice_block){
              if(next_is_practice_block) {
                return ['<p class="center-content">You have completed a practice block!</p> <p> Your reward points gained for the block was <b style="color:#32CD32">' + pointsInBlock + ' points</b>.</p> <p> &nbsp; </p> <p>Take a break if you would like and then press "Next" to continue to the next block.</p>'+
                '<p><i><b>Reminder: </b> the relationship between number keys and rewards for each image will stay the same throughout the task.</i></p>',]
              } else {
                return ['<p class="center-content">You have completed the practice block!</p>' 
                + '<p> Your reward points gained for the block was <b  style="color:#32CD32">' + pointsInBlock + ' points</b>.' 
                + '<p> &nbsp; </p>'
                + '<p class="center-content"> You will now proceed to the <b>proper block</b>, where your <b style="color:#32CD32">reward points</b> determine your bonus payment.</p>' 
                + '<p class="center-content">  Click "Next" to begin the experiment.</p>']
              }
            } else {
            return ['<p class="center-content">You have completed the proper block!</p> <p> Your reward points gained for the block was <b  style="color:#32CD32">' + pointsInBlock + ' points</b>.</p>']
            }
            },
            choices: ["Next"],
        };

        timeline.push(block);
        timeline.push(end_block);

        })(superblock_order,j);
    }// loop through ITIs
  })(superblock_order,j)
} // loop through superblocks with different set sizes.


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
  '<p class="center-content"> On the next page, we will ask for your MTurk ID and save your data. Then you will be redirected to the end-of-study survey page!</p>',
      choices: ['Next'],
};

// Save data //
var save_data = {
  type: "survey-text",
  questions: [{prompt: 'Please input your MTurk Worker ID so that we can pay you the appropriate bonus. Your ID will not be shared with anyone outside of our research team. Your data will now be saved.', value: 'Worker ID'}],
  on_finish: function(data) {
  var responses = JSON.parse(data.responses);
  var subject_id = responses.Q0;
  console.log(subject_id)
  //saveData(subject_id, jsPsych.data.get().csv());
  saveData(turkInfo.workerId, jsPsych.data.get().csv());

  // var experiment_data = jsPsych.data.get().csv();
  // var filename = "HumanData.csv";
  // downloadCSV(experiment_data, filename);
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
    window.location.href = "https://harvard.az1.qualtrics.com/jfe/form/SV_6taoCnJClKTdEtE?&workerId=" + turkInfo.workerId + "&assignmentId=" + turkInfo.assignmentId + "&hitId=" + turkInfo.hitId;
  },
};

timeline.push(end_all_blocks)
timeline.push(save_data);
timeline.push(end_experiment);


function startExperiment(){
  jsPsych.init({
    timeline: timeline,
    auto_update_progress_bar: false,
  })
};

jsPsych.pluginAPI.preloadImages(stimuli, function () {startExperiment();});
console.log("Images preloaded.");

})
