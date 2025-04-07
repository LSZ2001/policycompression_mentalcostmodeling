// Practice block //


var practice_instructions1= {
  type: 'instructions',
  pages: [ 
  '<p> Great job! &#128175; You passed the quiz :)</p>' +
  '<p> <b>You will now complete two practice blocks!</b></p>' +
  '<p> In this first practice block, the toilet paper is in relatively <b>low demand.</b> This means that the item is <b>likely</b> to be in stock after refreshing the page.</p>' +
  '<p> (In the real game, we will not tell you what the current demand is. We are telling you now just to familiarize you with the different block types.)</p>' +
  '<p> Click "Begin" to start the <b>first</b> practice block. This block will last 20 seconds.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};


// PRACTICE BLOCKS //
var practice_block_stim = [];
practice_block_stim.push([
  {data: {test_part: 'practice', p: 1}}]);
practice_block_stim.push([
  {data: {test_part: 'practice', p: 0.3}}]);

var practice_block1 = {
  timeline: [trial, feedback],
  timeline_variables: practice_block_stim[0],
  randomize_order: false,
  repetitions: 20
};

var practice_instructions2 = {
  type: 'instructions',
  pages: [ 
  '<p> Great job! Now you will experience a practice block where the toilet paper is in relatively <b>high demand.</b> This means that the item is <b>unlikely</b> to be in stock after refreshing the page.</p>',
  '<p> Click "Begin" to start the <b>second</b> practice block. This block will last 20 seconds.</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};

var practice_block2 = {
  timeline: [trial, feedback],
  timeline_variables: practice_block_stim[1],
  randomize_order: false,
  repetitions: 20
};

var practice_block = {
  timeline: [practice_instructions1, practice_block1, practice_instructions2, practice_block2],
  repetitions: 1
};

var practice_end = {
  type: 'instructions',
  pages: [ 
  '<p> This ends the practice portion of the task. You will now begin the game!</p>'
  ],
  show_clickable_nav: true,
  button_label_next: 'Begin'
};

/*var practice_finished = {
  type: 'html-button-response',
  stimulus: [
  '<p> You have completed the practice block.</p>' +
  '<p> Click "Practice again!" if you would like to do the practice block again. Press "Begin game!" if you would like to start the game.</p>'],
  choices: ['Practice again!','Begin game!'],
  response_ends_trial: true,
  on_finish: function(data) {
    trial_id = jsPsych.currentTimelineNodeID();
    trial = jsPsych.data.getDataByTimelineNode(trial_id);
    console.log(trial.select('button_pressed').values[0])
    if (trial.select('button_pressed').values[0][0]==0){
      console.log('Practice again')
      return finish;
    } else {
    finish = true; console.log(finish)
    return finish;
    }// Practice again
    

  }
};*/

var practice_finished = {
  type: 'instructions',
  pages: [ 
  '<p> You have completed the practice block.</p>' +
  '<p> Press "Begin game!" to start the game.</p>'],
  show_clickable_nav: true,
  button_label_next: 'Begin game!'
};

function create_practice() {
  console.log("Creating practice block!");
  return practice_block;
};

function finish_practice() {
  console.log("Finishing practice trials.");
  return practice_finished;
}