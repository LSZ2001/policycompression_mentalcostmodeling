var instructions = {
  type: 'instructions',
  pages: [
    // Welcome (page 1)
    '<p class="center-content"><b>Welcome to our study! </p>' +
    '<p class="center-content">In this study, you will earn <b style="color:#32CD32">$3</b> plus a bonus of <b style="color:#32CD32">$1-2</b> depending on your performance!</b></p>' +
    '<p class="center-content">This task should take you about <b>20 minutes</b> in total, which includes a short survey at the end of the experiment. </p>' +
    '<p class="center-content">Press "Next" to view the instructions.</p>',
    // Instructions (page 2)
    '<p> In this study, you will press numbers on your keyboard: <b>"1","2","3", or "4",</b> for different images on the screen.</p>' +
    '<p> On each trial, you will see one image such as these:</p>' +
    '<p> <img src= img/frac4.png style="width:150px; height:150px;"> <img src= img/frac2.png style="width:150px; height:150px;"> <img src= img/frac3.png style="width:150px; height:150px;"> <img src= img/frac1.png style="width:150px; height:150px;"></p>'+
    '<p> For each image, pressing some number keys would <b>more likely</b> give you <b style="color:#32CD32">rewards</b> than others.</p>'+
    '<p> Different images may share the same "most-likely-rewarding" key.</p>',

    //Instructions (page 6)
    '<p> If your key press yielded <b style="color:#32CD32">1 reward point</b>, a <b style="color:#32CD32">green border</b> will appear around the image, like this: </p>' +
    '<p> <img src= img/frac1.png style="border:14px solid green; width:150px; height:150px;"></p>'+
    '<p> If your key press did not yield reward points, a <b style="color:#bcbcbc">gray border</b> will appear around the image, like this:</p>'+
    '<p> <img src= img/frac1.png style="border:14px solid #bcbcbc; width:150px; height:150px;"> </p>',

    '<p> Your <b>goal</b> in this task is to <b>get as many reward points as possible.</b></p>'+
    '<p> Again, for each <b style="color:#32CD32">green border</b>, you will be rewarded <b style="color:#32CD32">1 point</b>. For each <b style="color:#bcbcbc">gray border</b>, you will not receive or lose reward points.'+
    '<p> &nbsp; </p>'+
    '<p> The experiment has <b>3 blocks</b>, each lasting <b>3 minutes</b>.' + 
    '<p> Once you respond to a trial, the next trial will show up with some unavoidable <b style="color:red">time delay</b>. </p>'+
    '<p> <b>As long as there is time left in the block, more trials will show up.</b></p>' + 
    '<p>Your bonus pay $$ will depend on the reward points you get in each block, relative to the maximum possible for that block.</p>',
    // '<p> <b> To summarize:</b> The number of trials you are able to complete in each 1 minute block, along with how accurate you are, will determine your pay!</p>'+

    
    '<p> <img src= img/display.png style="float: right; height:400px;"> </p>'+
    '<p> The right figure shows the typical display of a trial.</p>'+
    '<p> There is the <b>image</b>, the <b style="color:red">time left</b> in this block, and <b style="color:#32CD32">reward gained</b> in this block.</p>'+
    '<p> The <b style="color:#32CD32">reward gained</b> bar height is scaled to the <b style="color:green">maximum reward possible</b> for this block, to give you motivation!</p>'+
    '<p> You can use them to keep track of how well you are doing.</b>',

    // '<p> Now let us talk more about <b style="color:red">time delay</b>, which differs across blocks.</p>'+
    // '<p> Because each 3-minute block has a fixed time duration, <b style="color:red">the faster you are, the more trials you can complete.</b></p>'+
    // '<p> For a block with time delay <b>0s</b>, if you are infinitely fast, you can complete <b>infinitely many trials</b>.</p>'+
    // '<p> For a block with time delay <b>1s</b>, if you are infinitely fast, you can complete at most 3min/1s = <b>180 trials</b>.</p>'+
    // '<p> For a block with time delay <b>2s</b>, if you are infinitely fast, you can complete at most 3min/2s = <b>90 trials</b>.</p>'+
    // '<p> Hence, think about how to get <b style="color:#32CD32">as many reward points</b> as possible!</p>' +
    // '<p><b style="color:red">Sometimes it is not about getting every border green, but getting more borders in that 3-minute block...</b></p>'+
    // "<p> Don't worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how many <b>reward points</b> you get.</p>"+
    // '<p> &nbsp; </p>'+
    // '<p> Click "Next" to go through <b>practice blocks</b> with different <b style="color:red">time delays</b>, but with a shorter time duration.</p> <p>Practice blocks have no bearing on your bonus payment.</p>',

    // '<p> Now let us talk more about intertrial <b style="color:red">time delay</b>, which differs across blocks.</p>'+
    // '<p> The time delay of a block can be either <b>0s, 0.5s, or 2s</b>. We will tell you before starting each block.</p>'+
    // "<p> In each 3-minute block, <b style='color:red'>the faster you are, the more trials you can complete, but upper-bounded by the block's time delay.</b></p>"+
    // '<p> Hence, think about how to get <b style="color:#32CD32">as many green borders / reward points</b> as possible!</p>' +
    // '<p><b style="color:red">Sometimes it is not about getting every border green, but getting more borders in that 3-minute block...</b></p>'+
    // "<p> Don't worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how many <b>reward points</b> you get.</p>"+
    // '<p> &nbsp; </p>'+
    // '<p> Click "Next" to go through <b>practice blocks</b> with different <b style="color:red">time delays</b>, but with shorter block durations.</p> <p>Practice blocks have no bearing on your bonus payment.</p>',


    '<p> Now let us talk more about intertrial <b style="color:red">time delay</b>, which differs across blocks.</p>'+
    '<p> The time delay of a block can be either <b>0s, 0.5s, or 2s</b>. We will tell you before starting each block.</p>'+
    '<p> In each 3-minute block, <b style="color:red">the faster you are, the more trials you can complete.</b></p>'+
    '<p> However, <b style="color:red"> the longer the time delay, the fewer trials you can complete in 3 minutes.</b></p>'+
    '<p> Therefore, think about how to get as many <b style="color:#32CD32">green borders/rewards</b> as possible!</p>'+
    "<p> In other words, <b style='color:red'>sometimes it can make sense to complete as many trials as possible, even if you do not get every border green.</b></p><p> Don't worry: <b>your submission will be approved</b> no matter what <b>strategy</b> you use, no matter how much <b>reward</b> you earn.</p> <p> &nbsp; </p>"+
    '<p style="color:black"> Click "Next" to go through <b>practice blocks</b> with different <b style="color:red">time delays</b>, but with shorter block durations.</p> <p>Practice blocks have no bearing on your bonus payment.</p>',



  ],
  show_clickable_nav: true,
  allow_backward: true,
  show_page_number: true
};

console.log('instructions loaded')