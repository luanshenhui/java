<%
'-----------------------------------------------------------------------------
'		˜JŠîŠ‘®ƒKƒCƒh Include File (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// ƒGƒŒƒƒ“ƒgŽQÆ—p•Ï”
var orgWkPostGuide_OrgWkPostSeq;	// ˜JŠîŠ‘®‚r‚d‚p
var orgWkPostGuide_OrgWkPostName;	// ˜JŠîŠ‘®–¼Ì

var winGuideOrgWkPost;				// ƒEƒBƒ“ƒhƒEƒnƒ“ƒhƒ‹

// ˜JŠîŠ‘®ŒŸõƒKƒCƒh‰æ–Ê‚ð•\Ž¦
function orgWkPostGuide_showGuideOrg( orgCd1, orgCd2, orgWkPostSeq, orgWkPostName ) {

	var url;	// ˜JŠîŠ‘®ŒŸõƒKƒCƒh‰æ–Ê‚ÌURL

	// ƒKƒCƒh‰æ–Ê‚Æ‚Ì˜A—ˆæ‚ðŽg—p‚µ‚Äˆ—§Œä‚ðs‚¤
	orgWkPostGuide_OrgWkPostSeq  = orgWkPostSeq;
	orgWkPostGuide_OrgWkPostName = document.getElementById( orgWkPostName );

	// URL‚Ì•ÒW
	url = '/webHains/contents/guide/gdeOrgWkPost.asp';
	url = url + '?orgCd1=' + orgCd1;
	url = url + '&orgCd2=' + orgCd2;

	// ƒKƒCƒh‰æ–Ê‚ð•\Ž¦
	orgWkPostGuide_openWindow( url );

}

// ƒKƒCƒh‰æ–Ê‚ð•\Ž¦
function orgWkPostGuide_openWindow( url ) {

	var opened = false;	// ‰æ–Ê‚ªŠJ‚©‚ê‚Ä‚¢‚é‚©

	// ‚·‚Å‚ÉƒKƒCƒh‚ªŠJ‚©‚ê‚Ä‚¢‚é‚©ƒ`ƒFƒbƒN
	if ( winGuideOrgWkPost ) {
		if ( !winGuideOrgWkPost.closed ) {
			opened = true;
		}
	}

	// ŠJ‚©‚ê‚Ä‚¢‚éê‡‚Í‰æ–Ê‚ðREPLACE‚µA‚³‚à‚È‚­‚ÎV‹K‰æ–Ê‚ðŠJ‚­
	if ( opened ) {
		winGuideOrgWkPost.focus();
		winGuideOrgWkPost.location.replace( url );
	} else {
		winGuideOrgWkPost = window.open( url, '', 'width=700,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// ˜JŠîŠ‘®î•ñ•ÒW—pŠÖ”
function orgWkPostGuide_setOrgWkPostInfo( orgWkPostSeq, orgWkPostName ) {

	// ˜JŠîŠ‘®‚r‚d‚p‚Ì•ÒW
	if ( orgWkPostGuide_OrgWkPostSeq ) {
		orgWkPostGuide_OrgWkPostSeq.value = orgWkPostSeq;
	}

	// ˜JŠîŠ‘®–¼Ì‚Ì•ÒW
	if ( orgWkPostGuide_OrgWkPostName ) {
		orgWkPostGuide_OrgWkPostName.innerHTML = orgWkPostName;
	}

}

// ˜JŠîŠ‘®î•ñ‚ÌƒNƒŠƒA
function orgWkPostGuide_clearOrgWkPostInfo( orgWkPostSeq, orgWkPostName ) {

	// ˜JŠîŠ‘®‚r‚d‚p‚ÌƒNƒŠƒA
	if ( orgWkPostSeq ) {
		orgWkPostSeq.value = '';
	}

	// ˜JŠîŠ‘®–¼ÌƒGƒŒƒƒ“ƒg‚ÌƒNƒŠƒA
	if ( document.getElementById( orgWkPostName ) ) {
		document.getElementById( orgWkPostName ).innerHTML = '';
	}

}

// ƒKƒCƒh‚ð•Â‚¶‚é
function orgWkPostGuide_closeGuideOrgWkPost() {

	if ( winGuideOrgWkPost ) {
		if ( !winGuideOrgWkPost.closed ) {
			winGuideOrgWkPost.close();
		}
	}

	winGuideOrgWkPost = null;
}
//-->
</SCRIPT>
