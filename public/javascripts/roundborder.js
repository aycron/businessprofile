window.onload = function(){
    ES.Round.create('imagewrapper');
}
var ES = new Object();
ES.Round = {
    create: function(wrapper){
        for (var i = 1; 4 >= i; i++) {
            var curve = document.createElement('span');
            curve.className = 'curve' + i;
            var target = document.getElementById(wrapper);
            target.appendChild(curve);
        }
    }
}
