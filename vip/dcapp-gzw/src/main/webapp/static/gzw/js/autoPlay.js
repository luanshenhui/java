
$(document).ready(function(){
    var refreshTime = 3000000;
    // 定时刷新首页
        setInterval(function(){
            window.location.reload();
    }, refreshTime);

    $('#head-items li').click(function(){
        $(this).addClass('on').siblings('li').removeClass('on');
        currentIndex=$(this).index();
    });
});

var currentIndex = 0;
function startRoundPlay()
{
    var liList = document.getElementById("head-items").getElementsByTagName("li");
    isRunning = true;
    roundCount = liList.length;
    mytimeId = setInterval(fnTime,5000);
    fnTime();
    document.getElementById("playImg").src = "./image/header-icon-stop.png";
}
function fnTime(){
    currentIndex = (currentIndex+1)%roundCount;
    var liList = document.getElementById("head-items").getElementsByTagName("li");
    document.getElementById("firstpageFrame").src = liList.item(currentIndex).getElementsByTagName("a")[0].getAttribute("href");
    liList.item(currentIndex).setAttribute('class','on');
    liList.item((currentIndex-1+roundCount)%roundCount).removeAttribute("class");
}


function endRoundPlay()
{
    isRunning = false;
    clearInterval(mytimeId);
    document.getElementById("playImg").src = "./image/header-icon-start.png";
}

function playBtnClick()
{
    if(isRunning)
    {
        endRoundPlay();
    }
    else
    {
        startRoundPlay();
    }

}