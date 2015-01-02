$(document).ready(function(){
  var el = document.getElementById('canvasbg');
  var ctx = el.getContext('2d');
  var wwidth = window.innerWidth-1;
  var wheight = window.innerHeight-1;
  el.width = wwidth
  el.height = wheight
  ctx.lineWidth = 0.1;
  ctx.strokeStyle = '#FF7878';
  ctx.lineCap = 'round';
  var currentPos = [0,0];
  var revertPos = function(){ctx.moveTo(currentPos[0],currentPos[1])};
  var draw = function(randomX, randomY, randomXb, randomYb, add){
    ctx.quadraticCurveTo(randomX + add, randomY + add, randomXb, randomYb);
    ctx.stroke();
  }
  var drawRandom = function(){
    randomX = Math.floor(Math.random() * window.innerWidth) + 1
    randomXb =  Math.floor(Math.random() * window.innerWidth) + 1
    randomY =  Math.floor(Math.random() * window.innerHeight) + 1
    randomYb = Math.floor(Math.random() * window.innerHeight) + 1
    for(var i=0;i<=45;i+=15){
      draw(randomX, randomY, randomXb, randomYb, i);
      if(i != 45){
        revertPos();
      }
      if(i == 45){
        currentPos[0] = randomXb;
        currentPos[1] = randomYb;
      }
    }
  }
  var finish = function(){
    for(var i=0;i<=45;i+=15){draw(wwidth/2, wheight/2, wwidth, wheight, i);revertPos();}
  }
  ctx.beginPath();
  ctx.moveTo(currentPos[0],currentPos[1]);
  for(var i=0;i<1;i++){
    drawRandom();
  }
  finish();
});