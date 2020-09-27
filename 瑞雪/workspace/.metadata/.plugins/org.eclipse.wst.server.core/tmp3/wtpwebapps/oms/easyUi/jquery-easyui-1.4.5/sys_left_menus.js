/*左侧菜单树形规范结构（如果有url都说明能点击右侧显示内容，无url表示还有下一级菜单）
 * 异步加载会导致左侧列表控件失效，所以采用了转发机制。
 * 构建左侧菜单树目前只支持三级(如果支持更多级可以稍做修改)
 */
$(function() {
	init();
});
function init() {
	var menulist = '';
	menulist += '<ul>';
	_menus.menus.forEach(function(e) {
		if ("undefined" != typeof (e.url) && "" != e.url) {
			menulist += "<li><a href='" + e.url + "' ref='yhgl'>" + e.menuname
					+ "</a></li>"; // 第一级菜单存在url
		} else {
			menulist += "<li>" + e.menuname + "</li><ul>"; // 第一级菜单（无url,说明还有下一级）
		}
		if ("undefined" != typeof (e.menus)) {
			e.menus.forEach(function(n) {
				if ("undefined" != typeof (n.url) && "" != n.url) {
					menulist += "<li><a href='" + n.url + "' ref='yhgl'>" // 第二级菜单存在url
							+ n.menuname + "</a></li>";
				} else {
					menulist += "<li>" + n.menuname + "</li><ul>"; // 第二级菜单（无url,说明还有下一级）
				}
				if ("undefined" != typeof (n.menus)) {
					n.menus.forEach(function(f) {
						if ("undefined" != typeof (f.url) && "" != f.url) {
							menulist += "<li><a href='" + f.url
									+ "' ref='yhgl'>" // 第三级菜单
									+ f.menuname + "</a></li>";
						} else {
							menulist += "<li>" + f.menuname + "</li><ul>"; // 第三级菜单（无url,说明还有下一级）
						}
					});
				}
			});
			menulist += "</ul>";
		}
	});
	menulist += '</ul>';
	$(".st_tree").html(menulist);
}