/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	config.language = 'zh-cn';//语言设置  
    //config.uiColor='#ADE82E';//颜色  
    config.width='1000px';//宽度  
    config.height='400px';//高度  
    config.skin='kama';//界面：kama/office2003/v2  
    config.toolbar='Full';//工具栏：Full/Basic  
    
    //配置CKFinder
    config.filebrowserBrowseUrl ='/iframework/view/base/plugin/ckfinder/ckfinder.html';
    config.filebrowserImageBrowseUrl ='/iframework/view/base/plugin/ckfinder/ckfinder.html?Type=Images';
    config.filebrowserFlashBrowseUrl = '/iframework/view/base/plugin/ckfinder/ckfinder.html?Type=Flash';
    config.filebrowserUploadUrl = '/iframework/view/base/plugin/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Files';
    config.filebrowserImageUploadUrl = '/iframework/view/base/plugin/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Images';
    config.filebrowserFlashUploadUrl = '/iframework/view/base/plugin/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Flash';
    config.filebrowserWindowHeight='50%';//CKFinder浏览窗口高度,默认值70%，也可以赋像素值如：1000
    config.filebrowserWindowWidth='70%';//CKFinder浏览窗口宽度,默认值80%，也可以赋像素值
};
