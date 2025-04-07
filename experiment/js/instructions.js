var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content"><b>Welcome to our study! </p>' +
    '<p class="center-content">In this study, you will earn <b style="color:#32CD32">$2</b> plus a bonus of <b style="color:#32CD32">$1-2</b> depending on your performance!</b></p>' +
    '<p class="center-content">This task should take you about <b>15 minutes</b> in total, which includes a short survey at the end of the experiment. </p>' +
    '<p class="center-content">Press "Next" to view the instructions.</p>',
    // Instructions (page 2)
    '<p> In this study, your goal is to learn the correct number on your keyboard: <b>"1","2","3", or "4",</b> to press for different images on the screen.</p>' +
    '<p> On each trial, you will see one image such as these:</p>' +
    '<p> <img src= img/frac1.png style="width:150px; height:150px;"> <img src= img/frac2.png style="width:150px; height:150px;"> <img src= img/frac3.png style="width:150px; height:150px;"> <img src= img/frac4.png style="width:150px; height:150px;"></p>'+
    '<p> Your job is learn which number key matches with each image.</p>',
    //Instructions (page 6)
    '<p> If you are <b style="color:#32CD32">correct</b>, a green border will appear around the image, like this: </p>' +
    '<p> <img src= img/frac1.png style="border:14px solid green; width:150px; height:150px;"></p>'+
    '<p> If you are <b style="color:red">incorrect</b>, a red border will appear around the image, like this:</p>'+
    '<p> <img src= img/frac1.png style="border:14px solid red; width:150px; height:150px;"> </p>',

    '<p> Your <b>goal</b> in this task is to <b>get as many reward points as possible.</b></p>'+
    '<p> For each correct key press, you will be rewarded <b style="color:#32CD32">1 point</b>. <strong style="color:#FF0000">You never lose points for getting key presses wrong!</strong></p>'+
    '<p> &nbsp; </p>'+
    '<p> The experiment has <b>6 blocks</b>, each lasting <b>1 minute</b>.' + 
    '<p> Once you respond to a trial, the next trial will show up with some unavoidable <b style="color:#e8b11c">time delay</b>. </p>'+
    '<p> <b>As long as there is time left in the block, more trials will show up.</b></p>' + 
    '<p> At the end of the study, we will add up all your reward points and convert it into your bonus pay $$.</p>'+
    '<p>Your bonus will be based on the reward points you get in each block, relative to the maximum possible for that block.</p>',
    // '<p> <b> To summarize:</b> The number of trials you are able to complete in each 1 minute block, along with how accurate you are, will determine your pay!</p>'+

    
    '<p> <img src= img/display.png style="float: right; height:400px;"> </p>'+
    '<p> The right figure shows the typical display of a trial.</p>'+
    '<p> There is the <b>image</b>, the <b style="color:red">time left</b> in this block, and <b style="color:#32CD32">reward gained</b> in this block.</p>'+
    '<p> You can use them to keep track of how well you are doing.</b>',

    '<p> Now let us talk more about <b style="color:#e8b11c">time delay</b>, which differs across blocks.</p>'+
    '<p> Because each block has a fixed time duration, <b>the faster you are, the more trials you can complete.</b></p>'+
    '<p> For a block with time delay <b>0s</b>, if you are infinitely fast, you can complete <b>infinitely many trials</b>.</p>'+
    '<p> For a block with time delay <b>1s</b>, if you are infinitely fast, you can complete at most 1min/1s = <b>60 trials</b>.</p>'+
    '<p> For a block with time delay <b>2s</b>, if you are infinitely fast, you can complete at most 1min/2s = <b>30 trials</b>.</p>'+
    "<p> Hence, think about how to get <b style='color:#32CD32'>as many reward points</b> as possible!</p>"+
    "<p> Don't worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how many <b>reward points</b> you get.</p>"+
    '<p> &nbsp; </p>'+
    '<p> Click "Next" to go through <b>practice blocks</b> with different <b style="color:#e8b11c">time delays</b>. They have no bearing on your bonus payment.</p>',



  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};

console.log('instructions loaded')