<script type="text/javascript">
if ( orgGuide_setOrgInfo ) {

	// デフォルトのコールバック関数オブジェクトを退避
	var original_setOrgInfo   = orgGuide_setOrgInfo;
	var original_clearOrgInfo = orgGuide_clearOrgInfo;

	// コールバック関数の再定義	
	orgGuide_setOrgInfo = function()
	{
		// デフォルトのコールバック関数呼び出し
		original_setOrgInfo.apply(window, arguments);
		
		// 追加処理を行うコールバック関数呼び出し
		orgGuide_setOrgInfo_appendix.apply(window, arguments);
	};
	
	// コールバック関数の再定義	
	orgGuide_clearOrgInfo = function()
	{
		// デフォルトのコールバック関数呼び出し
		original_clearOrgInfo.apply(window, arguments);

		// 追加処理を行うコールバック関数呼び出し
		orgGuide_clearOrgInfo_appendix.apply(window, arguments);
	};
	
}

// 追加処理コールバック関数の定義
var orgGuide_setOrgInfo_appendix = function(orgCd1, orgCd2, orgName)
{
	if ( orgGuide_setLastOrgName && orgGuide_OrgName && orgGuide_OrgName.id ) {

		// 実装部の呼び出し
		//orgGuide_setLastOrgName(orgGuide_OrgName.id.toLowerCase(), orgName);
		orgGuide_setLastOrgName(orgGuide_OrgName.id.toLowerCase(), orgGuide_OrgName.innerHTML);

	}
};

// 追加処理コールバック関数の定義
var orgGuide_clearOrgInfo_appendix = function(orgCd1, orgCd2)
{
	if ( orgGuide_setLastOrgName && orgGuide_OrgName && orgGuide_OrgName.id ) {

		// 実装部の呼び出し
		orgGuide_setLastOrgName(orgGuide_OrgName.id.toLowerCase());

	}
};
</script>
