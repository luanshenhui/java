window.onload = function(){
    var ms = document.getElementsByClassName("effect-lily")[0]; // blue
    var add = document.getElementsByClassName("mainname")[0];   // white
    ms.onmouseover = function(){
        add.style.display = "none";
    };
    ms.onmouseout = function(){
        add.style.display = "block";
    };

    var ms1 = document.getElementsByClassName("effect-lily")[1];
    var add1 = document.getElementsByClassName("PERMISSION")[0];
    ms1.onmouseover = function(){
        add1.style.display = "none";
    };
    ms1.onmouseout = function(){
        add1.style.display = "block";
    };

    var ms2 = document.getElementsByClassName("effect-lily")[2];
    var add2 = document.getElementsByClassName("INSPECT")[0];
    ms2.onmouseover = function(){
        add2.style.display = "none";
    };
    ms2.onmouseout = function(){
        add2.style.display = "block";
    };

    var ms3 = document.getElementsByClassName("effect-lily")[3];
    var add3 = document.getElementsByClassName("PUNISH")[0];
    ms3.onmouseover = function(){
        add3.style.display = "none";
    };
    ms3.onmouseout = function(){
        add3.style.display = "block";
    };
};
