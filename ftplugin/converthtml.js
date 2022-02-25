<script>
let offset = 2;
var frame = 1;

// #n: go to slide n
if ('onhashchange' in window) {
  window.onhashchange = GoToFrameHash;
}

if(window.location.hash) {
  GoToFrameHash();
} 

function goUp() {
  if (frame <= 1) return;
  window.location.hash = frame-1;
}

function goDown() {
  let afterframe = frame+offset+1;
  if (!(document.getElementById("fold"+afterframe))) return;
  window.location.hash = frame+1;
}

// left arrow: go back, right arrow: go forth
document.onkeydown = function (e) {
  switch (e.keyCode) {
    case 37: // left key
      goUp();
      break;
    case 39: // right key
      goDown();
      break;
  }
}

function GoToFrameHash() {
  var lineNum;
  frameNum = window.location.hash;
  frameNum = offset+parseInt(frameNum.substr(1));
  goToFrame(frameNum);
  return true;
}

function goToFrame(num) {
  for (var i=1; i < num; i++) {
    document.getElementById("fold"+i).className = 'closed-fold';
  }
  document.getElementById("fold"+num).className = 'open-fold';
  for (var i=num+1; document.getElementById("fold"+i); i++) {
    document.getElementById("fold"+i).className = 'closed-fold';
  }
  frame = num - offset;
}

function GoToWheel(e) {
  if (e.deltaY < 0) {
    goUp();
  } else if (e.deltaY > 0) {
    goDown();
  }
}

window.onwheel = GoToWheel;

window.location.hash = frame;
</script>
