var env="prod";var hostLocal="localhost:8080";var hostTest="test.dpn.cn:8080";
var hostProd="apollo.dpn.com.cn";function getWholePath(){if(env=="local"){return"http://"+hostLocal+"/sso"
}else{if(env=="test"){return"http://"+hostTest+"/sso"}else{if(env=="prod"){return"http://"+hostProd+"/sso"
}else{return""}}}}function getProdForShow(){var a=new Array();
if(env=="test"||env=="local"){a.push(new Array("EPC","EPC\u7cfb\u7edf","http://epc.test.dpn.cn/sso/page/frame?ssopid=EPC"));
a.push(new Array("DCD","\u5371\u9669\u8d27\u7269\u7533\u62a5\u7cfb\u7edf","http://test.dpn.cn:7001/dcd/"));
a.push(new Array("VGM","\u96c6\u88c5\u7bb1\u91cd\u91cf\u9a8c\u8bc1\u7efc\u5408\u670d\u52a1\u7cfb\u7edf","http://test.dpn.cn:7001/vgm/"));
a.push(new Array("COD","\u68c0\u9a8c\u68c0\u75ab\u53e3\u5cb8\u7efc\u5408\u4e1a\u52a1\u7cfb\u7edf","http://test.dpn.cn:7001/cod2.0/"));
a.push(new Array("EVC","\u8239\u8236\u7efc\u5408\u7533\u62a5\u7cfb\u7edf","http://test.dpn.cn:7001/evc/"));
a.push(new Array("AIS","\u8239\u8236\u52a8\u6001\u8ddf\u8e2a\u7cfb\u7edf","http://test.dpn.cn:7001/ais/"));
a.push(new Array("MPC","\u591a\u5f0f\u8054\u8fd0\u534f\u540c\u670d\u52a1\u7cfb\u7edf","http://test.dpn.cn:7001/itc/forwardservlet"));
a.push(new Array("MPC","E\u8fbe\u901a\u5168\u7a0b\u7269\u6d41","http://test.dpn.cn:7001/itc/forwardservlet"));
a.push(new Array("JUPITER","\u7528\u6237\u7edf\u4e00\u7ba1\u7406\u7cfb\u7edf","http://test.dpn.cn:8080/jupiter/"));
a.push(new Array("OMS","\u4fe1\u606f\u5b9a\u5236\u7ba1\u7406\u7cfb\u7edf","http://test.dpn.cn:8081/oms/"));
a.push(new Array("TWM","\u7801\u5934\u4f5c\u4e1a\u4fe1\u606f\u670d\u52a1\u7cfb\u7edf","http://test.dpn.cn:8081/twm/"));
a.push(new Array("NMS","\u6d77\u5173\u65b0\u8231\u5355\u652f\u6301\u7cfb\u7edf","http://test.dpn.cn:7001/mfd/"));
a.push(new Array("CBIP","\u5927\u8fde\u6e2f\u96c6\u56e2\u7efc\u5408\u4fe1\u606f\u5e73\u53f0\u96c6\u88c5\u7bb1\u4fe1\u606f\u7533\u62a5","http://test.dpn.cn:7001/cbip/"));
a.push(new Array("CSP","\u5ba2\u670d\u4e2d\u5fc3\u4fe1\u606f\u7cfb\u7edf","http://test.dpn.cn:7001/csp/"));
a.push(new Array("EQSW","\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u76d1\u7ba1\u7cfb\u7edf","http://test.dpn.cn:7001/eqs-w/"));
a.push(new Array("EQSQDW","\u9752\u5c9b\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u7535\u5b50\u7533\u62a5\u7cfb\u7edf","http://test.dpn.cn:7001/eqs-qdw/"));
a.push(new Array("EQSNJW","\u5357\u4eac\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u7535\u5b50\u7533\u62a5\u7cfb\u7edf","http://test.dpn.cn:7001/eqs-njw/"));
a.push(new Array("SIS","\u5927\u8fde\u822a\u8fd0\u6307\u6570\u7cfb\u7edf","http://test.dpn.cn:7001/sis/"));
a.push(new Array("TRIALFUNC","\u4f1a\u5458\u4f53\u9a8c\u901a\u9053","http://test.dpn.cn:8080/trialfunc/"));
a.push(new Array("EDIWEB","EDI\u62a5\u6587\u72b6\u6001\u8ddf\u8e2a\u5e73\u53f0","http://10.10.3.205:7001/edi-web/"));
a.push(new Array("EBILLW","\u8ba1\u8d39\u67e5\u8be2\u7cfb\u7edf","http://10.10.40.20:7001/ebillw/"));
a.push(new Array("EHC","\u9ad8\u901f\u516c\u8def\u901a\u884c\u8d39\u8db8\u7f34\u7cfb\u7edf","http://test.dpn.cn:7001/ehc/pages/index.jsp"));
a.push(new Array("SPC","\u6d77\u8fd0\u4e2d\u8f6c\u670d\u52a1\u5e73\u53f0","http://test.dpn.cn:7001/spc/"));
a.push(new Array("TPS","\u573a\u7ad9\u88c5\u7bb1\u7406\u8d27\u5546\u52a1\u670d\u52a1\u7cfb\u7edf","http://test.dpn.cn:7001/tps/default.do"));
a.push(new Array("EPS","\u7535\u5b50\u652f\u4ed8\u5e73\u53f0","http://test.dpn.cn:8082/eps/"));
a.push(new Array("SCS","\u7bb1\u7ba1\u5bb6\u53e3\u5cb8\u516c\u5171\u667a\u80fd\u7bb1\u7ba1\u7cfb\u7edf","http://test.dpn.cn:7001/scs/"));
a.push(new Array("DBS","\u96c6\u88c5\u7bb1\u573a\u7ad9\u667a\u80fd\u5546\u52a1\u670d\u52a1\u7cfb\u7edf","http://test.dpn.cn:7001/dbs/"));
a.push(new Array("TSS","\u7801\u5934\u4f5c\u4e1a\u76d1\u7ba1\u652f\u6301\u7cfb\u7edf","http://test.dpn.cn:8080/sso/page/frame?ssopid=TSS"));
a.push(new Array("WCMS","\u5927\u8fde\u6e2f\u5fae\u4fe1\u4f1a\u8bae\u7ba1\u7406\u7cfb\u7edf","http://test.dpn.cn:7001/pispapp/page/mgr/weixin/pda/meeting/index"))
}else{if(env=="prod"){a.push(new Array("EPC","EPC\u7cfb\u7edf","http://apollo.dpn.com.cn/sso/page/frame?ssopid=EPC"));
a.push(new Array("DCD","\u5371\u9669\u8d27\u7269\u7533\u62a5\u7cfb\u7edf","http://dcd.dpn.com.cn/dcd/"));
a.push(new Array("VGM","\u96c6\u88c5\u7bb1\u91cd\u91cf\u9a8c\u8bc1\u7efc\u5408\u670d\u52a1\u7cfb\u7edf","http://dcd.dpn.com.cn/vgm/"));
a.push(new Array("COD","\u68c0\u9a8c\u68c0\u75ab\u53e3\u5cb8\u7efc\u5408\u4e1a\u52a1\u7cfb\u7edf","http://ciq.dpn.com.cn/cod2.0/"));
a.push(new Array("EVC","\u8239\u8236\u7efc\u5408\u7533\u62a5\u7cfb\u7edf","http://apollo.dpn.com.cn/sso/page/frame?ssopid=EPC"));
a.push(new Array("AIS","\u8239\u8236\u52a8\u6001\u8ddf\u8e2a\u7cfb\u7edf","http://ais.dpn.cn/ais/"));
a.push(new Array("MPC","\u591a\u5f0f\u8054\u8fd0\u534f\u540c\u670d\u52a1\u7cfb\u7edf","http://mpc.dpn.com.cn/itc/forwardservlet"));
a.push(new Array("MPC","E\u8fbe\u901a\u5168\u7a0b\u7269\u6d41","http://mpc.dpn.com.cn/itc/forwardservlet"));
a.push(new Array("JUPITER","\u7528\u6237\u7edf\u4e00\u7ba1\u7406\u7cfb\u7edf","http://apollo.dpn.com.cn/jupiter/"));
a.push(new Array("OMS","\u4fe1\u606f\u5b9a\u5236\u7ba1\u7406\u7cfb\u7edf","http://apollo.dpn.com.cn/oms/"));
a.push(new Array("TWM","\u7801\u5934\u4f5c\u4e1a\u4fe1\u606f\u670d\u52a1\u7cfb\u7edf","http://apollo.dpn.com.cn/twm/"));
a.push(new Array("NMS","\u6d77\u5173\u65b0\u8231\u5355\u652f\u6301\u7cfb\u7edf","http://apollo.dpn.com.cn/nms/"));
a.push(new Array("CBIP","\u5927\u8fde\u6e2f\u96c6\u56e2\u7efc\u5408\u4fe1\u606f\u5e73\u53f0\u96c6\u88c5\u7bb1\u4fe1\u606f\u7533\u62a5","http://apollo.dpn.com.cn/cbip/"));
a.push(new Array("CSP","\u5ba2\u670d\u4e2d\u5fc3\u4fe1\u606f\u7cfb\u7edf","http://csp.dpn.com.cn/csp/pages/index.jsp"));
a.push(new Array("EQSW","\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u76d1\u7ba1\u7cfb\u7edf","http://ciq.dpn.com.cn/eqs-w/"));
a.push(new Array("EQSQDW","\u9752\u5c9b\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u7535\u5b50\u7533\u62a5\u7cfb\u7edf","http://ciq.dpn.com.cn/eqs-qdw/"));
a.push(new Array("EQSNJW","\u5357\u4eac\u7a7a\u6e2f\u68c0\u9a8c\u68c0\u75ab\u7535\u5b50\u7533\u62a5\u7cfb\u7edf","http://ciq.dpn.com.cn/eqs-njw/"));
a.push(new Array("SIS","\u5927\u8fde\u822a\u8fd0\u6307\u6570\u7cfb\u7edf","http://ops.dpn.com.cn/sis/"));
a.push(new Array("TRIALFUNC","\u4f1a\u5458\u4f53\u9a8c\u901a\u9053","http://apollo.dpn.com.cn/trialfunc/"));
a.push(new Array("EDIWEB","EDI\u62a5\u6587\u72b6\u6001\u8ddf\u8e2a\u5e73\u53f0","http://ops.dpn.com.cn/edi-web/"));
a.push(new Array("EBILLW","\u8ba1\u8d39\u67e5\u8be2\u7cfb\u7edf","http://apollo.dpn.com.cn/ebillw/default.do"));
a.push(new Array("EHC","\u9ad8\u901f\u516c\u8def\u901a\u884c\u8d39\u8db8\u7f34\u7cfb\u7edf","http://ops.dpn.com.cn/ehc/pages/index.jsp"));
a.push(new Array("SPC","\u6d77\u8fd0\u4e2d\u8f6c\u670d\u52a1\u5e73\u53f0","http://apollo.dpn.com.cn/spc/"));
a.push(new Array("TPS","\u573a\u7ad9\u88c5\u7bb1\u7406\u8d27\u5546\u52a1\u670d\u52a1\u7cfb\u7edf","http://apollo.dpn.com.cn/tps/default.do"));
a.push(new Array("EPS","\u7535\u5b50\u652f\u4ed8\u5e73\u53f0","http://apollo.dpn.com.cn/eps/"));
a.push(new Array("SCS","\u7bb1\u7ba1\u5bb6\u53e3\u5cb8\u516c\u5171\u667a\u80fd\u7bb1\u7ba1\u7cfb\u7edf","http://apollo.dpn.com.cn/scs/"));
a.push(new Array("DBS","\u96c6\u88c5\u7bb1\u573a\u7ad9\u667a\u80fd\u5546\u52a1\u670d\u52a1\u7cfb\u7edf","http://apollo.dpn.com.cn/dbs/"));
a.push(new Array("TSS","\u7801\u5934\u4f5c\u4e1a\u76d1\u7ba1\u652f\u6301\u7cfb\u7edf","http://apollo.dpn.com.cn/sso/page/frame?ssopid=TSS"));
a.push(new Array("WCMS","\u5927\u8fde\u6e2f\u5fae\u4fe1\u4f1a\u8bae\u7ba1\u7406\u7cfb\u7edf","http://wxhw.portdalian.com/pispapp/page/mgr/weixin/pda/meeting/index"))
}}return a}function addProdAutoSwitch(d,a){var b=getProdForShow();
var c="";for(i=0;i<b.length;i++){if(b[i][0]==a){c+='<option value="'+b[i][2]+'" selected="selected">'+b[i][1]+"</option>"
}else{c+='<option value="'+b[i][2]+'">'+b[i][1]+"</option>"}}jQuery("#"+d).append(c);
jQuery("#"+d).bind("change",function(){window.location.href=document.getElementById(d).value
})}function reloadLoginVerifyCode(a,b){var c=document.getElementById(a);
if(c!=null){c.value=""}var d=document.getElementById(b);if(d!=null){d.src=getWholePath()+"/verifycodeimage?d="+new Date().getTime()
}}function encryptPwdForLogin(q){var l=8;var o=0;function j(r,u){var t=(r&65535)+(u&65535);
var s=(r>>16)+(u>>16)+(t>>16);return(s<<16)|(t&65535)}function e(s,r){return(s>>>r)|(s<<(32-r))
}function f(s,r){return(s>>>r)}function a(r,t,s){return((r&t)^((~r)&s))
}function d(r,t,s){return((r&t)^(r&s)^(t&s))}function g(r){return(e(r,2)^e(r,13)^e(r,22))
}function b(r){return(e(r,6)^e(r,11)^e(r,25))}function p(r){return(e(r,7)^e(r,18)^f(r,3))
}function k(r){return(e(r,17)^e(r,19)^f(r,10))}function c(s,t){var F=new Array(1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298);
var u=new Array(1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225);
var r=new Array(64);var H,G,E,D,B,z,y,x,w,v;var C,A;s[t>>5]|=128<<(24-t%32);
s[((t+64>>9)<<4)+15]=t;for(var w=0;w<s.length;w+=16){H=u[0];G=u[1];
E=u[2];D=u[3];B=u[4];z=u[5];y=u[6];x=u[7];for(var v=0;v<64;v++){if(v<16){r[v]=s[v+w]
}else{r[v]=j(j(j(k(r[v-2]),r[v-7]),p(r[v-15])),r[v-16])}C=j(j(j(j(x,b(B)),a(B,z,y)),F[v]),r[v]);
A=j(g(H),d(H,G,E));x=y;y=z;z=B;B=j(D,C);D=E;E=G;G=H;H=j(C,A)}u[0]=j(H,u[0]);
u[1]=j(G,u[1]);u[2]=j(E,u[2]);u[3]=j(D,u[3]);u[4]=j(B,u[4]);u[5]=j(z,u[5]);
u[6]=j(y,u[6]);u[7]=j(x,u[7])}return u}function h(u){var t=Array();
var r=(1<<l)-1;for(var s=0;s<u.length*l;s+=l){t[s>>5]|=(u.charCodeAt(s/l)&r)<<(24-s%32)
}return t}function n(s){s=s.replace(/\r\n/g,"\n");var r="";for(var u=0;
u<s.length;u++){var t=s.charCodeAt(u);if(t<128){r+=String.fromCharCode(t)
}else{if((t>127)&&(t<2048)){r+=String.fromCharCode((t>>6)|192);
r+=String.fromCharCode((t&63)|128)}else{r+=String.fromCharCode((t>>12)|224);
r+=String.fromCharCode(((t>>6)&63)|128);r+=String.fromCharCode((t&63)|128)
}}}return r}function m(t){var s=o?"0123456789ABCDEF":"0123456789abcdef";
var u="";for(var r=0;r<t.length*4;r++){u+=s.charAt((t[r>>2]>>((3-r%4)*8+4))&15)+s.charAt((t[r>>2]>>((3-r%4)*8))&15)
}return u}q=n(q);return m(c(h(q),q.length*l))}function encryptPwdForModify(e){var b="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
var a="";var m,k,h,l,j,g,f;var c=0;function d(p){p=p.replace(/\r\n/g,"\n");
var o="";for(var r=0;r<p.length;r++){var q=p.charCodeAt(r);if(q<128){o+=String.fromCharCode(q)
}else{if((q>127)&&(q<2048)){o+=String.fromCharCode((q>>6)|192);
o+=String.fromCharCode((q&63)|128)}else{o+=String.fromCharCode((q>>12)|224);
o+=String.fromCharCode(((q>>6)&63)|128);o+=String.fromCharCode((q&63)|128)
}}}return o}e=d(e);while(c<e.length){m=e.charCodeAt(c++);k=e.charCodeAt(c++);
h=e.charCodeAt(c++);l=m>>2;j=((m&3)<<4)|(k>>4);g=((k&15)<<2)|(h>>6);
f=h&63;if(isNaN(k)){g=f=64}else{if(isNaN(h)){f=64}}a=a+b.charAt(l)+b.charAt(j)+b.charAt(g)+b.charAt(f)
}return a};