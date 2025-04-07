// // Variable to keep track of most recent trial (to compare correctness)
// var trial_id = '';
// var trial = '';

// // Instantiate variables
//   var block_duration = 60*1000 // in milliseconds (60 seconds*1000 milliseconds = 1 mins)
//   //var num_trials_per_block = 60; // 60 trials per block in the "trial" condition
//   var num_blocks = 2; 
//   var iti = jsPsych.randomization.repeat([0, 1000, 2000], 2, false) //  ITI: 0, 1000, 2000 milliseconds
//   var counter = jsPsych.randomization.repeat([0, 0, 0], 2, false) //  ITI: 0, 1000, 2000 milliseconds
//   var RT = 0;

//   var stimuli_trials = [
//     { stimuli_trials: 'img/frac1.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
//     { stimuli_trials: 'img/frac2.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
//     { stimuli_trials: 'img/frac3.png', data_trials:{state: 3, test_part:'trials', correct_response:51}},
//     { stimuli_trials: 'img/frac4.png', data_trials:{state: 4, test_part:'trials', correct_response:52}}];

// /*var stimuli3 = [
//   { stimuli_trials: 'img/grey-r.png', data_trials:{state: 1, test_part:'trials', correct_response:49}},
//   { stimuli_trials: 'img/purple-r.png', data_trials:{state: 2, test_part:'trials', correct_response:50}},
//   { stimuli_trials: 'img/pink-r.png', data_trials:{state: 3, test_part:'trials', correct_response:51}},
//   { stimuli_trials: 'img/orange-r.png', data_trials:{state: 4, test_part:'trials', correct_response:52}}];*/


//   // Block


//   // var end_block = {
//   //   type: 'instructions',
//   //   pages: [
//   //     '<p class="center-content">You have completed a block!</p> Take a break if you would like and then press "Next" to continue to the next block.</p> </p> Note: the next block may have a different correct mapping.</p>'
//   //     ],
//   //   show_clickable_nav: true
//   // };
