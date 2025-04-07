
//In this block, you earned X rewards! How many rewards do you think you missed out on?
//How satisfied are you with the amount of reward you got?
//From 1-100% of the time, how often do you think your actions produced reward? (slider)
//On a scale of 0-10, how much do you think reward depended on your actions? (slider)
//On a scale of 0-10, how excessive do you feel like your pressing was? (slider)
//On a scale of 0-10, how much did your excessive pressing behavior bother you? (slider)
//On a scale of 0-10, how much do you feel like excessive pressing behavior was forced? (slider)
//What is your mood right now? 

var survey_instructions = {
  type: 'instructions',
  pages: [
  '<p class="center-content">You will now answer some questions about your performance and subjective feelings during this block. </p>'+
  '<p class="center-content">Please answer as honestly as possible! Press "Next" to continue to the questions.</p>'
  ],
  show_clickable_nav: true
  } // instructions

  var survey_fomo = {
    type: 'survey-text',
      /*preamble: function(){ var preamb = ['<p class="center-content">In this block, you earned <b style="color:#32CD32">' + jsPsych.data.get().filter({reward: true}).count() + '</b> rewards!</p>']
      return preamb; },*/
      questions:  function(){
        var questions_array = [ 
        {prompt: 'How many rewards do you think you got?', 
        placeholder:'Please enter a whole number', required: true, columns: 25},
        {prompt: 'How many rewards do you think you missed out on?', 
        placeholder:'Please enter a whole number', required: true, columns: 25},
        ];
        return questions_array; 
      }
  } // fomo


  var survey_est_p = {
    type: 'html-slider-response',
    stimulus: `<div style="width:500px;">
    <p>How often do you think you got rewarded after clicking the refresh button?</p></div>`,
    require_movement: true,
    labels: ['0% of the time', '50% of the time', '100% of the time']
  };

  var survey_reward = {
    type: 'survey-likert',
    questions: [{prompt: 'How satisfied are you with the amount of reward you got?', labels: [
    "Very dissatisfied", 
    "Dissatisfied", 
    "Neutral", 
    "Satisfied", 
    "Very satisfied"
    ], required: true},
    {prompt: 'Do you think you pressed the refresh button more than was necessary?', labels: [
    "I did not press the refresh button more than was necessary", 
    "", 
    "", 
    "", 
    "I pressed the refresh button way more than was necessary"
    ], required: true},

    ]
    /*{prompt: 'How much do you think reward depended on your actions overall?', labels: ["Reward did not depended on my actions at all",
    "",
    "Reward sometimes depended on my actions", 
    "",
    "Reward definitely depended on my actions"], required: true}
    ]*/
} // reward

var survey_excessive = {
  type: 'survey-likert',
  questions: [

  {prompt: 'Did you feel an urge to press the refresh button a lot?', labels: [
  "I did not feel an urge to press the button", 
  "", 
  "", 
  "", 
  "I felt a strong urge to press the button as much as possible"
  ], required: true},

  {prompt: 'How much did your button pressing behavior annoy you?', labels: [
  "Did not annoy me at all", 
  "", 
  "", 
  "", 
  "It was extremely annoying to me"
  ], required: true},

  {prompt: 'Did you feel compelled to press the button more or less than you wanted?', labels: [
  "I felt very compelled to button press less than I wanted",
  "", 
  "I did not feel compelled to press the button more or less than I wanted", 
  "", 
  "I felt very compelled to button press more than I wanted"
  ], required: true},

  ]
} // excessive

var survey_mood = {
  type: 'survey-likert',
  questions: [
  {prompt: 'How anxious are you right now?', labels: [
  "Not anxious at all", 
  "A little anxious", 
  "Moderately anxious", 
  "Very anxious", 
  "Extremely anxious"
  ], required: true},

  {prompt: 'How stressed are you right now?', labels: [
  "Not stressed at all", 
  "A little stressed", 
  "Moderately stressed", 
  "Very stressed", 
  "Extremely stressed"
  ], required: true}

  ]
} // mood


var demographic_age = {
  type: 'survey-text',
  questions: [
  {prompt: 'What is your age?', required: true},
  ]}

var demographic_gender = {
    type: 'survey-multi-choice',
    questions: [
    {prompt: 'What is your gender?', options: ['M','F','non-binary','prefer not to say'], name: 'gender',  required: true}
    ]}
